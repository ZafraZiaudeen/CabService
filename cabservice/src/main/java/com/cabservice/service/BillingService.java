package com.cabservice.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

import com.cabservice.dao.BillingDAO;
import com.cabservice.model.Billing;
public class BillingService {
    private BillingDAO billingDAO;

    public BillingService(Connection conn) {
        this.billingDAO = new BillingDAO(conn);
    }

    public Map<String, Double> getSystemConfig() throws SQLException {
        return billingDAO.getSystemConfig();
    }

    public int createBilling(Billing billing) throws SQLException {
        return billingDAO.createBilling(billing);
    }

    public Billing getBillingById(int billingId) throws SQLException {
        return billingDAO.getBillingById(billingId);
    }

    public void updateBillingStatus(int billingId, String status, String paymentType, String cardNumber, String cvv, String expiryDate) throws SQLException {
        billingDAO.updateBillingStatus(billingId, status, paymentType, cardNumber, cvv, expiryDate);
    }
   

    public void updateBillingStatusByBookingId(int bookingId, String status, String paymentType, String cardNumber, String cvv, String expiryDate) throws SQLException {
        // Update billing status
        billingDAO.updateBillingStatusByBookingId(bookingId, status, paymentType, cardNumber, cvv, expiryDate);

        // If billing status is "Paid", update the booking status to "Complete"
        if ("Paid".equals(status)) {
            billingDAO.updateBookingStatus(bookingId, "Completed");
        }
    }
    public Billing getBillingByBookingId(int bookingId) throws SQLException {
        return billingDAO.getBillingByBookingId(bookingId);
    }
   

    public void updateBilling(Billing billing) throws SQLException {
        billingDAO.updateBilling(billing);
    }
    public void removePaymentDetails(int bookingId) throws SQLException {
        billingDAO.removePaymentDetails(bookingId);
    }
}
