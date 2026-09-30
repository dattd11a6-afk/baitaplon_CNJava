package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.fruitfarmermarket.model.GoodsReceipt;
import com.fruitfarmermarket.model.GoodsReceiptDetail;

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 1. LẤY TẤT CẢ PHIẾU NHẬP (Hiển thị bảng tổng)
    public List<GoodsReceipt> getAllReceipts() {
        List<GoodsReceipt> list = new ArrayList<>();
        String sql = "SELECT r.id, s.name AS supplier_name, u.full_name AS user_name, r.total_amount, r.note, r.created_at " +
                "FROM goods_receipts r " +
                "LEFT JOIN suppliers s ON r.supplier_id = s.id " +
                "LEFT JOIN users u ON r.user_id = u.id " +
                "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                GoodsReceipt gr = new GoodsReceipt();
                gr.setId(rs.getInt("id"));
                gr.setSupplierName(rs.getString("supplier_name"));
                gr.setUserName(rs.getString("user_name"));
                gr.setTotalAmount(rs.getDouble("total_amount"));
                gr.setNote(rs.getString("note"));
                gr.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(gr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. LẤY CHI TIẾT 1 PHIẾU NHẬP (Hiển thị khi bấm nút "Xem chi tiết")
    public List<GoodsReceiptDetail> getReceiptDetails(int receiptId) {
        List<GoodsReceiptDetail> list = new ArrayList<>();
        String sql = "SELECT p.name AS product_name, d.quantity, d.import_price, d.subtotal " +
                "FROM goods_receipt_details d " +
                "JOIN products p ON d.product_id = p.id " +
                "WHERE d.receipt_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GoodsReceiptDetail detail = new GoodsReceiptDetail();
                    // ĐÃ SỬA: Không gọi detail.setId() nữa
                    detail.setProductName(rs.getString("product_name"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setImportPrice(rs.getDouble("import_price"));
                    detail.setSubtotal(rs.getDouble("subtotal"));
                    list.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // 3. XÓA PHIẾU NHẬP (Kèm logic tự động TRỪ LẠI TỒN KHO)
    public boolean deleteGoodsReceipt(int receiptId) {
        Connection conn = null;
        String getDetailsSql = "SELECT product_id, quantity FROM goods_receipt_details WHERE receipt_id = ?";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";
        String deleteDetailsSql = "DELETE FROM goods_receipt_details WHERE receipt_id = ?";
        String deleteReceiptSql = "DELETE FROM goods_receipts WHERE id = ?";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Quét các sản phẩm trong phiếu và trừ lại tồn kho
            try (PreparedStatement psGet = conn.prepareStatement(getDetailsSql);
                 PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                psGet.setInt(1, receiptId);
                try (ResultSet rs = psGet.executeQuery()) {
                    while (rs.next()) {
                        psStock.setInt(1, rs.getInt("quantity"));
                        psStock.setInt(2, rs.getInt("product_id"));
                        psStock.addBatch();
                    }
                    psStock.executeBatch();
                }
            }

            // 2. Xóa các dòng chi tiết phiếu
            try (PreparedStatement psDelDetails = conn.prepareStatement(deleteDetailsSql)) {
                psDelDetails.setInt(1, receiptId);
                psDelDetails.executeUpdate();
            }

            // 3. Xóa phiếu nhập gốc
            try (PreparedStatement psDelReceipt = conn.prepareStatement(deleteReceiptSql)) {
                psDelReceipt.setInt(1, receiptId);
                psDelReceipt.executeUpdate();
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