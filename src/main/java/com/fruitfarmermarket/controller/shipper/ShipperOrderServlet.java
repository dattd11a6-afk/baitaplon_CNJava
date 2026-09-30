package com.fruitfarmermarket.controller.shipper;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/shipper/orders")
public class ShipperOrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        List<Order> myOrders = orderDAO.getOrdersByShipperId(shipper.getId());

        // TÍNH NĂNG MỚI: Kéo thêm danh sách Chi tiết Sản phẩm giống Admin
        Map<Integer, List<OrderDetail>> detailsMap = new HashMap<>();
        for (Order o : myOrders) {
            detailsMap.put(o.getId(), orderDAO.getOrderDetailsByOrderId(o.getId()));
        }

        request.setAttribute("myOrders", myOrders);
        request.setAttribute("detailsMap", detailsMap);
        request.getRequestDispatcher("/view/shipper/orders.jsp").forward(request, response);
    }
}