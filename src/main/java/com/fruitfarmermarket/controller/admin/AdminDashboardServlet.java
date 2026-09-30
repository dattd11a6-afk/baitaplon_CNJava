package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.DashboardDAO;
import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.ReportDAO;
import com.fruitfarmermarket.model.DashboardSummaryDTO;
import com.fruitfarmermarket.utils.DBConnection;
import com.fruitfarmermarket.utils.DateHelper;
import com.fruitfarmermarket.utils.DateRange;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();
    private DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String period = request.getParameter("period");
        if (period == null || period.trim().isEmpty()) period = "this_month";

        DateRange range;
        String compareText = "kỳ trước";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        if ("custom".equals(period)) {
            String dates = request.getParameter("custom_dates");
            if (dates != null && dates.contains(" to ")) {
                String[] parts = dates.split(" to ");
                LocalDate start = LocalDate.parse(parts[0], formatter);
                LocalDate end = LocalDate.parse(parts[1], formatter);
                long days = ChronoUnit.DAYS.between(start, end) + 1;
                range = new DateRange(start, end, start.minusDays(days), end.minusDays(days));
                compareText = days + " ngày trước đó";
            } else {
                range = DateHelper.getDateRange("this_month");
            }
        } else {
            range = DateHelper.getDateRange(period);
            switch (period) {
                case "today": compareText = "hôm qua"; break;
                case "this_week": compareText = "tuần trước"; break;
                case "this_month": compareText = "tháng trước"; break;
                case "this_quarter": compareText = "quý trước"; break;
                case "this_year": compareText = "năm ngoái"; break;
            }
        }

        request.setAttribute("period", period);
        request.setAttribute("compareText", compareText);
        request.setAttribute("currentRangeText", range.getCurrentStart().format(formatter) + " – " + range.getCurrentEnd().format(formatter));

        try {
            DashboardSummaryDTO summary = reportDAO.getDashboardSummary(range);
            if (summary == null) summary = new DashboardSummaryDTO();
            request.setAttribute("summary", summary);

            // Gán data an toàn
            request.setAttribute("trendData", dashboardDAO.getTrendData(range.getCurrentStart(), range.getCurrentEnd()));
            request.setAttribute("topProductsBar", dashboardDAO.getTopProductsBarChart(range.getCurrentStart(), range.getCurrentEnd()));

            // TÍNH TOÁN DOANH THU THEO KÊNH BÁN HÀNG (Sửa ở đây theo yêu cầu)
            double websiteRev = 0, storeRev = 0;
            String sqlSource = "SELECT order_source, SUM(total_amount) as rev FROM orders WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN ? AND ? GROUP BY order_source";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlSource)) {
                ps.setDate(1, java.sql.Date.valueOf(range.getCurrentStart()));
                ps.setDate(2, java.sql.Date.valueOf(range.getCurrentEnd()));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String source = rs.getString("order_source");
                        if ("WEBSITE".equalsIgnoreCase(source)) {
                            websiteRev = rs.getDouble("rev");
                        } else if ("STORE".equalsIgnoreCase(source)) {
                            storeRev = rs.getDouble("rev");
                        }
                    }
                }
            } catch (SQLException e) { e.printStackTrace(); }

            double totalSourceRev = websiteRev + storeRev;
            if (totalSourceRev > 0) {
                request.setAttribute("websitePercent", Math.round((websiteRev / totalSourceRev) * 100));
                request.setAttribute("storePercent", Math.round((storeRev / totalSourceRev) * 100));
            } else {
                request.setAttribute("websitePercent", 0);
                request.setAttribute("storePercent", 0);
            }
            request.setAttribute("websiteRev", websiteRev);
            request.setAttribute("storeRev", storeRev);

            // TÍNH TOÁN TRẠNG THÁI ĐƠN HÀNG ĐỂ VẼ BIỂU ĐỒ VÒNG (MỚI)
            int pending = 0, confirmed = 0, preparing = 0, shipping = 0, completed = 0, cancelled = 0;
            String sqlStatus = "SELECT order_status, COUNT(id) as cnt FROM orders WHERE DATE(created_at) BETWEEN ? AND ? GROUP BY order_status";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlStatus)) {
                ps.setDate(1, java.sql.Date.valueOf(range.getCurrentStart()));
                ps.setDate(2, java.sql.Date.valueOf(range.getCurrentEnd()));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String st = rs.getString("order_status");
                        int c = rs.getInt("cnt");
                        if ("PENDING".equals(st)) pending = c;
                        else if ("CONFIRMED".equals(st)) confirmed = c;
                        else if ("PREPARING".equals(st)) preparing = c;
                        else if ("SHIPPING".equals(st)) shipping = c;
                        else if ("COMPLETED".equals(st)) completed = c;
                        else if ("CANCELLED".equals(st)) cancelled = c;
                    }
                }
            } catch (SQLException e) { e.printStackTrace(); }

            request.setAttribute("stPending", pending);
            request.setAttribute("stConfirmed", confirmed);
            request.setAttribute("stPreparing", preparing);
            request.setAttribute("stShipping", shipping);
            request.setAttribute("stCompleted", completed);
            request.setAttribute("stCancelled", cancelled);

            // Bổ sung dữ liệu
            request.setAttribute("recentOrders", orderDAO.getRecentOrders(5));
            request.setAttribute("lowStockProducts", productDAO.getLowStockProducts(10, 5));

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("summary", new DashboardSummaryDTO());
            request.setAttribute("trendData", new HashMap<>());
            request.setAttribute("topProductsBar", new ArrayList<>());
            request.setAttribute("recentOrders", new ArrayList<>());
            request.setAttribute("lowStockProducts", new ArrayList<>());
        }

        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}