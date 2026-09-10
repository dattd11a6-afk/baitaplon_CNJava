package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.ReportDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    private ReportDAO reportDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User staff = (User) request.getSession().getAttribute("user");

        // 1. Thống kê nhanh các đơn CẦN XỬ LÝ NGAY
        int pendingOrders = reportDAO.getOrderCountByStatus("PENDING");
        int preparingOrders = reportDAO.getOrderCountByStatus("PREPARING");
        int shippingOrders = reportDAO.getOrderCountByStatus("SHIPPING");
        int completedToday = reportDAO.getOrderCountByStatus("COMPLETED"); // Giả lập đếm, sau này có thể tách query theo ngày

        // 2. Lấy 5 đơn mới nhất đang chờ xác nhận (Để Staff click xử lý ngay)
        // (Sử dụng lại getRecentOrders, sau này sẽ viết riêng getPendingOrders)
        List<Order> recentOrders = orderDAO.getRecentOrders(5);

        // 3. Lấy cảnh báo tồn kho (Cần báo để nhắc Admin nhập hàng)
        List<Product> lowStockProducts = productDAO.getLowStockProducts(5, 5); // Tồn <= 5 là mức báo động cho Staff

        // Gửi data sang View
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("preparingOrders", preparingOrders);
        request.setAttribute("shippingOrders", shippingOrders);
        request.setAttribute("completedToday", completedToday);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("lowStockProducts", lowStockProducts);

        request.getRequestDispatcher("/view/staff/dashboard.jsp").forward(request, response);
    }
}