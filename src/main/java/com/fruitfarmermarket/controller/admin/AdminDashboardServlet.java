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
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

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

        // XỬ LÝ LỊCH CUSTOM (GG CALENDAR STYLE)
        if ("custom".equals(period)) {
            String dates = request.getParameter("custom_dates"); // Format: dd/MM/yyyy to dd/MM/yyyy
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

        // CÁC HÀM XỬ LÝ DATA
        DashboardSummaryDTO summary = reportDAO.getDashboardSummary(range);
        request.setAttribute("summary", summary);

        // Data mới cho 2 biểu đồ tách biệt và Top 5 ngang
        request.setAttribute("trendData", dashboardDAO.getTrendData(range.getCurrentStart(), range.getCurrentEnd()));
        request.setAttribute("topProductsBar", dashboardDAO.getTopProductsBarChart(range.getCurrentStart(), range.getCurrentEnd()));

        // Channel Data (Giữ nguyên cấu trúc cũ)
        BigDecimal webRev = BigDecimal.ZERO, storeRev = BigDecimal.ZERO;
        int webOrders = 0, storeOrders = 0;
        String sqlChannel = "SELECT order_source, SUM(total_amount) as rev, COUNT(id) as cnt FROM orders WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN ? AND ? GROUP BY order_source";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlChannel)) {
            ps.setDate(1, java.sql.Date.valueOf(range.getCurrentStart())); ps.setDate(2, java.sql.Date.valueOf(range.getCurrentEnd()));
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    if("WEBSITE".equals(rs.getString("order_source"))) { webRev = rs.getBigDecimal("rev"); webOrders = rs.getInt("cnt"); }
                    else if("STORE".equals(rs.getString("order_source"))) { storeRev = rs.getBigDecimal("rev"); storeOrders = rs.getInt("cnt"); }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        BigDecimal totalRev = summary.getCurrentRevenue();
        request.setAttribute("webRev", webRev); request.setAttribute("storeRev", storeRev);
        request.setAttribute("webPct", totalRev.compareTo(BigDecimal.ZERO) > 0 ? webRev.doubleValue() / totalRev.doubleValue() * 100 : 0);
        request.setAttribute("storePct", totalRev.compareTo(BigDecimal.ZERO) > 0 ? storeRev.doubleValue() / totalRev.doubleValue() * 100 : 0);

        request.setAttribute("lowStockProducts", productDAO.getLowStockProducts(10, 5));
        request.setAttribute("pendingOrdersCount", reportDAO.getOrderCountByStatus("PENDING"));

        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}