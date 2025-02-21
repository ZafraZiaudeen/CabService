package com.cabservice.service;

import com.cabservice.dao.DriverDAO;
import com.cabservice.model.Driver;

import java.util.List;

public class DriverService {

    private DriverDAO driverDAO;

    public DriverService() {
        // Initialize the DriverDAO instance
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

    // Method to delete a driver
    public boolean deleteDriver(int driverId) {
        return driverDAO.deleteDriver(driverId);
    }
    
    public List<Driver> getAvailableDrivers() {
        DriverDAO driverDAO = new DriverDAO();
        return driverDAO.getAvailableDrivers();
    }

    
}
