package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
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

@WebServlet("/booking/history")
public class BookingHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public BookingHistoryController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // false means don't create a new session if none exists

        // Check if the user is logged in
        if (session == null || session.getAttribute("customerUser") == null) {
            // Redirect to login page if not authenticated
            response.sendRedirect(request.getContextPath() + "/user?action=login");
            return;
        }

        // Get the logged-in customer
        Customer loggedInCustomer = (Customer) session.getAttribute("customerUser");
        int customerId = loggedInCustomer.getCustomerId();

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BookingService bookingService = new BookingService(conn);
            // Fetch booking history for the authenticated customer
            List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
            request.setAttribute("bookingHistory", bookingHistory);
            // Forward to the JSP
            request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while retrieving booking history: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // Delegate POST to GET for simplicity
    }
}