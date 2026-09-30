package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.AccessoriesDAO;
import com.fruitfarmermarket.model.Accessories;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/accessories")
public class AccessoriesServlet extends HttpServlet {
    private AccessoriesDAO dao = new AccessoriesDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("baskets", dao.getAccessoriesByType("BASKET"));
        request.setAttribute("decorations", dao.getAccessoriesByType("DECORATION"));
        request.setAttribute("packagings", dao.getAccessoriesByType("PACKAGING"));

        request.getRequestDispatcher("/view/admin/accessories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                Accessories a = new Accessories();
                // Ép kiểu chữ hoa để khớp với Database (BASKET, DECORATION, PACKAGING)
                a.setType(request.getParameter("type").toUpperCase());
                a.setName(request.getParameter("name"));
                a.setPrice(new BigDecimal(request.getParameter("price")));
                a.setImage(request.getParameter("image"));
                a.setDescription(request.getParameter("description"));

                dao.addAccessory(a);
                request.getSession().setAttribute("successMsg", "Đã thêm phụ kiện mới thành công!");

            } else if ("delete".equals(action)) {
                // Xóa mềm phụ kiện
                dao.softDeleteAccessory(Integer.parseInt(request.getParameter("id")));
                request.getSession().setAttribute("successMsg", "Đã vô hiệu hóa phụ kiện!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Lỗi: Kiểm tra lại định dạng dữ liệu đầu vào!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/accessories");
    }
}