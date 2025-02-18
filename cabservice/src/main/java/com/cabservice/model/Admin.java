package com.cabservice.model;

public class Admin extends User {

    private final int adminId; // Admin ID is assigned once and cannot be changed

    // Constructor (Admin details are pre-allocated, so no new Admins are created dynamically)
    public Admin(int userId, String name, String address, String phoneNumber, String username, String password, int adminId) {
        super(userId, name, address, phoneNumber, username, password, "ADMIN"); // Role is always ADMIN
        this.adminId = adminId;
    }

    // Getter for adminId (No setter, because it's pre-allocated)
    public int getAdminId() {
        return adminId;
    }

    // Allow admins to update their profile (including username)
    public void updateProfile(String name, String address, String phoneNumber, String username, String password) {
        setName(name);
        setAddress(address);
        setPhoneNumber(phoneNumber);
        setUsername(username);  // Now allows updating the username
        setPassword(password);
    }
}
