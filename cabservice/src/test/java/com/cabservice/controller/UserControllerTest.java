package com.cabservice.controller;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.junit.Before;
import org.junit.Test;
import org.mockito.*;

import com.cabservice.model.Customer;
import com.cabservice.service.UserService;

public class UserControllerTest {

    @Mock
    private UserService mockUserService;

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private RequestDispatcher mockDispatcher;

    @Mock
    private HttpSession mockSession;

    private UserController userController;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        userController = new UserController();

        // Inject the mock service into the controller
        java.lang.reflect.Field field = UserController.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(userController, mockUserService);

        // Mock getRequestDispatcher() to return a valid dispatcher
        when(mockRequest.getRequestDispatcher(anyString())).thenReturn(mockDispatcher);

        // Mock getSession() to return a valid session
        when(mockRequest.getSession()).thenReturn(mockSession);
    }

    @Test
    public void testCustomerRegistration_Success() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("action")).thenReturn("register");
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("email")).thenReturn("john@example.com");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate successful user creation
        when(mockUserService.addUser(any(Customer.class))).thenReturn(1);

        // Act: Call the doPost method (which calls processCustomerRegistration)
        userController.doPost(mockRequest, mockResponse);

        // Assert: Verify redirection to login page
        verify(mockResponse).sendRedirect("user?action=login");
        verify(mockRequest, never()).setAttribute(eq("errorMessage"), anyString());
        verify(mockDispatcher, never()).forward(mockRequest, mockResponse);
    }

    @Test
    public void testCustomerRegistration_Fails_Generic() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("action")).thenReturn("register");
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("email")).thenReturn("john@example.com");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate user creation failure
        when(mockUserService.addUser(any(Customer.class))).thenReturn(-1);
        when(mockUserService.isUsernameTaken("johndoe33")).thenReturn(false);
        when(mockUserService.isEmailTaken("john@example.com")).thenReturn(false);
        when(mockUserService.isNICTaken("987654321V")).thenReturn(false);

        // Act: Call the doPost method
        userController.doPost(mockRequest, mockResponse);

        // Assert: Verify error message is set and request is forwarded
        verify(mockRequest).setAttribute("errorMessage", "User registration failed.");
        verify(mockRequest).getRequestDispatcher("/WEB-INF/view/customer/register.jsp");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
        verify(mockResponse, never()).sendRedirect(anyString());
    }

    @Test
    public void testCustomerRegistration_Fails_DuplicateUsername() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("action")).thenReturn("register");
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("email")).thenReturn("john@example.com");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate user creation failure due to duplicate username
        when(mockUserService.addUser(any(Customer.class))).thenReturn(-1);
        when(mockUserService.isUsernameTaken("johndoe33")).thenReturn(true);
        when(mockUserService.isEmailTaken("john@example.com")).thenReturn(false);
        when(mockUserService.isNICTaken("987654321V")).thenReturn(false);

        // Act: Call the doPost method
        userController.doPost(mockRequest, mockResponse);

        // Assert: Verify specific error message for duplicate username
        verify(mockRequest).setAttribute("errorMessage", "Username 'johndoe33' is already taken.");
        verify(mockRequest).getRequestDispatcher("/WEB-INF/view/customer/register.jsp");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
        verify(mockResponse, never()).sendRedirect(anyString());
    }

    @Test
    public void testCustomerRegistration_Fails_DuplicateEmail() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("action")).thenReturn("register");
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("email")).thenReturn("john@example.com");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate user creation failure due to duplicate email
        when(mockUserService.addUser(any(Customer.class))).thenReturn(-1);
        when(mockUserService.isUsernameTaken("johndoe33")).thenReturn(false);
        when(mockUserService.isEmailTaken("john@example.com")).thenReturn(true);
        when(mockUserService.isNICTaken("987654321V")).thenReturn(false);

        // Act: Call the doPost method
        userController.doPost(mockRequest, mockResponse);

        // Assert: Verify specific error message for duplicate email
        verify(mockRequest).setAttribute("errorMessage", "Email 'john@example.com' is already registered.");
        verify(mockRequest).getRequestDispatcher("/WEB-INF/view/customer/register.jsp");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
        verify(mockResponse, never()).sendRedirect(anyString());
    }

    @Test
    public void testCustomerRegistration_Fails_DuplicateNIC() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("action")).thenReturn("register");
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("email")).thenReturn("john@example.com");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate user creation failure due to duplicate NIC
        when(mockUserService.addUser(any(Customer.class))).thenReturn(-1);
        when(mockUserService.isUsernameTaken("johndoe33")).thenReturn(false);
        when(mockUserService.isEmailTaken("john@example.com")).thenReturn(false);
        when(mockUserService.isNICTaken("987654321V")).thenReturn(true);

        // Act: Call the doPost method
        userController.doPost(mockRequest, mockResponse);

        // Assert: Verify specific error message for duplicate NIC
        verify(mockRequest).setAttribute("errorMessage", "NIC '987654321V' is already registered.");
        verify(mockRequest).getRequestDispatcher("/WEB-INF/view/customer/register.jsp");
        verify(mockDispatcher).forward(mockRequest, mockResponse);
        verify(mockResponse, never()).sendRedirect(anyString());
    }
}