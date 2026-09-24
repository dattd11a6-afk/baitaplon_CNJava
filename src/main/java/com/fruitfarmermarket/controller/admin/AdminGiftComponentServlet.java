package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.GiftBasketDAO;
import com.fruitfarmermarket.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/gift-components")
public class AdminGiftComponentServlet extends HttpServlet {

    private GiftBasketDAO gbDAO = new GiftBasketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tất cả dữ liệu (Bao gồm cả ACTIVE và INACTIVE để Admin quản lý)
        request.setAttribute("baskets", gbDAO.getActiveBaskets());
        request.setAttribute("decorations", gbDAO.getActiveDecorations());
        request.setAttribute("packagings", gbDAO.getActivePackagings());

        request.getRequestDispatcher("/view/admin/admin-gift-components.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String action = request.getParameter("action");
        String type = request.getParameter("type"); // basket, decoration, packaging

        try (Connection conn = DBConnection.getConnection()) {
            String tableName = type + "s"; // chuyển thành baskets, decorations, packagings

            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                String image = request.getParameter("image");

                String sql = "INSERT INTO " + tableName + " (name, description, price, image, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, desc);
                    ps.setBigDecimal(3, price);
                    ps.setString(4, image);
                    ps.executeUpdate();
                }
                session.setAttribute("successMsg", "Thêm mới thành công!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                // Xóa mềm (Đổi status) để không lỗi đơn hàng cũ
                String sql = "UPDATE " + tableName + " SET status = 'INACTIVE' WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                session.setAttribute("successMsg", "Đã vô hiệu hóa thành phần này!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/gift-components");
    }
}