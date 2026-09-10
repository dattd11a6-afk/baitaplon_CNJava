package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.StaffDTO;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    public List<StaffDTO> getAllStaff() {
        List<StaffDTO> list = new ArrayList<>();
        String sql = "SELECT id, full_name, email, phone, status, created_at FROM users WHERE role = 'STAFF' ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StaffDTO s = new StaffDTO();
                s.setId(rs.getInt("id"));
                s.setFullName(rs.getString("full_name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setStatus(rs.getString("status"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String insertStaff(StaffDTO s) {
        String sql = "INSERT INTO users (full_name, email, phone, password, role, status) VALUES (?, ?, ?, ?, 'STAFF', ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getPassword()); // Thực tế nên băm MD5/Bcrypt
            ps.setString(5, s.getStatus());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage(); // Bắn lỗi lên nếu trùng Email
        }
    }

    public String updateStaff(StaffDTO s) {
        // Cập nhật thông minh: Nếu có truyền Password thì update, nếu không thì giữ nguyên
        StringBuilder sql = new StringBuilder("UPDATE users SET full_name=?, email=?, phone=?, status=?");
        boolean updatePassword = s.getPassword() != null && !s.getPassword().trim().isEmpty();
        if (updatePassword) {
            sql.append(", password=?");
        }
        sql.append(" WHERE id=? AND role='STAFF'");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getStatus());

            if (updatePassword) {
                ps.setString(5, s.getPassword());
                ps.setInt(6, s.getId());
            } else {
                ps.setInt(5, s.getId());
            }

            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    // XÓA MỀM: Khóa tài khoản nhân viên nghỉ việc
    public boolean disableStaff(int id) {
        String sql = "UPDATE users SET status = 'INACTIVE' WHERE id = ? AND role = 'STAFF'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}