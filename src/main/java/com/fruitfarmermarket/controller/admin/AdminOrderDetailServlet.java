package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.OrderStatusHistory;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/order-detail")
public class AdminOrderDetailServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;

        // Chặn bảo mật Admin/Staff
        if (admin == null || (!"ADMIN".equals(admin.getRole()) && !"STAFF".equals(admin.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("id"));

            // 1. Lấy thông tin đơn hàng
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // 2. Lấy danh sách sản phẩm trong đơn
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);

            // 3. Lấy lịch sử tiến độ đơn hàng
            List<OrderStatusHistory> historyList = orderDAO.getOrderHistory(orderId);

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("historyList", historyList);

            // Bắn sang giao diện Admin (KHÔNG PHẢI GIAO DIỆN USER NỮA)
            request.getRequestDispatcher("/view/admin/admin-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}