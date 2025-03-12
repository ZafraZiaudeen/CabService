package com.cabservice.controller;

import com.cabservice.model.Driver;
import com.cabservice.service.DriverService;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/driver")
public class DriverController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DriverService driverService;

    public DriverController() {
        super();
        driverService = new DriverService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }
        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/view/admin/add-driver.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int driverId = Integer.parseInt(request.getParameter("driverId"));
            Driver driver = driverService.getDriverById(driverId);
            if (driver != null) {
                request.setAttribute("driver", driver);
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-driver.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Driver not found.");
                request.getRequestDispatcher("/WEB-INF/view/admin/manageDriver.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            int driverId = Integer.parseInt(request.getParameter("driverId"));
            boolean success = driverService.deleteDriver(driverId);
            response.sendRedirect(request.getContextPath() + "/driver?action=list");
        } else if ("list".equals(action)) {
            request.setAttribute("drivers", driverService.getAllDrivers());
            request.getRequestDispatcher("/WEB-INF/view/admin/manageDriver.jsp").forward(request, response);
        } else if ("available".equals(action)) {
            request.setAttribute("drivers", driverService.getAvailableDrivers());
            request.getRequestDispatcher("/WEB-INF/view/admin/active-drivers.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("save".equals(action)) {
            String name = request.getParameter("name");
            String nic = request.getParameter("nic");
            String licenseNumber = request.getParameter("licenseNumber");
            String phoneNumber = request.getParameter("phoneNumber");
            int experience = Integer.parseInt(request.getParameter("experience"));
            boolean availability = Boolean.parseBoolean(request.getParameter("availability"));

            try {
                boolean success = driverService.addDriver(name, nic, licenseNumber, phoneNumber, experience, availability);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/driver?action=list");
                } else {
                    request.setAttribute("errorMessage", "Error adding driver.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-driver.jsp").forward(request, response);
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/admin/add-driver.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            int driverId = Integer.parseInt(request.getParameter("driverId"));
            String name = request.getParameter("name");
            String nic = request.getParameter("nic");
            String licenseNumber = request.getParameter("licenseNumber");
            String phoneNumber = request.getParameter("phoneNumber");
            int experience = Integer.parseInt(request.getParameter("experience"));
            boolean availability = Boolean.parseBoolean(request.getParameter("availability"));

            Driver currentDriver = driverService.getDriverById(driverId);
            if (currentDriver == null) {
                request.setAttribute("errorMessage", "Driver not found.");
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-driver.jsp").forward(request, response);
                return;
            }

            try {
                boolean success = driverService.updateDriver(driverId, name, nic, licenseNumber, phoneNumber, experience, availability);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/driver?action=list");
                } else {
                    request.setAttribute("errorMessage", "Error updating driver.");
                    request.setAttribute("driver", currentDriver);
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-driver.jsp").forward(request, response);
                }
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", e.getMessage());
                request.setAttribute("driver", currentDriver);
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-driver.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error updating driver: " + e.getMessage());
                request.setAttribute("driver", currentDriver);
                request.getRequestDispatcher("/WEB-INF/view/admin/edit-driver.jsp").forward(request, response);
            }
        }
    }
}