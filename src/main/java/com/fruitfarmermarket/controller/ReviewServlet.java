package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra xem khách đã đăng nhập chưa
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy dữ liệu từ Form gửi lên
            int productId = Integer.parseInt(request.getParameter("productId"));
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int ratingValue = Integer.parseInt(request.getParameter("ratingValue"));
            String comment = request.getParameter("comment");

            String sql = "INSERT INTO reviews (user_id, product_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, user.getId());
                ps.setInt(2, productId);
                ps.setInt(3, orderId);
                ps.setInt(4, ratingValue);
                ps.setString(5, comment);

                if (ps.executeUpdate() > 0) {
                    request.getSession().setAttribute("successMsg", "Gửi đánh giá " + ratingValue + " sao thành công!");
                } else {
                    request.getSession().setAttribute("errorMsg", "Không thể lưu đánh giá lúc này!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Hệ thống bận, vui lòng thử lại sau!");
        }

        // Chuyển hướng lại trang Lịch sử đơn hàng
        response.sendRedirect(request.getContextPath() + "/orders/history");
    }
}