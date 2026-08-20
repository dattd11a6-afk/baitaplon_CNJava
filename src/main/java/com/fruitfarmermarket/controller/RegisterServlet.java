package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.PasswordUtil;
import com.fruitfarmermarket.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Hiển thị trang đăng ký
        request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Fix lỗi 500: Xử lý an toàn khi address bị bỏ trống trên giao diện mới
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            address = "Chưa cập nhật";
        }

        // 1. Validation an toàn tại Backend (Kiểm tra null trước)
        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Định dạng email không hợp lệ!");
            request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra trùng email trong CSDL
        if (userDAO.checkEmailExist(email)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
            return;
        }

        // 3. Mã hóa mật khẩu và lưu vào Database
        String hashedPassword = PasswordUtil.hashPassword(password);
        User newUser = new User(fullName, email, hashedPassword, phone, address);

        if (userDAO.register(newUser)) {
            // Hiển thị thông báo đăng ký thành công sang trang login (Bạn có thể bắt biến success này ở login.jsp nếu muốn)
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/view/user/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra từ hệ thống, vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/user/register.jsp").forward(request, response);
        }
    }
}