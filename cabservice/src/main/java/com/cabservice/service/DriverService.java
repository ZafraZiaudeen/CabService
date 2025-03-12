package com.cabservice.service;

import com.cabservice.dao.DriverDAO;
import com.cabservice.model.Driver;

import java.sql.SQLException;
import java.util.List;

public class DriverService {

    private DriverDAO driverDAO;

    public DriverService() {
        driverDAO = new DriverDAO();
    }

    // Method to get all drivers
    public List<Driver> getAllDrivers() {
        return driverDAO.getAllDrivers();
    }

    // Method to get a driver by ID
    public Driver getDriverById(int driverId) {
        return driverDAO.getDriverById(driverId);
    }

    // Method to save a new driver
    public boolean addDriver(String name, String nic, String licenseNumber, String phoneNumber, int experience, boolean availability) {
    	if (driverDAO.isNicExists(nic)) {
            throw new IllegalArgumentException("NIC '" + nic + "' already exists.");
        }
        if (driverDAO.isLicenseNumberExists(licenseNumber)) {
            throw new IllegalArgumentException("License Number '" + licenseNumber + "' already exists.");
        }
        Driver driver = new Driver();
        driver.setName(name);
        driver.setNic(nic);
        driver.setLicenseNumber(licenseNumber);
        driver.setPhoneNumber(phoneNumber);
        driver.setExperience(experience);
        driver.setAvailability(availability);

        return driverDAO.saveDriver(driver);
    }

    // Method to update driver information
    public boolean updateDriver(int driverId, String name, String nic, String licenseNumber, String phoneNumber, int experience, boolean availability) {
        // Fetch the current driver to compare NIC and license number
        Driver currentDriver = driverDAO.getDriverById(driverId);
        if (currentDriver == null) {
            throw new IllegalArgumentException("Driver with ID " + driverId + " not found.");
        }

        // Check if NIC is taken by another driver
        if (!nic.equals(currentDriver.getNic()) && driverDAO.isNicExists(nic)) {
            throw new IllegalArgumentException("NIC '" + nic + "' is already taken by another driver.");
        }

        // Check if license number is taken by another driver
        if (!licenseNumber.equals(currentDriver.getLicenseNumber()) && driverDAO.isLicenseNumberExists(licenseNumber)) {
            throw new IllegalArgumentException("License Number '" + licenseNumber + "' is already taken by another driver.");
        }

        // Update driver if validations pass
        Driver driver = new Driver();
        driver.setDriverId(driverId);
        driver.setName(name);
        driver.setNic(nic);
        driver.setLicenseNumber(licenseNumber);
        driver.setPhoneNumber(phoneNumber);
        driver.setExperience(experience);
        driver.setAvailability(availability);

        return driverDAO.updateDriver(driver);
    }

    public boolean deleteDriver(int driverId) {
        return driverDAO.deleteDriver(driverId);
    }
    
    public List<Driver> getAvailableDrivers() {
        DriverDAO driverDAO = new DriverDAO();
        return driverDAO.getAvailableDrivers();
    }

    public int getTotalDriversCount() throws SQLException {
        return driverDAO.getTotalDriversCount();
    }

    public int getAvailableDriversCount() throws SQLException {
        return driverDAO.getAvailableDriversCount();
    }
}
