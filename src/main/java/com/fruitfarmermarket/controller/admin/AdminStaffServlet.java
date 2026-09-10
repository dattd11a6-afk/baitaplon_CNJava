package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.StaffDAO;
import com.fruitfarmermarket.model.StaffDTO;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("disable".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (staffDAO.disableStaff(id)) {
                    session.setAttribute("successMsg", "Đã khóa tài khoản nhân viên!");
                } else {
                    session.setAttribute("errorMsg", "Lỗi khi khóa tài khoản!");
                }
            } else {
                StaffDTO s = new StaffDTO();
                s.setFullName(request.getParameter("fullName"));
                s.setEmail(request.getParameter("email"));
                s.setPhone(request.getParameter("phone"));
                s.setPassword(request.getParameter("password"));
                s.setStatus(request.getParameter("status"));

                if ("add".equals(action)) {
                    String result = staffDAO.insertStaff(s);
                    if ("SUCCESS".equals(result)) session.setAttribute("successMsg", "Tạo tài khoản Nhân viên thành công!");
                    else session.setAttribute("errorMsg", "LỖI: " + result);
                } else if ("update".equals(action)) {
                    s.setId(Integer.parseInt(request.getParameter("id")));
                    String result = staffDAO.updateStaff(s);
                    if ("SUCCESS".equals(result)) session.setAttribute("successMsg", "Cập nhật thông tin thành công!");
                    else session.setAttribute("errorMsg", "LỖI: " + result);
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/staff");
    }
}