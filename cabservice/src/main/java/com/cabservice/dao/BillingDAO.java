package com.cabservice.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.cabservice.model.Billing;

public class BillingDAO {
    private Connection conn;

    public BillingDAO(Connection conn) {
        this.conn = conn;
    }

    public Map<String, Double> getSystemConfig() throws SQLException {
        Map<String, Double> config = new HashMap<>();
        String sql = "SELECT tax_rate, discount_rate FROM system_config ORDER BY updated_at DESC LIMIT 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                config.put("taxRate", rs.getDouble("tax_rate"));
                config.put("discountRate", rs.getDouble("discount_rate"));
            }
        }
        return config;
    }
    public int createBilling(Billing billing) throws SQLException {
        String sql = """
            INSERT INTO billing (booking_id, total_amount, tax, discount, final_amount, generated_at, card_number, cvv, expiry_date, payment_type)
            VALUES (?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?)
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, billing.getBookingId());
            stmt.setDouble(2, billing.getTotalAmount());
            stmt.setDouble(3, billing.getTax());
            stmt.setDouble(4, billing.getDiscount());
            stmt.setDouble(5, billing.getFinalAmount());

           
            if ("Card".equals(billing.getPaymentType())) {
                stmt.setString(6, billing.getCardNumber());
                stmt.setString(7, billing.getCvv());
                stmt.setString(8, billing.getExpiryDate());
            } else {
                stmt.setNull(6, java.sql.Types.VARCHAR);  
                stmt.setNull(7, java.sql.Types.VARCHAR);
                stmt.setNull(8, java.sql.Types.VARCHAR);
            }

            stmt.setString(9, billing.getPaymentType()); 

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);  
                }
            }
        }
        return -1;  
    }

    
    public Billing getBillingById(int billingId) throws SQLException {
        String sql = "SELECT * FROM billing WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, billingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Billing billing = new Billing();
                billing.setId(rs.getInt("id"));
                billing.setBookingId(rs.getInt("booking_id"));
                billing.setTotalAmount(rs.getDouble("total_amount"));
                billing.setTax(rs.getDouble("tax"));
                billing.setDiscount(rs.getDouble("discount"));
                billing.setFinalAmount(rs.getDouble("final_amount"));
                billing.setGeneratedAt(rs.getTimestamp("generated_at"));
                billing.setPaymentType(rs.getString("payment_type"));
                billing.setStatus(rs.getString("status"));
                return billing;
            }
        }
        return null;
    }


    public void updateBillingStatus(int billingId, String status, String paymentType, String cardNumber, String cvv, String expiryDate) throws SQLException {
        String sql;
        
        if ("Card".equals(paymentType)) {
           
            sql = "UPDATE billing SET status = ?, payment_type = ?, card_number = ?, cvv = ?, expiry_date = ? WHERE id = ?";
        } else {
        
            sql = "UPDATE billing SET status = ?, payment_type = ? WHERE id = ?";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, paymentType);

            if ("Card".equals(paymentType)) {
           
                stmt.setString(3, cardNumber);
                stmt.setString(4, cvv);
                stmt.setString(5, expiryDate);
                stmt.setInt(6, billingId);
            } else {
                stmt.setInt(3, billingId);
            }

            stmt.executeUpdate();
        }
    }


    public void updateBillingStatusByBookingId(int bookingId, String status, String paymentType, String cardNumber, String cvv, String expiryDate) throws SQLException {
        String sql;
        
        if ("Card".equals(paymentType)) {
           
            sql = "UPDATE billing SET status = ?, payment_type = ?, card_number = ?, cvv = ?, expiry_date = ? WHERE booking_id = ?";
        } else {
           
            sql = "UPDATE billing SET status = ?, payment_type = ? WHERE booking_id = ?";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, paymentType);

            if ("Card".equals(paymentType)) {
               
                stmt.setString(3, cardNumber);
                stmt.setString(4, cvv);
                stmt.setString(5, expiryDate); 
                stmt.setInt(6, bookingId);  
            } else {
                stmt.setInt(3, bookingId); 
            }

            stmt.executeUpdate();
        }
    }
    
    public void updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql;
        
        
        if ("Completed".equals(status)) {
            sql = "UPDATE bookings SET status = ?, completed_at = NOW() WHERE id = ?";
        } else {
            sql = "UPDATE bookings SET status = ? WHERE id = ?";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            
         
            stmt.executeUpdate();
        }
    }
    
    public Billing getBillingByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM billing WHERE booking_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Billing billing = new Billing();
                billing.setId(rs.getInt("id"));
                billing.setBookingId(rs.getInt("booking_id"));
                billing.setTotalAmount(rs.getDouble("total_amount"));
                billing.setTax(rs.getDouble("tax"));
                billing.setDiscount(rs.getDouble("discount"));
                billing.setFinalAmount(rs.getDouble("final_amount"));
                billing.setGeneratedAt(rs.getTimestamp("generated_at"));
                billing.setPaymentType(rs.getString("payment_type"));
                billing.setStatus(rs.getString("status"));
                return billing;
            }
        }
        return null;
    }
  

    public void updateBilling(Billing billing) throws SQLException {
        String sql = """
            UPDATE billing SET total_amount = ?, tax = ?, discount = ?, final_amount = ?, payment_type = ?
            WHERE id = ?
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDouble(1, billing.getTotalAmount());
            stmt.setDouble(2, billing.getTax());
            stmt.setDouble(3, billing.getDiscount());
            stmt.setDouble(4, billing.getFinalAmount());
            stmt.setString(5, billing.getPaymentType());
            stmt.setInt(6, billing.getId());
            stmt.executeUpdate();
        }
    }
    

    public void removePaymentDetails(int bookingId) throws SQLException {
        String sql = "UPDATE billing SET card_number = NULL, cvv = NULL, expiry_date = NULL WHERE booking_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            stmt.executeUpdate();
        }
    }
    

    public double getRevenueByPaymentType(String paymentType) throws SQLException {
        String sql = "SELECT SUM(final_amount) AS total FROM billing WHERE payment_type = ?";
        try (Connection conn = DBConnectionFactory.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, paymentType); 
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        }
        return 0.0; 
    }

public double getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(final_amount) AS total FROM billing";
        try (Connection conn = DBConnectionFactory.getConnection(); 
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }
}