package com.cabservice.service;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import com.cabservice.dao.UserDAO;
import com.cabservice.model.Admin;
import com.cabservice.model.Customer;
import com.cabservice.model.User;

public class UserService {
    private static volatile UserService instance;
    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());

    // Private constructor for Singleton Pattern
    private UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    // Default constructor using actual DAO
    private UserService() {
        this(new UserDAO());
    }

    public static UserService getInstance() {
        if (instance == null) {
            synchronized (UserService.class) {
                if (instance == null) {
                    instance = new UserService();
                }
            }
        }
        return instance;
    }

    // Dependency Injection - for testing
    public static UserService getInstance(UserDAO userDAO) {
        if (instance == null) {
            synchronized (UserService.class) {
                if (instance == null) {
                    instance = new UserService(userDAO);
                }
            }
        }
        return instance;
    }
    public int addUser(User user) {
        int userId = -1;
        try {
            if (user instanceof Admin) {
                LOGGER.warning("Admin cannot be added dynamically.");
                return userId;
            }

            userId = userDAO.addUser(user);

            if (userId > 0) {
                LOGGER.info("User (including Customer if applicable) added successfully: " + user.getUsername());
            } else {
                LOGGER.warning("Failed to save the user.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding user: " + user.getUsername(), e);
        }
        return userId;
    }


    public Admin loginAdmin(String username, String password) {
        return userDAO.loginAdmin(username, password);
    }
    public Customer loginCustomer(String username, String password) {
        return userDAO.loginCustomer(username, password);
    }

    // Get all users (including Admins & Customers)
    public List<User> getAllUsers() {
        try {
            return userDAO.getAllUsers();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all users", e);
            return null;
        }
    }
    
    public boolean updateAdminPassword(int adminId, String currentPassword, String newPassword) {
        try {
            Admin admin = userDAO.getAdminById(adminId); 
            if (admin != null && BCrypt.checkpw(currentPassword, admin.getPassword())) {
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                admin.setPassword(hashedNewPassword);
                userDAO.updateAdminPassword(admin); 
                LOGGER.info("Admin password updated successfully for: " + admin.getUsername());
                return true;
            } else {
                LOGGER.warning("Current password incorrect or admin not found.");
                return false;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating admin password for admin ID: " + adminId, e);
            return false;
        }
    }

    // Update Admin details (since only one admin exists)
    public void updateAdminDetails(Admin admin) {
        try {
            userDAO.updateAdminDetails(admin);
            LOGGER.info("Updated Admin details for: " + admin.getUsername());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating admin details for user ID: " + admin.getUserId(), e);
        }
    }
    
    public Admin getAdminById(int adminId) {
        try {
            return userDAO.getAdminById(adminId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching admin by ID: " + adminId, e);
            return null;
        }
    }
    
    public boolean isUsernameTaken(String username) {
        try {
            return userDAO.isUsernameTaken(username);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEmailTaken(String email) {
        try {
            return userDAO.isEmailTaken(email);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isNICTaken(String nic) {
        try {
            return userDAO.isNICTaken(nic);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}
