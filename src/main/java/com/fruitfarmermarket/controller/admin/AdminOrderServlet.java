package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            // Xem chi tiết đơn
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderByIdAndUserId(orderId, Integer.parseInt(request.getParameter("uid"))); // Tạm thời bỏ qua check UID nếu là Admin
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/view/admin/order-detail.jsp").forward(request, response);
        } else {
            // Danh sách đơn
            List<Order> orders = orderDAO.getAllOrdersForAdmin();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/view/admin/orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            if (orderDAO.updateOrderStatus(orderId, status)) {
                request.getSession().setAttribute("successMsg", "Cập nhật trạng thái đơn hàng thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Lỗi khi cập nhật!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}