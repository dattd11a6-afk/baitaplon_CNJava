package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.AccessoryDAO;
import com.fruitfarmermarket.model.Accessory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/accessories")
public class AdminAccessoryServlet extends HttpServlet {
    private AccessoryDAO dao = new AccessoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("baskets", dao.getAccessoriesByType("BASKET"));
        request.setAttribute("decorations", dao.getAccessoriesByType("DECORATION"));
        request.setAttribute("packagings", dao.getAccessoriesByType("PACKAGING"));

        request.getRequestDispatcher("/view/admin/admin-accessories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                Accessory a = new Accessory();
                a.setType(request.getParameter("type"));
                a.setName(request.getParameter("name"));
                a.setPrice(new BigDecimal(request.getParameter("price")));
                a.setImage(request.getParameter("image"));
                dao.addAccessory(a);
                request.getSession().setAttribute("successMsg", "Thêm phụ kiện thành công!");
            } else if ("delete".equals(action)) {
                dao.softDeleteAccessory(Integer.parseInt(request.getParameter("id")));
                request.getSession().setAttribute("successMsg", "Đã xóa phụ kiện!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/accessories");
    }
}