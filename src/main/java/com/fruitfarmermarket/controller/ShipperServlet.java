package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ShipperDAO;
import com.fruitfarmermarket.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShipperServlet", urlPatterns = {"/shipper", "/shipper/update"})
public class ShipperServlet extends HttpServlet {
    private ShipperDAO shipperDAO = new ShipperDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tab = request.getParameter("tab");

        // Mở rộng bộ lọc cho 3 thẻ Tab
        if (tab == null || (!tab.equals("pending") && !tab.equals("shipping") && !tab.equals("completed"))) {
            tab = "pending"; // Mặc định mở tab Chờ nhận đơn (READY)
        }

        List<Order> orders = shipperDAO.getOrdersByStatus(tab);

        request.setAttribute("orders", orders);
        request.setAttribute("currentTab", tab);
        request.getRequestDispatcher("/view/shipper/shipper-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/update")) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String action = request.getParameter("action"); // ACCEPT, COMPLETED, hoặc CANCEL
            String cancelReason = request.getParameter("cancelReason"); // Có thể null

            shipperDAO.updateDeliveryStatus(orderId, action, cancelReason);

            // Chuyển hướng UX linh hoạt:
            // - Nhận đơn mới (ACCEPT) -> Nhảy qua tab "Đang giao" để Shipper thấy ngay
            // - Giao thành công / Hủy (COMPLETED, CANCEL) -> Vẫn giữ ở tab "Đang giao" để xử lý tiếp các đơn còn lại
            String redirectTab = "ACCEPT".equals(action) ? "shipping" : "shipping";
            response.sendRedirect(request.getContextPath() + "/shipper?tab=" + redirectTab);
        }
    }
}