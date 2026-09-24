package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.AccessoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("========== HOMESERVLET ĐÃ hoạt động==========");
        try {
            // bắt lỗi
            ProductDAO productDAO = new ProductDAO();
            AccessoryDAO accessoryDAO = new AccessoryDAO();

            request.setAttribute("featuredProducts", productDAO.getFeaturedProducts(8));
            request.setAttribute("baskets", accessoryDAO.getAccessoriesByType("BASKET"));
            request.setAttribute("decorations", accessoryDAO.getAccessoriesByType("DECORATION"));
            request.setAttribute("packagings", accessoryDAO.getAccessoriesByType("PACKAGING"));

            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>hỏng</h1><p>" + e.getMessage() + "</p>");
        }
    }
}