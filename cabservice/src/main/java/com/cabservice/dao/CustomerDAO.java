package com.cabservice.dao;

import com.cabservice.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CustomerDAO {
    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    /**
     * Fetch all customers from the database.
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, u.password, u.role, u.email, c.id AS customer_id, c.nic " +
                       "FROM users u " +
                       "LEFT JOIN customer c ON u.id = c.user_id " +
                       "WHERE u.role = 'Customer'";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer customer = new Customer(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("phoneNumber"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("email"),
                    rs.getInt("customer_id"),
                    rs.getString("nic")
                );
                customers.add(customer);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all customers", e);
        }
        return customers;
    }

    /**
     * Delete a customer from both 'customer' and 'users' tables.
     */
    public boolean deleteCustomer(int customerId) {
        String fetchUserIdQuery = "SELECT user_id FROM customer WHERE id = ?";
        String deleteCustomerQuery = "DELETE FROM customer WHERE id = ?";
        String deleteUserQuery = "DELETE FROM users WHERE id = ? AND role = 'Customer'";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false);

            // Step 1: Fetch the user_id associated with the customerId
            Integer userId = null;
            try (PreparedStatement psFetch = conn.prepareStatement(fetchUserIdQuery)) {
                psFetch.setInt(1, customerId);
                ResultSet rs = psFetch.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    LOGGER.log(Level.WARNING, "No customer found with ID: " + customerId);
                    conn.rollback();
                    return false; // Customer doesn't exist
                }
            }

            // Step 2: Delete from customer table
            try (PreparedStatement psCustomer = conn.prepareStatement(deleteCustomerQuery)) {
                psCustomer.setInt(1, customerId);
                int customerRows = psCustomer.executeUpdate();

                if (customerRows == 0) {
                    LOGGER.log(Level.WARNING, "Failed to delete customer with ID: " + customerId);
                    conn.rollback();
                    return false;
                }
            }

            // Step 3: Delete from users table using the fetched user_id
            try (PreparedStatement psUser = conn.prepareStatement(deleteUserQuery)) {
                psUser.setInt(1, userId);
                int userRows = psUser.executeUpdate();

                if (userRows == 0) {
                    LOGGER.log(Level.WARNING, "Failed to delete user with ID: " + userId + " for customer ID: " + customerId);
                    conn.rollback();
                    return false;
                }
            }

            // If both deletions succeed, commit the transaction
            conn.commit();
            LOGGER.log(Level.INFO, "Successfully deleted customer with ID: " + customerId);
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting customer with ID: " + customerId, e);
            try (Connection conn = DBConnectionFactory.getConnection()) {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE, "Rollback failed for customer deletion: " + customerId, rollbackEx);
            }
            return false;
        }
    }

    /**
     * Insert a new customer into the database.
     */
    public boolean insertCustomer(String name, String address, String phoneNumber, String username, 
                                String hashedPassword, String role, String email, String nic) {
        String insertUserQuery = "INSERT INTO users (name, address, phoneNumber, username, password, role, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertCustomerQuery = "INSERT INTO customer (NIC, user_id) VALUES (?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement userPs = conn.prepareStatement(insertUserQuery, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, name);
                userPs.setString(2, address);
                userPs.setString(3, phoneNumber);
                userPs.setString(4, username);
                userPs.setString(5, hashedPassword);
                userPs.setString(6, role);
                userPs.setString(7, email);
                userPs.executeUpdate();

                try (ResultSet rs = userPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);

                        try (PreparedStatement customerPs = conn.prepareStatement(insertCustomerQuery)) {
                            customerPs.setString(1, nic);
                            customerPs.setInt(2, userId);
                            customerPs.executeUpdate();
                        }

                        conn.commit();
                        return true;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error inserting customer", e);
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in insertCustomer transaction", e);
            return false;
        }
        return false;
    }

    /**
     * Fetch a customer by ID.
     */
    public Customer getCustomerById(int customerId) {
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, u.password, u.role, u.email, c.id AS customer_id, c.NIC " +
                       "FROM users u JOIN customer c ON u.id = c.user_id WHERE c.id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("email"),
                        rs.getInt("customer_id"),
                        rs.getString("NIC")
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching customer by ID: " + customerId, e);
        }
        return null;
    }

    /**
     * Update an existing customer in the database.
     */
    public boolean updateCustomer(int customerId, String name, String address, String phoneNumber, 
                                String username, String email, String nic) {
        String updateUserQuery = "UPDATE users SET name = ?, address = ?, phoneNumber = ?, username = ?, email = ? " +
                                "WHERE id = (SELECT user_id FROM customer WHERE id = ?)";
        String updateCustomerQuery = "UPDATE customer SET NIC = ? WHERE id = ?";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement userPs = conn.prepareStatement(updateUserQuery);
                 PreparedStatement customerPs = conn.prepareStatement(updateCustomerQuery)) {

                userPs.setString(1, name);
                userPs.setString(2, address);
                userPs.setString(3, phoneNumber);
                userPs.setString(4, username);
                userPs.setString(5, email);
                userPs.setInt(6, customerId);
                int userRows = userPs.executeUpdate();

                customerPs.setString(1, nic);
                customerPs.setInt(2, customerId);
                int customerRows = customerPs.executeUpdate();

                if (userRows > 0 && customerRows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error updating customer with ID: " + customerId, e);
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateCustomer transaction", e);
            return false;
        }
    }

    /**
     * Search for customers by name, phone, or email.
     */
    public List<Customer> searchCustomers(String keyword) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, u.password, u.role, u.email, c.id AS customer_id, c.nic " +
                     "FROM users u JOIN customer c ON u.id = c.user_id " +
                     "WHERE u.role = 'Customer' AND (u.name LIKE ? OR u.phoneNumber LIKE ? OR u.email LIKE ?)";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            stmt.setString(3, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("email"),
                        rs.getInt("customer_id"),
                        rs.getString("nic")
                    );
                    customers.add(customer);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching customers with keyword: " + keyword, e);
        }
        return customers;
    }

    /**
     * Get total count of customers.
     */
    public int getTotalCustomerCount() throws SQLException {
        String sql = "SELECT COUNT(*) AS total FROM customer";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total customer count", e);
            throw e;
        }
        return 0;
    }
    
    public void updateCustomerPassword(int customerId, String hashedPassword) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE id = (SELECT user_id FROM customer WHERE id = ?) AND role = 'Customer'";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, customerId);
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated == 0) {
                LOGGER.log(Level.WARNING, "Password update failed. No matching customer found for ID: " + customerId);
                throw new SQLException("Password update failed. No matching customer found.");
            }
            LOGGER.log(Level.INFO, "Successfully updated password for customer with ID: " + customerId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating customer password for ID: " + customerId, e);
            throw e;
        }
    }
}