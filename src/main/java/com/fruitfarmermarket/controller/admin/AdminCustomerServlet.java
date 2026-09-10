package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.CustomerDAO;
import com.fruitfarmermarket.model.CustomerDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/customers")
public class AdminCustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CustomerDTO> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);

        // Thống kê đếm số lượng theo hạng
        long diamond = customers.stream().filter(c -> "DIAMOND".equals(c.getTier())).count();
        long gold = customers.stream().filter(c -> "GOLD".equals(c.getTier())).count();
        request.setAttribute("diamondCount", diamond);
        request.setAttribute("goldCount", gold);

        request.getRequestDispatcher("/view/admin/customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStatus = request.getParameter("currentStatus");

            if (customerDAO.toggleCustomerStatus(id, currentStatus)) {
                session.setAttribute("successMsg", "Đã thay đổi trạng thái khách hàng!");
            } else {
                session.setAttribute("errorMsg", "Lỗi khi đổi trạng thái!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }
}