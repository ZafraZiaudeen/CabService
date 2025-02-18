package com.cabservice.model;

public class Customer extends User {
    
    private int customerId;
    private String nic; 
    // No-argument constructor 
    public Customer() {
        super(); 
    }

    // Constructor including User attributes + customerId and NIC
    public Customer(int userId, String name, String address, String phoneNumber, String username, String password, String role, int customerId, String nic) {
        super(userId, name, address, phoneNumber, username, password, role);
        this.customerId = customerId;
        this.nic = nic;
    }

    // Constructor for creating Customer from User (without customerId initially)
    public Customer(User user, String nic) {
        super(user.getUserId(), user.getName(), user.getAddress(), user.getPhoneNumber(), user.getUsername(), user.getPassword(), user.getRole());
        this.nic = nic;
    }

    // Getter and Setter for customerId
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    // Getter and Setter for NIC
    public String getNic() {
        return nic;
    }

    public void setNic(String nic) {
        this.nic = nic;
    }
}
