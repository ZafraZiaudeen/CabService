package com.cabservice.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SystemConfig {
    private int id;
    private BigDecimal taxRate;
    private BigDecimal discountRate;
    private Timestamp updatedAt;

    // Constructors
    public SystemConfig() {
    }

    public SystemConfig(int id, BigDecimal taxRate, BigDecimal discountRate, Timestamp updatedAt) {
        this.id = id;
        this.taxRate = taxRate;
        this.discountRate = discountRate;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getTaxRate() {
        return taxRate;
    }

    public void setTaxRate(BigDecimal taxRate) {
        this.taxRate = taxRate;
    }

    public BigDecimal getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(BigDecimal discountRate) {
        this.discountRate = discountRate;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // toString method
    @Override
    public String toString() {
        return "SystemConfig{" +
                "id=" + id +
                ", taxRate=" + taxRate +
                ", discountRate=" + discountRate +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
