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
        // Lấy session hiện tại (nếu có) và xóa nó đi
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Điều hướng về trang chủ
        response.sendRedirect(request.getContextPath() + "/");
    }
}