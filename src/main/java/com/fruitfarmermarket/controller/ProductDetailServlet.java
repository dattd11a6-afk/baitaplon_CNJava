package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.ReviewDAO;
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
    private ReviewDAO reviewDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        reviewDAO = new ReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idStr);

            // Lấy thông tin Sản phẩm
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);

                // Sử dụng ReviewDAO để kéo Dữ liệu Thống kê & Danh sách đánh giá
                request.setAttribute("averageRating", reviewDAO.getAverageRating(productId));
                request.setAttribute("totalSold", reviewDAO.getTotalSold(productId));

                // Lấy toàn bộ đánh giá (bao gồm URL ảnh/video và phản hồi từ seller)
                request.setAttribute("reviews", reviewDAO.getReviewsByProduct(productId));
                request.setAttribute("reviewCount", reviewDAO.getReviewsByProduct(productId).size());

                request.getRequestDispatcher("/view/user/product-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("errorTitle", "Không tìm thấy sản phẩm");
                request.setAttribute("errorMessage", "Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã ngừng kinh doanh.");
                request.getRequestDispatcher("/404.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}