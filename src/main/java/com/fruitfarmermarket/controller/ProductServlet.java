package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // Hứng các tham số Bộ Lọc Mới
        String category = request.getParameter("category");
        String[] origins = request.getParameterValues("origin"); // Có thể chọn nhiều
        String priceRange = request.getParameter("priceRange");
        String sortOption = request.getParameter("sort");

        List<Product> products;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nút Tìm kiếm thanh Header
            products = productDAO.searchProducts(keyword);
        } else {
            // Gọi hàm Dynamic Filter mới viết
            products = productDAO.getFilteredProducts(category, origins, priceRange, sortOption);
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/view/user/products.jsp").forward(request, response);
    }
}