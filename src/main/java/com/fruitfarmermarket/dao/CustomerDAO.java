package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.CustomerDTO;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // Lấy danh sách Khách hàng & Tổng chi tiêu
    public List<CustomerDTO> getAllCustomers() {
        List<CustomerDTO> list = new ArrayList<>();
        // Lưu ý: Tên cột 'full_name' có thể thay đổi tùy DB của bạn (ví dụ: 'name' hoặc 'fullname')
        String sql = "SELECT u.id, u.full_name, u.email, u.phone, u.status, u.created_at, " +
                "COALESCE(SUM(o.total_amount), 0) AS total_spent " +
                "FROM users u " +
                "LEFT JOIN orders o ON u.id = o.user_id AND o.order_status = 'COMPLETED' " +
                "WHERE u.role = 'CUSTOMER' " +
                "GROUP BY u.id, u.full_name, u.email, u.phone, u.status, u.created_at " +
                "ORDER BY total_spent DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CustomerDTO c = new CustomerDTO();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setTotalSpent(rs.getBigDecimal("total_spent")); // Sẽ tự động gọi calculateTier()
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Khóa / Mở khóa Khách hàng
    public boolean toggleCustomerStatus(int id, String currentStatus) {
        String newStatus = "ACTIVE".equals(currentStatus) ? "INACTIVE" : "ACTIVE";
        String sql = "UPDATE users SET status = ? WHERE id = ? AND role = 'CUSTOMER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}