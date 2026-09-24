package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ReviewDAO;
import com.fruitfarmermarket.model.Review;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/review")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 50, maxRequestSize = 1024 * 1024 * 100) // Cho phép upload file tối đa 50MB (chứa được video ngắn)
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int orderId = Integer.parseInt(request.getParameter("orderId")); // Lấy từ form lịch sử mua hàng
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            String mediaName = null;

            // Xử lý Upload Ảnh / Video
            Part filePart = request.getPart("mediaFile");
            if (filePart != null && filePart.getSize() > 0) {
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "reviews";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // Đổi tên file để chống trùng lặp
                mediaName = System.currentTimeMillis() + "_" + originalFileName;
                filePart.write(uploadPath + File.separator + mediaName);
            }

            Review r = new Review();
            r.setUserId(user.getId());
            r.setProductId(productId);
            r.setOrderId(orderId);
            r.setRating(rating);
            r.setComment(comment);
            r.setMediaUrl(mediaName);

            if (reviewDAO.insertReview(r)) {
                session.setAttribute("successMsg", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                session.setAttribute("errorMsg", "Không thể gửi đánh giá, vui lòng thử lại.");
            }

            // Quay lại trang chi tiết sản phẩm
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}