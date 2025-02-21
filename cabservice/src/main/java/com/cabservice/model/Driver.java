package com.cabservice.model;

public class Driver {

    private int driverId;
    private String name;
    private String nic;
    private String licenseNumber;
    private String phoneNumber;
    private int experience;
    private boolean availability;

    // Full constructor with all attributes
    public Driver(int driverId, String name, String nic, String licenseNumber, String phoneNumber, int experience, boolean availability) {
        this.driverId = driverId;
        this.name = name;
        this.nic = nic;
        this.licenseNumber = licenseNumber;
        this.phoneNumber = phoneNumber;
        this.experience = experience;
        this.availability = availability;
    }

    // Constructor with essential attributes (name, licenseNumber, phoneNumber, experience)
    public Driver(int driverId, String name, String licenseNumber, String phoneNumber, int experience) {
        this.driverId = driverId;
        this.name = name;
        this.licenseNumber = licenseNumber;
        this.phoneNumber = phoneNumber;
        this.experience = experience;
    }

    // Constructor with minimal attributes (driverId, name, phoneNumber)
    public Driver(int driverId, String name, String phoneNumber) {
        this.driverId = driverId;
        this.name = name;
        this.phoneNumber = phoneNumber;
    }

    // Default constructor
    public Driver() {
    }

    // Getter and Setter methods

    public int getDriverId() {
        return driverId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public int getExperience() {
        return experience;
    }

    public void setExperience(int experience) {
        this.experience = experience;
    }

    public boolean isAvailability() {
        return availability;
    }

    public void setAvailability(boolean availability) {
        this.availability = availability;
    }

    // Override toString method for better readability
    @Override
    public String toString() {
        return "Driver{driverId=" + driverId + ", name='" + name + "', nic='" + nic + "', licenseNumber='" + licenseNumber + "', phoneNumber='" + phoneNumber + "', experience=" + experience + ", availability=" + availability + '}';
    }
}
