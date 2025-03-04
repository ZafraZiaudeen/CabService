package com.cabservice.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.model.Admin;
import com.cabservice.service.UserService;

@WebServlet("/adminProfile")
public class AdminProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    public AdminProfileController() {
        super();
        userService = UserService.getInstance();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("adminUser");
        
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        // Fetch the latest admin details from the database using userId
        try {
            admin = userService.getAdminById(admin.getUserId()); // Add this method in UserService
            if (admin == null) {
                session.invalidate(); // Invalidate session if admin no longer exists
                response.sendRedirect(request.getContextPath() + "/user?action=login");
                return;
            }
            session.setAttribute("adminUser", admin); // Update session with latest data
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching admin details: " + e.getMessage());
        }

        request.setAttribute("admin", admin); // Set for JSP
        request.getRequestDispatcher("/WEB-INF/view/admin/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("adminUser");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            admin.setName(request.getParameter("fullName"));
            admin.setUsername(request.getParameter("username"));
            admin.setPhoneNumber(request.getParameter("phone"));
            admin.setAddress(request.getParameter("address"));
            userService.updateAdminDetails(admin);
            session.setAttribute("adminUser", admin); // Update session
            request.setAttribute("message", "Profile updated successfully!");
        } else if ("updatePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match!");
            } else if (userService.updateAdminPassword(admin.getUserId(), currentPassword, newPassword)) {
                // Fetch updated admin after password change
                admin = userService.getAdminById(admin.getUserId());
                session.setAttribute("adminUser", admin);
                request.setAttribute("message", "Password updated successfully!");
            } else {
                request.setAttribute("error", "Current password is incorrect!");
            }
        }

        request.setAttribute("admin", admin); // Set for JSP
        request.getRequestDispatcher("/WEB-INF/view/admin/profile.jsp").forward(request, response);
    }
}