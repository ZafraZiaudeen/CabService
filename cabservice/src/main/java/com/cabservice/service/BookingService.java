package com.cabservice.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.cabservice.dao.BillingDAO;
import com.cabservice.dao.BookingDAO;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;

public class BookingService {
	private BookingDAO bookingDAO;
    private BillingDAO billingDAO;

    public BookingService(Connection conn) {
        this.bookingDAO = new BookingDAO(conn);
        this.billingDAO = new BillingDAO(conn);
    
    }

    public List<String> getCustomerSuggestions(String input) throws SQLException {
        return bookingDAO.getCustomerSuggestions(input);
    }

    public List<Map<String, String>> getAvailableVehicles() throws SQLException {
        return bookingDAO.getAvailableVehicles();
    }

    public double calculateDistance(String from, String to) throws SQLException {
        return bookingDAO.getDistance(from, to);
    }

    public int createBooking(Booking booking) throws SQLException {
        return bookingDAO.createBooking(booking);
    }
    public int getDriverForVehicle(int vehicleId) throws SQLException {
        return bookingDAO.getDriverForVehicle(vehicleId);
    }

    public double getRatePerKm(int vehicleId) throws SQLException {
        return bookingDAO.getRatePerKm(vehicleId);
    }

    public double calculateFare(double distanceKm, double ratePerKm) {
        return distanceKm * ratePerKm;
    }
    public Map<String, Double> getSystemConfig() throws SQLException {
        return bookingDAO.getSystemConfig();
    }

    public int createBilling(Billing billing) throws SQLException {
        return billingDAO.createBilling(billing);  // Ensure the DAO method returns the generated ID
    }

    public Billing getBillingById(int billingId) throws SQLException {
        return billingDAO.getBillingById(billingId);
    }
    public Booking getBookingById(int bookingId) throws SQLException {
        return bookingDAO.getBookingById(bookingId);
    }

    public boolean updateBooking(Booking booking) throws SQLException {
        
		return bookingDAO.updateBooking(booking);
    }
    
    public boolean deleteBooking(int bookingId) throws SQLException {
        return bookingDAO.deleteBooking(bookingId);
    }

    public List<Booking> getBookingHistoryByCustomerId(int customerId) throws SQLException {
        return bookingDAO.getBookingHistoryByCustomerId(customerId);
    }
    
    public List<Map<String, Object>> getBookingHistoryWithPaymentDetails(int customerId) throws SQLException {
        return bookingDAO.getBookingHistoryWithPaymentDetails(customerId);
    }

 // In BookingService.java
    public boolean cancelBooking(int bookingId) throws SQLException {
        if (bookingDAO.canCancelBooking(bookingId)) {
            bookingDAO.cancelBooking(bookingId); 
            billingDAO.removePaymentDetails(bookingId); 
            return true;
        }
        return false; // Cancellation not allowed (beyond 5 minutes)
    }
    
}