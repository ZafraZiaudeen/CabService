package com.cabservice.controller;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BookingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false); 

        if (session == null || session.getAttribute("adminUser") == null) {
            System.out.println("Redirecting: No active session found!");
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }
        // Start with a try-with-resources block for connection handling
        try (Connection conn = DBConnectionFactory.getConnection()) {
            // Instantiate the BookingService with the database connection
            BookingService bookingService = new BookingService(conn);

            // Handle the different actions based on the request parameter
            if ("add".equals(action)) {
                // Show the add booking page
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);

            } else if ("view".equals(action)) {
                // Handle the view action for billing details
                String billingIdStr = request.getParameter("id");

                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    try {
                        int billingId = Integer.parseInt(billingIdStr);
                        Billing billing = bookingService.getBillingById(billingId); // Retrieve billing details using the service

                        if (billing != null) {
                            request.setAttribute("billing", billing);
                            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                        } else {
                            request.setAttribute("error", "Billing details not found.");
                            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Invalid billing ID format.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid billing ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                }

            } else if ("edit".equals(action)) {
                // Handle the edit action for the booking
                String bookingIdStr = request.getParameter("booking_id");

                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    try {
                        int bookingId = Integer.parseInt(bookingIdStr);
                        Booking booking = bookingService.getBookingById(bookingId); 

                        if (booking != null) {
                            // Pass the booking to the JSP for rendering
                            request.setAttribute("booking", booking); 
                            request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
                        } else {
                            request.setAttribute("error", "Booking not found.");
                            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Invalid booking ID format.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                    }

                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                }
            } else {
                // If the action parameter is not recognized, redirect to the add-booking page
                request.setAttribute("error", "Invalid action.");
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            BillingService billingService = new BillingService(conn); 

            if ("save".equals(action)) {
                // Validate customer_id, vehicle_id, pickup_location, and dropoff_location
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");

                // Check for null or empty values
                if (customerIdStr == null || customerIdStr.isEmpty() ||
                    vehicleIdStr == null || vehicleIdStr.isEmpty() ||
                    pickupLocation == null || pickupLocation.isEmpty() ||
                    dropoffLocation == null || dropoffLocation.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                // Try to parse customer_id and vehicle_id, handle NumberFormatException
                int customerId = -1;
                int vehicleId = -1;
                try {
                    customerId = Integer.parseInt(customerIdStr);
                    vehicleId = Integer.parseInt(vehicleIdStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid customer or vehicle ID format.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                // Validate distance
                double distanceKm = bookingService.calculateDistance(pickupLocation, dropoffLocation);
                if (distanceKm == 0) {
                    request.setAttribute("error", "No valid route found between the selected locations.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                // Get driver for the selected vehicle
                int driverId = bookingService.getDriverForVehicle(vehicleId);
                if (driverId == -1) {
                    request.setAttribute("error", "No driver assigned to this vehicle.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
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
                    // Fetch the latest tax and discount rates
                    Map<String, Double> config = bookingService.getSystemConfig();
                    double taxRate = config.get("taxRate");
                    double discountRate = config.get("discountRate");

                    // Calculate billing details
                    double ratePerKm = bookingService.getRatePerKm(vehicleId);
                    double totalAmount = bookingService.calculateFare(distanceKm, ratePerKm);
                    double tax = totalAmount * (taxRate / 100);
                    double discount = totalAmount * (discountRate / 100);
                    double finalAmount = totalAmount + tax - discount;

                    // Create a billing entry
                    Billing billing = new Billing();
                    billing.setBookingId(bookingId); // Use the generated booking ID
                    billing.setTotalAmount(totalAmount);
                    billing.setTax(tax);
                    billing.setDiscount(discount);
                    billing.setFinalAmount(finalAmount);

                    // Save the billing entry and get the generated ID
                    int billingId = billingService.createBilling(billing); // Use billingService here
                    if (billingId != -1) {
                        // Redirect to the billing page with the billing ID
                        response.sendRedirect(request.getContextPath() + "/billing?action=view&id=" + billingId);
                    } else {
                        request.setAttribute("error", "Billing creation failed.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    }

                } else {
                    request.setAttribute("error", "Booking failed.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                }

            } else if ("update".equals(action)) {
                // Fetch and update booking details
                String bookingIdStr = request.getParameter("booking_id");
                if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
                    return;
                }

                int bookingId = Integer.parseInt(bookingIdStr);
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
                int customerId = Integer.parseInt(request.getParameter("customer_id"));

                // Get driver id
                int driverId = bookingService.getDriverForVehicle(vehicleId);
                if (driverId == -1) {
                    request.setAttribute("error", "No driver assigned to this vehicle.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
                    return;
                }

                Booking updatedBooking = new Booking();
                updatedBooking.setId(bookingId);
                updatedBooking.setPickupLocation(pickupLocation);
                updatedBooking.setDropoffLocation(dropoffLocation);
                updatedBooking.setVehicleId(vehicleId);
                updatedBooking.setCustomerId(customerId);
                updatedBooking.setDriverId(driverId);

                // Update booking details
                bookingService.updateBooking(updatedBooking);

                // Fetch the billing details for the updated booking
                Billing billing = billingService.getBillingByBookingId(bookingId);
                if (billing != null) {
                    // Recalculate the fare based on the new pickup and dropoff locations
                    double distanceKm = bookingService.calculateDistance(pickupLocation, dropoffLocation);
                    double ratePerKm = bookingService.getRatePerKm(vehicleId);
                    double totalAmount = bookingService.calculateFare(distanceKm, ratePerKm);
                    double tax = totalAmount * (bookingService.getSystemConfig().get("taxRate") / 100);
                    double discount = totalAmount * (bookingService.getSystemConfig().get("discountRate") / 100);
                    double finalAmount = totalAmount + tax - discount;

                    // Update billing details
                    billing.setTotalAmount(totalAmount);
                    billing.setTax(tax);
                    billing.setDiscount(discount);
                    billing.setFinalAmount(finalAmount);

                    // Update billing record in the database
                    billingService.updateBilling(billing);
                }

                // Redirect to dashboard.jsp after updating the booking
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data.");
            request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
        }
    }
}
