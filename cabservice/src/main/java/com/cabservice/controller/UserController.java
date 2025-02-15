package com.cabservice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cabservice.model.User;
import com.cabservice.service.UserService;

@WebServlet("/user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public UserController() {
        super();
    }

    public void init() throws ServletException {
        userService = UserService.getInstance();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.equals("home")) {
            // Redirect to the homepage (index.jsp)
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else if (action.equals("register")) {
            showRegisterPage(request, response);
        } else if (action.equals("login")) {
            showLoginPage(request, response);
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/customer/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && action.equals("register")) {
            processUserRegistration(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
    }

    private void processUserRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "customer";
        User user = new User();
        user.setName(name);
        user.setAddress(address);
        user.setPhoneNumber(phoneNumber);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);
        try {
            userService.addUser(user);  // This actually saves the user to the database
            response.sendRedirect("user?action=login"); // Redirect after success
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }
}
