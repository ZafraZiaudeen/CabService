package com.cabservice.dao;

import java.sql.*;
import java.util.*;

import com.cabservice.model.Billing;
import com.cabservice.model.Booking;

public class BookingDAO {
    private Connection conn;

    public BookingDAO(Connection conn) {
        this.conn = conn;
    }

    public List<String> getCustomerSuggestions(String input) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT CONCAT(name, ' (', phone, ', ', email, ')') FROM customers WHERE name LIKE ? OR phone LIKE ? OR email LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + input + "%");
            stmt.setString(2, "%" + input + "%");
            stmt.setString(3, "%" + input + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                suggestions.add(rs.getString(1));
            }
        }
        return suggestions;
    }
    public List<Map<String, String>> getAvailableVehicles() throws SQLException {
        List<Map<String, String>> vehicles = new ArrayList<>();
        String sql = """
            SELECT v.id, v.plate_number, v.model, v.rate_per_km, v.status, d.id AS driver_id
            FROM vehicle v
            INNER JOIN driver_vehicle dv ON v.id = dv.vehicle_id
            INNER JOIN driver d ON dv.driver_id = d.id
            WHERE v.status = 'In Use' AND d.availability = TRUE
        """;

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, String> vehicle = new HashMap<>();
                vehicle.put("vehicleId", rs.getString("id"));
                vehicle.put("plateNumber", rs.getString("plate_number"));
                vehicle.put("model", rs.getString("model"));
                vehicle.put("ratePerKm", rs.getString("rate_per_km"));
                vehicle.put("status", rs.getString("status"));
                vehicle.put("driverId", rs.getString("driver_id"));
                vehicles.add(vehicle);
            }
        }
        return vehicles;
    }
    public double getDistance(String fromLocation, String toLocation) throws SQLException {
        // Try to find distance directly (from -> to)
        String sql = "SELECT distance_km FROM distance WHERE (from_location = ? AND to_location = ?) OR (from_location = ? AND to_location = ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fromLocation);
            stmt.setString(2, toLocation);
            stmt.setString(3, toLocation);
            stmt.setString(4, fromLocation);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("distance_km");
            }
        }

        // If no direct or reverse entry exists, try to find a path through intermediate locations
        sql = """
            SELECT d1.distance_km + d2.distance_km AS total_distance
            FROM distance d1
            JOIN distance d2 ON d1.to_location = d2.from_location
            WHERE (d1.from_location = ? AND d2.to_location = ?) OR (d1.from_location = ? AND d2.to_location = ?)
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fromLocation);
            stmt.setString(2, toLocation);
            stmt.setString(3, toLocation);
            stmt.setString(4, fromLocation);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total_distance");
            }
        }

        // If no path is found, return 0 (or throw an exception if preferred)
        return 0;
    }

    public int getDriverForVehicle(int vehicleId) throws SQLException {
        String sql = "SELECT driver_id FROM driver_vehicle WHERE vehicle_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("driver_id");
            }
        }
        return -1;  // Return -1 if no driver is assigned
    }

    public double getRatePerKm(int vehicleId) throws SQLException {
        String sql = "SELECT rate_per_km FROM vehicle WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("rate_per_km");
            }
        }
        return 0;  // Return 0 if no rate is found
    }

    public int createBooking(Booking booking) throws SQLException {
        String sql = """
            INSERT INTO bookings (booking_number, customer_id, driver_id, vehicle_id, pickup_location, dropoff_location, distance_km, status, booked_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', NOW())
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, booking.getBookingNumber());
            stmt.setInt(2, booking.getCustomerId());
            stmt.setInt(3, booking.getDriverId());
            stmt.setInt(4, booking.getVehicleId());
            stmt.setString(5, booking.getPickupLocation());
            stmt.setString(6, booking.getDropoffLocation());
            stmt.setDouble(7, booking.getDistanceKm());
            stmt.executeUpdate();

            // Retrieve the generated booking ID
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Return the generated booking ID
            }
        }
        return -1; // Return -1 if the booking ID could not be retrieved
    }
    public List<String> getLocations() throws SQLException {
        List<String> locations = new ArrayList<>();
        String sql = "SELECT DISTINCT from_location FROM distance UNION SELECT DISTINCT to_location FROM distance";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                locations.add(rs.getString("from_location"));
            }
        }
        return locations;
    }
    public List<Map<String, String>> getCustomers() throws SQLException {
        List<Map<String, String>> customers = new ArrayList<>();
        String sql = """
            SELECT c.id AS customer_id, u.name, u.phoneNumber, u.address
            FROM customer c
            JOIN users u ON c.user_id = u.id
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> customer = new HashMap<>();
                customer.put("customerId", rs.getString("customer_id"));
                customer.put("name", rs.getString("name"));
                customer.put("phoneNumber", rs.getString("phoneNumber"));
                customer.put("address", rs.getString("address"));
                customers.add(customer);
            }
        }
        return customers;
    }
    public Map<String, Double> getSystemConfig() throws SQLException {
        Map<String, Double> config = new HashMap<>();
        String sql = "SELECT tax_rate, discount_rate FROM system_config ORDER BY updated_at DESC LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                config.put("taxRate", rs.getDouble("tax_rate"));
                config.put("discountRate", rs.getDouble("discount_rate"));
            }
        }
        return config;
    }

    public boolean createBilling(Billing billing) throws SQLException {
        String sql = """
            INSERT INTO billing (booking_id, total_amount, tax, discount, final_amount, generated_at)
            VALUES (?, ?, ?, ?, ?, NOW())
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, billing.getBookingId());
            stmt.setDouble(2, billing.getTotalAmount());
            stmt.setDouble(3, billing.getTax());
            stmt.setDouble(4, billing.getDiscount());
            stmt.setDouble(5, billing.getFinalAmount());
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Method to get booking by ID (for edit-booking.jsp)
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerId(rs.getInt("customer_id"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDropoffLocation(rs.getString("dropoff_location"));
                booking.setVehicleId(rs.getInt("vehicle_id"));
                return booking;
            }
        }
        return null;
    }

    // Modify updateBooking method to include pickup and dropoff
    public boolean updateBooking(Booking booking) throws SQLException {
        String sql = """
            UPDATE bookings SET customer_id = ?, pickup_location = ?, dropoff_location = ?, vehicle_id = ?, distance_km = ?
            WHERE id = ?
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, booking.getCustomerId());
            stmt.setString(2, booking.getPickupLocation());
            stmt.setString(3, booking.getDropoffLocation());
            stmt.setInt(4, booking.getVehicleId());
            stmt.setDouble(5, booking.getDistanceKm());
            stmt.setInt(6, booking.getId());
            return stmt.executeUpdate() > 0;
        }
    }
    
    
    public Map<String, String> getCustomerById(int customerId) throws SQLException {
        String sql = """
            SELECT c.id AS customer_id, u.name, u.phoneNumber, u.address
            FROM customer c
            JOIN users u ON c.user_id = u.id
            WHERE c.id = ?
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Map<String, String> customer = new HashMap<>();
                customer.put("customerId", rs.getString("customer_id"));
                customer.put("name", rs.getString("name"));
                customer.put("phoneNumber", rs.getString("phoneNumber"));
                customer.put("address", rs.getString("address"));
                return customer;
            }
        }
        return null; // Return null if no customer is found
    }

    public Map<String, String> getVehicleById(int vehicleId) throws SQLException {
        String sql = """
            SELECT v.id, v.plate_number, v.model, v.rate_per_km, v.status
            FROM vehicle v
            WHERE v.id = ?
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicleId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Map<String, String> vehicle = new HashMap<>();
                vehicle.put("vehicleId", rs.getString("id"));
                vehicle.put("plateNumber", rs.getString("plate_number"));
                vehicle.put("model", rs.getString("model"));
                vehicle.put("ratePerKm", rs.getString("rate_per_km"));
                vehicle.put("status", rs.getString("status"));
                return vehicle;
            }
        }
        return null; // Return null if no vehicle is found
    }

    
    public boolean deleteBooking(int bookingId) throws SQLException {
        String sql = "DELETE FROM bookings WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public List<Booking> getBookingHistoryByCustomerId(int customerId) throws SQLException {
        List<Booking> bookingHistory = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE customer_id = ? ORDER BY booked_at DESC"; 

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setCustomerId(rs.getInt("customer_id"));
                booking.setDriverId(rs.getInt("driver_id"));
                booking.setVehicleId(rs.getInt("vehicle_id"));
                booking.setPickupLocation(rs.getString("pickup_location"));
                booking.setDropoffLocation(rs.getString("dropoff_location"));
                booking.setDistanceKm(rs.getDouble("distance_km"));
                booking.setStatus(rs.getString("status"));
                booking.setBookedAt(rs.getTimestamp("booked_at"));
                bookingHistory.add(booking);
            }
        }
        return bookingHistory;
    }
    public List<Map<String, Object>> getBookingHistoryWithPaymentDetails(int customerId) throws SQLException {
        List<Map<String, Object>> bookingHistory = new ArrayList<>();
        String sql = """
            SELECT b.id AS booking_id, b.booked_at, b.pickup_location, b.dropoff_location, b.status,
                   b.vehicle_id, bi.total_amount, bi.payment_type
            FROM bookings b
            LEFT JOIN billing bi ON b.id = bi.booking_id
            WHERE b.customer_id = ?
            ORDER BY b.booked_at DESC
        """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("booked_at", rs.getTimestamp("booked_at"));
                booking.put("pickup_location", rs.getString("pickup_location"));
                booking.put("dropoff_location", rs.getString("dropoff_location"));
                booking.put("status", rs.getString("status"));
                booking.put("vehicle_id", rs.getInt("vehicle_id")); // Added vehicle_id
                booking.put("total_amount", rs.getDouble("total_amount"));
                booking.put("payment_type", rs.getString("payment_type"));
                bookingHistory.add(booking);
            }
        }
        return bookingHistory;
    }
    
 // In BookingDAO.java
    public boolean canCancelBooking(int bookingId) throws SQLException {
        String sql = "SELECT booked_at FROM bookings WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Timestamp bookedAt = rs.getTimestamp("booked_at");
                long currentTime = System.currentTimeMillis();
                long bookedTime = bookedAt.getTime();
                long diffInMinutes = (currentTime - bookedTime) / (1000 * 60); // Convert milliseconds to minutes
                return diffInMinutes <= 5; // True if within 5 minutes
            }
        }
        return false; // Booking not found or too late to cancel
    }

    public void cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'Cancelled' WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();
        }
    }
    
    public List<Map<String, Object>> getAllBookingsWithCustomerDetails() throws SQLException {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = """
            SELECT 
                b.id AS booking_id, 
                b.booking_number, 
                b.customer_id, 
                b.driver_id, 
                b.vehicle_id, 
                b.pickup_location, 
                b.dropoff_location, 
                b.distance_km, 
                b.status, 
                b.booked_at, 
                u.name AS customer_name, 
                u.phoneNumber AS customer_phone,
                bi.final_amount AS final_amount, 
                bi.payment_type AS payment_type, 
                v.plate_number AS vehicle_plate, 
                v.model AS vehicle_model, 
                v.rate_per_km AS vehicle_rate_per_km
            FROM bookings b
            INNER JOIN customer c ON b.customer_id = c.id
            INNER JOIN users u ON c.user_id = u.id
            LEFT JOIN billing bi ON b.id = bi.booking_id
            INNER JOIN vehicle v ON b.vehicle_id = v.id
            ORDER BY b.booked_at DESC
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("bookingNumber", rs.getString("booking_number"));
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("driverId", rs.getInt("driver_id"));
                booking.put("vehicleId", rs.getInt("vehicle_id"));
                booking.put("pickupLocation", rs.getString("pickup_location"));
                booking.put("dropoffLocation", rs.getString("dropoff_location"));
                booking.put("distanceKm", rs.getDouble("distance_km"));
                booking.put("status", rs.getString("status")); // Only set once
                booking.put("bookedAt", rs.getTimestamp("booked_at"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                booking.put("finalAmount", rs.getObject("final_amount") != null ? rs.getDouble("final_amount") : null);
                booking.put("paymentType", rs.getString("payment_type"));
                booking.put("vehiclePlate", rs.getString("vehicle_plate"));
                booking.put("vehicleModel", rs.getString("vehicle_model"));
                booking.put("vehicleRatePerKm", rs.getDouble("vehicle_rate_per_km"));
                bookings.add(booking);
            }
        }
        return bookings;
    }
    
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql;
        if ("Completed".equals(status)) {
            sql = "UPDATE bookings SET status = ?, completed_at = NOW() WHERE id = ?";
        } else {
            sql = "UPDATE bookings SET status = ? WHERE id = ?";
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            stmt.executeUpdate();
        }
    }
    
    public List<Map<String, Object>> getPendingBooking() throws SQLException {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = """
            SELECT 
                b.id AS booking_id, 
                b.booking_number, 
                b.customer_id, 
                b.driver_id, 
                b.vehicle_id, 
                b.pickup_location, 
                b.dropoff_location, 
                b.distance_km, 
                b.status, 
                b.booked_at, 
                u.name AS customer_name, 
                u.phoneNumber AS customer_phone,
                bi.final_amount AS final_amount, 
                bi.payment_type AS payment_type, 
                v.plate_number AS vehicle_plate, 
                v.model AS vehicle_model, 
                v.rate_per_km AS vehicle_rate_per_km
            FROM bookings b
            INNER JOIN customer c ON b.customer_id = c.id
            INNER JOIN users u ON c.user_id = u.id
            LEFT JOIN billing bi ON b.id = bi.booking_id
            INNER JOIN vehicle v ON b.vehicle_id = v.id
            WHERE b.status = 'Pending'  -- Added filter for Pending status
            ORDER BY b.booked_at DESC
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getInt("booking_id"));
                booking.put("bookingNumber", rs.getString("booking_number"));
                booking.put("customerId", rs.getInt("customer_id"));
                booking.put("driverId", rs.getInt("driver_id"));
                booking.put("vehicleId", rs.getInt("vehicle_id"));
                booking.put("pickupLocation", rs.getString("pickup_location"));
                booking.put("dropoffLocation", rs.getString("dropoff_location"));
                booking.put("distanceKm", rs.getDouble("distance_km"));
                booking.put("status", rs.getString("status"));
                booking.put("bookedAt", rs.getTimestamp("booked_at"));
                booking.put("customerName", rs.getString("customer_name"));
                booking.put("customerPhone", rs.getString("customer_phone"));
                booking.put("finalAmount", rs.getObject("final_amount") != null ? rs.getDouble("final_amount") : null);
                booking.put("paymentType", rs.getString("payment_type")); // Added payment_type
                booking.put("vehiclePlate", rs.getString("vehicle_plate"));
                booking.put("vehicleModel", rs.getString("vehicle_model"));
                booking.put("vehicleRatePerKm", rs.getDouble("vehicle_rate_per_km"));
                bookings.add(booking);
            }
        }
        return bookings;
    }
}