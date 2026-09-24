package com.fruitfarmermarket.api;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// Mapping đúng với action form trong file shipper-dashboard.jsp
@WebServlet("/shipper/update")
public class ShippingApiServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User shipper = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Kiểm tra đăng nhập (Bảo mật)
        if (shipper == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2. Lấy dữ liệu từ form của Shipper
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status"); // Sẽ là "COMPLETED" hoặc "CANCELLED"

            // Lấy đơn hàng hiện tại để lấy trạng thái cũ
            Order currentOrder = orderDAO.getOrderById(orderId);

            if (currentOrder != null) {
                boolean success = false;

                // 3. Xử lý logic cập nhật
                if ("CANCELLED".equals(newStatus)) {
                    // Nếu Shipper báo khách boom hàng -> Hủy đơn và gọi hàm hoàn trả số lượng vào kho
                    success = orderDAO.cancelOrderWithStockRestore(
                            orderId,
                            shipper.getId(),
                            "Giao hàng thất bại (Shipper báo cáo)",
                            orderDAO.getOrderDetailsByOrderId(orderId)
                    );
                } else if ("COMPLETED".equals(newStatus)) {
                    // Nếu giao thành công -> Chuyển trạng thái và ghi log lịch sử
                    success = orderDAO.updateOrderStatusWithHistory(
                            orderId,
                            currentOrder.getOrderStatus(),
                            "COMPLETED",
                            shipper.getId(),
                            "Shipper đã giao thành công và thu tiền"
                    );
                }

                // 4. Thông báo kết quả
                if (success) {
                    session.setAttribute("successMsg", "Đã cập nhật trạng thái đơn hàng #" + orderId);
                } else {
                    session.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu đầu vào không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/view/shipper/shipper-dashboard.jsp");
    }
}