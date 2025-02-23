package com.cabservice.controller;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
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

@WebServlet("/booking")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BookingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);

            if ("add".equals(action)) {
                // Show the add booking page
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // Handle billing details view
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);
                    Billing billing = bookingService.getBillingById(billingId); // Use BookingService
                    if (billing != null) {
                        request.setAttribute("billing", billing);
                        request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Billing details not found.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid billing ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid billing ID format.");
            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);

            if ("save".equals(action)) {
                // Validate customer_id, vehicle_id, pickup_location, and dropoff_location
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");

                if (customerIdStr == null || customerIdStr.isEmpty() ||
                    vehicleIdStr == null || vehicleIdStr.isEmpty() ||
                    pickupLocation == null || pickupLocation.isEmpty() ||
                    dropoffLocation == null || dropoffLocation.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                int customerId = Integer.parseInt(customerIdStr);
                int vehicleId = Integer.parseInt(vehicleIdStr);

                // Calculate distance
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
                    int billingId = bookingService.createBilling(billing); // Assuming this method now returns the ID
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input data.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        }
    }
}
