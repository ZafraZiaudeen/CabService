package com.cabservice.dao;

import com.cabservice.model.Driver;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
public class DriverDAO {

    // Constructor
    public DriverDAO() {
        // You can initialize any resources or configurations if needed
    }

    // Method to get all drivers
    public List<Driver> getAllDrivers() {
        List<Driver> drivers = new ArrayList<>();
        String query = "SELECT id, name, nic, licenseNumber, phoneNumber, experience, availability FROM driver";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Driver driver = new Driver();
                driver.setDriverId(rs.getInt("id"));
                driver.setName(rs.getString("name"));
                driver.setNic(rs.getString("nic"));
                driver.setLicenseNumber(rs.getString("licenseNumber"));
                driver.setPhoneNumber(rs.getString("phoneNumber"));
                driver.setExperience(rs.getInt("experience"));
                driver.setAvailability(rs.getBoolean("availability"));
                drivers.add(driver);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return drivers;
    }

    // Method to get driver by ID
    public Driver getDriverById(int driverId) {
        Driver driver = null;
        String query = "SELECT id, name, nic, licenseNumber, phoneNumber, experience, availability FROM driver WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                driver = new Driver();
                driver.setDriverId(rs.getInt("id"));
                driver.setName(rs.getString("name"));
                driver.setNic(rs.getString("nic"));
                driver.setLicenseNumber(rs.getString("licenseNumber"));
                driver.setPhoneNumber(rs.getString("phoneNumber"));
                driver.setExperience(rs.getInt("experience"));
                driver.setAvailability(rs.getBoolean("availability"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return driver;
    }

    // Method to save a new driver to the database
    public boolean saveDriver(Driver driver) {
        String query = "INSERT INTO driver (name, nic, licenseNumber, phoneNumber, experience, availability) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, driver.getName());
            ps.setString(2, driver.getNic());
            ps.setString(3, driver.getLicenseNumber());
            ps.setString(4, driver.getPhoneNumber());
            ps.setInt(5, driver.getExperience());
            // Set availability to true by default for new drivers
            ps.setBoolean(6, true);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
 // Check if NIC already exists
    public boolean isNicExists(String nic) {
        String query = "SELECT COUNT(*) FROM driver WHERE nic = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, nic);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check if license number already exists
    public boolean isLicenseNumberExists(String licenseNumber) {
        String query = "SELECT COUNT(*) FROM driver WHERE licenseNumber = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, licenseNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to update driver information
    public boolean updateDriver(Driver driver) {
        String query = "UPDATE driver SET name = ?, nic = ?, licenseNumber = ?, phoneNumber = ?, experience = ?, availability = ? WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, driver.getName());
            ps.setString(2, driver.getNic());
            ps.setString(3, driver.getLicenseNumber());
            ps.setString(4, driver.getPhoneNumber());
            ps.setInt(5, driver.getExperience());
            ps.setBoolean(6, driver.isAvailability());
            ps.setInt(7, driver.getDriverId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
 // Method to delete a driver by ID
    public boolean deleteDriver(int driverId) {
        String findVehiclesQuery = "SELECT vehicle_id FROM driver_vehicle WHERE driver_id = ?";
        String updateVehicleQuery = "UPDATE vehicle SET status = 'Available' WHERE id = ?";
        String deleteDriverVehicleQuery = "DELETE FROM driver_vehicle WHERE driver_id = ?";
        String deleteDriverQuery = "DELETE FROM driver WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            // Step 1: Find all vehicles assigned to the driver
            List<Integer> vehicleIds = new ArrayList<>();
            try (PreparedStatement psFind = conn.prepareStatement(findVehiclesQuery)) {
                psFind.setInt(1, driverId);
                ResultSet rs = psFind.executeQuery();
                while (rs.next()) {
                    vehicleIds.add(rs.getInt("vehicle_id"));
                }
            }

            // Step 2: Update the status of assigned vehicles to "Available"
            try (PreparedStatement psUpdate = conn.prepareStatement(updateVehicleQuery)) {
                for (Integer vehicleId : vehicleIds) {
                    psUpdate.setInt(1, vehicleId);
                    psUpdate.executeUpdate();
                }
            }

            // Step 3: Delete driver-vehicle assignments
            try (PreparedStatement psDeleteDV = conn.prepareStatement(deleteDriverVehicleQuery)) {
                psDeleteDV.setInt(1, driverId);
                psDeleteDV.executeUpdate();
            }

            // Step 4: Delete the driver
            int driverRows = 0;
            try (PreparedStatement psDelete = conn.prepareStatement(deleteDriverQuery)) {
                psDelete.setInt(1, driverId);
                driverRows = psDelete.executeUpdate();
            }

            if (driverRows > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                Connection conn = DBConnectionFactory.getConnection();
                conn.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        }
    }
    
    public List<Driver> getAvailableDrivers() {
        List<Driver> availableDrivers = new ArrayList<>();
        String query = "SELECT id, name, nic, licenseNumber, phoneNumber, experience, availability FROM driver WHERE availability = true";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Driver driver = new Driver();
                driver.setDriverId(rs.getInt("id"));
                driver.setName(rs.getString("name"));
                driver.setNic(rs.getString("nic"));
                driver.setLicenseNumber(rs.getString("licenseNumber"));
                driver.setPhoneNumber(rs.getString("phoneNumber"));
                driver.setExperience(rs.getInt("experience"));
                driver.setAvailability(rs.getBoolean("availability"));
                availableDrivers.add(driver);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return availableDrivers;
    }
    public List<Driver> getUnassignedDrivers() {
        List<Driver> drivers = new ArrayList<>();
        String query = "SELECT d.id, d.name, d.phoneNumber " +
                       "FROM driver d " +
                       "WHERE NOT EXISTS (SELECT 1 FROM driver_vehicle dv WHERE dv.driver_id = d.id)";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Driver driver = new Driver();
                driver.setDriverId(rs.getInt("id"));
                driver.setName(rs.getString("name"));
                driver.setPhoneNumber(rs.getString("phoneNumber"));
                drivers.add(driver);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return drivers;
    }

    public void updateDriverAvailability(int driverId, boolean availability) throws SQLException {
        String query = "UPDATE driver SET availability = ? WHERE id = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setBoolean(1, availability);
            ps.setInt(2, driverId);
            ps.executeUpdate();
        }
    }
    
    public int getTotalDriversCount() throws SQLException {
        String query = "SELECT COUNT(*) AS total FROM driver";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    //  get the count of available drivers
    public int getAvailableDriversCount() throws SQLException {
        String query = "SELECT COUNT(*) AS available FROM driver WHERE availability = true";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("available");
            }
        }
        return 0;
    }
}
