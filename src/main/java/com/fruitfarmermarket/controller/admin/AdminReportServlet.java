package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // XỬ LÝ NÚT XUẤT EXCEL (Tạo file CSV chuẩn UTF-8 để Excel đọc tiếng Việt)
        if ("exportExcel".equals(action)) {
            exportToCSV(response);
            return; // Xong là ngắt luồng, không chạy tiếp xuống JSP
        }

        // LẤY DỮ LIỆU THẬT 100% TỪ DATABASE LÊN GIAO DIỆN
        BigDecimal totalRevenue = reportDAO.getTotalRevenue();
        int totalOrders = reportDAO.getTotalOrders();
        Map<String, BigDecimal> rev7Days = reportDAO.getRevenueLast7Days();
        Map<String, Integer> statusDist = reportDAO.getOrderStatusDistribution();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("rev7Days", rev7Days);
        request.setAttribute("statusDist", statusDist);

        request.getRequestDispatcher("/view/admin/reports.jsp").forward(request, response);
    }

    private void exportToCSV(HttpServletResponse response) throws IOException {
        // Cấu hình Header để trình duyệt ép tải file về
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"BaoCao_KinhDoanh_FruitFarmer.csv\"");

        try (OutputStream os = response.getOutputStream()) {
            // Ghi cờ BOM (Byte Order Mark) để Excel nhận dạng đúng tiếng Việt có dấu
            os.write(239);
            os.write(187);
            os.write(191);

            PrintWriter writer = new PrintWriter(os, true, StandardCharsets.UTF_8);

            // Bảng 1: Doanh thu 7 ngày
            writer.println("THỐNG KÊ DOANH THU 7 NGÀY GẦN NHẤT");
            writer.println("Ngày,Doanh thu (VNĐ)");
            Map<String, BigDecimal> data = reportDAO.getRevenueLast7Days();
            for (Map.Entry<String, BigDecimal> entry : data.entrySet()) {
                writer.println(entry.getKey() + "," + entry.getValue());
            }

            // Khoảng trắng
            writer.println("");
            writer.println("");

            // Bảng 2: Trạng thái đơn hàng
            writer.println("TỶ LỆ TRẠNG THÁI ĐƠN HÀNG");
            writer.println("Trạng thái,Số lượng đơn");
            Map<String, Integer> statusData = reportDAO.getOrderStatusDistribution();
            for (Map.Entry<String, Integer> entry : statusData.entrySet()) {
                writer.println(entry.getKey() + "," + entry.getValue());
            }

            writer.flush();
        }
    }
}