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
                o.setCancelReason(rs.getString("cancel_reason")); // Đã map với cột lý do hủy
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật trạng thái giao hàng dựa trên Action (ACCEPT, COMPLETED, CANCEL)
    public boolean updateDeliveryStatus(int orderId, String action, String reason) {
        String sql = "";

        if ("ACCEPT".equals(action)) {
            // Shipper nhận đơn -> Trạng thái đổi thành Đang giao
            sql = "UPDATE orders SET order_status = 'SHIPPING' WHERE id = ?";
        } else if ("COMPLETED".equals(action)) {
            // Giao thành công -> Hoàn thành + Đã thanh toán (như logic cũ)
            sql = "UPDATE orders SET order_status = 'COMPLETED', payment_status = 'PAID' WHERE id = ?";
        } else if ("CANCEL".equals(action)) {
            // Khách không nhận hàng -> Hủy + Lưu lại lý do
            sql = "UPDATE orders SET order_status = 'CANCELLED', cancel_reason = ? WHERE id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Nếu là thao tác Hủy, truyền thêm tham số lý do vào vị trí index 1
            if ("CANCEL".equals(action)) {
                ps.setString(1, reason);
                ps.setInt(2, orderId);
            } else {
                ps.setInt(1, orderId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}