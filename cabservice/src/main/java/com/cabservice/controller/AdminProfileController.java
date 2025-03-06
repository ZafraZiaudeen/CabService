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
        HttpSession session = request.getSession(false); 
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("adminUser");

        // Fetch the latest admin details from the database
        try {
            admin = userService.getAdminById(admin.getUserId());
            if (admin == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/user?action=login");
                return;
            }
            session.setAttribute("adminUser", admin);
        } catch (Exception e) {
            request.setAttribute("error", "Error fetching admin details: " + e.getMessage());
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/WEB-INF/view/admin/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("adminUser");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            admin.setName(request.getParameter("fullName"));
            admin.setUsername(request.getParameter("username"));
            admin.setPhoneNumber(request.getParameter("phone"));
            admin.setAddress(request.getParameter("address"));
            admin.setEmail(request.getParameter("email")); 

            try {
                userService.updateAdminDetails(admin);
                session.setAttribute("adminUser", admin);
                request.setAttribute("message", "Profile updated successfully!");
            } catch (Exception e) {
                request.setAttribute("error", "Error updating profile: " + e.getMessage());
            }
        } else if ("updatePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match!");
            } else {
                try {
                    if (userService.updateAdminPassword(admin.getUserId(), currentPassword, newPassword)) {
                        admin = userService.getAdminById(admin.getUserId());
                        session.setAttribute("adminUser", admin);
                        request.setAttribute("message", "Password updated successfully!");
                    } else {
                        request.setAttribute("error", "Current password is incorrect!");
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Error updating password: " + e.getMessage());
                }
            }
        }

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/WEB-INF/view/admin/profile.jsp").forward(request, response);
    }
}