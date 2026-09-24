package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // --------------------------------------------------------
        // LUỒNG 1: GỬI MÃ OTP ĐẾN EMAIL
        // --------------------------------------------------------
        if ("send_otp".equals(action)) {
            String email = request.getParameter("email");
            User user = userDAO.getUserByEmail(email);

            if (user == null) {
                request.setAttribute("errorMsg", "Email này chưa được đăng ký trong hệ thống!");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            // Random mã OTP 6 số
            String otp = String.format("%06d", new Random().nextInt(999999));

            // MÓC EMAIL UTIL VÀO ĐÂY
            boolean isSent = EmailUtil.sendOTP(email, otp);

            if (!isSent) {
                request.setAttribute("errorMsg", "Lỗi hệ thống: Không thể gửi email lúc này. Vui lòng kiểm tra lại kết nối mạng hoặc cấu hình SMTP!");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            // Lưu OTP, Email và Thời gian tạo vào Session
            session.setAttribute("sessionOtp", otp);
            session.setAttribute("sessionEmail", email);
            session.setAttribute("otpCreationTime", System.currentTimeMillis());

            // Chuyển sang màn hình nhập OTP
            request.setAttribute("step", "verify_otp");
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
        }

        // --------------------------------------------------------
        // LUỒNG 2: XÁC THỰC MÃ OTP (Bảo mật 5 phút)
        // --------------------------------------------------------
        else if ("verify_otp".equals(action)) {
            String inputOtp = request.getParameter("otp");
            String sessionOtp = (String) session.getAttribute("sessionOtp");
            Long otpCreationTime = (Long) session.getAttribute("otpCreationTime");

            if (sessionOtp == null || !sessionOtp.equals(inputOtp)) {
                request.setAttribute("errorMsg", "Mã OTP không chính xác!");
                request.setAttribute("step", "verify_otp");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            long currentTime = System.currentTimeMillis();
            if ((currentTime - otpCreationTime) > 300000) {
                session.removeAttribute("sessionOtp");
                request.setAttribute("errorMsg", "Mã OTP đã hết hạn (quá 5 phút). Vui lòng gửi lại!");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("step", "reset_password");
            request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
        }

        // --------------------------------------------------------
        // LUỒNG 3: ĐẶT LẠI MẬT KHẨU MỚI
        // --------------------------------------------------------
        else if ("reset_password".equals(action)) {
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            String email = (String) session.getAttribute("sessionEmail");

            if (email == null) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
                request.setAttribute("step", "reset_password");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            User user = userDAO.getUserByEmail(email);
            if (user != null && user.getPassword().equals(newPassword)) {
                request.setAttribute("errorMsg", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
                request.setAttribute("step", "reset_password");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            boolean isUpdated = userDAO.updatePassword(email, newPassword);

            if (isUpdated) {
                session.removeAttribute("sessionOtp");
                session.removeAttribute("sessionEmail");
                session.removeAttribute("otpCreationTime");

                session.setAttribute("successMsg", "Đổi mật khẩu thành công! Đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMsg", "Có lỗi xảy ra khi cập nhật Database!");
                request.setAttribute("step", "reset_password");
                request.getRequestDispatcher("/view/auth/forgot-password.jsp").forward(request, response);
            }
        }
    }
}