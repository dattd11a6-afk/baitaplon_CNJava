package com.fruitfarmermarket.controller.staff;

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
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/staff/profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 2,       // Tối đa 2 MB cho ảnh Avatar
        maxRequestSize = 1024 * 1024 * 5     // Tối đa 5 MB tổng request
)
public class StaffProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/staff/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User staff = (User) session.getAttribute("user");
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy dữ liệu cơ bản
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Xử lý Upload file ảnh (Avatar)
            Part filePart = request.getPart("avatar");
            String fileName = (filePart != null && filePart.getSize() > 0) ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;
            String avatarPath = staff.getAvatar();

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "images" + File.separator + "users";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadPath + File.separator + uniqueFileName);
                avatarPath = uniqueFileName;
            }

            // Gán data vào đối tượng (Không set ngày sinh nữa vì DB không có)
            staff.setFullName(fullName);
            staff.setEmail(email);
            staff.setPhone(phone);
            staff.setAddress(address);
            staff.setAvatar(avatarPath);

            // Xử lý Mật khẩu mới an toàn
            boolean isUpdatePassword = false;
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (newPassword.equals(confirmPassword)) {
                    staff.setPassword(PasswordUtil.hashPassword(newPassword));
                    isUpdatePassword = true;
                } else {
                    session.setAttribute("errorMsg", "Mật khẩu xác nhận không khớp!");
                    response.sendRedirect(request.getContextPath() + "/staff/profile");
                    return;
                }
            }

            // Lưu vào Database
            boolean success = userDAO.updateStaffProfile(staff, isUpdatePassword);

            if (success) {
                session.setAttribute("user", staff);
                session.setAttribute("successMsg", "Cập nhật hồ sơ cá nhân thành công!");
            } else {
                session.setAttribute("errorMsg", "Có lỗi xảy ra khi lưu vào cơ sở dữ liệu.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/staff/profile");
    }
}