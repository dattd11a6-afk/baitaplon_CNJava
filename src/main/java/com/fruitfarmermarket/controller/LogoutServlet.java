package com.fruitfarmermarket.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy session hiện tại (nếu có)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Hủy toàn bộ dữ liệu trong session (User, Giỏ hàng, Quyền...)
            session.invalidate();
        }

        // Đẩy về trang chủ của khách hàng
        response.sendRedirect(request.getContextPath() + "/");
    }
}