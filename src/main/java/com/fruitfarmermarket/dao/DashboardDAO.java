package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    // 1. Tách riêng Data cho Biểu đồ Doanh Thu & Đơn Hàng theo khoảng thời gian
    public Map<String, double[]> getTrendData(LocalDate start, LocalDate end) {
        Map<String, double[]> data = new LinkedHashMap<>();
        // Khởi tạo các mốc thời gian bằng 0 để chart không bị đứt đoạn
        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            data.put(date.toString(), new double[]{0.0, 0.0});
        }

        String sql = "SELECT DATE(created_at) as date, SUM(total_amount) as rev, COUNT(id) as cnt " +
                "FROM orders WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN ? AND ? GROUP BY DATE(created_at)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String date = rs.getString("date");
                    if (data.containsKey(date)) {
                        data.get(date)[0] = rs.getDouble("rev");
                        data.get(date)[1] = rs.getDouble("cnt");
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    // 2. Data cho Biểu đồ Top 5 Sản phẩm (Ngang)
    public List<Map<String, Object>> getTopProductsBarChart(LocalDate start, LocalDate end) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.name, SUM(od.quantity) as qty, SUM(od.price * od.quantity) as rev " +
                "FROM order_details od JOIN orders o ON od.order_id = o.id JOIN products p ON od.product_id = p.id " +
                "WHERE o.order_status = 'COMPLETED' AND DATE(o.created_at) BETWEEN ? AND ? " +
                "GROUP BY p.id, p.name ORDER BY rev DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(start));
            ps.setDate(2, java.sql.Date.valueOf(end));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("name", rs.getString("name"));
                    map.put("qty", rs.getInt("qty"));
                    map.put("rev", rs.getBigDecimal("rev"));
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}