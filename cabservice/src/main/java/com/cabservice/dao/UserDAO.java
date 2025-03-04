package com.cabservice.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.mindrot.jbcrypt.BCrypt;

import com.cabservice.model.User;
import com.cabservice.model.Admin;
import com.cabservice.model.Customer;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    
 // Check if username already exists
    public boolean isUsernameTaken(String username) throws SQLException {
        String query = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Check if email already exists
    public boolean isEmailTaken(String email) throws SQLException {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Check if NIC already exists
    public boolean isNICTaken(String nic) throws SQLException {
        String query = "SELECT COUNT(*) FROM customer WHERE NIC = ?";
        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, nic);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int addUser(User user) throws SQLException {
        if (user instanceof Admin) {
            throw new SQLException("Admin cannot be added dynamically.");
        }

        String userQuery = "INSERT INTO users (name, address, phoneNumber, username, password, role, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String customerQuery = "INSERT INTO customer (user_id, NIC) VALUES (?, ?)";
        
        int userId = -1;

        try (Connection connection = DBConnectionFactory.getConnection()) {
            connection.setAutoCommit(false);

            try (PreparedStatement userStatement = connection.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS)) {
                userStatement.setString(1, user.getName());
                userStatement.setString(2, user.getAddress());
                userStatement.setString(3, user.getPhoneNumber());
                userStatement.setString(4, user.getUsername());
                userStatement.setString(5, user.getPassword());
                userStatement.setString(6, user.getRole());
                userStatement.setString(7, user.getEmail());
                userStatement.executeUpdate();

                try (ResultSet generatedKeys = userStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        userId = generatedKeys.getInt(1);
                    }
                }
            }

            if (userId > 0 && user instanceof Customer) {
                try (PreparedStatement statement = connection.prepareStatement(customerQuery)) {
                    statement.setInt(1, userId);
                    statement.setString(2, ((Customer) user).getNic());
                    statement.executeUpdate();
                }
            }

            connection.commit();
            return userId;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding user and customer details", e);
            throw e;
        }
    }

    public void addCustomerDetails(Customer customer) throws SQLException {
        String customerQuery = "INSERT INTO customer (user_id, NIC) VALUES (?, ?)";
        int customerId = -1;

        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(customerQuery, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, customer.getUserId());  
            statement.setString(2, customer.getNic());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    customerId = generatedKeys.getInt(1); 
                }
            }
            customer.setCustomerId(customerId);
        }
    }
    
    public Admin loginAdmin(String username, String password) {
        String userQuery = "SELECT * FROM users WHERE username = ? AND role = 'Admin'";
        String adminQuery = "SELECT id FROM admin WHERE fk_admin_user_id = ?";

        try (Connection connection = DBConnectionFactory.getConnection()) { 
            try (PreparedStatement userStmt = connection.prepareStatement(userQuery)) {
                userStmt.setString(1, username);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    int userId = userRs.getInt("id");
                    String hashedPassword = userRs.getString("password");
                    String name = userRs.getString("name");
                    String address = userRs.getString("address");
                    String phoneNumber = userRs.getString("phoneNumber");
                    String storedUsername = userRs.getString("username");
                    String email = userRs.getString("email");

                    if (BCrypt.checkpw(password, hashedPassword)) {
                        try (PreparedStatement adminStmt = connection.prepareStatement(adminQuery)) {
                            adminStmt.setInt(1, userId);
                            ResultSet adminRs = adminStmt.executeQuery();

                            if (adminRs.next()) {
                                int adminId = adminRs.getInt("id");
                                return new Admin(userId, name, address, phoneNumber, storedUsername, hashedPassword, email, adminId);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during Admin login", e);
        }
        return null;
    }

    // Fixed parameter index bug
    public void updateAdminDetails(Admin admin) {
        String updateQuery = "UPDATE users SET name = ?, address = ?, phoneNumber = ?, username = ?, email = ? WHERE id = ? AND role = 'Admin'";

        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {

            statement.setString(1, admin.getName());
            statement.setString(2, admin.getAddress());
            statement.setString(3, admin.getPhoneNumber());
            statement.setString(4, admin.getUsername());
            statement.setString(5, admin.getEmail());
            statement.setInt(6, admin.getUserId());

            int rowsUpdated = statement.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Admin details update failed. No matching admin found.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating admin details", e);
        }
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.id, u.name, u.address, u.phoneNumber, u.username, u.password, u.role, u.email, c.NIC " +
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
                String email = resultSet.getString("email");
                String nic = resultSet.getString("NIC");

                if ("ADMIN".equalsIgnoreCase(role)) {
                    users.add(new Admin(id, name, address, phoneNumber, username, password, email, id));
                } else if ("CUSTOMER".equalsIgnoreCase(role)) {
                    users.add(new Customer(id, name, address, phoneNumber, username, password, "CUSTOMER", email, id, nic));
                }
            }
        }
        return users;
    }
    
    public Customer loginCustomer(String username, String password) {
        String userQuery = "SELECT * FROM users WHERE username = ? AND role = 'Customer'";

        try (Connection connection = DBConnectionFactory.getConnection()) {
            try (PreparedStatement userStmt = connection.prepareStatement(userQuery)) {
                userStmt.setString(1, username);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    int userId = userRs.getInt("id");
                    String hashedPassword = userRs.getString("password");
                    String name = userRs.getString("name");
                    String address = userRs.getString("address");
                    String phoneNumber = userRs.getString("phoneNumber");
                    String storedUsername = userRs.getString("username");
                    String email = userRs.getString("email");

                    if (BCrypt.checkpw(password, hashedPassword)) {
                        String customerQuery = "SELECT id, NIC FROM customer WHERE user_id = ?";

                        try (PreparedStatement customerStmt = connection.prepareStatement(customerQuery)) {
                            customerStmt.setInt(1, userId);
                            ResultSet customerRs = customerStmt.executeQuery();

                            if (customerRs.next()) {
                                int customerId = customerRs.getInt("id");
                                String nic = customerRs.getString("NIC");
                                return new Customer(userId, name, address, phoneNumber, storedUsername, hashedPassword, "Customer", email, customerId, nic);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during Customer login", e);
        }
        return null;
    }

    public Admin getAdminById(int adminId) throws SQLException {
        String query = "SELECT * FROM users WHERE id = ? AND role = 'Admin'";
        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, adminId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Admin(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        adminId
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching admin by ID: " + adminId, e);
            throw e;
        }
        return null;
    }

    public void updateAdminPassword(Admin admin) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE id = ? AND role = 'Admin'";
        try (Connection connection = DBConnectionFactory.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, admin.getPassword());
            stmt.setInt(2, admin.getUserId());
            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Password update failed. No matching admin found.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating admin password for ID: " + admin.getUserId(), e);
            throw e;
        }
    }
}