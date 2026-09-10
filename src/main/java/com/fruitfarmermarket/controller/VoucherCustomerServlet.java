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

@WebServlet("/vouchers")
public class VoucherCustomerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Map<String, Object>> voucherList = new ArrayList<>();
        // Lấy tất cả các Voucher đang hoạt động và còn hạn sử dụng
        String sql = "SELECT * FROM vouchers WHERE status = 'ACTIVE' AND expiration_date >= CURDATE() ORDER BY expiration_date ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> v = new HashMap<>();
                v.put("id", rs.getInt("id"));
                v.put("code", rs.getString("code"));
                v.put("discountAmount", rs.getBigDecimal("discount_amount"));
                v.put("minOrder", rs.getBigDecimal("min_order_value"));
                v.put("expirationDate", rs.getDate("expiration_date"));
                v.put("type", rs.getString("type")); // Ví dụ: PERCENT (Phần trăm), AMOUNT (Trừ thẳng tiền), FREESHIP
                voucherList.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("vouchers", voucherList);
        request.getRequestDispatcher("/view/user/vouchers.jsp").forward(request, response);
    }
}