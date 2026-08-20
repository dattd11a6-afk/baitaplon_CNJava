package com.fruitfarmermarket.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra xem có đơn hàng vừa đặt trong session không
        if (session.getAttribute("lastOrder") == null) {
            // Nếu khách tự gõ URL /order-success mà chưa mua hàng -> đuổi về trang chủ
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Forward sang trang giao diện
        request.getRequestDispatcher("/view/user/order-success.jsp").forward(request, response);
    }
}