package com.cabservice.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.cabservice.dao.BillingDAO;
import com.cabservice.dao.BookingDAO;
import com.cabservice.model.Billing;
import com.cabservice.model.Booking;
import com.cabservice.dao.DBConnectionFactory;
public class BookingService {
	private final BookingDAO bookingDAO;
    private final BillingDAO billingDAO;;
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
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            return false;
        }
        
        // Start a transaction using the existing connection
        Connection conn = bookingDAO.getConnection();
        boolean autoCommit = conn.getAutoCommit();
        conn.setAutoCommit(false);
        try {
            boolean deleted = bookingDAO.deleteBooking(bookingId);
            Billing billing = billingDAO.getBillingByBookingId(bookingId);
            if (billing != null) {
                String deleteBillingSql = "DELETE FROM billing WHERE booking_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteBillingSql)) {
                    stmt.setInt(1, bookingId);
                    stmt.executeUpdate();
                }
            }
            conn.commit();
            return deleted;
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(autoCommit);
        }
    }

    public List<Booking> getBookingHistoryByCustomerId(int customerId) throws SQLException {
        return bookingDAO.getBookingHistoryByCustomerId(customerId);
    }
    
    public List<Map<String, Object>> getBookingHistoryWithPaymentDetails(int customerId) throws SQLException {
        return bookingDAO.getBookingHistoryWithPaymentDetails(customerId);
    }

 // Modify cancelBooking method
    public boolean cancelBooking(int bookingId) throws SQLException {
        if (bookingDAO.canCancelBooking(bookingId)) {
            // Update booking status to Cancelled and driver availability
            bookingDAO.updateBookingStatus(bookingId, "Cancelled"); 
            
            // Update billing status and remove payment details
            Billing billing = billingDAO.getBillingByBookingId(bookingId);
            if (billing != null) {
                billingDAO.updateBillingStatusByBookingId(bookingId, "Cancelled", billing.getPaymentType(), null, null, null);
                billingDAO.removePaymentDetails(bookingId);
            }
            return true;
        }
        return false;
    }
    public List<Map<String, Object>> getAllBookingsWithCustomerDetails() throws SQLException {
        return bookingDAO.getAllBookingsWithCustomerDetails();
    }
    
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
       
        bookingDAO.updateBookingStatus(bookingId, status);
    }
    
    public List<Map<String, Object>> getPendingBookings() throws SQLException {
        return bookingDAO.getPendingBooking();
    }
    
    public List<Map<String, Object>> getOngoingBookings() throws SQLException {
        return bookingDAO.getOngoingBookings();
    }
    
    public int getTotalBookingsCount() throws SQLException {
        return bookingDAO.getTotalBookingsCount();
    }
    
    public double getMonthlyBookingGrowthPercentage(int currentYear, int currentMonth) throws SQLException {
        int currentMonthCount = bookingDAO.getBookingsCountForMonth(currentYear, currentMonth);
        int previousMonth = currentMonth - 1;
        int previousYear = currentYear;
        if (previousMonth < 1) {
            previousMonth = 12;
            previousYear--;
        }
        int previousMonthCount = bookingDAO.getBookingsCountForMonth(previousYear, previousMonth);

        if (previousMonthCount == 0) {
            return currentMonthCount > 0 ? 100.0 : 0.0; 
        }

        double growth = ((double) (currentMonthCount - previousMonthCount) / previousMonthCount) * 100;
        return growth;
    }
    
    public int getPendingBookingsCount() throws SQLException {
        return bookingDAO.getPendingBookingsCount();
    }

    public int getOngoingBookingsCount() throws SQLException {
        return bookingDAO.getOngoingBookingsCount();
    }

    public int getCurrentBookingsCount() throws SQLException {
        return getPendingBookingsCount() + getOngoingBookingsCount();
    }
    
    public int getCompletedBookingsCount() throws SQLException {
        return bookingDAO.getCompletedBookingsCount();
    }

    public int getCancelledBookingsCount() throws SQLException {
        return bookingDAO.getCancelledBookingsCount();
    }
    

    public List<Map<String, Object>> getRecentBookingsLast3Days() throws SQLException {
        return bookingDAO.getRecentBookingsLast3Days();
    }
}