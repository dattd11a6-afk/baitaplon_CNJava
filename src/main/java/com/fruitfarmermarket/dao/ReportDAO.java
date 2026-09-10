package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.DashboardSummaryDTO;
import com.fruitfarmermarket.utils.DBConnection;
import com.fruitfarmermarket.utils.DateRange;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    // =========================================================================
    // PHẦN 1: CÁC HÀM NÂNG CẤP CHO ADMIN DASHBOARD MỚI (PHASE 1)
    // =========================================================================

    public DashboardSummaryDTO getDashboardSummary(DateRange range) {
        DashboardSummaryDTO dto = new DashboardSummaryDTO();

        java.sql.Date currStart = java.sql.Date.valueOf(range.getCurrentStart());
        java.sql.Date currEnd = java.sql.Date.valueOf(range.getCurrentEnd());
        java.sql.Date prevStart = java.sql.Date.valueOf(range.getPreviousStart());
        java.sql.Date prevEnd = java.sql.Date.valueOf(range.getPreviousEnd());

        String sqlOrders = "SELECT " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? AND order_status = 'COMPLETED' THEN total_amount ELSE 0 END), 0) AS curr_rev, " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? AND order_status = 'COMPLETED' THEN total_amount ELSE 0 END), 0) AS prev_rev, " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 ELSE 0 END), 0) AS curr_orders, " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 ELSE 0 END), 0) AS prev_orders " +
                "FROM orders " +
                "WHERE DATE(created_at) BETWEEN ? AND ?";

        String sqlCustomers = "SELECT " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 ELSE 0 END), 0) AS curr_cust, " +
                "COALESCE(SUM(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 ELSE 0 END), 0) AS prev_cust " +
                "FROM users " +
                "WHERE role = 'CUSTOMER' AND DATE(created_at) BETWEEN ? AND ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlOrders)) {
                ps.setDate(1, currStart); ps.setDate(2, currEnd);
                ps.setDate(3, prevStart); ps.setDate(4, prevEnd);
                ps.setDate(5, currStart); ps.setDate(6, currEnd);
                ps.setDate(7, prevStart); ps.setDate(8, prevEnd);
                ps.setDate(9, prevStart); ps.setDate(10, currEnd);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setCurrentRevenue(rs.getBigDecimal("curr_rev"));
                        dto.setPreviousRevenue(rs.getBigDecimal("prev_rev"));
                        dto.setCurrentOrders(rs.getInt("curr_orders"));
                        dto.setPreviousOrders(rs.getInt("prev_orders"));
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlCustomers)) {
                ps.setDate(1, currStart); ps.setDate(2, currEnd);
                ps.setDate(3, prevStart); ps.setDate(4, prevEnd);
                ps.setDate(5, prevStart); ps.setDate(6, currEnd);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        dto.setCurrentCustomers(rs.getInt("curr_cust"));
                        dto.setPreviousCustomers(rs.getInt("prev_cust"));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return dto;
    }

    public Map<String, Object[]> getComboChartData(int days) {
        Map<String, Object[]> map = new LinkedHashMap<>();
        for (int i = days - 1; i >= 0; i--) {
            map.put(LocalDate.now().minusDays(i).toString(), new Object[]{BigDecimal.ZERO, 0});
        }
        String sql = "SELECT DATE(created_at) as d, SUM(total_amount) as rev, COUNT(id) as cnt " +
                "FROM orders WHERE order_status = 'COMPLETED' AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                "GROUP BY DATE(created_at) ORDER BY d ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String d = rs.getString("d");
                    if (map.containsKey(d)) map.put(d, new Object[]{rs.getBigDecimal("rev"), rs.getInt("cnt")});
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        BigDecimal totalSystemRevenue = BigDecimal.ZERO;
        String sqlTotal = "SELECT SUM(od.quantity * od.price) as total FROM order_details od JOIN orders o ON od.order_id = o.id WHERE o.order_status = 'COMPLETED'";
        String sqlTop = "SELECT p.name as productName, SUM(od.quantity) as quantitySold, SUM(od.quantity * od.price) as revenue " +
                "FROM order_details od JOIN orders o ON od.order_id = o.id JOIN products p ON od.product_id = p.id " +
                "WHERE o.order_status = 'COMPLETED' GROUP BY p.id, p.name ORDER BY quantitySold DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement psTotal = conn.prepareStatement(sqlTotal); ResultSet rsTotal = psTotal.executeQuery()) {
                if (rsTotal.next() && rsTotal.getBigDecimal("total") != null) totalSystemRevenue = rsTotal.getBigDecimal("total");
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlTop)) {
                ps.setInt(1, limit);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> item = new HashMap<>();
                        item.put("productName", rs.getString("productName"));
                        item.put("quantitySold", rs.getInt("quantitySold"));
                        BigDecimal rev = rs.getBigDecimal("revenue");
                        item.put("revenue", rev);
                        item.put("percentage", totalSystemRevenue.compareTo(BigDecimal.ZERO) > 0 ? (rev.doubleValue() / totalSystemRevenue.doubleValue() * 100) : 0.0);
                        list.add(item);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }


    // =========================================================================
    // PHẦN 2: PHỤC HỒI CÁC HÀM CŨ CHO STAFF & ADMIN REPORT ĐỂ KHÔNG BỊ LỖI
    // =========================================================================

    // 1. Phục hồi hàm đếm trạng thái cho StaffDashboardServlet
    public int getOrderCountByStatus(String status) {
        int count = 0;
        String sql = "SELECT COUNT(id) FROM orders WHERE order_status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // 2. Phục hồi hàm cho AdminReportServlet
    public BigDecimal getTotalRevenue() {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_amount) FROM orders WHERE order_status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getBigDecimal(1) != null) total = rs.getBigDecimal(1);
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    public int getTotalOrders() {
        int count = 0;
        String sql = "SELECT COUNT(id) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public Map<String, BigDecimal> getRevenueLast7Days() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        for (int i = 6; i >= 0; i--) {
            map.put(LocalDate.now().minusDays(i).toString(), BigDecimal.ZERO);
        }
        String sql = "SELECT DATE(created_at) as d, SUM(total_amount) as rev FROM orders WHERE order_status = 'COMPLETED' AND created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) GROUP BY DATE(created_at)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String d = rs.getString("d");
                if (map.containsKey(d)) map.put(d, rs.getBigDecimal("rev"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    public Map<String, Integer> getOrderStatusDistribution() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT order_status, COUNT(id) as cnt FROM orders GROUP BY order_status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getString("order_status"), rs.getInt("cnt"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    public int getTotalProducts() {
        int count = 0;
        String sql = "SELECT COUNT(id) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int getTotalCustomers() {
        int count = 0;
        String sql = "SELECT COUNT(id) FROM users WHERE role = 'CUSTOMER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
}