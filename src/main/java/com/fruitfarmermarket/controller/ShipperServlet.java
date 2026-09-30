package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ShipperDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/shipper", "/shipper/update"})
public class ShipperServlet extends HttpServlet {
    private ShipperDAO shipperDAO = new ShipperDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // PHÂN QUYỀN
        if (user == null || !"SHIPPER".equals(user.getRole()) && !"ADMIN".equals(user.getRole())) {
            // Nếu là khách, đuổi về trang chủ hoặc trang đăng nhập
            session.setAttribute("errorMsg", "Khu vực này chỉ dành cho Tài xế giao hàng!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "pending"; // Mặc định là Chờ nhận đơn

        List<Order> orders = shipperDAO.getOrdersByStatus(tab);
        request.setAttribute("orders", orders);
        request.setAttribute("currentTab", tab);

        request.getRequestDispatcher("/view/shipper/shipper-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Xử lý nút bấm: Nhận đơn, Hủy, Hoàn thành... (Gọi updateDeliveryStatus trong ShipperDAO)
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status"); // ACCEPT, COMPLETED, CANCEL
        String reason = request.getParameter("reason");

        if (orderIdStr != null && status != null) {
            int orderId = Integer.parseInt(orderIdStr);
            shipperDAO.updateDeliveryStatus(orderId, status, reason);
        }

        response.sendRedirect(request.getHeader("referer"));
    }
}