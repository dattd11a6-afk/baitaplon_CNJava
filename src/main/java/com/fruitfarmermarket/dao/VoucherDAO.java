package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Voucher;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSet(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Voucher> searchVouchers(String keyword) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM vouchers WHERE code LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Voucher mapResultSet(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setId(rs.getInt("id"));
        v.setCode(rs.getString("code"));
        v.setType(rs.getString("type"));
        v.setDiscountValue(rs.getBigDecimal("discount_value"));
        v.setMaxDiscountAmount(rs.getBigDecimal("max_discount_amount"));
        v.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
        v.setUsageLimit(rs.getInt("usage_limit"));
        v.setUsedCount(rs.getInt("used_count"));
        v.setExpiryDate(rs.getDate("expiry_date"));
        v.setStatus(rs.getString("status"));
        return v;
    }

    public String insertVoucher(Voucher v) {
        String sql = "INSERT INTO vouchers (code, type, discount_value, max_discount_amount, min_order_amount, usage_limit, used_count, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?, 0, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().toUpperCase());
            ps.setString(2, v.getType());
            ps.setBigDecimal(3, v.getDiscountValue());
            ps.setBigDecimal(4, v.getMaxDiscountAmount());
            ps.setBigDecimal(5, v.getMinOrderAmount());
            ps.setInt(6, v.getUsageLimit());
            ps.setDate(7, v.getExpiryDate());
            ps.setString(8, v.getStatus());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    public String updateVoucher(Voucher v) {
        String sql = "UPDATE vouchers SET code=?, type=?, discount_value=?, max_discount_amount=?, min_order_amount=?, usage_limit=?, expiry_date=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode().toUpperCase());
            ps.setString(2, v.getType());
            ps.setBigDecimal(3, v.getDiscountValue());
            ps.setBigDecimal(4, v.getMaxDiscountAmount());
            ps.setBigDecimal(5, v.getMinOrderAmount());
            ps.setInt(6, v.getUsageLimit());
            ps.setDate(7, v.getExpiryDate());
            ps.setString(8, v.getStatus());
            ps.setInt(9, v.getId());
            ps.executeUpdate();
            return "SUCCESS";
        } catch (SQLException e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    public boolean deleteVoucher(int id) {
        String sql = "DELETE FROM vouchers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); } return false;
    }
}