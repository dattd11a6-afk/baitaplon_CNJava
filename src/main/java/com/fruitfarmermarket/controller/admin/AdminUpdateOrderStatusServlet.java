package com.fruitfarmermarket.controller.admin;

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

@WebServlet("/admin/order/update-status")
public class AdminUpdateOrderStatusServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User staff = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Bảo mật: Chỉ ADMIN hoặc STAFF mới được phép đổi trạng thái
        if (staff == null || (!"ADMIN".equals(staff.getRole()) && !"STAFF".equals(staff.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String action = request.getParameter("action"); // Sẽ là "CONFIRM" hoặc "CALL_SHIPPER"

            Order currentOrder = orderDAO.getOrderById(orderId);
            if (currentOrder == null) {
                session.setAttribute("errorMsg", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getHeader("referer"));
                return;
            }

            boolean success = false;

            // 2. Xử lý Logic theo 5 bước
            if ("CONFIRM".equals(action) && "PENDING".equals(currentOrder.getOrderStatus())) {
                // Bước 2: Staff bấm chốt đơn -> Chuyển sang Đang chuẩn bị hàng
                success = orderDAO.updateOrderStatusWithHistory(
                        orderId,
                        "PENDING",
                        "PROCESSING",
                        staff.getId(),
                        "Nhân viên đã xác nhận đơn, bắt đầu đóng gói"
                );
            }
            else if ("CALL_SHIPPER".equals(action) && "PROCESSING".equals(currentOrder.getOrderStatus())) {
                // Bước 3: Đóng gói xong, gọi Shipper -> Nổ đơn trên app Shipper
                success = orderDAO.updateOrderStatusWithHistory(
                        orderId,
                        "PROCESSING",
                        "READY",
                        staff.getId(),
                        "Đóng gói hoàn tất, đang chờ Shipper đến lấy hàng"
                );
            }

            if (success) {
                session.setAttribute("successMsg", "Đã cập nhật tiến độ đơn hàng #" + orderId);
            } else {
                session.setAttribute("errorMsg", "Cập nhật thất bại hoặc sai trạng thái!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi xử lý hệ thống!");
        }

        // F5 lại trang hiện tại (danh sách đơn hoặc chi tiết đơn của Staff)
        response.sendRedirect(request.getHeader("referer"));
    }
}