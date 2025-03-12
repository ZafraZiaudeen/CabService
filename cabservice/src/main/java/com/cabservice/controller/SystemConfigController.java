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
                        request.setAttribute("errorMessage", "Failed to delete existing tax/discount configuration.");
                        request.setAttribute("config", systemConfigService.getSystemConfig());
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageTax.jsp").forward(request, response);
                    }
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error occurred.");
            request.getRequestDispatcher("/WEB-INF/view/admin/manageTax.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            systemConfigService = new SystemConfigService(conn);

            if ("update".equals(action)) {
                String taxRateStr = request.getParameter("tax_rate");
                String discountRateStr = request.getParameter("discount_rate");

                if (taxRateStr == null || discountRateStr == null || taxRateStr.trim().isEmpty() || discountRateStr.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Tax rate and discount rate are required.");
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                    return;
                }

                BigDecimal taxRate = new BigDecimal(taxRateStr.trim());
                BigDecimal discountRate = new BigDecimal(discountRateStr.trim());
                BigDecimal hundred = new BigDecimal("100");

                if (taxRate.compareTo(hundred) > 0 || discountRate.compareTo(hundred) > 0) {
                    request.setAttribute("errorMessage", "Tax rate and discount rate cannot exceed 100%.");
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                    return;
                }

                boolean isUpdated = systemConfigService.updateSystemConfig(taxRate, discountRate);
                if (isUpdated) {
                    response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                } else {
                    request.setAttribute("errorMessage", "Failed to update tax/discount configuration.");
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                }
            } else if ("add".equals(action)) {
                String taxRateStr = request.getParameter("tax_rate");
                String discountRateStr = request.getParameter("discount_rate");

                if (taxRateStr == null || discountRateStr == null || taxRateStr.trim().isEmpty() || discountRateStr.trim().isEmpty()) {
                    request.setAttribute("errorMessage", "Tax rate and discount rate are required.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
                    return;
                }

                BigDecimal taxRate = new BigDecimal(taxRateStr.trim());
                BigDecimal discountRate = new BigDecimal(discountRateStr.trim());
                BigDecimal hundred = new BigDecimal("100");

                if (taxRate.compareTo(hundred) > 0 || discountRate.compareTo(hundred) > 0) {
                    request.setAttribute("errorMessage", "Tax rate and discount rate cannot exceed 100%.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
                    return;
                }

                // Delete existing config and insert new one
                conn.setAutoCommit(false); // Start transaction
                try {
                    if (systemConfigService.getSystemConfig() != null) {
                        systemConfigService.deleteSystemConfig(); // Delete existing config
                    }
                    boolean isInserted = systemConfigService.insertSystemConfig(taxRate, discountRate);
                    if (isInserted) {
                        conn.commit();
                        response.sendRedirect(request.getContextPath() + "/system-config?action=view");
                    } else {
                        try {
                            conn.rollback();
                        } catch (SQLException rollbackEx) {
                            rollbackEx.printStackTrace(); // Log rollback failure
                        }
                        request.setAttribute("errorMessage", "Failed to add new tax/discount configuration.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
                    }
                } catch (SQLException e) {
                    try {
                        conn.rollback();
                    } catch (SQLException rollbackEx) {
                        rollbackEx.printStackTrace(); // Log rollback failure
                    }
                    request.setAttribute("errorMessage", "Error adding new tax/discount: " + e.getMessage());
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
                } finally {
                    try {
                        conn.setAutoCommit(true); // Reset to default
                    } catch (SQLException resetEx) {
                        resetEx.printStackTrace(); // Log reset failure
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error occurred: " + e.getMessage());
            if ("update".equals(action)) {
                try {
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                } catch (SQLException configEx) {
                    configEx.printStackTrace();
                    request.setAttribute("errorMessage", "Server error occurred and failed to retrieve config: " + configEx.getMessage());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                }
            } else {
                request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            if ("update".equals(action)) {
                try {
                    request.setAttribute("config", systemConfigService.getSystemConfig());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                } catch (SQLException configEx) {
                    configEx.printStackTrace();
                    request.setAttribute("errorMessage", "Invalid number format and failed to retrieve config: " + configEx.getMessage());
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-tax.jsp").forward(request, response);
                }
            } else {
                request.getRequestDispatcher("/WEB-INF/view/admin/add-tax.jsp").forward(request, response);
            }
        }
    }
}