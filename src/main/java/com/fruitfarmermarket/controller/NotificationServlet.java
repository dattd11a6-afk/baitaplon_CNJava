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
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> notiList = new ArrayList<>();
        // Lấy thông báo theo user_id, mới nhất xếp lên đầu
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> n = new HashMap<>();
                    n.put("id", rs.getInt("id"));
                    n.put("title", rs.getString("title"));
                    n.put("message", rs.getString("message"));
                    n.put("type", rs.getString("type")); // Phân loại: ORDER (Đơn hàng), PROMO (Khuyến mãi)
                    n.put("isRead", rs.getBoolean("is_read")); // True (Đã đọc) hoặc False (Chưa đọc)
                    n.put("createdAt", rs.getTimestamp("created_at"));
                    notiList.add(n);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("notifications", notiList);
        request.getRequestDispatcher("/view/user/notifications.jsp").forward(request, response);
    }
}