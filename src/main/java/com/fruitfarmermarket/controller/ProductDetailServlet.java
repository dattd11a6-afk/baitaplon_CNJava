package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        // 1. Kiểm tra ID truyền vào có hợp lệ không
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 2. Lấy sản phẩm từ Database
            Product product = productDAO.getProductById(id);

            // 3. Xử lý kết quả
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/view/user/product-detail.jsp").forward(request, response);
            } else {
                // Nếu không tìm thấy sản phẩm (ID = 9999)
                request.setAttribute("errorTitle", "Không tìm thấy sản phẩm");
                request.setAttribute("errorMessage", "Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã ngừng kinh doanh.");
                request.getRequestDispatcher("/404.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            // Nếu người dùng nhập chữ vào chỗ của ID (ví dụ: ?id=abc)
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}