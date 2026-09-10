package com.fruitfarmermarket.controller.staff;

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

@WebServlet("/staff/invoice")
public class StaffInvoiceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        OrderDAO orderDAO = new OrderDAO();

        Order order = orderDAO.getOrderById(orderId);
        List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.getRequestDispatcher("/view/staff/invoice.jsp").forward(request, response);
    }
}