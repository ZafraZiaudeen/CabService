package com.cabservice.service;

import java.sql.SQLException;
import java.util.List;
import com.cabservice.dao.UserDAO;
import com.cabservice.model.User;

public class UserService {
    private static volatile UserService instance;
    private UserDAO userDAO;

    private UserService() {
        this.userDAO = new UserDAO();
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

    public void addUser(User user) {
        userDAO.addUser(user);
    }

    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }
}