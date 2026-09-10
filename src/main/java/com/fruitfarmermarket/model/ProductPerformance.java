package com.fruitfarmermarket.model;
import java.math.BigDecimal;

public class ProductPerformance {
    private String productName;
    private int quantitySold;
    private BigDecimal revenue;
    private double percentage;

    public ProductPerformance(String productName, int quantitySold, BigDecimal revenue, double percentage) {
        this.productName = productName;
        this.quantitySold = quantitySold;
        this.revenue = revenue;
        this.percentage = percentage;
    }

    public String getProductName() { return productName; }
    public int getQuantitySold() { return quantitySold; }
    public BigDecimal getRevenue() { return revenue; }
    public double getPercentage() { return percentage; }
}