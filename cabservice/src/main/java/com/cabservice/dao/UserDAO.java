package com.cabservice.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.cabservice.model.User;

public class UserDAO {

	
		public void addUser(User user) {
			  String query = "INSERT INTO users (name, address, phoneNumber, email, password, role) VALUES (?, ?, ?, ?, ?, ?)";
		        Connection connection = null;
		        PreparedStatement statement = null;
		        
		        try {
		            connection = DBConnectionFactory.getConnection();
		            statement = connection.prepareStatement(query);
		            statement.setString(1, user.getName());
		            statement.setString(2, user.getAddress());
		            statement.setString(3, user.getPhoneNumber());
		            statement.setString(4, user.getEmail());
		            statement.setString(5, user.getPassword());
		           statement.setString(6,user.getRole());
		            statement.executeUpdate();
		        } catch (SQLException e) {
		            e.printStackTrace();
		        } finally {
		            try {
		                if (statement != null) {
		                    statement.close();
		                }
		            } catch (SQLException e) {
		                e.printStackTrace();
		            }
		        }
		
		}
		
		 public List<User> getAllUsers() throws SQLException {
		        List<User> users = new ArrayList<>();
		        String query = "SELECT * FROM users";

		        Connection connection = DBConnectionFactory.getConnection();
		        Statement statement = connection.createStatement();
		        ResultSet resultSet = statement.executeQuery(query);
		        
		        while (resultSet.next()) {
		            int Id = resultSet.getInt("id");
		            String name = resultSet.getString("name");
		            String address = resultSet.getString("address");
		            String phoneNumber = resultSet.getString("phoneNumber");
		            String email= resultSet.getString("email");
		            String password = resultSet.getString("password");
		            String role = resultSet.getString("role");
		            
		           
		            users.add(new User(Id,name,address,phoneNumber,email,password,role));
		        }
		        
		        resultSet.close();
		        statement.close();
		        return users;
		    }
		
}
