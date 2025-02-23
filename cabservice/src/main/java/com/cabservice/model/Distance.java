package com.cabservice.model;

public class Distance {
    private int id;
    private String fromLocation;
    private String toLocation;
    private double distanceKm;

    // No-argument constructor (Add this)
    public Distance() {
    }

    // Parameterized constructor
    public Distance(int id, String fromLocation, String toLocation, double distanceKm) {
        this.id = id;
        this.fromLocation = fromLocation;
        this.toLocation = toLocation;
        this.distanceKm = distanceKm;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFromLocation() {
        return fromLocation;
    }

    public void setFromLocation(String fromLocation) {
        this.fromLocation = fromLocation;
    }

    public String getToLocation() {
        return toLocation;
    }

    public void setToLocation(String toLocation) {
        this.toLocation = toLocation;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }
}
