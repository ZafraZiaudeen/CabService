package com.cabservice.model;

import static org.junit.Assert.*;

import org.junit.Test;

public class UserTest {

    @Test
    public void testUserFullConstructor() {
        User user = new User(1, "John Doe", "123 Street", "1234567890", "john32", 
                             "password123", "customer", "john@example.com");

        assertEquals(1, user.getUserId());
        assertEquals("John Doe", user.getName());
        assertEquals("123 Street", user.getAddress());
        assertEquals("1234567890", user.getPhoneNumber());
        assertEquals("john32", user.getUsername());
        assertEquals("password123", user.getPassword());
        assertEquals("customer", user.getRole());
        assertEquals("john@example.com", user.getEmail());
    }

    @Test
    public void testUserKeyAttributesConstructor() {
        User user = new User(2, "Alice", "alice12", "securePass");

        assertEquals(2, user.getUserId());
        assertEquals("Alice", user.getName());
        assertEquals("alice12", user.getUsername());
        assertEquals("securePass", user.getPassword());
        assertNull(user.getAddress());  
        assertNull(user.getPhoneNumber());  
        assertNull(user.getRole());  
        assertNull(user.getEmail());  
    }

    @Test
    public void testUserMinimalConstructor() {
        User user = new User(3, "bob34", "pass123");

        assertEquals(3, user.getUserId());
        assertEquals("bob34", user.getUsername());
        assertEquals("pass123", user.getPassword());
        assertNull(user.getName());  // Not set in this constructor
        assertNull(user.getAddress());  // Not set
        assertNull(user.getPhoneNumber());  // Not set
        assertNull(user.getRole());  // Not set
        assertNull(user.getEmail());  // Not set
    }

    @Test
    public void testDefaultConstructorAndSetters() {
        User user = new User();
        user.setUserId(4);
        user.setName("David");
        user.setAddress("456 Avenue");
        user.setPhoneNumber("9876543210");
        user.setUsername("david11");
        user.setPassword("pass456");
        user.setRole("driver");
        user.setEmail("david@example.com");

        assertEquals(4, user.getUserId());
        assertEquals("David", user.getName());
        assertEquals("456 Avenue", user.getAddress());
        assertEquals("9876543210", user.getPhoneNumber());
        assertEquals("david11", user.getUsername());
        assertEquals("pass456", user.getPassword());
        assertEquals("driver", user.getRole());
        assertEquals("david@example.com", user.getEmail());
    }
}