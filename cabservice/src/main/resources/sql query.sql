DELIMITER //
CREATE PROCEDURE sp_create_booking(
    IN p_booking_number VARCHAR(20),
    IN p_customer_id INT,
    IN p_vehicle_id INT,
    IN p_pickup_location VARCHAR(200),
    IN p_dropoff_location VARCHAR(200),
    IN p_distance_km DECIMAL(10, 2),
    OUT p_booking_id INT
)
BEGIN
    DECLARE v_driver_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error occurred during booking creation.';
    END;

    START TRANSACTION;

    -- Check vehicle availability and assigned driver
    SELECT dv.driver_id INTO v_driver_id
    FROM driver_vehicle dv
    JOIN driver d ON dv.driver_id = d.id
    JOIN vehicle v ON dv.vehicle_id = v.id
    WHERE dv.vehicle_id = p_vehicle_id
    AND v.status = 'In Use'
    AND d.availability = TRUE
    AND NOT EXISTS (
        SELECT 1 FROM bookings b
        WHERE b.vehicle_id = p_vehicle_id
        AND b.status IN ('Pending', 'Ongoing')
    );

    IF v_driver_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle or driver not available for booking.';
    ELSE
        -- Insert the booking
        INSERT INTO bookings (
            booking_number, customer_id, driver_id, vehicle_id,
            pickup_location, dropoff_location, distance_km, status, booked_at
        )
        VALUES (
            p_booking_number, p_customer_id, v_driver_id, p_vehicle_id,
            p_pickup_location, p_dropoff_location, p_distance_km, 'Pending', NOW()
        );

        -- Get the generated booking ID
        SET p_booking_id = LAST_INSERT_ID();

        -- Update driver availability
        UPDATE driver
        SET availability = FALSE
        WHERE id = v_driver_id;

        COMMIT;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_create_billing(
    IN p_booking_id INT,
    IN p_payment_type VARCHAR(20),
    IN p_card_number VARCHAR(16),
    IN p_cvv VARCHAR(4),
    IN p_expiry_date VARCHAR(7),
    OUT p_total_amount DECIMAL(10, 2),
    OUT p_tax DECIMAL(10, 2),
    OUT p_discount DECIMAL(10, 2),
    OUT p_final_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE v_vehicle_id INT;
    DECLARE v_distance_km DECIMAL(10, 2);
    DECLARE v_rate_per_km DECIMAL(10, 2);
    DECLARE v_tax_rate DECIMAL(5, 2);
    DECLARE v_discount_rate DECIMAL(5, 2);

    -- Get booking details
    SELECT vehicle_id, distance_km INTO v_vehicle_id, v_distance_km
    FROM bookings
    WHERE id = p_booking_id;

    -- Get vehicle rate per km
    SELECT rate_per_km INTO v_rate_per_km
    FROM vehicle
    WHERE id = v_vehicle_id;

    -- Get latest tax and discount rates
    SELECT tax_rate, discount_rate INTO v_tax_rate, v_discount_rate
    FROM system_config
    ORDER BY updated_at DESC
    LIMIT 1;

    -- Calculate amounts
    SET p_total_amount = v_rate_per_km * v_distance_km;
    SET p_tax = p_total_amount * (v_tax_rate / 100);
    SET p_discount = p_total_amount * (v_discount_rate / 100);
    SET p_final_amount = p_total_amount + p_tax - p_discount;

    -- Insert into billing table with payment details
    INSERT INTO billing (
        booking_id, total_amount, tax, discount, final_amount, generated_at,
        payment_type, card_number, cvv, expiry_date
    )
    VALUES (
        p_booking_id, p_total_amount, p_tax, p_discount, p_final_amount, NOW(),
        p_payment_type, 
        IF(p_payment_type = 'Card', p_card_number, NULL),
        IF(p_payment_type = 'Card', p_cvv, NULL),
        IF(p_payment_type = 'Card', p_expiry_date, NULL)
    );
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_update_availability_after_booking_update
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    -- If status changes to Pending or Ongoing, mark driver as unavailable
    IF NEW.status IN ('Pending', 'Ongoing') AND OLD.status NOT IN ('Pending', 'Ongoing') THEN
        UPDATE driver
        SET availability = FALSE
        WHERE id = NEW.driver_id;

        -- Vehicle status remains 'In Use' (set during assignment), no change needed here
    END IF;

    -- If status changes to Completed or Cancelled, check if driver can be made available
    IF NEW.status IN ('Completed', 'Cancelled') AND OLD.status NOT IN ('Completed', 'Cancelled') THEN
        -- Only make driver available if no other active bookings exist
        IF NOT EXISTS (
            SELECT 1
            FROM bookings
            WHERE driver_id = NEW.driver_id
            AND status IN ('Pending', 'Ongoing')
        ) THEN
            UPDATE driver
            SET availability = TRUE
            WHERE id = NEW.driver_id;
        END IF;

        -- No vehicle status change here; handled by assignment logic
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_calculate_final_amount(
    p_vehicle_id INT,
    p_distance_km DECIMAL(10, 2)
) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_rate_per_km DECIMAL(10, 2);
    DECLARE v_tax_rate DECIMAL(5, 2);
    DECLARE v_discount_rate DECIMAL(5, 2);
    DECLARE v_total_amount DECIMAL(10, 2);
    DECLARE v_tax DECIMAL(10, 2);
    DECLARE v_discount DECIMAL(10, 2);
    DECLARE v_final_amount DECIMAL(10, 2);

    -- Get vehicle rate per km
    SELECT rate_per_km INTO v_rate_per_km
    FROM vehicle
    WHERE id = p_vehicle_id;

    -- Get latest tax and discount rates
    SELECT tax_rate, discount_rate INTO v_tax_rate, v_discount_rate
    FROM system_config
    ORDER BY updated_at DESC
    LIMIT 1;

    -- Calculate amounts
    SET v_total_amount = v_rate_per_km * p_distance_km;
    SET v_tax = v_total_amount * (v_tax_rate / 100);
    SET v_discount = v_total_amount * (v_discount_rate / 100);
    SET v_final_amount = v_total_amount + v_tax - v_discount;

    RETURN v_final_amount;
END //
DELIMITER ;
SHOW CREATE PROCEDURE sp_create_billing;
DROP PROCEDURE IF EXISTS sp_create_billing;