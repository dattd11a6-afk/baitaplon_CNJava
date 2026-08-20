package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/orders", "/order-detail"})
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Bắt buộc đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        // 2. Xử lý logic tùy theo URL
        if ("/orders".equals(path)) {
            // Hiển thị danh sách đơn hàng
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/view/user/orders.jsp").forward(request, response);

        } else if ("/order-detail".equals(path)) {
            // Hiển thị chi tiết 1 đơn hàng
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));

                // KIỂM TRA QUYỀN SỞ HỮU (Chỉ lấy đơn nếu đúng user_id)
                Order order = orderDAO.getOrderByIdAndUserId(orderId, user.getId());

                if (order != null) {
                    List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("details", details);
                    request.getRequestDispatcher("/view/user/order-detail.jsp").forward(request, response);
                } else {
                    // Cố tình xem đơn người khác hoặc ID sai -> Đuổi về trang danh sách
                    response.sendRedirect(request.getContextPath() + "/orders");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/orders");
            }
        }
    }
}