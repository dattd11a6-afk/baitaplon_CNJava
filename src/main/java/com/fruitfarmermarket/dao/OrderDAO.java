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

    // ==========================================
    // 5. CÁC HÀM CHO ADMIN DASHBOARD
    // ==========================================
    // Lấy danh sách 5 đơn hàng mới nhất
    public List<Order> getRecentOrders(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setReceiverName(rs.getString("receiver_name"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(order);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    // Lấy TẤT CẢ đơn hàng của hệ thống (Cho Admin)
    public List<Order> getAllOrdersForAdmin() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setReceiverName(rs.getString("receiver_name"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(order);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Cập nhật trạng thái đơn hàng (PENDING -> CONFIRMED -> SHIPPING...)
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    // ==========================================
    // 6. CÁC HÀM CHO NHÂN VIÊN (STAFF)
    // ==========================================

    // Lấy chi tiết 1 đơn hàng (Không cần check user_id vì Staff được quyền xem mọi đơn)
    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
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
        } catch (SQLException e) { e.printStackTrace(); }
        return order;
    }

    // Đổi trạng thái đơn hàng & Ghi lịch sử (Sử dụng Transaction)
    public boolean updateOrderStatusWithHistory(int orderId, String oldStatus, String newStatus, int changedBy, String reason) {
        Connection conn = null;
        String sqlUpdateOrder = "UPDATE orders SET order_status = ? WHERE id = ?";
        String sqlInsertHistory = "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, reason) VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Cập nhật trạng thái Order
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateOrder)) {
                ps1.setString(1, newStatus);
                ps1.setInt(2, orderId);
                ps1.executeUpdate();
            }

            // 2. Ghi lịch sử
            try (PreparedStatement ps2 = conn.prepareStatement(sqlInsertHistory)) {
                ps2.setInt(1, orderId);
                ps2.setString(2, oldStatus);
                ps2.setString(3, newStatus);
                ps2.setInt(4, changedBy);
                ps2.setString(5, reason);
                ps2.executeUpdate();
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

    // Hủy đơn hàng & Hoàn lại Tồn kho & Ghi lịch sử (Transaction hạng nặng)
    public boolean cancelOrderWithStockRestore(int orderId, int changedBy, String reason, List<OrderDetail> details) {
        Connection conn = null;
        String sqlUpdateOrder = "UPDATE orders SET order_status = 'CANCELLED' WHERE id = ?";
        String sqlInsertHistory = "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, reason) VALUES (?, ?, 'CANCELLED', ?, ?)";
        String sqlRestoreStock = "UPDATE products SET stock = stock + ? WHERE id = ?";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Đổi trạng thái thành CANCELLED
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdateOrder)) {
                ps1.setInt(1, orderId);
                ps1.executeUpdate();
            }

            // 2. Ghi lịch sử hủy đơn
            Order currentOrder = getOrderById(orderId); // Lấy trạng thái cũ
            try (PreparedStatement ps2 = conn.prepareStatement(sqlInsertHistory)) {
                ps2.setInt(1, orderId);
                ps2.setString(2, currentOrder != null ? currentOrder.getOrderStatus() : "UNKNOWN");
                ps2.setInt(3, changedBy);
                ps2.setString(4, reason);
                ps2.executeUpdate();
            }

            // 3. Vòng lặp cộng lại Tồn kho cho từng sản phẩm
            try (PreparedStatement ps3 = conn.prepareStatement(sqlRestoreStock)) {
                for (OrderDetail detail : details) {
                    ps3.setInt(1, detail.getQuantity());
                    ps3.setInt(2, detail.getProductId());
                    ps3.addBatch();
                }
                ps3.executeBatch();
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
    // ==========================================
    // 7. TẠO ĐƠN TẠI QUẦY (POS) CHO STAFF
    // ==========================================
    public int createStoreOrder(Order order, List<CartItem> cart, int staffId) {
        int orderId = -1;
        Connection conn = null;

        // Chú ý: order_source được fix cứng là 'STORE'
        String sqlOrder = "INSERT INTO orders (user_id, receiver_name, receiver_phone, receiver_address, total_amount, payment_method, payment_status, order_status, note, order_source) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'STORE')";
        String sqlDetail = "INSERT INTO order_details (order_id, product_id, product_name, price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE products SET stock = stock - ? WHERE id = ?";
        String sqlHistory = "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, reason) VALUES (?, NULL, 'COMPLETED', ?, 'Tạo đơn tại quầy (POS)')";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Lưu Order
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                if (order.getUserId() > 0) {
                    psOrder.setInt(1, order.getUserId());
                } else {
                    psOrder.setNull(1, java.sql.Types.INTEGER); // Khách vãng lai
                }
                psOrder.setString(2, order.getReceiverName() != null && !order.getReceiverName().isEmpty() ? order.getReceiverName() : "Khách lẻ");
                psOrder.setString(3, order.getReceiverPhone() != null ? order.getReceiverPhone() : "");
                psOrder.setString(4, "Mua tại quầy");
                psOrder.setBigDecimal(5, order.getTotalAmount());
                psOrder.setString(6, order.getPaymentMethod());
                psOrder.setString(7, "PAID");       // Mua tại quầy -> Đã thanh toán
                psOrder.setString(8, "COMPLETED");  // Mua tại quầy -> Hoàn thành
                psOrder.setString(9, order.getNote());
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) orderId = rs.getInt(1);
                }
            }

            if (orderId != -1) {
                // 2. Lưu Chi tiết & 3. Trừ Stock
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                     PreparedStatement psStock = conn.prepareStatement(sqlUpdateStock)) {
                    for (CartItem item : cart) {
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, item.getProduct().getId());
                        psDetail.setString(3, item.getProduct().getName());
                        psDetail.setBigDecimal(4, item.getProduct().getPrice());
                        psDetail.setInt(5, item.getQuantity());
                        psDetail.setBigDecimal(6, item.getSubtotal());
                        psDetail.addBatch();

                        psStock.setInt(1, item.getQuantity());
                        psStock.setInt(2, item.getProduct().getId());
                        psStock.addBatch();
                    }
                    psDetail.executeBatch();
                    psStock.executeBatch();
                }

                // 4. Ghi Lịch sử
                try (PreparedStatement psHist = conn.prepareStatement(sqlHistory)) {
                    psHist.setInt(1, orderId);
                    psHist.setInt(2, staffId);
                    psHist.executeUpdate();
                }
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            orderId = -1;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return orderId;
    }
}
