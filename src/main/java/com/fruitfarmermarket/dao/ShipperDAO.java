package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShipperDAO {

    // Lấy danh sách đơn theo Tab (pending = READY, shipping = SHIPPING, completed = COMPLETED/CANCELLED)
    public List<Order> getOrdersByStatus(String tab) {
        List<Order> list = new ArrayList<>();
        String sql = "";

        if ("pending".equals(tab)) {
            sql = "SELECT * FROM orders WHERE order_status = 'READY' ORDER BY id DESC";
        } else if ("shipping".equals(tab)) {
            sql = "SELECT * FROM orders WHERE order_status = 'SHIPPING' ORDER BY id DESC";
        } else if ("completed".equals(tab)) {
            // Gộp cả đơn hoàn thành và đơn bị hủy vào tab Lịch sử giao hàng
            sql = "SELECT * FROM orders WHERE order_status IN ('COMPLETED', 'CANCELLED') ORDER BY id DESC";
        } else {
            return list;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setReceiverName(rs.getString("receiver_name"));
                o.setReceiverPhone(rs.getString("receiver_phone"));
                o.setReceiverAddress(rs.getString("receiver_address"));
                o.setTotalAmount(rs.getBigDecimal("total_amount"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setPaymentStatus(rs.getString("payment_status"));
                o.setOrderStatus(rs.getString("order_status"));
                o.setNote(rs.getString("note"));
                o.setCancelReason(rs.getString("cancel_reason"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật trạng thái giao hàng VÀ Hoàn kho tự động nếu Hủy đơn
    public boolean updateDeliveryStatus(int orderId, String action, String reason) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // LOGIC 1: KHÁCH BOOM HÀNG -> HỦY ĐƠN & HOÀN KHO (Cần Transaction)
            if ("CANCEL".equals(action)) {
                conn.setAutoCommit(false); // Bắt đầu Transaction

                // 1. Cập nhật trạng thái Order thành CANCELLED và lưu lý do
                String sqlUpdateOrder = "UPDATE orders SET order_status = 'CANCELLED', cancel_reason = ? WHERE id = ?";
                try (PreparedStatement psOrder = conn.prepareStatement(sqlUpdateOrder)) {
                    psOrder.setString(1, reason);
                    psOrder.setInt(2, orderId);
                    if (psOrder.executeUpdate() == 0) {
                        conn.rollback();
                        return false; // Lỗi cập nhật đơn
                    }
                }

                // 2. Hoàn lại số lượng tồn kho cho từng sản phẩm trong đơn
                String sqlGetDetails = "SELECT product_id, quantity FROM order_details WHERE order_id = ?";
                String sqlRestoreStock = "UPDATE products SET stock = stock + ? WHERE id = ?";

                try (PreparedStatement psGetDetails = conn.prepareStatement(sqlGetDetails);
                     PreparedStatement psRestoreStock = conn.prepareStatement(sqlRestoreStock)) {

                    psGetDetails.setInt(1, orderId);
                    try (ResultSet rs = psGetDetails.executeQuery()) {
                        while (rs.next()) {
                            psRestoreStock.setInt(1, rs.getInt("quantity"));
                            psRestoreStock.setInt(2, rs.getInt("product_id"));
                            psRestoreStock.addBatch(); // Gom lệnh lại cho tối ưu hiệu suất
                        }
                        psRestoreStock.executeBatch();
                    }
                }

                conn.commit(); // Chốt lưu Transaction
                return true;
            }
            // LOGIC 2: NHẬN ĐƠN (ACCEPT) HOẶC GIAO THÀNH CÔNG (COMPLETED)
            else {
                String sql = "";
                if ("ACCEPT".equals(action)) {
                    sql = "UPDATE orders SET order_status = 'SHIPPING' WHERE id = ?";
                } else if ("COMPLETED".equals(action)) {
                    sql = "UPDATE orders SET order_status = 'COMPLETED', payment_status = 'PAID' WHERE id = ?";
                }

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, orderId);
                    return ps.executeUpdate() > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }
}