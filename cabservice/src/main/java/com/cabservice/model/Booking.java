package com.cabservice.model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private String bookingNumber;
    private int customerId;
    private int driverId;
    private int vehicleId;
    private String pickupLocation;
    private String dropoffLocation;
    private double distanceKm;
    private String status;
    private Timestamp bookedAt;
    private Timestamp completedAt;

    // ✅ Constructors
    public Booking() {}

    public Booking(int id, String bookingNumber, int customerId, int driverId, int vehicleId, 
                   String pickupLocation, String dropoffLocation, double distanceKm, 
                   String status, Timestamp bookedAt, Timestamp completedAt) {
        this.id = id;
        this.bookingNumber = bookingNumber;
        this.customerId = customerId;
        this.driverId = driverId;
        this.vehicleId = vehicleId;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
        this.distanceKm = distanceKm;
        this.status = status;
        this.bookedAt = bookedAt;
        this.completedAt = completedAt;
    }

    // ✅ Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBookingNumber() {
        return bookingNumber;
    }

    public void setBookingNumber(String bookingNumber) {
        this.bookingNumber = bookingNumber;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

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

    public String getPickupLocation() {
        return pickupLocation;
    }

    public void setPickupLocation(String pickupLocation) {
        this.pickupLocation = pickupLocation;
    }

    public String getDropoffLocation() {
        return dropoffLocation;
    }

    public void setDropoffLocation(String dropoffLocation) {
        this.dropoffLocation = dropoffLocation;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getBookedAt() {
        return bookedAt;
    }

    public void setBookedAt(Timestamp bookedAt) {
        this.bookedAt = bookedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    // ✅ Overriding `toString()` for debugging
    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", bookingNumber='" + bookingNumber + '\'' +
                ", customerId=" + customerId +
                ", driverId=" + driverId +
                ", vehicleId=" + vehicleId +
                ", pickupLocation='" + pickupLocation + '\'' +
                ", dropoffLocation='" + dropoffLocation + '\'' +
                ", distanceKm=" + distanceKm +
                ", status='" + status + '\'' +
                ", bookedAt=" + bookedAt +
                ", completedAt=" + completedAt +
                '}';
    }
}
