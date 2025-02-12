package com.cabservice.model;

import static org.junit.Assert.*;

import org.junit.Test;

public class UserTest {

    @Test
    public void testUserFullConstructor() {
        User user = new User(1, "John Doe", "123 Street", "1234567890", "john@example.com", "password123", "customer");

        assertEquals(1, user.getUserId());
        assertEquals("John Doe", user.getName());
        assertEquals("123 Street", user.getAddress());
        assertEquals("1234567890", user.getPhoneNumber());
        assertEquals("john@example.com", user.getEmail());
        assertEquals("password123", user.getPassword());
        assertEquals("customer", user.getRole());
    }

    @Test
    public void testUserKeyAttributesConstructor() {
        User user = new User(2, "Alice", "alice@example.com", "securePass");

        assertEquals(2, user.getUserId());
        assertEquals("Alice", user.getName());
        assertEquals("alice@example.com", user.getEmail());
        assertEquals("securePass", user.getPassword());
    }

    @Test
    public void testUserMinimalConstructor() {
        User user = new User(3, "bob@example.com", "pass123");

        assertEquals(3, user.getUserId());
        assertEquals("bob@example.com", user.getEmail());
        assertEquals("pass123", user.getPassword());
    }

    @Test
    public void testDefaultConstructorAndSetters() {
        User user = new User();
        user.setUserId(4);
        user.setName("David");
        user.setAddress("456 Avenue");
        user.setPhoneNumber("9876543210");
        user.setEmail("david@example.com");
        user.setPassword("pass456");
        user.setRole("driver");

        assertEquals(4, user.getUserId());
        assertEquals("David", user.getName());
        assertEquals("456 Avenue", user.getAddress());
        assertEquals("9876543210", user.getPhoneNumber());
        assertEquals("david@example.com", user.getEmail());
        assertEquals("pass456", user.getPassword());
        assertEquals("driver", user.getRole());
    }
}
