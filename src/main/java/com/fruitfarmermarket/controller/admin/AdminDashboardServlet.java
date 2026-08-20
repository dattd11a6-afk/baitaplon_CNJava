package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các số liệu thống kê từ Database
        int totalProducts = reportDAO.getTotalProducts();
        int totalOrders = reportDAO.getTotalOrders();
        int totalCustomers = reportDAO.getTotalCustomers();
        BigDecimal totalRevenue = reportDAO.getTotalRevenue();

        // Đẩy dữ liệu sang View
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalRevenue", totalRevenue);

        // Forward sang trang JSP của Admin
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}