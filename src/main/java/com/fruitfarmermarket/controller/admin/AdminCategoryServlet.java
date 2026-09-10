package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.CategoryDAO;
import com.fruitfarmermarket.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chỉ load danh sách, Add/Edit sẽ dùng Popup (Modal)
        List<Category> categories = categoryDAO.getAllCategoriesForAdmin();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/view/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (categoryDAO.deleteCategory(id)) {
                    session.setAttribute("successMsg", "Đã xóa/ẩn danh mục thành công!");
                } else {
                    session.setAttribute("errorMsg", "Không thể xóa danh mục này.");
                }
            } else {
                Category c = new Category();
                c.setName(request.getParameter("name"));
                c.setDescription(request.getParameter("description"));
                c.setStatus(request.getParameter("status"));

                if ("add".equals(action)) {
                    String result = categoryDAO.insertCategory(c);
                    if ("SUCCESS".equals(result)) session.setAttribute("successMsg", "Thêm danh mục thành công!");
                    else session.setAttribute("errorMsg", "Lỗi CSDL: " + result);
                } else if ("update".equals(action)) {
                    c.setId(Integer.parseInt(request.getParameter("id")));
                    String result = categoryDAO.updateCategory(c);
                    if ("SUCCESS".equals(result)) session.setAttribute("successMsg", "Cập nhật danh mục thành công!");
                    else session.setAttribute("errorMsg", "Lỗi CSDL: " + result);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu nhập vào không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}