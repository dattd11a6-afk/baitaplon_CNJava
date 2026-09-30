package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.UserDAO;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/shipper-manage")
public class ShipperManageServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String statusFilter = request.getParameter("status");

        // 1. Lấy danh sách đơn hàng
        List<Order> orders = orderDAO.getOrdersByFilterForAdmin(statusFilter);

        // 2. Lấy danh sách Shipper để thả vào Modal phân công
        List<User> shippers = userDAO.getUsersByRole("SHIPPER");

        // 3. Tạo Map truy xuất tên Shipper
        Map<Integer, String> shipperMap = new HashMap<>();
        for (User s : shippers) {
            shipperMap.put(s.getId(), s.getFullName());
        }

        // ==========================================
        // TÍNH NĂNG MỚI: Kéo danh sách Chi tiết Sản phẩm
        // để hiển thị ở Bảng trượt Offcanvas không bị 0đ
        // ==========================================
        Map<Integer, List<OrderDetail>> detailsMap = new HashMap<>();
        for (Order o : orders) {
            detailsMap.put(o.getId(), orderDAO.getOrderDetailsByOrderId(o.getId()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("shippers", shippers);
        request.setAttribute("shipperMap", shipperMap);
        request.setAttribute("detailsMap", detailsMap); // Đẩy Map ra JSP
        request.setAttribute("currentStatus", statusFilter == null ? "ALL" : statusFilter);

        request.getRequestDispatcher("/view/admin/shipper-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int shipperId = Integer.parseInt(request.getParameter("shipperId"));

            boolean success = orderDAO.assignShipperToOrder(orderId, shipperId, admin.getId());

            if (success) {
                session.setAttribute("successMsg", "Đã phân công Đơn #" + orderId + " thành công!");
            } else {
                session.setAttribute("errorMsg", "Lỗi khi phân công đơn hàng!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu không hợp lệ.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/shipper-manage");
    }
}