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
    private ProductDAO productDAO = new ProductDAO(); // Bổ sung ProductDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy danh sách đơn hàng
        List<Order> myOrders = orderDAO.getOrdersByUserId(user.getId());

        // Tạo Map để chứa danh sách sản phẩm của từng đơn hàng
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
        request.setAttribute("orderItemsMap", orderItemsMap); // Ném map này sang JSP
        request.getRequestDispatcher("/view/user/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("confirm_received".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.updateOrderStatus(orderId, "COMPLETED");
                request.getSession().setAttribute("successMsg", "Xác nhận nhận hàng thành công! Hãy để lại đánh giá nhé.");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMsg", "Lỗi cập nhật trạng thái!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/orders/history");
    }
}