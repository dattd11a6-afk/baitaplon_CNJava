package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/orders/history")
public class OrderHistoryServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Order> myOrders = orderDAO.getOrdersByUserId(user.getId());
        Map<Integer, List<CartItem>> orderItemsMap = new HashMap<>();

        for (Order order : myOrders) {
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(order.getId());
            List<CartItem> items = new ArrayList<>();

            for (OrderDetail od : details) {
                Product p = productDAO.getProductById(od.getProductId());
                if (p != null) {
                    items.add(new CartItem(p, od.getQuantity()));
                }
            }
            orderItemsMap.put(order.getId(), items);
        }

        request.setAttribute("myOrders", myOrders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.getRequestDispatcher("/view/user/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("confirm_received".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.updateOrderStatus(orderId, "COMPLETED");
                session.setAttribute("successMsg", "Xác nhận nhận hàng thành công! Hãy để lại đánh giá nhé.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Lỗi cập nhật trạng thái!");
            }
        }
        // LÔ-GÍC MỚI: XỬ LÝ HỦY ĐƠN TỪ KHÁCH HÀNG
        else if ("cancel_order".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String reasonType = request.getParameter("reasonType");
                String reasonOther = request.getParameter("reasonOther");

                // Nối chuỗi lý do nếu chọn Khác
                String finalReason = "Khác".equals(reasonType) ? reasonOther : reasonType;

                // Lấy details để trừ kho
                List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);

                if (orderDAO.cancelOrderByCustomer(orderId, user.getId(), finalReason, details)) {
                    session.setAttribute("successMsg", "Hủy đơn hàng thành công!");
                } else {
                    session.setAttribute("errorMsg", "Hủy đơn thất bại! Đơn hàng có thể đã được xử lý.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Lỗi hệ thống khi hủy đơn!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/orders/history");
    }
}