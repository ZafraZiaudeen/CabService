package com.cabservice.dao;

import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.sql.*;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import com.cabservice.model.Admin;
import com.cabservice.model.Customer;
import com.cabservice.model.User;

public class UserDAOTest {

    @InjectMocks
    private UserDAO userDAO;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @Mock
    private PreparedStatement secondPreparedStatement; 

    @Mock
    private Statement statement;

    @Mock
    private ResultSet resultSet;

    private MockedStatic<DBConnectionFactory> mockedStatic;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        // Mock the static DBConnectionFactory
        mockedStatic = mockStatic(DBConnectionFactory.class);
        mockedStatic.when(DBConnectionFactory::getConnection).thenReturn(connection);

        // Default stubbing for connection methods
        lenient().when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
        lenient().when(connection.createStatement()).thenReturn(statement);
        lenient().when(preparedStatement.executeQuery()).thenReturn(resultSet);
        lenient().when(statement.executeQuery(anyString())).thenReturn(resultSet);
    }

    @After
    public void tearDown() {
        if (mockedStatic != null) {
            mockedStatic.close();
        }
    }

    @Test
    public void testIsUsernameTaken_True() throws SQLException {
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt(1)).thenReturn(1);

        boolean result = userDAO.isUsernameTaken("testuser");
        assertTrue(result);
        verify(preparedStatement).setString(1, "testuser");
    }

    @Test
    public void testIsUsernameTaken_False() throws SQLException {
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt(1)).thenReturn(0);

        boolean result = userDAO.isUsernameTaken("testuser");
        assertFalse(result);
    }

    @Test
    public void testIsEmailTaken_True() throws SQLException {
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt(1)).thenReturn(1);

        boolean result = userDAO.isEmailTaken("test@example.com");
        assertTrue(result);
        verify(preparedStatement).setString(1, "test@example.com");
    }

    @Test
    public void testIsNICTaken_True() throws SQLException {
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt(1)).thenReturn(1);

        boolean result = userDAO.isNICTaken("123456789V");
        assertTrue(result);
        verify(preparedStatement).setString(1, "123456789V");
    }

    @Test
    public void testAddUser_Customer() throws SQLException {
        Customer customer = new Customer(0, "John Doe", "123 Street", "1234567890", "johndoe", "hashedpass", "Customer", "john@example.com", 0, "123456789V");
        when(connection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(preparedStatement);
        when(connection.prepareStatement(eq("INSERT INTO customer (user_id, NIC) VALUES (?, ?)"))).thenReturn(secondPreparedStatement);
        when(preparedStatement.getGeneratedKeys()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true, false);
        when(resultSet.getInt(1)).thenReturn(1);

        int userId = userDAO.addUser(customer);
        assertEquals(1, userId);
        verify(connection).commit();
        verify(preparedStatement).setString(1, "John Doe");
        verify(preparedStatement).setString(4, "johndoe");
        verify(secondPreparedStatement).setInt(1, 1);
        verify(secondPreparedStatement).setString(2, "123456789V");
    }

    @Test(expected = SQLException.class)
    public void testAddUser_Admin() throws SQLException {
        Admin admin = new Admin(1, "Admin", "Admin St", "0987654321", "admin", "hashedpass", "admin@example.com", 1);
        userDAO.addUser(admin);
    }

    @Test
    public void testAddCustomerDetails() throws SQLException {
        Customer customer = new Customer(1, "John Doe", "123 Street", "1234567890", "johndoe", "hashedpass", "Customer", "john@example.com", 0, "123456789V");
        when(connection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS))).thenReturn(preparedStatement);
        when(preparedStatement.getGeneratedKeys()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt(1)).thenReturn(2);

        userDAO.addCustomerDetails(customer);
        assertEquals(2, customer.getCustomerId());
    }

}