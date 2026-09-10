package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/staff/orders", "/staff/order-detail"})
public class StaffOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/staff/order-detail".equals(path)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/view/staff/order-detail.jsp").forward(request, response);
        } else {
            // Lấy toàn bộ đơn hàng cho Staff
            List<Order> orders = orderDAO.getAllOrdersForAdmin();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/view/staff/orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User staff = (User) request.getSession().getAttribute("user");
        int staffId = staff.getId();

        int orderId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        String oldStatus = request.getParameter("currentStatus");
        String reason = request.getParameter("reason"); // Dành cho hủy đơn

        boolean success = false;

        if ("CANCELLED".equals(action)) {
            // Nghiệp vụ HỦY ĐƠN & HOÀN KHO
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
            success = orderDAO.cancelOrderWithStockRestore(orderId, staffId, reason, details);
            if(success) request.getSession().setAttribute("successMsg", "Đã hủy đơn hàng và hoàn lại tồn kho.");
        } else {
            // Nghiệp vụ ĐỔI TRẠNG THÁI BÌNH THƯỜNG
            String newStatus = action;
            success = orderDAO.updateOrderStatusWithHistory(orderId, oldStatus, newStatus, staffId, "Staff cập nhật trạng thái");
            if(success) request.getSession().setAttribute("successMsg", "Cập nhật trạng thái đơn hàng thành công.");
        }

        if(!success) {
            request.getSession().setAttribute("errorMsg", "Có lỗi xảy ra khi xử lý đơn hàng.");
        }

        // Quay lại trang chi tiết đơn
        response.sendRedirect(request.getContextPath() + "/staff/order-detail?id=" + orderId);
    }
}