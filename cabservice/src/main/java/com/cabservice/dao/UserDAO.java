package com.cabservice.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.cabservice.model.User;
import com.cabservice.model.Admin;
import com.cabservice.model.Customer;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public int addUser(User user) throws SQLException {
        if (user instanceof Admin) {
            throw new SQLException("Admin cannot be added dynamically.");
        }

        String userQuery = "INSERT INTO users (name, address, phoneNumber, username, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        String customerQuery = "INSERT INTO customer (user_id, NIC) VALUES (?, ?)";
        
        int userId = -1;

        try (Connection connection = DBConnectionFactory.getConnection()) {
            connection.setAutoCommit(false);  // Start transaction

            try (PreparedStatement userStatement = connection.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS)) {
                userStatement.setString(1, user.getName());
                userStatement.setString(2, user.getAddress());
                userStatement.setString(3, user.getPhoneNumber());
                userStatement.setString(4, user.getUsername());
                userStatement.setString(5, user.getPassword());
                userStatement.setString(6, user.getRole());
                userStatement.executeUpdate();

                // Retrieve generated user_id
                try (ResultSet generatedKeys = userStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userId = generatedKeys.getInt(1);
                    }
                }
            }

            // If user is a customer, insert into the customer table
            if (userId > 0 && user instanceof Customer) {
                try (PreparedStatement statement = connection.prepareStatement(customerQuery)) {
                    statement.setInt(1, userId);
                    statement.setString(2, ((Customer) user).getNic());
                    statement.executeUpdate();
                }
            }

            connection.commit();  // Commit transaction
            return userId;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding user and customer details", e);
            throw e;
        }
    }

    // Add customer details to customer table
    public void addCustomerDetails(Customer customer) throws SQLException {
        String customerQuery = "INSERT INTO customer (user_id, NIC) VALUES (?, ?)";
        int customerId = -1;

        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(customerQuery, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, customer.getUserId());  // Use the user_id as the foreign key
            statement.setString(2, customer.getNic());
            statement.executeUpdate();

            // Retrieve the generated customer_id
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    customerId = generatedKeys.getInt(1);  // Get the generated customer_id
                }
            }

            // Set the customerId to the customer object
            customer.setCustomerId(customerId);
        }
    }

    // Update existing Admin details
    public void updateAdminDetails(Admin admin) {
        String updateQuery = "UPDATE users SET name = ?, address = ?, phoneNumber = ?, username = ? WHERE id = ? AND role = 'ADMIN'";

        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {

            statement.setString(1, admin.getName());
            statement.setString(2, admin.getAddress());
            statement.setString(3, admin.getPhoneNumber());
            statement.setString(4, admin.getUsername());
            statement.setInt(5, admin.getUserId());

            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Admin details update failed. No matching admin found.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating admin details", e);
        }
    }

    // Retrieve all users (Admins & Customers)
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, u.password, u.role, c.NIC " +
                       "FROM users u LEFT JOIN customer c ON u.id = c.user_id";

        try (Connection connection = DBConnectionFactory.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String address = resultSet.getString("address");
                String phoneNumber = resultSet.getString("phoneNumber");
                String username = resultSet.getString("username");
                String password = resultSet.getString("password");
                String role = resultSet.getString("role");
                String nic = resultSet.getString("NIC"); // NULL for Admins

                if ("ADMIN".equalsIgnoreCase(role)) {
                    users.add(new Admin(id, name, address, phoneNumber, username, password, id));  // Fixed constructor
                } else if ("CUSTOMER".equalsIgnoreCase(role)) {
                    users.add(new Customer(id, name, address, phoneNumber, username, password, "CUSTOMER", id, nic));
                }
            }
        }
        return users;
    }
}
