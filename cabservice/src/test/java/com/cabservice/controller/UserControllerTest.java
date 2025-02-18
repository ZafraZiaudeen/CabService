package com.cabservice.controller;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.junit.Before;
import org.junit.Test;
import org.mockito.*;

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
    private UserController userController;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        userController = new UserController();

        // Inject the mock service into the controller
        java.lang.reflect.Field field = UserController.class.getDeclaredField("userService");
        field.setAccessible(true);
        field.set(userController, mockUserService);

        // ✅ Mock getRequestDispatcher() to return a valid dispatcher
        when(mockRequest.getRequestDispatcher(anyString())).thenReturn(mockDispatcher);
    }

    @Test
    public void testCustomerRegistration_Fails() throws ServletException, IOException {
        // Arrange: Simulate form input values
        when(mockRequest.getParameter("name")).thenReturn("John Doe");
        when(mockRequest.getParameter("address")).thenReturn("123 Main St");
        when(mockRequest.getParameter("phoneNumber")).thenReturn("1234567890");
        when(mockRequest.getParameter("nic")).thenReturn("987654321V");
        when(mockRequest.getParameter("username")).thenReturn("johndoe33");
        when(mockRequest.getParameter("password")).thenReturn("password123");

        // Simulate user creation failure
        when(mockUserService.addUser(any())).thenReturn(-1);

        // Act: Call the registration method
        userController.processCustomerRegistration(mockRequest, mockResponse);

        // ✅ Verify error message is set
        verify(mockRequest).setAttribute(eq("errorMessage"), anyString());

        // ✅ Verify request is forwarded correctly
        verify(mockRequest).getRequestDispatcher("/WEB-INF/view/customer/register.jsp");
        verify(mockDispatcher).forward(mockRequest, mockResponse); // ✅ Prevents NullPointerException
    }
}
