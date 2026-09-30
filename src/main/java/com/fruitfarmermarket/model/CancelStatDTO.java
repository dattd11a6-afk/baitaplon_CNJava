package com.fruitfarmermarket.model;

import java.math.BigDecimal;

public class CancelStatDTO {
    private String productName;
    private int quantity;
    private BigDecimal revenueLost;
    private double percentage;

    public CancelStatDTO() {}

    public CancelStatDTO(String productName, int quantity, BigDecimal revenueLost, double percentage) {
        this.productName = productName;
        this.quantity = quantity;
        this.revenueLost = revenueLost;
        this.percentage = percentage;
    }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getRevenueLost() { return revenueLost; }
    public void setRevenueLost(BigDecimal revenueLost) { this.revenueLost = revenueLost; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }
}