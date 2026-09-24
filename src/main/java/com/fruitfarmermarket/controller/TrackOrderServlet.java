package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderStatusHistory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/track-order")
public class TrackOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ hiển thị giao diện khi truy cập bằng URL
        request.getRequestDispatcher("/view/user/track-order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderIdStr = request.getParameter("orderId");
        String phone = request.getParameter("phone");

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId); // Lấy thông tin đơn hàng

            // BẢO MẬT: Phải đúng mã đơn VÀ đúng số điện thoại đặt hàng
            if (order != null && order.getReceiverPhone() != null && order.getReceiverPhone().equals(phone.trim())) {
                // Lấy lịch sử timeline của đơn hàng
                List<OrderStatusHistory> orderHistory = orderDAO.getOrderHistory(orderId);

                request.setAttribute("order", order);
                request.setAttribute("orderHistory", orderHistory);
            } else {
                request.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc số điện thoại không khớp!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Mã đơn hàng phải là một dãy số hợp lệ!");
        }

        // Trả kết quả về lại chính trang tra cứu để hiển thị
        request.getRequestDispatcher("/view/user/track-order.jsp").forward(request, response);
    }
}