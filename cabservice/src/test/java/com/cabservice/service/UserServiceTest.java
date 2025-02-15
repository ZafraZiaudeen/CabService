package com.cabservice.service;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.cabservice.dao.UserDAO;
import com.cabservice.model.User;

public class UserServiceTest {

    @Mock
    private UserDAO mockUserDAO;

    private UserService userService;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        userService = UserService.getInstance();
        
        try {
            java.lang.reflect.Field field = UserService.class.getDeclaredField("userDAO");
            field.setAccessible(true);
            field.set(userService, mockUserDAO);
        } catch (Exception e) {
            throw new RuntimeException("Failed to inject mock UserDAO", e);
        }
    }

    @Test
    public void testAddUser() {
        User user = new User(1, "John Doe", "123 Main St", "1234567890", "johndoe@example.com", "password123", "customer");
        doNothing().when(mockUserDAO).addUser(user);
        userService.addUser(user);
        verify(mockUserDAO, times(1)).addUser(user);
    }

    @Test
    public void testGetAllUsers() throws SQLException {
        List<User> mockUsers = Arrays.asList(
            new User(1, "John Doe", "123 Main St", "1234567890", "johndoe@example.com", "password123", "customer"),
            new User(2, "Jane Smith", "456 Oak St", "9876543210", "janesmith@example.com", "securepass", "driver")
        );

        when(mockUserDAO.getAllUsers()).thenReturn(mockUsers);
        List<User> users = userService.getAllUsers();
        assertNotNull(users);
        assertEquals(2, users.size());
        verify(mockUserDAO, times(1)).getAllUsers();
    }
}