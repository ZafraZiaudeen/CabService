package com.cabservice.dao;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.sql.Connection;
import java.sql.SQLException;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class DBConnectionTest {

    private DBConnection dbConnection;

    @Before
    public void setUp() {
        dbConnection = DBConnection.getInstance();
    }

    @Test
    public void testSingletonInstance() {
        DBConnection instance1 = DBConnection.getInstance();
        DBConnection instance2 = DBConnection.getInstance();
        
        assertSame(instance1, instance2);
    }

    @Test
    public void testDatabaseConnectionNotNull() {
        Connection connection = dbConnection.getConnection();
        assertNotNull("Database connection should not be null", connection);
    }

    @Test
    public void testDatabaseConnectionIsValid() throws SQLException {
        Connection connection = dbConnection.getConnection();
        assertTrue("Connection should be valid", connection.isValid(2));
    }
}
