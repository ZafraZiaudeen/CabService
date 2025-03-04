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

    public void init() throws ServletException {
        userService = UserService.getInstance();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("home")) {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else if (action.equals("register")) {
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        } else if (action.equals("login")) {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else if ("checkLogin".equals(action)) {
            HttpSession session = request.getSession(false);
            boolean isLoggedIn = (session != null && session.getAttribute("customerUser") != null);
            response.setContentType("application/json");
            response.getWriter().write("{\"isLoggedIn\": " + isLoggedIn + "}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            processLogin(request, response);
        } else if ("register".equals(action)) {
            processCustomerRegistration(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Admin admin = userService.loginAdmin(username, password);
        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Customer customer = userService.loginCustomer(username, password);
        if (customer != null) {
            HttpSession session = request.getSession();
            session.setAttribute("customerUser", customer);
            session.setAttribute("customerId", customer.getCustomerId());
            response.sendRedirect(request.getContextPath() + "/user?action=home");
            return;
        }

        request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    private void processCustomerRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Customer customer = new Customer();
            customer.setName(request.getParameter("name"));
            customer.setAddress(request.getParameter("address"));
            customer.setPhoneNumber(request.getParameter("phoneNumber"));
            customer.setUsername(request.getParameter("username"));
            customer.setPassword(BCrypt.hashpw(request.getParameter("password"), BCrypt.gensalt()));
            customer.setRole("Customer");
            customer.setEmail(request.getParameter("email"));
            customer.setNic(request.getParameter("nic"));

            int userId = userService.addUser(customer);
            if (userId > 0) {
                response.sendRedirect("user?action=login");
            } else {
                String errorMessage = "User registration failed.";
                if (userService.isUsernameTaken(customer.getUsername())) {
                    errorMessage = "Username '" + customer.getUsername() + "' is already taken.";
                } else if (userService.isEmailTaken(customer.getEmail())) {
                    errorMessage = "Email '" + customer.getEmail() + "' is already registered.";
                } else if (userService.isNICTaken(customer.getNic())) {
                    errorMessage = "NIC '" + customer.getNic() + "' is already registered.";
                }
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }
}