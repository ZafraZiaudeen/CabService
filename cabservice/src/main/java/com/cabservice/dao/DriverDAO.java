package com.cabservice.dao;

import com.cabservice.model.Driver;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
            ps.setBoolean(6, driver.isAvailability());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

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
        String query = "DELETE FROM driver WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, driverId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
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

}
