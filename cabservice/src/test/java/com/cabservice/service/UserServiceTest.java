package com.cabservice.service;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.lang.reflect.Field;

import org.junit.Before;
import org.junit.Test;
import org.mockito.*;

import com.cabservice.dao.UserDAO;
import com.cabservice.model.Admin;
import com.cabservice.model.Customer;
import com.cabservice.model.User;

public class UserServiceTest {

    @Mock
    private UserDAO mockUserDAO;

    private UserService userService;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        resetSingleton();
        userService = UserService.getInstance(mockUserDAO);  // Initialize UserService with mocked DAO
    }

    // Reset the singleton instance before each test
    private void resetSingleton() throws Exception {
        Field instance = UserService.class.getDeclaredField("instance");
        instance.setAccessible(true);
        instance.set(null, null);
    }

    @Test
    public void testAddCustomer() throws Exception {
        // Arrange: Create a customer to be added
        Customer customer = new Customer(0, "John Doe", "123 Main St", "1234567890", 
                                         "johndoe33", "password123", "CUSTOMER", 0, "987654321V");

        // Mock the behavior of UserDAO's addUser method to return a generated userId
        when(mockUserDAO.addUser(any(User.class))).thenReturn(1);

        // Act: Add user via UserService
        int userId = userService.addUser(customer);

        // Assert: Check if the returned userId is correct
        assertEquals(1, userId);

        // Verify that addUser was called exactly once
        verify(mockUserDAO, times(1)).addUser(customer);

        // Remove verification for addCustomerDetails() since it's now part of addUser()
    }

    @Test
    public void testAddAdmin_NotAllowed() throws SQLException {
        // Arrange: Create an Admin user (should not be added dynamically)
        Admin admin = new Admin(2, "Admin User", "Admin Address", "1234567890", "admin12", "adminpass", 100);

        // Act: Attempt to add admin
        int userId = userService.addUser(admin);

        // Assert: Ensure that the returned userId is -1 (admin should not be added)
        assertEquals(-1, userId);

        // Verify addUser was never called for an Admin
        verify(mockUserDAO, never()).addUser(any(Admin.class));
    }

    @Test
    public void testGetAllUsers() throws SQLException {
        // Arrange: Mock list of users to return
        List<User> mockUsers = Arrays.asList(
            new Customer(1, "John Doe", "123 Main St", "1234567890", "johndoe33", "password123", "CUSTOMER", 1, "987654321V"),
            new Admin(2, "Admin User", "Admin Address", "1234567890", "admin12", "adminpass", 100)
        );

        when(mockUserDAO.getAllUsers()).thenReturn(mockUsers);

        // Act: Get all users via UserService
        List<User> users = userService.getAllUsers();

        // Assert: Check if users are returned
        assertNotNull(users);
        assertEquals(2, users.size());
        verify(mockUserDAO, times(1)).getAllUsers();
    }
}
