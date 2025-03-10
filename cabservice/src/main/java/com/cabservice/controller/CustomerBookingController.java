package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;

@WebServlet("/customerBooking")
public class CustomerBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerBookingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("customerUser") != null) {
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            BillingService billingService = new BillingService(conn);

            if ("save".equals(action)) {
             
                // Retrieve form parameters
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                String distanceKmStr = request.getParameter("distance_km");

                // Check for empty values
                if (customerIdStr == null || customerIdStr.isEmpty() ||
                    vehicleIdStr == null || vehicleIdStr.isEmpty() ||
                    pickupLocation == null || pickupLocation.isEmpty() ||
                    dropoffLocation == null || dropoffLocation.isEmpty() ||
                    distanceKmStr == null || distanceKmStr.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    return;
                }

                // Parse customer_id, vehicle_id, and distance_km
                int customerId;
                int vehicleId;
                double distanceKm;
                try {
                    customerId = Integer.parseInt(customerIdStr);
                    vehicleId = Integer.parseInt(vehicleIdStr);
                    distanceKm = Double.parseDouble(distanceKmStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid customer, vehicle ID, or distance format.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    return;
                }

                // Validate distance
                if (distanceKm <= 0) {
                    request.setAttribute("error", "Invalid distance between the selected locations.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    return;
                }

                // Get driver for the selected vehicle
                int driverId = bookingService.getDriverForVehicle(vehicleId);
                if (driverId == -1) {
                    request.setAttribute("error", "No driver assigned to this vehicle.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    return;
                }

                // Create a new booking
                Booking newBooking = new Booking();
                newBooking.setBookingNumber("BK" + System.currentTimeMillis());
                newBooking.setCustomerId(customerId);
                newBooking.setDriverId(driverId);
                newBooking.setVehicleId(vehicleId);
                newBooking.setPickupLocation(pickupLocation);
                newBooking.setDropoffLocation(dropoffLocation);
                newBooking.setDistanceKm(distanceKm);

                // Save the booking and get the generated booking ID
                int bookingId = bookingService.createBooking(newBooking);
                if (bookingId != -1) {
                    double finalAmount = bookingService.calculateFinalAmount(vehicleId, distanceKm);
                    if (finalAmount < 0) {
                        request.setAttribute("error", "Failed to calculate final amount.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                        return;
                    }

                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    // Let sp_create_billing calculate total_amount, tax, discount, and final_amount
                    int billingId = billingService.createBilling(billing);
                    if (billingId != -1) {
                        response.sendRedirect(request.getContextPath() + "/customerBilling?action=view&id=" + billingId);
                    } else {
                        request.setAttribute("error", "Billing creation failed.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Booking failed.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
        }
    }
}