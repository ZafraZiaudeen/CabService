package com.cabservice.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.service.SystemConfigService;

@WebServlet("/system-config")
public class SystemConfigController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SystemConfigService systemConfigService;

    public SystemConfigController() {
        super();
        try (Connection conn = DBConnectionFactory.getConnection()) {
            systemConfigService = new SystemConfigService(conn);
        } catch (Exception e) {
            throw new RuntimeException("Database connection error", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false); 

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }
        try (Connection conn = DBConnectionFactory.getConnection()) {
            systemConfigService = new SystemConfigService(conn);

            if (action == null || action.isEmpty()) {
                action = "view";
            }

            switch (action) {
                case "view":
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageTax.jsp").forward(request, response);
                    break;

                case "edit":
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                    break;

                case "add":
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
                    break;

                case "delete":
                    boolean isDeleted = systemConfigService.deleteSystemConfig();
                    if (isDeleted) {
                        response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/system-config?action=view&error=deleteFailed");
                    }
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/system-config?action=view&error=serverError");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            systemConfigService = new SystemConfigService(conn);

            if ("update".equals(action)) {
                String taxRateStr = request.getParameter("tax_rate");
                String discountRateStr = request.getParameter("discount_rate");

                if (taxRateStr == null || discountRateStr == null ||
                    taxRateStr.trim().isEmpty() || discountRateStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=edit&error=missingFields");
                    return;
                }

                BigDecimal taxRate = new BigDecimal(taxRateStr.trim());
                BigDecimal discountRate = new BigDecimal(discountRateStr.trim());

                boolean isUpdated = systemConfigService.updateSystemConfig(taxRate, discountRate);
                if (isUpdated) {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                } else {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=edit&error=updateFailed");
                }
            }

            // Add new tax/discount configuration
            if ("add".equals(action)) {
                String taxRateStr = request.getParameter("tax_rate");
                String discountRateStr = request.getParameter("discount_rate");

                if (taxRateStr == null || discountRateStr == null ||
                    taxRateStr.trim().isEmpty() || discountRateStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view&error=missingFields");
                    return;
                }

                BigDecimal taxRate = new BigDecimal(taxRateStr.trim());
                BigDecimal discountRate = new BigDecimal(discountRateStr.trim());

                boolean isInserted = systemConfigService.insertSystemConfig(taxRate, discountRate);
                if (isInserted) {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                } else {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view&error=insertFailed");
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/system-config?action=view&error=serverError");
        }
    }
}
