package com.fruitfarmermarket.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout-success")
public class OrderSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. Kiểm tra xem khách có thực sự vừa đặt hàng không
        Integer lastOrderId = (Integer) session.getAttribute("lastOrderId");

        if (lastOrderId == null) {
            // Khách tự gõ URL mạo danh -> Đuổi về trang chủ
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // 2. Chuyển ID sang request để hiển thị trên giao diện
        request.setAttribute("orderId", lastOrderId);

        // (Tùy chọn) Xóa lastOrderId đi để F5 không hiện lại, nhưng giữ lại cũng tốt để khách xem
        // session.removeAttribute("lastOrderId");

        // 3. Render trang Cảm ơn
        request.getRequestDispatcher("/view/user/checkout-success.jsp").forward(request, response);
    }
}