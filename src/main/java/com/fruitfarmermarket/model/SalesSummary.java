package com.fruitfarmermarket.model;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class SalesSummary {
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private int totalOrders = 0;
    private int completedOrders = 0;
    private int cancelledOrders = 0;

    // Tự động tính AOV (Average Order Value) dựa trên doanh thu và đơn hoàn thành
    public BigDecimal getAverageOrderValue() {
        if (completedOrders == 0) return BigDecimal.ZERO;
        return totalRevenue.divide(new BigDecimal(completedOrders), 0, RoundingMode.HALF_UP);
    }

    // Tự động tính tỷ lệ hoàn thành
    public double getCompletionRate() {
        if (totalOrders == 0) return 0.0;
        return (double) completedOrders / totalOrders * 100;
    }

    // Getters and Setters
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public int getCompletedOrders() { return completedOrders; }
    public void setCompletedOrders(int completedOrders) { this.completedOrders = completedOrders; }
    public int getCancelledOrders() { return cancelledOrders; }
    public void setCancelledOrders(int cancelledOrders) { this.cancelledOrders = cancelledOrders; }
}