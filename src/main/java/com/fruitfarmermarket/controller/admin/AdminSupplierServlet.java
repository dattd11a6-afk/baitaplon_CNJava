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
        request.setAttribute("suppliers", supplierDAO.getAllSuppliersAdmin());
        request.getRequestDispatcher("/view/admin/suppliers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (supplierDAO.deleteSupplier(id)) session.setAttribute("successMsg", "Đã xóa nhà cung cấp!");
                else session.setAttribute("errorMsg", "Lỗi khi xóa nhà cung cấp!");
            } else {
                Supplier s = new Supplier();
                s.setName(request.getParameter("name"));
                s.setPhone(request.getParameter("phone"));
                s.setEmail(request.getParameter("email"));
                s.setAddress(request.getParameter("address"));
                s.setStatus(request.getParameter("status"));

                if ("add".equals(action)) {
                    if (supplierDAO.insertSupplier(s)) session.setAttribute("successMsg", "Thêm nhà cung cấp thành công!");
                    else session.setAttribute("errorMsg", "Lỗi khi thêm nhà cung cấp!");
                } else if ("update".equals(action)) {
                    s.setId(Integer.parseInt(request.getParameter("id")));
                    if (supplierDAO.updateSupplier(s)) session.setAttribute("successMsg", "Cập nhật thành công!");
                    else session.setAttribute("errorMsg", "Lỗi khi cập nhật!");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/suppliers");
    }
}