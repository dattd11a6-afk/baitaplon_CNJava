package com.fruitfarmermarket.controller.shipper;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/shipper/order-detail")
public class ShipperOrderDetailServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/shipper/orders");
            return;
        }

        int orderId = Integer.parseInt(idParam);

        // BẢO MẬT: Chỉ lấy đơn nếu shipper_id khớp với người đang đăng nhập
        Order order = orderDAO.getOrderByIdAndShipperId(orderId, shipper.getId());

        if (order == null) {
            session.setAttribute("errorMsg", "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập!");
            response.sendRedirect(request.getContextPath() + "/shipper/orders");
            return;
        }

        List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
        request.setAttribute("order", order);
        request.setAttribute("details", details);
        request.getRequestDispatcher("/view/shipper/order-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String action = request.getParameter("action");
        String currentStatus = request.getParameter("currentStatus");
        String reason = request.getParameter("reason"); // Dành cho trường hợp Giao thất bại

        boolean success = false;

        // Xử lý luồng trạng thái của Shipper
        if ("START_DELIVERY".equals(action) && "PREPARING".equals(currentStatus)) {
            success = orderDAO.updateOrderStatusByShipper(orderId, shipper.getId(), "PREPARING", "SHIPPING", "Shipper bắt đầu đi giao");
        }
        else if ("COMPLETE".equals(action) && "SHIPPING".equals(currentStatus)) {
            success = orderDAO.updateOrderStatusByShipper(orderId, shipper.getId(), "SHIPPING", "COMPLETED", "Giao hàng thành công");
        }
        else if ("FAIL".equals(action) && "SHIPPING".equals(currentStatus)) {
            if (reason == null || reason.trim().isEmpty()) reason = "Giao hàng thất bại";
            success = orderDAO.updateOrderStatusByShipper(orderId, shipper.getId(), "SHIPPING", "CANCELLED", "Lỗi giao hàng: " + reason);
        }

        if (success) {
            session.setAttribute("successMsg", "Đã cập nhật trạng thái đơn hàng!");
        } else {
            session.setAttribute("errorMsg", "Cập nhật thất bại. Vui lòng thử lại!");
        }

        response.sendRedirect(request.getContextPath() + "/shipper/order-detail?id=" + orderId);
    }
}