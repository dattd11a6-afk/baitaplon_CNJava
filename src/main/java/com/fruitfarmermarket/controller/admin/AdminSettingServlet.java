package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.SettingDAO;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/settings")
public class AdminSettingServlet extends HttpServlet {
    private SettingDAO settingDAO = new SettingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đẩy toàn bộ cấu hình từ DB ra giao diện
        Map<String, String> settings = settingDAO.getAllSettings();
        request.setAttribute("settings", settings);
        request.getRequestDispatcher("/view/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Lấy dữ liệu từ Form
            String taxRate = request.getParameter("TAX_RATE");
            String shipStandard = request.getParameter("SHIP_STANDARD");
            String shipExpress = request.getParameter("SHIP_EXPRESS");

            // Lưu xuống Database
            settingDAO.updateSetting("TAX_RATE", taxRate);
            settingDAO.updateSetting("SHIP_STANDARD", shipStandard);
            settingDAO.updateSetting("SHIP_EXPRESS", shipExpress);

            session.setAttribute("successMsg", "Đã lưu Cấu hình hệ thống thành công!");
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Có lỗi xảy ra khi lưu cấu hình.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
}