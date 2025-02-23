package com.cabservice.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cabservice.dao.DBConnectionFactory;
import com.cabservice.model.Billing;
import com.cabservice.service.BillingService;

@WebServlet("/billing")
public class BillingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);

            if ("view".equals(action)) {
                String billingIdStr = request.getParameter("id");
                if (billingIdStr != null && !billingIdStr.isEmpty()) {
                    int billingId = Integer.parseInt(billingIdStr);
                    Billing billing = billingService.getBillingById(billingId);
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
            request.setAttribute("error", "An error occurred while fetching billing details.");
            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid billing ID.");
            request.getRequestDispatcher("/WEB-INF/view/admin/billing.jsp").forward(request, response);
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DBConnectionFactory.getConnection()) {
            BillingService billingService = new BillingService(conn);

            if ("save".equals(action)) {
                // Extract user inputs for billing details
                String bookingIdStr = request.getParameter("booking_id");
                String paymentType = request.getParameter("payment_type"); // 'Cash' or 'Card'
                int bookingId = Integer.parseInt(bookingIdStr);

                // Check if payment_type is not null or empty
                if (paymentType == null || paymentType.isEmpty()) {
                    request.setAttribute("error", "Payment type cannot be null.");
                    request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
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
                        request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
                        return;
                    }
                }

                // Set success message
                request.setAttribute("success", "Billing completed successfully!");

                // Redirect to the add-booking page
                request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error occurred while processing your request.");
            request.getRequestDispatcher("/WEB-INF/view/admin/add-booking.jsp").forward(request, response);
        }
    }
}
