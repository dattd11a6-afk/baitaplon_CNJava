package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Basket;
import com.fruitfarmermarket.model.Decoration;
import com.fruitfarmermarket.model.Packaging;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GiftBasketDAO {

    // ==========================================
    // 1. QUẢN LÝ VỎ GIỎ (BASKETS)
    // ==========================================
    public List<Basket> getActiveBaskets() {
        List<Basket> list = new ArrayList<>();
        String sql = "SELECT * FROM baskets WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Basket b = new Basket();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setDescription(rs.getString("description"));
                b.setCapacityKg(rs.getDouble("capacity_kg"));
                b.setPrice(rs.getBigDecimal("price"));
                b.setImage(rs.getString("image"));
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Basket getBasketById(int id) {
        String sql = "SELECT * FROM baskets WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Basket b = new Basket();
                    b.setId(rs.getInt("id"));
                    b.setName(rs.getString("name"));
                    b.setDescription(rs.getString("description"));
                    b.setCapacityKg(rs.getDouble("capacity_kg"));
                    b.setPrice(rs.getBigDecimal("price"));
                    b.setImage(rs.getString("image"));
                    b.setStatus(rs.getString("status"));
                    return b;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ==========================================
    // 2. QUẢN LÝ TRANG TRÍ (DECORATIONS)
    // ==========================================
    public List<Decoration> getActiveDecorations() {
        List<Decoration> list = new ArrayList<>();
        String sql = "SELECT * FROM decorations WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Decoration d = new Decoration();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setDescription(rs.getString("description"));
                d.setPrice(rs.getBigDecimal("price"));
                d.setImage(rs.getString("image"));
                d.setStatus(rs.getString("status"));
                list.add(d);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Decoration getDecorationById(int id) {
        String sql = "SELECT * FROM decorations WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Decoration d = new Decoration();
                    d.setId(rs.getInt("id"));
                    d.setName(rs.getString("name"));
                    d.setDescription(rs.getString("description"));
                    d.setPrice(rs.getBigDecimal("price"));
                    d.setImage(rs.getString("image"));
                    d.setStatus(rs.getString("status"));
                    return d;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ==========================================
    // 3. QUẢN LÝ ĐÓNG GÓI (PACKAGINGS)
    // ==========================================
    public List<Packaging> getActivePackagings() {
        List<Packaging> list = new ArrayList<>();
        String sql = "SELECT * FROM packagings WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Packaging p = new Packaging();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setImage(rs.getString("image"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Packaging getPackagingById(int id) {
        String sql = "SELECT * FROM packagings WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Packaging p = new Packaging();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setImage(rs.getString("image"));
                    p.setStatus(rs.getString("status"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}