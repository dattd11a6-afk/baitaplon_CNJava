package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Category;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // Dành cho Admin (Lấy tất cả kể cả đã ẩn)
    public List<Category> getAllCategoriesForAdmin() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Dành cho form hiển thị (Chỉ lấy danh mục ACTIVE)
    public List<Category> getAllActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 'ACTIVE' ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public String insertCategory(Category c) {
        String sql = "INSERT INTO categories (name, description, status) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getStatus());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    public String updateCategory(Category c) {
        String sql = "UPDATE categories SET name=?, description=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getStatus());
            ps.setInt(4, c.getId());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    public boolean deleteCategory(int id) {
        // Cố gắng xóa hẳn
        String sqlDelete = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Nếu có sản phẩm đang dùng danh mục này -> Xóa mềm (Đổi status)
            String sqlSoftDelete = "UPDATE categories SET status = 'INACTIVE' WHERE id = ?";
            try (Connection conn2 = DBConnection.getConnection(); PreparedStatement ps2 = conn2.prepareStatement(sqlSoftDelete)) {
                ps2.setInt(1, id);
                return ps2.executeUpdate() > 0;
            } catch (SQLException ex) {
                ex.printStackTrace();
                return false;
            }
        }
    }
}