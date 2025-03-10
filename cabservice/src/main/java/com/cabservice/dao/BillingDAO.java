package com.cabservice.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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
        String sql = "{CALL sp_create_billing(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            // Input parameters
            stmt.setInt(1, billing.getBookingId());
            stmt.setString(2, billing.getPaymentType());
            stmt.setString(3, billing.getCardNumber());
            stmt.setString(4, billing.getCvv());
            stmt.setString(5, billing.getExpiryDate());

            // Output parameters
            stmt.registerOutParameter(6, Types.DECIMAL); // total_amount
            stmt.registerOutParameter(7, Types.DECIMAL); // tax
            stmt.registerOutParameter(8, Types.DECIMAL); // discount
            stmt.registerOutParameter(9, Types.DECIMAL); // final_amount

            // Execute the stored procedure
            stmt.execute();

            // Update Billing object
            billing.setTotalAmount(stmt.getDouble(6));
            billing.setTax(stmt.getDouble(7));
            billing.setDiscount(stmt.getDouble(8));
            billing.setFinalAmount(stmt.getDouble(9));

            // Fetch generated ID
            String getIdSql = "SELECT LAST_INSERT_ID() AS billing_id";
            try (PreparedStatement idStmt = conn.prepareStatement(getIdSql);
                 ResultSet rs = idStmt.executeQuery()) {
                if (rs.next()) {
                    int billingId = rs.getInt("billing_id");
                    billing.setId(billingId);
                    return billingId;
                }
            }
        }
        return -1;
    }
    public double calculateFinalAmount(int vehicleId, double distanceKm) throws SQLException {
        String sql = "SELECT fn_calculate_final_amount(?, ?) AS final_amount";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vehicleId);
            stmt.setDouble(2, distanceKm);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("final_amount");
            }
        }
        return -1.0; // Indicate error if no result
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