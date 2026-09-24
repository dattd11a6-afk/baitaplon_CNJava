package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 2, maxRequestSize = 1024 * 1024 * 5)
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // LẤY DỮ LIỆU TỔNG CHI TIÊU THẬT TỪ DATABASE NÉM SANG GIAO DIỆN
        User user = (User) session.getAttribute("user");
        OrderDAO orderDAO = new OrderDAO();
        BigDecimal totalSpend = orderDAO.getTotalSpendByUserId(user.getId());
        request.setAttribute("totalSpend", totalSpend);

        request.getRequestDispatcher("/view/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        if (action == null) action = "updateProfile";

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String avatarName = user.getAvatar();

            try {
                String contentType = request.getContentType();
                if (contentType != null && contentType.toLowerCase().contains("multipart/form-data")) {
                    Part filePart = request.getPart("avatarFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "users";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();

                        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        avatarName = "user_" + user.getId() + "_" + originalFileName;
                        filePart.write(uploadPath + File.separator + avatarName);
                    }
                }

                String sql = "UPDATE users SET full_name = ?, phone = ?, address = ?, avatar = ? WHERE id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, fullName);
                    ps.setString(2, phone);
                    ps.setString(3, address);
                    ps.setString(4, avatarName);
                    ps.setInt(5, user.getId());

                    if (ps.executeUpdate() > 0) {
                        user.setFullName(fullName);
                        user.setPhone(phone);
                        user.setAddress(address);
                        user.setAvatar(avatarName);
                        session.setAttribute("user", user);
                        session.setAttribute("successMsg", "Cập nhật hồ sơ và địa chỉ thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Cập nhật thất bại, vui lòng thử lại!");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMsg", "Lỗi cập nhật hệ thống!");
            }
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}