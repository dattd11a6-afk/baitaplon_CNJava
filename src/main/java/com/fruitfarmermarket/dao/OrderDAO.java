package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // ==========================================
    // 1. TẠO ĐƠN HÀNG (CÓ TRANSACTION TRỪ KHO)
    // ==========================================
    public int createOrder(Order order, List<CartItem> cart) {
        int orderId = -1;
        Connection conn = null;

        String sqlOrder = "INSERT INTO orders (user_id, receiver_name, receiver_phone, receiver_address, total_amount, payment_method, payment_status, order_status, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO order_details (order_id, product_id, product_name, price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE products SET stock = stock - ? WHERE id = ?";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // BẮT ĐẦU TRANSACTION

            // 1. Lưu Order
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                psOrder.setString(2, order.getReceiverName());
                psOrder.setString(3, order.getReceiverPhone());
                psOrder.setString(4, order.getReceiverAddress());
                psOrder.setBigDecimal(5, order.getTotalAmount());
                psOrder.setString(6, order.getPaymentMethod());
                psOrder.setString(7, order.getPaymentStatus());
                psOrder.setString(8, order.getOrderStatus());
                psOrder.setString(9, order.getNote());
                psOrder.executeUpdate();

                // Lấy ID đơn hàng vừa tạo
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            // 2. Lưu Order Details & 3. Trừ Stock
            if (orderId != -1) {
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                     PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock)) {

                    for (CartItem item : cart) {
                        // Lưu detail
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, item.getProduct().getId());
                        psDetail.setString(3, item.getProduct().getName());
                        psDetail.setBigDecimal(4, item.getProduct().getPrice());
                        psDetail.setInt(5, item.getQuantity());
                        psDetail.setBigDecimal(6, item.getSubtotal());
                        psDetail.addBatch();

                        // Cập nhật kho
                        psStock.setInt(1, item.getQuantity());
                        psStock.setInt(2, item.getProduct().getId());
                        psStock.addBatch();
                    }
                    psDetail.executeBatch();
                    psStock.executeBatch();
                }
            }

            conn.commit(); // THÀNH CÔNG -> Lưu thật vào DB
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } // LỖI -> Hủy bỏ
            }
            orderId = -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return orderId;
    }

    // ==========================================
    // 2. LẤY DANH SÁCH ĐƠN HÀNG CỦA 1 USER
    // ==========================================
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // 3. LẤY CHI TIẾT 1 ĐƠN HÀNG (CÓ CHECK BẢO MẬT USER_ID)
    // ==========================================
    public Order getOrderByIdAndUserId(int orderId, int userId) {
        Order order = null;
        String sql = "SELECT * FROM orders WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setReceiverName(rs.getString("receiver_name"));
                    order.setReceiverPhone(rs.getString("receiver_phone"));
                    order.setReceiverAddress(rs.getString("receiver_address"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setNote(rs.getString("note"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    // ==========================================
    // 4. LẤY DANH SÁCH SẢN PHẨM TRONG 1 ĐƠN HÀNG
    // ==========================================
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setId(rs.getInt("id"));
                    detail.setProductId(rs.getInt("product_id"));
                    detail.setProductName(rs.getString("product_name"));
                    detail.setPrice(rs.getBigDecimal("price"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setSubtotal(rs.getBigDecimal("subtotal"));
                    list.add(detail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}