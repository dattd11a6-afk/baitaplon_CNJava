package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/customers")
public class StaffCustomerServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Staff chỉ xem danh sách khách hàng để hỗ trợ
        List<User> customers = new UserDAO().getUsersByRole("CUSTOMER");
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/view/staff/customers.jsp").forward(request, response);
    }
}