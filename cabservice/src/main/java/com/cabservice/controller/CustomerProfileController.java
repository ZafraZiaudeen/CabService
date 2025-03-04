package com.cabservice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.model.Customer;
import com.cabservice.service.CustomerService;
import org.mindrot.jbcrypt.BCrypt; // Add BCrypt dependency for password hashing

@WebServlet("/customerProfile")
public class CustomerProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerProfileController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if customer is authenticated
        if (session == null || session.getAttribute("customerUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        // Get customer ID from session
        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            request.setAttribute("error", "Customer ID not found in session.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
            return;
        }

        // Fetch customer details
        CustomerService customerService = new CustomerService();
        Customer customer = customerService.getCustomerById(customerId);

        if (customer != null) {
            // Set attributes for JSP including NIC
            request.setAttribute("name", customer.getName());
            request.setAttribute("username", customer.getUsername());
            request.setAttribute("email", customer.getEmail());
            request.setAttribute("phone", customer.getPhoneNumber());
            request.setAttribute("address", customer.getAddress());
            request.setAttribute("nic", customer.getNic());
            request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Customer details not found.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            request.setAttribute("error", "Customer ID not found in session.");
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        CustomerService customerService = new CustomerService();

        if ("updatePersonalInfo".equals(action)) {
            String name = request.getParameter("name");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String nic = request.getParameter("nic");

            try {
                // Update customer details including NIC
                boolean updated = customerService.updateCustomer(customerId, name, address, phone, username, email, nic);
                if (updated) {
                    request.setAttribute("name", name);
                    request.setAttribute("username", username);
                    request.setAttribute("email", email);
                    request.setAttribute("phone", phone);
                    request.setAttribute("address", address);
                    request.setAttribute("nic", nic);
                    request.setAttribute("success", "Personal information updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update personal information.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error updating personal information: " + e.getMessage());
            }
            request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
        } else if ("updatePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate passwords match
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match.");
                reloadCustomerData(request, customerService, customerId);
                request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
                return;
            }

            Customer customer = customerService.getCustomerById(customerId);
            if (customer == null) {
                request.setAttribute("error", "Customer not found.");
                reloadCustomerData(request, customerService, customerId);
                request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
                return;
            }

            // Check current password (assumes passwords are hashed with BCrypt)
            if (!BCrypt.checkpw(currentPassword, customer.getPassword())) {
                request.setAttribute("error", "Current password is incorrect.");
                reloadCustomerData(request, customerService, customerId);
                request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
                return;
            }

            try {
                // Hash the new password
                String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                // Update only the password
                customerService.updateCustomerPassword(customerId, hashedNewPassword);
                request.setAttribute("success", "Password updated successfully.");
            } catch (Exception e) {
                request.setAttribute("error", "Error updating password: " + e.getMessage());
            }
            // Reload customer data to refresh other fields
            reloadCustomerData(request, customerService, customerId);
            request.getRequestDispatcher("/WEB-INF/view/customer/profile.jsp").forward(request, response);
        }
    }

    // Helper method to reload customer data
    private void reloadCustomerData(HttpServletRequest request, CustomerService customerService, int customerId) {
        Customer customer = customerService.getCustomerById(customerId);
        if (customer != null) {
            request.setAttribute("name", customer.getName());
            request.setAttribute("username", customer.getUsername());
            request.setAttribute("email", customer.getEmail());
            request.setAttribute("phone", customer.getPhoneNumber());
            request.setAttribute("address", customer.getAddress());
            request.setAttribute("nic", customer.getNic());
        }
    }
}