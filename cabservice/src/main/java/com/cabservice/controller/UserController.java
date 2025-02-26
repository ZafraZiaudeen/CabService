package com.cabservice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import com.cabservice.model.Customer;
import com.cabservice.model.Admin;
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
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else if (action.equals("register")) {
            showRegisterPage(request, response);
        } else if (action.equals("login")) {
            showLoginPage(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false); // Get existing session
            if (session != null) {
                session.invalidate();  // Invalidate the session to log out
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp"); // Redirect to home page
            return;
        } else if ("checkLogin".equals(action)) {
            // New action to check login status
            HttpSession session = request.getSession(false);
            boolean isLoggedIn = (session != null && session.getAttribute("customerUser") != null);
            response.setContentType("application/json");
            response.getWriter().write("{\"isLoggedIn\": " + isLoggedIn + "}");
            return;
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("login")) {
            processLogin(request, response);
        } else if (action != null && action.equals("register")) {
            processCustomerRegistration(request, response);
        } else {
            doGet(request, response);
        }
    }

    protected void processLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Try to login as Admin
        Admin admin = userService.loginAdmin(username, password);
        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/dashboard"); // Redirect to admin dashboard
            return;
        }

        // If not admin, try to login as Customer
        Customer customer = userService.loginCustomer(username, password);

        if (customer != null) {
            HttpSession session = request.getSession();
            session.setAttribute("customerUser", customer);
            session.setAttribute("customerId", customer.getCustomerId()); // Correct method to get customerId
 // Use the customerId from the customer table
            System.out.println("Customer logged in: " + customer.getCustomerId()); // Debug log
            response.sendRedirect(request.getContextPath() + "/user?action=home");
            return;
        }

        // If authentication fails, show error message and stay on login page
        request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }


    // Customer registration process
    protected void processCustomerRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Customer customer = new Customer();
            customer.setName(request.getParameter("name"));
            customer.setAddress(request.getParameter("address"));
            customer.setPhoneNumber(request.getParameter("phoneNumber"));
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt()));
            customer.setRole("Customer");
            customer.setNic(request.getParameter("nic"));

            if (userService.addUser(customer) > 0) {
                response.sendRedirect("user?action=login");
            } else {
                request.setAttribute("errorMessage", "User registration failed.");
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }
}
