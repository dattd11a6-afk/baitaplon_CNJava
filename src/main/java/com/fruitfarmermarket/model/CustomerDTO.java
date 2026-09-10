package com.fruitfarmermarket.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CustomerDTO {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String status;
    private Timestamp createdAt;
    private BigDecimal totalSpent;
    private String tier;

    public CustomerDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public BigDecimal getTotalSpent() { return totalSpent; }
    public void setTotalSpent(BigDecimal totalSpent) {
        this.totalSpent = totalSpent;
        calculateTier();
    }

    public String getTier() { return tier; }

    // LOGIC PHÂN HẠNG TỰ ĐỘNG
    private void calculateTier() {
        if (totalSpent == null) totalSpent = BigDecimal.ZERO;
        double spent = totalSpent.doubleValue();

        if (spent >= 10000000) {
            this.tier = "DIAMOND"; // Trên 10 triệu
        } else if (spent >= 5000000) {
            this.tier = "GOLD";    // 5 - 10 triệu
        } else if (spent >= 2000000) {
            this.tier = "SILVER";  // 2 - 5 triệu
        } else {
            this.tier = "BRONZE";  // Dưới 2 triệu
        }
    }
}