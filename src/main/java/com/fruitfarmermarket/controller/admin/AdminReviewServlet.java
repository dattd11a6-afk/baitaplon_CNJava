package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.ReviewDAO;
import com.fruitfarmermarket.model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hứng tham số bộ lọc từ UI
        String type = request.getParameter("type");
        String stars = request.getParameter("stars");

        // Đẩy tham số ngược lại JSP để Active các nút lọc
        request.setAttribute("currentType", type != null ? type : "all");
        request.setAttribute("currentStars", stars);

        // Gọi hàm DAO MỚI có Filter
        List<Review> reviews = reviewDAO.getFilteredReviewsForAdmin(type, stars);

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/view/admin/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        String reply = request.getParameter("sellerReply");

        if (reviewDAO.replyReview(reviewId, reply)) {
            request.getSession().setAttribute("successMsg", "Đã gửi phản hồi thành công!");
        } else {
            request.getSession().setAttribute("errorMsg", "Lỗi khi gửi phản hồi.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/reviews");
    }
}