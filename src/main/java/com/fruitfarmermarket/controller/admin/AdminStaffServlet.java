package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.StaffDAO;
import com.fruitfarmermarket.model.StaffDTO;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends HttpServlet {
    private StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<StaffDTO> staffList = staffDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/view/admin/staff.jsp").forward(request, response);
    }

    // Hàm phụ trợ dịch role thành tên gọi
    private String getRoleName(String role) {
        if ("ADMIN".equals(role)) return "quản trị viên";
        if ("SHIPPER".equals(role)) return "tài xế giao hàng";
        return "nhân viên bán hàng";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        User loggedInAdmin = (User) session.getAttribute("user");

        if (loggedInAdmin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if ("disable".equals(action)) {
                int targetId = Integer.parseInt(request.getParameter("id"));
                String targetRole = request.getParameter("targetRole");
                String targetName = request.getParameter("targetName");

                String roleDisplay = getRoleName(targetRole);

                if (loggedInAdmin.getId() == targetId) {
                    session.setAttribute("errorMsg", "Cảnh báo bảo mật: Không thể tự khóa tài khoản của chính mình!");
                } else {
                    if (staffDAO.disableStaff(targetId)) {
                        session.setAttribute("successMsg", "Đã khóa tài khoản " + roleDisplay + " [" + targetName + "]");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi khi khóa tài khoản " + roleDisplay);
                    }
                }
            } else {
                StaffDTO s = new StaffDTO();
                s.setFullName(request.getParameter("fullName"));
                s.setEmail(request.getParameter("email"));
                s.setPhone(request.getParameter("phone"));
                s.setPassword(request.getParameter("password"));
                s.setStatus(request.getParameter("status"));
                s.setRole(request.getParameter("role"));

                String roleDisplay = getRoleName(s.getRole());

                if ("add".equals(action)) {
                    String result = staffDAO.insertStaff(s);
                    if ("SUCCESS".equals(result)) {
                        session.setAttribute("successMsg", "Thêm mới " + roleDisplay + " [" + s.getFullName() + "] thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi: " + result);
                    }
                } else if ("update".equals(action)) {
                    int updateId = Integer.parseInt(request.getParameter("id"));

                    if (loggedInAdmin.getId() == updateId &&
                            ("INACTIVE".equals(s.getStatus()) || !"ADMIN".equals(s.getRole()))) {
                        session.setAttribute("errorMsg", "Cảnh báo bảo mật: Không thể tự hạ quyền hoặc tự khóa tài khoản đang đăng nhập!");
                    } else {
                        s.setId(updateId);
                        String result = staffDAO.updateStaff(s);
                        if ("SUCCESS".equals(result)) {
                            session.setAttribute("successMsg", "Cập nhật hồ sơ " + roleDisplay + " [" + s.getFullName() + "] thành công!");
                        } else {
                            session.setAttribute("errorMsg", "Lỗi: " + result);
                        }
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Dữ liệu gửi lên không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }
}