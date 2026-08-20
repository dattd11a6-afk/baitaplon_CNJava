package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.CategoryDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Category;
import com.fruitfarmermarket.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Nhận các tham số từ URL (Filter, Sort, Search, Pagination)
        String keyword = request.getParameter("keyword");
        String categoryStr = request.getParameter("category");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sort = request.getParameter("sort");
        String pageStr = request.getParameter("page");

        // 2. Chuyển đổi kiểu dữ liệu an toàn
        Integer categoryId = null;
        if (categoryStr != null && !categoryStr.trim().isEmpty()) {
            try { categoryId = Integer.parseInt(categoryStr); } catch (NumberFormatException e) { /* Bỏ qua nếu lỗi */ }
        }

        BigDecimal minPrice = null;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try { minPrice = new BigDecimal(minPriceStr); } catch (NumberFormatException e) {}
        }

        BigDecimal maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try { maxPrice = new BigDecimal(maxPriceStr); } catch (NumberFormatException e) {}
        }

        int page = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (NumberFormatException e) {}
        }
        int pageSize = 12; // Hiển thị 12 sản phẩm trên 1 trang

        // 3. Gọi DAO để lấy dữ liệu
        List<Category> categories = categoryDAO.getAllActiveCategories();
        List<Product> products = productDAO.getProducts(keyword, categoryId, minPrice, maxPrice, sort, page, pageSize);

        // Tính toán phân trang
        int totalProducts = productDAO.countProducts(keyword, categoryId, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // 4. Gắn dữ liệu vào Request để đẩy sang JSP
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("totalProducts", totalProducts);

        // Giữ lại trạng thái của các bộ lọc để hiển thị đúng trên giao diện
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.setAttribute("sort", sort);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // 5. Chuyển hướng sang trang giao diện
        request.getRequestDispatcher("/view/user/products.jsp").forward(request, response);
    }
}