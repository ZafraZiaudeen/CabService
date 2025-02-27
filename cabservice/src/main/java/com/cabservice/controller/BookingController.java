package com.cabservice.controller;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
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

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);

            if ("add".equals(action)) {
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            } else if ("manage".equals(action)) {
                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            } else if ("pending".equals(action)) {
                List<Map<String, Object>> bookings = bookingService.getPendingBookings();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/pendingBooking.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Booking booking = bookingService.getBookingById(bookingId);
                    if (booking != null) {
                        request.setAttribute("booking", booking);
                        request.getRequestDispatcher("/WEB-INF/view/admin/edit-booking.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Booking not found.");
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                }
            } else if ("delete".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    int bookingId = Integer.parseInt(bookingIdStr);
                    boolean deleted = bookingService.deleteBooking(bookingId);
                    if (deleted) {
                        request.setAttribute("success", "Booking deleted successfully!");
                    } else {
                        request.setAttribute("error", "Failed to delete booking.");
                    }
                } else {
                    request.setAttribute("error", "Invalid booking ID.");
                }
                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            } else {
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
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                String distanceKmStr = request.getParameter("distance_km");

                if (customerIdStr == null || customerIdStr.isEmpty() ||
                    vehicleIdStr == null || vehicleIdStr.isEmpty() ||
                    pickupLocation == null || pickupLocation.isEmpty() ||
                    dropoffLocation == null || dropoffLocation.isEmpty() ||
                    distanceKmStr == null || distanceKmStr.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                int customerId = Integer.parseInt(customerIdStr);
                int vehicleId = Integer.parseInt(vehicleIdStr);
                double distanceKm;
                try {
                    distanceKm = Double.parseDouble(distanceKmStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid distance value.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                if (distanceKm <= 0) {
                    request.setAttribute("error", "Distance must be greater than zero.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                int driverId = bookingService.getDriverForVehicle(vehicleId);
                if (driverId == -1) {
                    request.setAttribute("error", "No driver assigned to this vehicle.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                    return;
                }

                Booking newBooking = new Booking();
                newBooking.setBookingNumber("BK" + System.currentTimeMillis());
                newBooking.setCustomerId(customerId);
                newBooking.setDriverId(driverId);
                newBooking.setVehicleId(vehicleId);
                newBooking.setPickupLocation(pickupLocation);
                newBooking.setDropoffLocation(dropoffLocation);
                newBooking.setDistanceKm(distanceKm);

                int bookingId = bookingService.createBooking(newBooking);
                if (bookingId != -1) {
                    Map<String, Double> config = bookingService.getSystemConfig();
                    double taxRate = config.get("taxRate");
                    double discountRate = config.get("discountRate");

                    double ratePerKm = bookingService.getRatePerKm(vehicleId);
                    double totalAmount = bookingService.calculateFare(distanceKm, ratePerKm);
                    double tax = totalAmount * (taxRate / 100);
                    double discount = totalAmount * (discountRate / 100);
                    double finalAmount = totalAmount + tax - discount;

                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    billing.setTotalAmount(totalAmount);
                    billing.setTax(tax);
                    billing.setDiscount(discount);
                    billing.setFinalAmount(finalAmount);

                    int billingId = billingService.createBilling(billing);
                    if (billingId != -1) {
                        request.setAttribute("success", "Booking created successfully with ID: " + bookingId);
                        List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                        request.setAttribute("bookings", bookings);
                        request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Billing creation failed.");
                    }
                } else {
                    request.setAttribute("error", "Booking creation failed.");
                }
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                String bookingIdStr = request.getParameter("bookingId");
                String pickupLocation = request.getParameter("pickup_location");
                String dropoffLocation = request.getParameter("dropoff_location");
                String customerIdStr = request.getParameter("customer_id");
                String vehicleIdStr = request.getParameter("vehicle_id");
                String status = request.getParameter("status");
                String distanceKmStr = request.getParameter("distance_km");

                if (bookingIdStr == null || pickupLocation == null || dropoffLocation == null || 
                    customerIdStr == null || vehicleIdStr == null || status == null || 
                    distanceKmStr == null || distanceKmStr.isEmpty()) {
                    request.setAttribute("error", "Missing required fields.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                int bookingId = Integer.parseInt(bookingIdStr);
                int customerId = Integer.parseInt(customerIdStr);
                int vehicleId = Integer.parseInt(vehicleIdStr);
                double distanceKm;
                try {
                    distanceKm = Double.parseDouble(distanceKmStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid distance value.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                if (distanceKm <= 0) {
                    request.setAttribute("error", "Distance must be greater than zero.");
                    List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                    request.setAttribute("bookings", bookings);
                    request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
                    return;
                }

                Booking booking = bookingService.getBookingById(bookingId);
                if (booking != null) {
                    booking.setCustomerId(customerId);
                    booking.setVehicleId(vehicleId);
                    booking.setPickupLocation(pickupLocation);
                    booking.setDropoffLocation(dropoffLocation);
                    booking.setDistanceKm(distanceKm);
                    booking.setStatus(status); // Set status from form
                    bookingService.updateBooking(booking);
                    bookingService.updateBookingStatus(bookingId, status);

                    if (!"Cancelled".equals(status)) {
                        double ratePerKm = bookingService.getRatePerKm(booking.getVehicleId());
                        Map<String, Double> config = bookingService.getSystemConfig();
                        double taxRate = config.get("taxRate");
                        double discountRate = config.get("discountRate");

                        double totalAmount = bookingService.calculateFare(distanceKm, ratePerKm);
                        double tax = totalAmount * (taxRate / 100);
                        double discount = totalAmount * (discountRate / 100);
                        double finalAmount = totalAmount + tax - discount;

                        Billing billing = billingService.getBillingByBookingId(bookingId);
                        if (billing != null) {
                            billing.setTotalAmount(totalAmount);
                            billing.setTax(tax);
                            billing.setDiscount(discount);
                            billing.setFinalAmount(finalAmount);
                            billingService.updateBilling(billing);
                        }
                    } else {
                        Billing billing = billingService.getBillingByBookingId(bookingId);
                        if (billing != null) {
                            billingService.updateBillingStatusByBookingId(bookingId, "Cancelled", billing.getPaymentType(), null, null, null);
                            billingService.removePaymentDetails(bookingId);
                        }
                    }

                    request.setAttribute("success", "Booking updated successfully!");
                } else {
                    request.setAttribute("error", "Booking not found.");
                }

                List<Map<String, Object>> bookings = bookingService.getAllBookingsWithCustomerDetails();
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/manageBooking.jsp").forward(request, response);
        }
    }
}