package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;
import com.cabservice.service.CustomerService;
import com.cabservice.service.DriverService;
import com.cabservice.service.VehicleService;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public DashboardController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            DriverService driverService = new DriverService(); 
            BillingService billingService = new BillingService(conn);
            CustomerService customerService = new CustomerService();
            VehicleService vehicleService = new VehicleService();
            
            // Fetch total bookings count and growth percentage
            int totalBookings = bookingService.getTotalBookingsCount();
            request.setAttribute("totalBookings", totalBookings);

            LocalDate now = LocalDate.now();
            int currentYear = now.getYear();
            int currentMonth = now.getMonthValue();
            double growthPercentage = bookingService.getMonthlyBookingGrowthPercentage(currentYear, currentMonth);
            request.setAttribute("growthPercentage", growthPercentage);

            // Fetch driver counts
            int totalDrivers = driverService.getTotalDriversCount();
            int availableDrivers = driverService.getAvailableDriversCount();
            request.setAttribute("totalDrivers", totalDrivers);
            request.setAttribute("availableDrivers", availableDrivers);

            // Fetch current bookings counts
            int currentBookings = bookingService.getCurrentBookingsCount();
            int pendingBookings = bookingService.getPendingBookingsCount();
            int ongoingBookings = bookingService.getOngoingBookingsCount();
            int completedBookings = bookingService.getCompletedBookingsCount();
            int cancelledBookings = bookingService.getCancelledBookingsCount();
            
            request.setAttribute("currentBookings", currentBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("ongoingBookings", ongoingBookings);
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("cancelledBookings", cancelledBookings);

         // Fetch revenue breakdown
            double totalRevenue = billingService.getTotalRevenue();
            double cardRevenue = billingService.getCardRevenue();
            double cashRevenue = billingService.getCashRevenue();
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("cardRevenue", cardRevenue);
            request.setAttribute("cashRevenue", cashRevenue);
            
         // Fetch total customer count
            int totalCustomers = customerService.getTotalCustomerCount();
            request.setAttribute("totalCustomers", totalCustomers);
            
            
         // Fetch total vehicle count
            int totalVehicles = vehicleService.getTotalVehicleCount();
            request.setAttribute("totalVehicles", totalVehicles);
            
            
         // Fetch recent bookings for the last 3 days
            List<Map<String, Object>> recentBookings = bookingService.getRecentBookingsLast3Days();
            request.setAttribute("recentBookings", recentBookings); 
            
            request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred while loading dashboard.");
            request.getRequestDispatcher("/WEB-INF/view/admin/dashboard.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}