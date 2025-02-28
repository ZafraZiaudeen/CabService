package com.cabservice.service;

import com.cabservice.dao.VehicleDAO;
import com.cabservice.model.Vehicle;

import java.sql.SQLException;
import java.util.List;

public class VehicleService {
    private VehicleDAO vehicleDAO;

    public VehicleService() {
        this.vehicleDAO = new VehicleDAO();
    }

    // Get all vehicles
    public List<Vehicle> getAllVehicles() {
        return vehicleDAO.getAllVehicles();
    }

    // Get a single vehicle by ID
    public Vehicle getVehicleById(int vehicleId) {
        return vehicleDAO.getVehicleById(vehicleId);
    }

    // Add a new vehicle
    public boolean addVehicle(String plateNumber, String model, int capacity, double ratePerKm, String status) {
        Vehicle vehicle = new Vehicle(0, plateNumber, model, capacity, ratePerKm, status);
        return vehicleDAO.addVehicle(vehicle);
    }

    // Update vehicle details
    public boolean updateVehicle(int id, String plateNumber, String model, int capacity, double ratePerKm, String status) {
        Vehicle vehicle = new Vehicle(id, plateNumber, model, capacity, ratePerKm, status);
        return vehicleDAO.updateVehicle(vehicle);
    }

    // Delete a vehicle
    public boolean deleteVehicle(int vehicleId) {
        return vehicleDAO.deleteVehicle(vehicleId);
    }
    
 // Get only available vehicles
    public List<Vehicle> getAvailableVehicles() {
        return vehicleDAO.getAvailableVehicles();
    }

    public int getTotalVehicleCount() throws SQLException {
        return vehicleDAO.getTotalVehicleCount();
    }
}
