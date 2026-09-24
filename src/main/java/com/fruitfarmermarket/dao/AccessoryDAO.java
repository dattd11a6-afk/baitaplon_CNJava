package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Accessory;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccessoryDAO {

    public AccessoryDAO() {
        // TỰ ĐỘNG TẠO BẢNG NẾU CHƯA CÓ TRONG DB (Không cần tự chạy SQL)
        String createTableSQL = "CREATE TABLE IF NOT EXISTS accessories (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "type VARCHAR(50), name VARCHAR(255), price DECIMAL(10,2), " +
                "image VARCHAR(255), status VARCHAR(20) DEFAULT 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
            stmt.execute(createTableSQL);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public List<Accessory> getAccessoriesByType(String type) {
        List<Accessory> list = new ArrayList<>();
        String sql = "SELECT * FROM accessories WHERE type = ? AND status = 'ACTIVE' ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Accessory a = new Accessory();
                    a.setId(rs.getInt("id"));
                    a.setType(rs.getString("type"));
                    a.setName(rs.getString("name"));
                    a.setPrice(rs.getBigDecimal("price"));
                    a.setImage(rs.getString("image"));
                    list.add(a);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public void addAccessory(Accessory a) {
        String sql = "INSERT INTO accessories (type, name, price, image, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getType()); ps.setString(2, a.getName());
            ps.setBigDecimal(3, a.getPrice()); ps.setString(4, a.getImage());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void softDeleteAccessory(int id) {
        String sql = "UPDATE accessories SET status = 'INACTIVE' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id); ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}