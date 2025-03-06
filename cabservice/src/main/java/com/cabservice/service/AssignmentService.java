package com.cabservice.service;

import com.cabservice.dao.AssignmentDAO;
import com.cabservice.dao.DriverDAO;
import com.cabservice.dao.VehicleDAO;
import com.cabservice.model.Assignment;
import com.cabservice.model.Driver;
import com.cabservice.model.Vehicle;

import java.util.List;

public class AssignmentService {
    private AssignmentDAO assignmentDAO;
    private DriverDAO driverDAO;
    private VehicleDAO vehicleDAO;

    public AssignmentService() {
        this.assignmentDAO = new AssignmentDAO();
        this.driverDAO = new DriverDAO();
        this.vehicleDAO = new VehicleDAO();
    }
    public List<Assignment> getAllAssignments() {
        return assignmentDAO.getAllAssignments();
    }

    public boolean assignVehicleToDriver(int driverId, int vehicleId) {
        boolean assigned = assignmentDAO.assignVehicle(driverId, vehicleId);
        if (assigned) {
            vehicleDAO.updateVehicleStatus(vehicleId, "In Use");  // Set status to "In Use"
        }
        return assigned;
    }

    public boolean unassignVehicle(int driverId, int vehicleId) {
        boolean unassigned = assignmentDAO.unassignVehicle(driverId, vehicleId);
        if (unassigned) {
            vehicleDAO.updateVehicleStatus(vehicleId, "Available");  
        }
        return unassigned;
    }

    public List<Driver> getUnassignedDrivers() {
        return driverDAO.getUnassignedDrivers();
    }

    public List<Vehicle> getAvailableVehicles() {
        return vehicleDAO.getAvailableVehicles();
    }

}
