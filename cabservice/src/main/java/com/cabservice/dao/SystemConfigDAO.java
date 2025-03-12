package com.cabservice.dao;

import com.cabservice.model.SystemConfig;

import java.math.BigDecimal;
import java.sql.*;

public class SystemConfigDAO {
    private Connection connection;

    public SystemConfigDAO(Connection connection) {
        this.connection = connection;
    }

    public SystemConfig getSystemConfig() throws SQLException {
        String query = "SELECT id, tax_rate, discount_rate, updated_at FROM system_config ORDER BY updated_at DESC LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return new SystemConfig(
                        rs.getInt("id"),
                        rs.getBigDecimal("tax_rate"),
                        rs.getBigDecimal("discount_rate"),
                        rs.getTimestamp("updated_at")
                );
            }
        }
        return null;
    }

    public boolean updateSystemConfig(BigDecimal taxRate, BigDecimal discountRate) throws SQLException {
        String selectQuery = "SELECT id FROM system_config ORDER BY updated_at DESC LIMIT 1";
        try (PreparedStatement selectStmt = connection.prepareStatement(selectQuery)) {
            ResultSet rs = selectStmt.executeQuery();
            if (rs.next()) {
                int idToUpdate = rs.getInt("id");
                String updateQuery = "UPDATE system_config SET tax_rate = ?, discount_rate = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                    updateStmt.setBigDecimal(1, taxRate);
                    updateStmt.setBigDecimal(2, discountRate);
                    updateStmt.setInt(3, idToUpdate);
                    return updateStmt.executeUpdate() > 0;
                }
            }
            return false;
        }
    }

    public boolean insertSystemConfig(BigDecimal taxRate, BigDecimal discountRate) throws SQLException {
        String query = "INSERT INTO system_config (tax_rate, discount_rate, updated_at) VALUES (?, ?, CURRENT_TIMESTAMP)";
        try (PreparedStatement stmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setBigDecimal(1, taxRate);
            stmt.setBigDecimal(2, discountRate);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSystemConfig() throws SQLException {
        String selectQuery = "SELECT id FROM system_config ORDER BY updated_at DESC LIMIT 1";
        try (PreparedStatement selectStmt = connection.prepareStatement(selectQuery)) {
            ResultSet rs = selectStmt.executeQuery();
            if (rs.next()) {
                int idToDelete = rs.getInt("id");
                String deleteQuery = "DELETE FROM system_config WHERE id = ?";
                try (PreparedStatement deleteStmt = connection.prepareStatement(deleteQuery)) {
                    deleteStmt.setInt(1, idToDelete);
                    return deleteStmt.executeUpdate() > 0;
                }
            }
            return false;
        }
    }
}