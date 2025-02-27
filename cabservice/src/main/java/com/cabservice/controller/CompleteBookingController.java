package com.cabservice.controller;

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

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Customer;
import com.cabservice.service.BookingService;

/**
 * Servlet implementation class CompleteBookingController
 */
@WebServlet("/booking/complete") // Changed to a more specific and consistent URL pattern
public class CompleteBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Default constructor
     */
    public CompleteBookingController() {
        super();
    }

    /**
     * Handles GET requests to complete a booking
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        // Get the logged-in customer
        Customer loggedInCustomer = (Customer) session.getAttribute("customerUser");
        int customerId = loggedInCustomer.getCustomerId();

        // Get booking ID from request
        String bookingIdStr = request.getParameter("id");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            request.setAttribute("error", "Invalid booking ID.");
            forwardToHistory(request, response, customerId);
            return;
        }

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            int bookingId = Integer.parseInt(bookingIdStr);

            // Check if the booking is Ongoing and belongs to the customer
            List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
            boolean isOngoing = false;
            for (Map<String, Object> booking : bookingHistory) {
                if ((Integer) booking.get("booking_id") == bookingId && 
                    "Ongoing".equalsIgnoreCase((String) booking.get("status"))) {
                    isOngoing = true;
                    break;
                }
            }

            if (isOngoing) {
                // Perform completion
                bookingService.updateBookingStatus(bookingId, "Completed");
                request.setAttribute("message", "Booking completed successfully.");
            } else {
                request.setAttribute("error", "Only ongoing bookings can be completed.");
            }

            // Forward back to booking history page
            forwardToHistory(request, response, customerId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid booking ID format.");
            forwardToHistory(request, response, customerId);
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred while completing the booking: " + e.getMessage());
            forwardToHistory(request, response, customerId);
        }
    }

    /**
     * Handles POST requests by delegating to doGet
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // For simplicity, delegate POST to GET
    }

    /**
     * Forwards the request back to the booking history page with updated data
     */
    private void forwardToHistory(HttpServletRequest request, HttpServletResponse response, int customerId) 
            throws ServletException, IOException {
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
            request.setAttribute("bookingHistory", bookingHistory);
            request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to retrieve booking history", e);
        }
    }
}