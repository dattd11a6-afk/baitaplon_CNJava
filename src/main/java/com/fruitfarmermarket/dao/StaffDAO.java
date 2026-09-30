package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.StaffDTO;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    // ĐÃ FIX: Lấy TẤT CẢ các tài khoản KHÔNG PHẢI là KHÁCH HÀNG (CUSTOMER)
    public List<StaffDTO> getAllStaff() {
        List<StaffDTO> list = new ArrayList<>();
        String sql = "SELECT id, full_name, email, phone, role, status, created_at FROM users WHERE role != 'CUSTOMER' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffDTO s = new StaffDTO();
                s.setId(rs.getInt("id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setRole(rs.getString("role")); // Thêm lấy thông tin Role
                s.setStatus(rs.getString("status"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String insertStaff(StaffDTO s) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getPassword()); // Thực tế nên băm MD5/Bcrypt
            ps.setString(5, s.getRole()); // Lấy Role từ form thay vì fix cứng 'STAFF'
            ps.setString(6, s.getStatus());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage(); // Bắn lỗi lên nếu trùng Email
        }
    }

    public String updateStaff(StaffDTO s) {
        // ĐÃ FIX: Bổ sung cập nhật cột "role" vào câu SQL
        StringBuilder sql = new StringBuilder("UPDATE users SET full_name=?, email=?, phone=?, status=?, role=?");
        boolean updatePassword = s.getPassword() != null && !s.getPassword().trim().isEmpty();

        if (updatePassword) {
            sql.append(", password=?");
        }

        // ĐÃ FIX: Chỉ Update theo ID, không giới hạn điều kiện role='STAFF' nữa
        sql.append(" WHERE id=? AND role != 'CUSTOMER'");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getStatus());
            ps.setString(5, s.getRole()); // Bổ sung cập nhật phân quyền

            if (updatePassword) {
                ps.setString(6, s.getPassword());
                ps.setInt(7, s.getId());
            } else {
                ps.setInt(6, s.getId());
            }

            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    // XÓA MỀM: Khóa tài khoản nhân viên
    public boolean disableStaff(int id) {
        String sql = "UPDATE users SET status = 'INACTIVE' WHERE id = ? AND role != 'CUSTOMER'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}