package com.cabservice.model;

public class User {

    private int userId;
    private String name;
    private String address;
    private String phoneNumber;
    private String email;
    private String password;
    private String role;
    
    // Full constructor with all attributes
    public User(int userId, String name, String address, String phoneNumber, String email, String password, String role) {
        this.userId = userId;
        this.name = name;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.password = password;
        this.role = role;
    }
    
    // Constructor with key attributes (name, email, and password)
    public User(int userId, String name, String email, String password) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    // Minimal constructor (userId, email, and password)
    public User(int userId, String email, String password) {
        this.userId = userId;
        this.email = email;
        this.password = password;
    }
    
    // Default constructor
    public User() {
    }

    // Getter and Setter methods
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
