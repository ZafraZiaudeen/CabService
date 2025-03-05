package com.cabservice.service;

import com.cabservice.dao.VerificationDAO;
import com.cabservice.model.Customer;

import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VerificationService {
    private static final Logger LOGGER = Logger.getLogger(VerificationService.class.getName());
    private final VerificationDAO verificationDAO;

    public VerificationService() {
        this.verificationDAO = new VerificationDAO();
    }

    // For dependency injection (e.g., testing)
    public VerificationService(VerificationDAO verificationDAO) {
        this.verificationDAO = verificationDAO;
    }

    public String storePendingUser(Customer customer) {
        String token = UUID.randomUUID().toString();
        try {
            verificationDAO.storePendingUser(token, customer);
            return token;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to store pending user", e);
            return null;
        }
    }

    public Customer verifyUser(String token) {
        try {
            Customer customer = verificationDAO.getPendingUser(token);
            if (customer != null) {
                verificationDAO.deletePendingUser(token); 
                return customer;
            }
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to verify user with token: " + token, e);
            return null;
        }
    }
}