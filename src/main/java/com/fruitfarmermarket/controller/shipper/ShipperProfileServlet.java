package com.fruitfarmermarket.controller.shipper;

import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/shipper/profile")
public class ShipperProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/shipper/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword != null && !newPassword.isEmpty()) {
            if (newPassword.equals(confirmPassword)) {
                shipper.setPassword(PasswordUtil.hashPassword(newPassword));
                // Tái sử dụng hàm cập nhật của UserDAO
                boolean success = userDAO.updateStaffProfile(shipper, true);
                if (success) {
                    session.setAttribute("user", shipper);
                    session.setAttribute("successMsg", "Đổi mật khẩu thành công!");
                } else {
                    session.setAttribute("errorMsg", "Lỗi cập nhật CSDL!");
                }
            } else {
                session.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/shipper/profile");
    }
}