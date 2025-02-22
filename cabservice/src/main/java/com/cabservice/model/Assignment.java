package com.cabservice.model;

import java.sql.Timestamp;

public class Assignment {
    private int driverId;
    private int vehicleId;
    private Timestamp assignedAt;
    private String driverName; // New Field
    private String vehiclePlate; // New Field
    private String vehicleModel; 
    
    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public Timestamp getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(Timestamp assignedAt) {
        this.assignedAt = assignedAt;
    }

    public String getDriverName() {  // New Getter
        return driverName;
    }

    public void setDriverName(String driverName) {  // New Setter
        this.driverName = driverName;
    }

    public String getVehiclePlate() {  // New Getter
        return vehiclePlate;
    }

    public void setVehiclePlate(String vehiclePlate) {  // New Setter
        this.vehiclePlate = vehiclePlate;
    }
    
    public String getVehicleModel() {
        return vehicleModel;
    }

    public void setVehicleModel(String vehicleModel) {
        this.vehicleModel = vehicleModel;
    }

}
