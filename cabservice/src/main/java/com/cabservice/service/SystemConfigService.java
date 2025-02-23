package com.cabservice.service;

import com.cabservice.dao.SystemConfigDAO;
import com.cabservice.model.SystemConfig;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;

public class SystemConfigService {
    private SystemConfigDAO systemConfigDAO;

    public SystemConfigService(Connection connection) {
        this.systemConfigDAO = new SystemConfigDAO(connection);
    }

    // Get current system configuration
    public SystemConfig getSystemConfig() throws SQLException {
        return systemConfigDAO.getSystemConfig();
    }

    // Update system configuration
    public boolean updateSystemConfig(BigDecimal taxRate, BigDecimal discountRate) throws SQLException {
        return systemConfigDAO.updateSystemConfig(taxRate, discountRate);
    }

    // Insert new system configuration (if needed)
    public boolean insertSystemConfig(BigDecimal taxRate, BigDecimal discountRate) throws SQLException {
        return systemConfigDAO.insertSystemConfig(taxRate, discountRate);
    }
    
    public boolean deleteSystemConfig() throws SQLException {
        return systemConfigDAO.deleteSystemConfig();
    }

}
