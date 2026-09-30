package com.fruitfarmermarket.controller.shipper;

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
import java.util.List;

@WebServlet("/shipper/home")
public class ShipperHomeServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Đếm KPI
        List<Order> orders = orderDAO.getOrdersByShipper(user.getId());
        int countPreparing = 0, countShipping = 0, countCompleted = 0, countFailed = 0;

        Order pendingOrder = null; // Đơn đang chờ Shipper ấn Chấp nhận (PREPARING)
        Order shippingOrder = null; // Đơn đang đi giao (SHIPPING)

        for (Order o : orders) {
            switch (o.getOrderStatus()) {
                case "PREPARING":
                    countPreparing++;
                    // Lấy ra đơn PREPARING đầu tiên để bật Modal bắt tài xế xác nhận
                    if(pendingOrder == null) {
                        pendingOrder = o;
                    }
                    break;
                case "SHIPPING":
                    countShipping++;
                    if(shippingOrder == null) shippingOrder = o; // Đơn đang hiển thị ưu tiên ngoài Home
                    break;
                case "COMPLETED":
                    countCompleted++;
                    break;
                case "CANCELLED":
                    countFailed++;
                    break;
            }
        }

        request.setAttribute("countPreparing", countPreparing);
        request.setAttribute("countShipping", countShipping);
        request.setAttribute("countCompleted", countCompleted);
        request.setAttribute("countFailed", countFailed);
        request.setAttribute("myOrders", orders); // Đẩy danh sách đơn hàng ra Dashboard

        request.setAttribute("currentDelivery", shippingOrder);

        // NẾU CÓ ĐƠN ĐANG CHỜ NHẬN (PREPARING) -> GỬI RA KÈM CHI TIẾT SẢN PHẨM ĐỂ BẬT MODAL HỎI YES/NO
        if (pendingOrder != null) {
            List<OrderDetail> pendingDetails = orderDAO.getOrderDetails(pendingOrder.getId());
            request.setAttribute("pendingOrder", pendingOrder);
            request.setAttribute("pendingDetails", pendingDetails);
        }

        request.getRequestDispatcher("/view/shipper/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try {
            if ("ACCEPT".equals(action)) {
                // Đổi trạng thái từ PREPARING -> SHIPPING (Shipper đã ôm đơn)
                if (orderDAO.updateOrderStatus(orderId, "SHIPPING", shipper.getId(), "Tài xế đã tiếp nhận đơn hàng.")) {
                    session.setAttribute("successMsg", "Nhận đơn thành công! Hãy lấy hàng và đi giao nhé.");
                }
            } else if ("REJECT".equals(action)) {
                // Nhả lại đơn cho Admin ( shipper_id = null, status = CONFIRMED )
                if (orderDAO.rejectOrderByShipper(orderId, shipper.getId())) {
                    session.setAttribute("errorMsg", "Đã từ chối đơn hàng thành công.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/shipper/home");
    }
}