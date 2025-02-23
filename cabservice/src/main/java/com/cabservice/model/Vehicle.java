package com.cabservice.model;

public class Vehicle {
    private int id;
    private String plateNumber;
    private String model;
    private int capacity;
    private double ratePerKm;
    private String status; 

    // ✅ Constructors
    public Vehicle() {}

    public Vehicle(int id, String plateNumber, String model, int capacity, double ratePerKm, String status) {
        this.id = id;
        this.plateNumber = plateNumber;
        this.model = model;
        this.capacity = capacity;
        this.ratePerKm = ratePerKm;
        this.status = status;
    }

    // ✅ Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public double getRatePerKm() {
        return ratePerKm;
    }

    public void setRatePerKm(double ratePerKm) {
        this.ratePerKm = ratePerKm;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ✅ Overriding `toString()` for debugging
    @Override
    public String toString() {
        return "Vehicle{" +
                "id=" + id +
                ", plateNumber='" + plateNumber + '\'' +
                ", model='" + model + '\'' +
                ", capacity=" + capacity +
                ", ratePerKm=" + ratePerKm +
                ", status='" + status + '\'' +
                '}';
    }
}
