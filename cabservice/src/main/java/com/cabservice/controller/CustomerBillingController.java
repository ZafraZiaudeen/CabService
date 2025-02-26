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
                // View billing details
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
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
                    request.setAttribute("error", "Invalid billing ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }

            } else if ("completeBilling".equals(action)) {
                // After completing the billing, navigate to booking history
                String customerIdStr = request.getParameter("customer_id");  // Assuming customer_id is passed
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);

                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);

                    if (bookingHistory != null && !bookingHistory.isEmpty()) {
                        // Store the booking history in the request to be displayed in the booking history page
                        request.setAttribute("bookingHistory", bookingHistory);

                        // Forward to the bookingHistory.jsp page
                        request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                    } else {
                        // Handle case where no bookings are found for the customer
                        request.setAttribute("error", "No bookings found for this customer.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
                }

            } else if ("back".equals(action)) {
                // Navigate back to booking page after billing (based on the billingId)
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);

                    // Fetch the billing details first
                    Billing billing = billingService.getBillingById(billingId);
                    if (billing != null) {
                        // Fetch the booking details using the bookingId from the billing object
                        int bookingId = billing.getBookingId();
                        Booking booking = bookingService.getBookingById(bookingId);

                        if (booking != null) {
                           
                            request.setAttribute("tempBookingData", booking);

                            // Optionally, you can delete the booking if needed (like a cancellation or modification)
                             bookingService.deleteBooking(bookingId);

                            // Forward to booking page with pre-populated data
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
            }else if ("viewHistory".equals(action)) {
                String customerIdStr = request.getParameter("customer_id");
                if (customerIdStr != null && !customerIdStr.isEmpty()) {
                    int customerId = Integer.parseInt(customerIdStr);
                    // Fetch booking history with payment details for this customer
                    List<Map<String, Object>> bookingHistory = bookingService.getBookingHistoryWithPaymentDetails(customerId);

                    // Store the booking history in the request
                    request.setAttribute("bookingHistory", bookingHistory);

                    // Forward to the bookingHistory.jsp page to display the data
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Invalid customer ID.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/bookingHistory.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            // Handle unexpected errors
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/billing.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);
            BookingService bookingService = new BookingService(conn); // Instantiate the bookingService here

            if ("save".equals(action)) {
                // Extract user inputs for billing details
                String bookingIdStr = request.getParameter("booking_id");
                String paymentType = request.getParameter("payment_type"); // 'Cash' or 'Card'
                int bookingId = Integer.parseInt(bookingIdStr);

                // Check if payment_type is not null or empty
                if (paymentType == null || paymentType.isEmpty()) {
                    request.setAttribute("error", "Payment type cannot be null.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                    return;
                }

                // Check if a billing record already exists for this booking_id
                Billing existingBilling = billingService.getBillingByBookingId(bookingId);

                if (existingBilling != null) {
                    // Update the existing billing record's status to 'Paid'
                    billingService.updateBillingStatusByBookingId(bookingId, "Paid", paymentType, 
                            request.getParameter("card_number"), 
                            request.getParameter("cvv"),
                            request.getParameter("expiry_date"));
                } else {
                    // Create a new billing record
                    Billing billing = new Billing();
                    billing.setBookingId(bookingId);
                    billing.setTotalAmount(Double.parseDouble(request.getParameter("total_amount")));
                    billing.setTax(Double.parseDouble(request.getParameter("tax")));
                    billing.setDiscount(Double.parseDouble(request.getParameter("discount")));
                    billing.setFinalAmount(Double.parseDouble(request.getParameter("final_amount")));
                    billing.setPaymentType(paymentType); // Ensure payment_type is set

                    // Save card details only if payment type is Card
                    if ("Card".equals(paymentType)) {
                        billing.setCardNumber(request.getParameter("card_number"));
                        billing.setCvv(request.getParameter("cvv"));
                        billing.setExpiryDate(request.getParameter("expiry_date"));
                    }

                    // Create the billing entry
                    int billingId = billingService.createBilling(billing);

                    if (billingId != -1) {
                        // Update payment status to 'Paid'
                        billingService.updateBillingStatus(billingId, "Paid", paymentType, 
                            request.getParameter("card_number"), 
                            request.getParameter("cvv"),
                            request.getParameter("expiry_date"));
                    } else {
                        request.setAttribute("error", "Failed to create billing.");
                        request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                        return;
                    }
                }

                // Set success message
                request.setAttribute("success", "Billing completed successfully!");

                // After successful billing, redirect to booking history page
                // Assuming you have customer_id in session, or you could fetch it from request
                Integer customerId = (Integer) request.getSession().getAttribute("customerId");
                if (customerId != null) {
                    // Redirect to booking history page
                    response.sendRedirect(request.getContextPath() + "/customerBilling?action=completeBilling&customer_id=" + customerId);
                } else {
                    // Handle error if customerId is missing
                    request.setAttribute("error", "Customer ID is missing.");
                    request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            // Handle any unexpected errors
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp").forward(request, response);
        }
    }

}
