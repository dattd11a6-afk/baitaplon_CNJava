package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class UserDAO {

    // Hàm kiểm tra đăng nhập
    public User login(String email, String hashedPassword) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND status = 'ACTIVE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    // Không lấy password ra để bảo mật
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // Hàm thêm người dùng mới
    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, address, role, status) VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 'ACTIVE')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Mật khẩu này đã được băm từ Servlet
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm kiểm tra email đã tồn tại chưa
    public boolean checkEmailExist(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có kết quả trả về true
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    // Lấy danh sách user theo Role (Dùng cho trang Quản lý Khách hàng và Nhân viên)
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setAddress(rs.getString("address"));
                    u.setRole(rs.getString("role"));
                    list.add(u);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}

