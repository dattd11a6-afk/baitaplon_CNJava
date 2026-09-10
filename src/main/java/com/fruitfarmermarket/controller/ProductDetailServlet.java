package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 1. Lấy thông tin Sản phẩm
            Product product = productDAO.getProductById(id);

            if (product != null) {
                request.setAttribute("product", product);

                // 2. Kéo danh sách Đánh giá (Review)
                List<Map<String, Object>> reviews = new ArrayList<>();
                int totalStars = 0;

                String sqlReview = "SELECT r.*, u.full_name, u.avatar FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sqlReview)) {
                    ps.setInt(1, id);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, Object> rev = new HashMap<>();
                        rev.put("fullName", rs.getString("full_name"));
                        rev.put("avatar", rs.getString("avatar"));
                        rev.put("rating", rs.getInt("rating"));
                        rev.put("comment", rs.getString("comment"));
                        rev.put("createdAt", rs.getTimestamp("created_at"));
                        reviews.add(rev);
                        totalStars += rs.getInt("rating");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // 3. Tính toán Trung bình sao
                double avgRating = reviews.isEmpty() ? 5.0 : (double) totalStars / reviews.size();
                request.setAttribute("reviews", reviews);
                request.setAttribute("avgRating", avgRating);
                request.setAttribute("reviewCount", reviews.size());

                request.getRequestDispatcher("/view/user/product-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("errorTitle", "Không tìm thấy sản phẩm");
                request.setAttribute("errorMessage", "Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã ngừng kinh doanh.");
                request.getRequestDispatcher("/404.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}