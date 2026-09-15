package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.VoucherDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.model.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

// Thanh toán
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private VoucherDAO voucherDAO; // Thêm DAO Voucher

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để thanh toán.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.getRequestDispatcher("/view/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 1. Tính toán lại giá dựa trên Database
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : cart) {
            Product dbProduct = productDAO.getProductById(item.getProduct().getId());
            if (dbProduct == null || dbProduct.getStock() < item.getQuantity()) {
                session.setAttribute("errorMsg", "Sản phẩm " + item.getProduct().getName() + " không đủ số lượng trong kho.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            // Cập nhật giá mới nhất phòng trường hợp Admin đổi giá trong lúc khách đang mua
            item.setProduct(dbProduct);
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        // ==========================================
        // ÁP DỤNG TRỪ TIỀN VOUCHER TRƯỚC KHI LƯU (MỚI)
        // ==========================================
        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        Voucher appliedVoucher = (Voucher) session.getAttribute("appliedVoucher");

        if (discountAmount != null) {
            totalAmount = totalAmount.subtract(discountAmount);
            if (totalAmount.compareTo(BigDecimal.ZERO) < 0) totalAmount = BigDecimal.ZERO;
        }

        // 2. Tạo đối tượng Order
        Order order = new Order();
        order.setUserId(user.getId());
        order.setReceiverName(request.getParameter("receiverName"));
        order.setReceiverPhone(request.getParameter("receiverPhone"));
        order.setReceiverAddress(request.getParameter("receiverAddress"));
        order.setNote(request.getParameter("note"));
        order.setTotalAmount(totalAmount); // Đã trừ voucher

        String paymentMethod = request.getParameter("paymentMethod");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("PENDING");
        order.setOrderStatus("PENDING");

        // 3. Thực thi Transaction
        int orderId = orderDAO.createOrder(order, cart);

        if (orderId != -1) {
            order.setId(orderId);

            // Nếu có dùng Voucher, trừ đi 1 lượt sử dụng trong Database
            if (appliedVoucher != null) {
                voucherDAO.decreaseVoucherUsage(appliedVoucher.getId());
            }

            // Dọn dẹp sạch sẽ
            session.removeAttribute("cart");
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");

            session.setAttribute("lastOrder", order);
            response.sendRedirect(request.getContextPath() + "/order-success");
        } else {
            session.setAttribute("errorMsg", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}