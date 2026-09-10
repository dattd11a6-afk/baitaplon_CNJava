package com.fruitfarmermarket.controller.admin;

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
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private ReportDAO reportDAO = new ReportDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. TIME RANGE & CONTEXT
        String period = request.getParameter("period");
        if (period == null || period.trim().isEmpty()) period = "this_month";

        DateRange range = DateHelper.getDateRange(period);
        request.setAttribute("period", period);
        request.setAttribute("range", range);

        // Format dải ngày tháng cho Context Bar
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        request.setAttribute("currentRangeText", range.getCurrentStart().format(formatter) + " – " + range.getCurrentEnd().format(formatter));
        request.setAttribute("previousRangeText", range.getPreviousStart().format(formatter) + " – " + range.getPreviousEnd().format(formatter));

        // 2. DASHBOARD SUMMARY DTO
        DashboardSummaryDTO summary = reportDAO.getDashboardSummary(range);
        request.setAttribute("summary", summary);

        int days = (int) ChronoUnit.DAYS.between(range.getCurrentStart(), range.getCurrentEnd());
        if (days <= 0) days = 1;
        request.setAttribute("selectedDays", days);

        request.setAttribute("comboChartData", reportDAO.getComboChartData(days));
        request.setAttribute("topProducts", reportDAO.getTopSellingProducts(5));

        // 3. CHANNEL PERFORMANCE (Nâng cấp)
        BigDecimal webRev = BigDecimal.ZERO, storeRev = BigDecimal.ZERO;
        int webOrders = 0, storeOrders = 0;

        String sqlChannel = "SELECT order_source, SUM(total_amount) as rev, COUNT(id) as cnt FROM orders WHERE order_status = 'COMPLETED' AND DATE(created_at) BETWEEN ? AND ? GROUP BY order_source";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlChannel)) {
            ps.setDate(1, java.sql.Date.valueOf(range.getCurrentStart()));
            ps.setDate(2, java.sql.Date.valueOf(range.getCurrentEnd()));

            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    if("WEBSITE".equals(rs.getString("order_source"))) { webRev = rs.getBigDecimal("rev"); webOrders = rs.getInt("cnt"); }
                    else if("STORE".equals(rs.getString("order_source"))) { storeRev = rs.getBigDecimal("rev"); storeOrders = rs.getInt("cnt"); }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        BigDecimal totalRev = summary.getCurrentRevenue();
        double webPct = totalRev.compareTo(BigDecimal.ZERO) > 0 ? webRev.doubleValue() / totalRev.doubleValue() * 100 : 0;
        double storePct = totalRev.compareTo(BigDecimal.ZERO) > 0 ? storeRev.doubleValue() / totalRev.doubleValue() * 100 : 0;

        request.setAttribute("webRev", webRev); request.setAttribute("webOrders", webOrders); request.setAttribute("webPct", webPct);
        request.setAttribute("webAov", webOrders > 0 ? webRev.divide(new BigDecimal(webOrders), 0, RoundingMode.HALF_UP) : 0);
        request.setAttribute("storeRev", storeRev); request.setAttribute("storeOrders", storeOrders); request.setAttribute("storePct", storePct);
        request.setAttribute("storeAov", storeOrders > 0 ? storeRev.divide(new BigDecimal(storeOrders), 0, RoundingMode.HALF_UP) : 0);

        // 4. ACTION CENTER & ALERTS
        request.setAttribute("lowStockProducts", productDAO.getLowStockProducts(10, 5));
        request.setAttribute("pendingOrdersCount", reportDAO.getOrderCountByStatus("PENDING"));

        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}