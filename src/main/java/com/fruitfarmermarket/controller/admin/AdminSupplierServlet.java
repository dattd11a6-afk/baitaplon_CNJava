package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.SupplierDAO;
import com.fruitfarmermarket.model.Supplier;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/suppliers")
public class AdminSupplierServlet extends HttpServlet {
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                // THỰC HIỆN XÓA MỀM (Chuyển sang INACTIVE)
                if (supplierDAO.deleteSupplier(id)) {
                    session.setAttribute("successMsg", "Đã ngừng hợp tác và ẩn nhà cung cấp!");
                } else {
                    session.setAttribute("errorMsg", "Lỗi khi cập nhật trạng thái!");
                }
            } else {
                Supplier s = new Supplier();
                s.setName(request.getParameter("name"));
                s.setPhone(request.getParameter("phone"));
                s.setEmail(request.getParameter("email")); // FIX RƠI EMAIL
                s.setAddress(request.getParameter("address"));

                // FIX TRẠNG THÁI (Lấy từ Form, nếu ko có thì lấy ACTIVE)
                String status = request.getParameter("status");
                s.setStatus(status != null && !status.isEmpty() ? status : "ACTIVE");

                if ("add".equals(action)) {
                    if (supplierDAO.insertSupplier(s)) {
                        session.setAttribute("successMsg", "Thêm nhà cung cấp mới thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi khi lưu nhà cung cấp!");
                    }
                } else if ("update".equals(action)) {
                    s.setId(Integer.parseInt(request.getParameter("id")));
                    if (supplierDAO.updateSupplier(s)) {
                        session.setAttribute("successMsg", "Cập nhật hồ sơ nhà cung cấp thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi khi lưu cập nhật!");
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/inventory");
    }
}