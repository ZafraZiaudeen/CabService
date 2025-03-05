package com.cabservice.dao;

import com.cabservice.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VerificationDAO {
    private static final Logger LOGGER = Logger.getLogger(VerificationDAO.class.getName());

    public void storePendingUser(String token, Customer customer) throws SQLException {
        String query = "INSERT INTO pending_users (token, name, address, phone_number, username, password, email, nic) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, token);
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getPhoneNumber());
            stmt.setString(5, customer.getUsername());
            stmt.setString(6, customer.getPassword());
            stmt.setString(7, customer.getEmail());
            stmt.setString(8, customer.getNic());
            stmt.executeUpdate();
            LOGGER.info("Stored pending user with token: " + token);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error storing pending user with token: " + token, e);
            throw e;
        }
    }

    public Customer getPendingUser(String token) throws SQLException {
        String query = "SELECT * FROM pending_users WHERE token = ?";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Customer customer = new Customer();
                    customer.setName(rs.getString("name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setPhoneNumber(rs.getString("phone_number"));
                    customer.setUsername(rs.getString("username"));
                    customer.setPassword(rs.getString("password"));
                    customer.setRole("Customer");
                    customer.setEmail(rs.getString("email"));
                    customer.setNic(rs.getString("nic"));
                    return customer;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving pending user with token: " + token, e);
            throw e;
        }
        return null;
    }

    public void deletePendingUser(String token) throws SQLException {
        String query = "DELETE FROM pending_users WHERE token = ?";
        
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, token);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Deleted pending user with token: " + token);
            } else {
                LOGGER.warning("No pending user found with token: " + token);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting pending user with token: " + token, e);
            throw e;
        }
    }
}