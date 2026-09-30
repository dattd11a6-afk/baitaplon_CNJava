package com.fruitfarmermarket.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/checkout-success")
public class CheckoutSuccessServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Kiểm tra xem khách có thực sự vừa đặt hàng không (chống gõ URL ảo)
        Object lastOrderId = session.getAttribute("lastOrderId");

        if (lastOrderId == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // 2. Chuyển ID sang request để hiển thị trên giao diện (ví dụ: "Cảm ơn bạn đã đặt đơn #1024")
        request.setAttribute("orderId", lastOrderId);

        // (Tùy chọn) Xóa lastOrderId để nếu khách F5 lại trang sẽ bị văng ra trang chủ
        // session.removeAttribute("lastOrderId");

        // 3. Render trang giao diện Cảm ơn
        request.getRequestDispatcher("/view/user/checkout-success.jsp").forward(request, response);
    }
}