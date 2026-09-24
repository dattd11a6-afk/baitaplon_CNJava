package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InventoryDAO {

    // LẤY DANH SÁCH NHÀ CUNG CẤP
    public List<Map<String, Object>> getAllSuppliers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM suppliers WHERE status = 'ACTIVE' ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("phone", rs.getString("phone"));
                map.put("address", rs.getString("address"));
                list.add(map);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // TẠO PHIẾU NHẬP KHO VÀ TỰ ĐỘNG CỘNG TỒN KHO
    public boolean createGoodsReceipt(int supplierId, int userId, BigDecimal totalAmount, String note, List<Map<String, Object>> details) {
        Connection conn = null;
        String sqlReceipt = "INSERT INTO goods_receipts (supplier_id, user_id, total_amount, note) VALUES (?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO goods_receipt_details (receipt_id, product_id, quantity, import_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE products SET stock = stock + ? WHERE id = ?"; // CỘNG DỒN TỒN KHO

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int receiptId = -1;
            // 1. Lưu Phiếu Nhập
            try (PreparedStatement psReceipt = conn.prepareStatement(sqlReceipt, Statement.RETURN_GENERATED_KEYS)) {
                psReceipt.setInt(1, supplierId);
                psReceipt.setInt(2, userId);
                psReceipt.setBigDecimal(3, totalAmount);
                psReceipt.setString(4, note);
                psReceipt.executeUpdate();

                try (ResultSet rs = psReceipt.getGeneratedKeys()) {
                    if (rs.next()) receiptId = rs.getInt(1);
                }
            }

            // 2. Lưu Chi tiết & 3. Cộng kho
            if (receiptId > 0) {
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                     PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock)) {

                    for (Map<String, Object> item : details) {
                        int productId = (Integer) item.get("productId");
                        int quantity = (Integer) item.get("quantity");
                        BigDecimal importPrice = (BigDecimal) item.get("importPrice");
                        BigDecimal subtotal = importPrice.multiply(new BigDecimal(quantity));

                        // Lưu chi tiết
                        psDetail.setInt(1, receiptId);
                        psDetail.setInt(2, productId);
                        psDetail.setInt(3, quantity);
                        psDetail.setBigDecimal(4, importPrice);
                        psDetail.setBigDecimal(5, subtotal);
                        psDetail.addBatch();

                        // Cộng tồn kho
                        psStock.setInt(1, quantity);
                        psStock.setInt(2, productId);
                        psStock.addBatch();
                    }
                    psDetail.executeBatch();
                    psStock.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}