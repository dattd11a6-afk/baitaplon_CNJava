package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Review;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    // Thêm đánh giá mới có chứa file Media
    public boolean insertReview(Review r) {
        String sql = "INSERT INTO reviews (user_id, product_id, order_id, rating, comment, media_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getUserId());
            ps.setInt(2, r.getProductId());
            ps.setInt(3, r.getOrderId());
            ps.setInt(4, r.getRating());
            ps.setString(5, r.getComment());
            ps.setString(6, r.getMediaUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); } return false;
    }

    // Lấy danh sách đánh giá của 1 sản phẩm (Kèm thông tin người dùng)
    public List<Review> getReviewsByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setId(rs.getInt("id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setMediaUrl(rs.getString("media_url"));
                    r.setSellerReply(rs.getString("seller_reply"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setUserName(rs.getString("full_name"));
                    r.setUserAvatar(rs.getString("avatar"));
                    list.add(r);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); } return list;
    }

    // Tính điểm trung bình (Ví dụ: 4.5 sao)
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); } return 0.0;
    }

    // Lấy tổng số lượng đã bán (Chỉ tính đơn COMPLETED)
    public int getTotalSold(int productId) {
        String sql = "SELECT SUM(od.quantity) FROM order_details od JOIN orders o ON od.order_id = o.id WHERE od.product_id = ? AND o.order_status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); } return 0;
    }
    // Lấy tất cả đánh giá cho Admin quản lý
    public List<Review> getAllReviewsForAdmin() {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name, u.avatar, p.name AS product_name " +
                "FROM reviews r " +
                "JOIN users u ON r.user_id = u.id " +
                "JOIN products p ON r.product_id = p.id " +
                "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Review r = new Review();
                r.setId(rs.getInt("id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setMediaUrl(rs.getString("media_url"));
                r.setSellerReply(rs.getString("seller_reply"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("full_name"));
                r.setUserAvatar(rs.getString("avatar"));
                // Mượn tạm trường mediaUrl hoặc tạo thêm trường productName trong model Review nếu cần
                r.setProductName(rs.getString("product_name"));
                list.add(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Cập nhật câu trả lời của Người bán
    public boolean replyReview(int reviewId, String reply) {
        String sql = "UPDATE reviews SET seller_reply = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}