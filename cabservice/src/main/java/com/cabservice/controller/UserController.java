package com.cabservice.controller;

import com.cabservice.model.Admin;
import com.cabservice.model.Customer;
import com.cabservice.service.UserService;
import com.cabservice.service.VerificationService;
import com.cabservice.util.EmailUtil;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private VerificationService verificationService;

    public void init() throws ServletException {
        userService = UserService.getInstance();
        verificationService = new VerificationService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("verify".equals(action)) {
            processVerification(request, response);
        } else if (action == null || action.equals("home")) {
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else if (action.equals("register")) {
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        } else if (action.equals("login")) {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            request.getSession(false).invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else if ("checkLogin".equals(action)) {
            boolean isLoggedIn = request.getSession(false) != null && request.getSession().getAttribute("customerUser") != null;
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

            if (userService.isUsernameTaken(customer.getUsername())) {
                request.setAttribute("errorMessage", "Username '" + customer.getUsername() + "' is already taken.");
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
                return;
            } else if (userService.isEmailTaken(customer.getEmail())) {
                request.setAttribute("errorMessage", "Email '" + customer.getEmail() + "' is already registered.");
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
                return;
            } else if (userService.isNICTaken(customer.getNic())) {
                request.setAttribute("errorMessage", "NIC '" + customer.getNic() + "' is already registered.");
                request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
                return;
            }

            String token = verificationService.storePendingUser(customer);
            if (token != null) {
                EmailUtil.sendVerificationEmail(customer.getEmail(), token);
                request.setAttribute("message", "A verification email has been sent to your email address. Please verify to complete registration.");
            } else {
                request.setAttribute("errorMessage", "Failed to store pending user details.");
            }
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }

    private void processVerification(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        Customer customer = verificationService.verifyUser(token);

        if (customer != null) {
            // Check if the user is already registered (e.g., verified from another device)
            if (!userService.isUsernameTaken(customer.getUsername()) && 
                !userService.isEmailTaken(customer.getEmail()) && 
                !userService.isNICTaken(customer.getNic())) {
                int userId = userService.addUser(customer); // Save to database only if not already registered
                if (userId <= 0) {
                    request.setAttribute("errorMessage", "Failed to save user after verification.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
                    return;
                }
            }
            // Redirect to the verification success page
            request.getRequestDispatcher("/WEB-INF/view/customer/verificationSuccess.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Invalid or expired verification link.");
            request.getRequestDispatcher("/WEB-INF/view/customer/register.jsp").forward(request, response);
        }
    }

    private void processLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Admin admin = userService.loginAdmin(username, password);
        if (admin != null) {
            request.getSession().setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Customer customer = userService.loginCustomer(username, password);
        if (customer != null) {
            request.getSession().setAttribute("customerUser", customer);
            request.getSession().setAttribute("customerId", customer.getCustomerId());
            response.sendRedirect(request.getContextPath() + "/user?action=home");
            return;
        }

        request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }
}