package com.cabservice.dao;

import com.cabservice.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    /**
     * Fetch all customers from the database.
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, c.nic " +
                "FROM users u " +
                "LEFT JOIN customer c ON u.id = c.user_id " +
                "WHERE u.role = 'Customer'";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setUserId(rs.getInt("id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phoneNumber"));
                customer.setUsername(rs.getString("username"));
                customer.setNic(rs.getString("nic"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    /**
     * Delete a customer from both 'customer' and 'users' tables.
     */
    public boolean deleteCustomer(int customerId) {
        String deleteCustomerQuery = "DELETE FROM customer WHERE user_id = ?";
        String deleteUserQuery = "DELETE FROM users WHERE id = ? AND role = 'Customer'";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement psCustomer = conn.prepareStatement(deleteCustomerQuery);
                 PreparedStatement psUser = conn.prepareStatement(deleteUserQuery)) {

                // Delete from customer table first
                psCustomer.setInt(1, customerId);
                psCustomer.executeUpdate();

                // Delete from users table
                psUser.setInt(1, customerId);
                psUser.executeUpdate();

                conn.commit(); // Commit only if both queries succeed
                return true;

            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Insert a new customer into the database.
     */
    public boolean insertCustomer(String name, String address, String phoneNumber, String username, String hashedPassword, String role, String nic) {
        String insertUserQuery = "INSERT INTO users (name, address, phoneNumber, username, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        String insertCustomerQuery = "INSERT INTO customer (NIC, user_id) VALUES (?, ?)";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement userPs = conn.prepareStatement(insertUserQuery, Statement.RETURN_GENERATED_KEYS)) {

                // Insert into users table
                userPs.setString(1, name);
                userPs.setString(2, address);
                userPs.setString(3, phoneNumber);
                userPs.setString(4, username);
                userPs.setString(5, hashedPassword);
                userPs.setString(6, role);
                userPs.executeUpdate();

                // Retrieve the generated user ID
                try (ResultSet rs = userPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        int userId = rs.getInt(1);

                        // Insert into customer table
                        try (PreparedStatement customerPs = conn.prepareStatement(insertCustomerQuery)) {
                            customerPs.setString(1, nic);
                            customerPs.setInt(2, userId);
                            customerPs.executeUpdate();
                        }

                        conn.commit(); // Commit transaction
                        return true;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Fetch a customer by ID.
     */
    public Customer getCustomerById(int customerId) {
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, c.NIC " +
                       "FROM users u JOIN customer c ON u.id = c.user_id WHERE u.id = ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setUserId(rs.getInt("id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phoneNumber"));
                customer.setUsername(rs.getString("username"));
                customer.setNic(rs.getString("NIC"));
                return customer;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;  // ✅ Return null if no customer found
    }

    /**
     * Update an existing customer in the database.
     */
    public boolean updateCustomer(int customerId, String name, String address, String phoneNumber, String username, String nic) {
        String updateUserQuery = "UPDATE users SET name = ?, address = ?, phoneNumber = ?, username = ? WHERE id = ?";
        String updateCustomerQuery = "UPDATE customer SET NIC = ? WHERE user_id = ?";

        try (Connection conn = DBConnectionFactory.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement userPs = conn.prepareStatement(updateUserQuery);
                 PreparedStatement customerPs = conn.prepareStatement(updateCustomerQuery)) {

                // Update users table
                userPs.setString(1, name);
                userPs.setString(2, address);
                userPs.setString(3, phoneNumber);
                userPs.setString(4, username);
                userPs.setInt(5, customerId);
                userPs.executeUpdate();

                // Update customer table
                customerPs.setString(1, nic);
                customerPs.setInt(2, customerId);
                customerPs.executeUpdate();

                conn.commit(); // Commit only if both updates succeed
                return true;

            } catch (SQLException e) {
                conn.rollback(); // Rollback on error
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
