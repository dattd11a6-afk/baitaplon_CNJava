package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Supplier;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliersAdmin() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPhone(rs.getString("phone"));
                s.setAddress(rs.getString("address"));
                s.setEmail(rs.getString("email"));
                s.setStatus(rs.getString("status"));
                s.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insertSupplier(Supplier s) {
        String sql = "INSERT INTO suppliers (name, phone, address, email, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getPhone());
            ps.setString(3, s.getAddress());
            ps.setString(4, s.getEmail());
            ps.setString(5, s.getStatus() != null ? s.getStatus() : "ACTIVE");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateSupplier(Supplier s) {
        String sql = "UPDATE suppliers SET name=?, phone=?, address=?, email=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getPhone());
            ps.setString(3, s.getAddress());
            ps.setString(4, s.getEmail());
            ps.setString(5, s.getStatus());
            ps.setInt(6, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Xóa thông minh: Thử xóa cứng, nếu vướng khóa ngoại thì chuyển sang xóa mềm (INACTIVE)
    public boolean deleteSupplier(int id) {
        String sqlDelete = "DELETE FROM suppliers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            String sqlSoftDelete = "UPDATE suppliers SET status = 'INACTIVE' WHERE id = ?";
            try (Connection conn2 = DBConnection.getConnection(); PreparedStatement ps2 = conn2.prepareStatement(sqlSoftDelete)) {
                ps2.setInt(1, id);
                return ps2.executeUpdate() > 0;
            } catch (SQLException ex) { ex.printStackTrace(); return false; }
        }
    }
}