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

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.service.BillingService;
import com.cabservice.service.BookingService;

/**
 * Servlet implementation class CustomerBillingController
 */
@WebServlet("/customerBilling")
public class CustomerBillingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerBillingController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);
            BookingService bookingService = new BookingService(conn);

            if ("view".equals(action)) {
                String billingIdStr = request.getParameter("id");
                String bookingIdStr = request.getParameter("booking_id");

                if (bookingIdStr != null && !bookingIdStr.isEmpty()) {
                    // Fetch billing by booking_id if provided
                    int bookingId = Integer.parseInt(bookingIdStr);
                    Billing billing = billingService.getBillingByBookingId(bookingId);
                    if (billing != null) {
                        request.setAttribute("billing", billing);
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Billing details not found for this booking.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    }
                } else if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    // Fetch billing by billing_id
                    int billingId = Integer.parseInt(billingIdStr);
                    Billing billing = billingService.getBillingById(billingId);
                    if (billing != null) {
                        request.setAttribute("billing", billing);
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Billing details not found.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid billing or booking ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }

            } else if ("completeBilling".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);
                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
                    request.setAttribute("bookingHistory", bookingHistory);
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }

            } else if ("back".equals(action)) {
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);
                    Billing billing = billingService.getBillingById(billingId);
                    if (billing != null) {
                        int bookingId = billing.getBookingId();
                        Booking booking = bookingService.getBookingById(bookingId);
                        if (booking != null) {
                            request.setAttribute("tempBookingData", booking);
                            bookingService.deleteBooking(bookingId);
                            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                        } else {
                            request.setAttribute("error", "Booking details not found.");
                            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("error", "Billing details not found.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid billing ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            } else if ("viewHistory".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);
                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);
                    request.setAttribute("bookingHistory", bookingHistory);
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);
            BookingService bookingService = new BookingService(conn);

            if ("save".equals(action)) {
                String bookingIdStr = request.getParameter("booking_id");
                String paymentType = request.getParameter("payment_type");
                int bookingId = Integer.parseInt(bookingIdStr);

                if (paymentType == null || paymentType.isEmpty()) {
                    request.setAttribute("error", "Payment type cannot be null.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                    return;
                }

                Billing existingBilling = billingService.getBillingByBookingId(bookingId);
                if (existingBilling != null) {
                    // Update existing billing record
                    existingBilling.setPaymentType(paymentType);
                    if ("Card".equals(paymentType)) {
                        existingBilling.setCardNumber(request.getParameter("card_number"));
                        existingBilling.setCvv(request.getParameter("cvv"));
                        existingBilling.setExpiryDate(request.getParameter("expiry_date"));
                    } else {
                        existingBilling.setCardNumber(null);
                        existingBilling.setCvv(null);
                        existingBilling.setExpiryDate(null);
                    }
                    billingService.updateBilling(existingBilling);
                    billingService.updateBillingStatusByBookingId(bookingId, "Paid", paymentType, 
                        request.getParameter("card_number"), request.getParameter("cvv"), request.getParameter("expiry_date"));
                    
                    // Update booking status to Ongoing
                    bookingService.updateBookingStatus(bookingId, "Ongoing");
                } else {
                    // Create new billing record (shouldn't happen since booking already has billing, but included for robustness)
                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    billing.setTotalAmount(Double.parseDouble(request.getParameter("total_amount")));
                    billing.setTax(Double.parseDouble(request.getParameter("tax")));
                    billing.setDiscount(Double.parseDouble(request.getParameter("discount")));
                    billing.setFinalAmount(Double.parseDouble(request.getParameter("final_amount")));
                    billing.setPaymentType(paymentType);
                    if ("Card".equals(paymentType)) {
                        billing.setCardNumber(request.getParameter("card_number"));
                        billing.setCvv(request.getParameter("cvv"));
                        billing.setExpiryDate(request.getParameter("expiry_date"));
                    }
                    int billingId = billingService.createBilling(billing);
                    if (billingId != -1) {
                        billingService.updateBillingStatus(billingId, "Paid", paymentType, 
                            request.getParameter("card_number"), request.getParameter("cvv"), request.getParameter("expiry_date"));
                        bookingService.updateBookingStatus(bookingId, "Ongoing");
                    } else {
                        request.setAttribute("error", "Failed to create billing.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                        return;
                    }
                }

                // Set success message
                request.setAttribute("success", "Payment completed successfully!");

                // Redirect to booking history
                Integer customerId = (Integer) request.getSession().getAttribute("customerId");
                if (customerId != null) {
                    response.sendRedirect(request.getContextPath() + "/customerBilling?action=completeBilling&customer_id=" + customerId);
                } else {
                    request.setAttribute("error", "Customer ID is missing.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
        }
    }
}