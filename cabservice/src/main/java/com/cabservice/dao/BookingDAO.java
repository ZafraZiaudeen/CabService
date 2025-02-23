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
            LEFT JOIN driver_vehicle dv ON v.id = dv.vehicle_id
            LEFT JOIN driver d ON dv.driver_id = d.id
            WHERE (v.status = 'Available' OR (v.status = 'In Use' AND d.availability = TRUE))
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
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
 
}