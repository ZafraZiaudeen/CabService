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

@WebServlet("/booking/cancel")
public class CancelBookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

   
    @Override
    public void init() throws ServletException {
       
    }

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

            // Perform cancellation
            if (bookingService.cancelBooking(bookingId)) {
                request.setAttribute("message", "Booking cancelled successfully.");
            } else {
                request.setAttribute("error", "Cancellation failed. Booking cannot be cancelled after 5 minutes from booking time.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid booking ID format.");
            forwardToHistory(request, response, customerId);
            return;
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred while cancelling the booking: " + e.getMessage());
            forwardToHistory(request, response, customerId);
            return;
        }

        // Forward back to booking history page
        forwardToHistory(request, response, customerId);
    }

    private void forwardToHistory(HttpServletRequest request, HttpServletResponse response, int customerId) 
            throws ServletException, IOException {
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
            request.setAttribute("bookingHistory", bookingHistory);
            response.sendRedirect(request.getContextPath() + "/booking/history");
        } catch (SQLException e) {
            throw new ServletException("Failed to retrieve booking history", e);
        }
    }
}