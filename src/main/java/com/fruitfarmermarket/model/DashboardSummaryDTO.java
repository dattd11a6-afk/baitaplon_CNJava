package com.fruitfarmermarket.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class DashboardSummaryDTO {
    // 1. Doanh thu
    private BigDecimal currentRevenue = BigDecimal.ZERO;
    private BigDecimal previousRevenue = BigDecimal.ZERO;

    // 2. Đơn hàng
    private int currentOrders = 0;
    private int previousOrders = 0;

    // 3. Khách hàng
    private int currentCustomers = 0;
    private int previousCustomers = 0;

    // --- HÀM TÍNH TOÁN TỰ ĐỘNG --- //

    // Tính AOV (Giá trị đơn trung bình)
    public BigDecimal getCurrentAov() {
        if (currentOrders == 0) return BigDecimal.ZERO;
        return currentRevenue.divide(new BigDecimal(currentOrders), 0, RoundingMode.HALF_UP);
    }

    public BigDecimal getPreviousAov() {
        if (previousOrders == 0) return BigDecimal.ZERO;
        return previousRevenue.divide(new BigDecimal(previousOrders), 0, RoundingMode.HALF_UP);
    }

    // Tính % Tăng trưởng Doanh thu
    public double getRevenueGrowth() {
        return calculateGrowth(currentRevenue.doubleValue(), previousRevenue.doubleValue());
    }

    // Tính % Tăng trưởng Đơn hàng
    public double getOrdersGrowth() {
        return calculateGrowth(currentOrders, previousOrders);
    }

    private double calculateGrowth(double current, double previous) {
        if (previous == 0) return current > 0 ? 100.0 : 0.0;
        return ((current - previous) / previous) * 100.0;
    }

    // --- GETTERS & SETTERS CƠ BẢN --- //
    public BigDecimal getCurrentRevenue() { return currentRevenue; }
    public void setCurrentRevenue(BigDecimal currentRevenue) { this.currentRevenue = currentRevenue; }
    public BigDecimal getPreviousRevenue() { return previousRevenue; }
    public void setPreviousRevenue(BigDecimal previousRevenue) { this.previousRevenue = previousRevenue; }

    public int getCurrentOrders() { return currentOrders; }
    public void setCurrentOrders(int currentOrders) { this.currentOrders = currentOrders; }
    public int getPreviousOrders() { return previousOrders; }
    public void setPreviousOrders(int previousOrders) { this.previousOrders = previousOrders; }

    public int getCurrentCustomers() { return currentCustomers; }
    public void setCurrentCustomers(int currentCustomers) { this.currentCustomers = currentCustomers; }
    public int getPreviousCustomers() { return previousCustomers; }
    public void setPreviousCustomers(int previousCustomers) { this.previousCustomers = previousCustomers; }
}