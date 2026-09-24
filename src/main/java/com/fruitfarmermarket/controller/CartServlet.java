package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.VoucherDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.GiftBasketCartItem; // Kéo model giỏ quà vào
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.OrderDetail;
import com.fruitfarmermarket.model.Voucher;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        BigDecimal cartTotal = BigDecimal.ZERO;
        if (cart != null) {
            for (CartItem item : cart) {
                cartTotal = cartTotal.add(item.getSubtotal());
            }
        }

        List<Voucher> availableVouchers = voucherDAO.getAllVouchers();
        request.setAttribute("availableVouchers", availableVouchers);

        session.setAttribute("cartSubtotal", cartTotal);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/view/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        try {
            if ("apply_voucher".equals(action)) {
                // (Giữ nguyên logic Voucher)
                if (user == null) {
                    session.setAttribute("errorMsg", "Khách hàng đăng nhập hoặc liên kết Google để nhận ưu đãi từ Voucher này nhé!");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                String code = request.getParameter("voucherCode").trim().toUpperCase();
                BigDecimal cartSubtotal = (BigDecimal) session.getAttribute("cartSubtotal");
                if (cartSubtotal == null) cartSubtotal = BigDecimal.ZERO;

                Voucher voucher = voucherDAO.getVoucherByCode(code);

                if (voucher == null || !"ACTIVE".equals(voucher.getStatus())) {
                    session.setAttribute("errorMsg", "Mã khuyến mãi không tồn tại hoặc đã bị khóa!");
                } else if (voucher.getUsageLimit() <= 0) {
                    session.setAttribute("errorMsg", "Mã khuyến mãi đã hết lượt sử dụng!");
                } else if (voucher.getExpiryDate().before(new java.util.Date())) {
                    session.setAttribute("errorMsg", "Mã khuyến mãi đã hết hạn!");
                } else if (cartSubtotal.compareTo(voucher.getMinOrderAmount()) < 0) {
                    session.setAttribute("errorMsg", "Đơn hàng chưa đạt giá trị tối thiểu để dùng mã này!");
                } else {
                    BigDecimal discount = BigDecimal.ZERO;
                    if ("PERCENT".equals(voucher.getType())) {
                        discount = cartSubtotal.multiply(voucher.getDiscountValue().divide(new BigDecimal(100)));
                        if (voucher.getMaxDiscountAmount() != null && discount.compareTo(voucher.getMaxDiscountAmount()) > 0) {
                            discount = voucher.getMaxDiscountAmount();
                        }
                    } else {
                        discount = voucher.getDiscountValue();
                    }
                    if (discount.compareTo(cartSubtotal) > 0) discount = cartSubtotal;

                    session.setAttribute("appliedVoucher", voucher);
                    session.setAttribute("discountAmount", discount);
                    session.setAttribute("successMsg", "Áp dụng mã giảm giá thành công!");
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            else if ("remove_voucher".equals(action)) {
                session.removeAttribute("appliedVoucher");
                session.removeAttribute("discountAmount");
                session.setAttribute("successMsg", "Đã gỡ mã giảm giá!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("repurchase".equals(action)) {
                if (user == null) {
                    session.setAttribute("errorMsg", "Vui lòng đăng nhập để sử dụng tính năng mua lại!");
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                List<OrderDetail> oldOrderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
                for (OrderDetail od : oldOrderDetails) {
                    addToCart(cart, od.getProductId(), od.getQuantity(), request);
                }
                session.setAttribute("cart", cart);
                session.setAttribute("successMsg", "Đã thêm các sản phẩm từ đơn cũ vào Giỏ hàng!");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("clear".equals(action)) {
                cart.clear();
            } else if ("remove_basket".equals(action)) {

                // FIX LOGIC XÓA GIỎ QUÀ SẠCH SẼ VỚI INSTANCEOF
                String basketSessionId = request.getParameter("basketSessionId");
                cart.removeIf(item -> item instanceof GiftBasketCartItem && basketSessionId.equals(((GiftBasketCartItem) item).getBasketSessionId()));
                session.setAttribute("successMsg", "Đã hủy Giỏ quà tùy chỉnh.");

            } else {
                int productId = Integer.parseInt(request.getParameter("id"));
                switch (action) {
                    case "add":
                        int quantityToAdd = Integer.parseInt(request.getParameter("quantity"));
                        addToCart(cart, productId, quantityToAdd, request);
                        break;
                    case "update":
                        int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                        updateCart(cart, productId, newQuantity, request);
                        break;
                    case "remove":
                        cart.removeIf(item -> item.getProduct() != null && item.getProduct().getId() == productId);
                        session.setAttribute("successMsg", "Đã xóa sản phẩm khỏi giỏ hàng.");
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        session.setAttribute("cart", cart);

        if ("add".equals(action)) {
            String referer = request.getHeader("referer");
            if (referer != null && !referer.isEmpty()) response.sendRedirect(referer);
            else response.sendRedirect(request.getContextPath() + "/products");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void addToCart(List<CartItem> cart, int productId, int quantityToAdd, HttpServletRequest request) {
        Product product = productDAO.getProductById(productId);
        if (product == null || product.getStock() <= 0) return;

        for (CartItem item : cart) {
            if (item.getProduct() != null && item.getProduct().getId() == productId) {
                int newQty = item.getQuantity() + quantityToAdd;
                if (newQty > product.getStock()) {
                    request.getSession().setAttribute("errorMsg", "Không đủ số lượng tồn kho!");
                    return;
                }
                item.setQuantity(newQty);
                request.getSession().setAttribute("successMsg", "Đã cập nhật số lượng trong giỏ.");
                return;
            }
        }

        if (quantityToAdd <= product.getStock()) {
            cart.add(new CartItem(product, quantityToAdd));
            request.getSession().setAttribute("successMsg", "Đã thêm " + product.getName() + " vào giỏ hàng.");
        }
    }

    private void updateCart(List<CartItem> cart, int productId, int newQuantity, HttpServletRequest request) {
        Product product = productDAO.getProductById(productId);
        if (product == null) return;

        if (newQuantity <= 0) {
            cart.removeIf(item -> item.getProduct() != null && item.getProduct().getId() == productId);
            return;
        }

        if (newQuantity > product.getStock()) {
            request.getSession().setAttribute("errorMsg", "Chỉ còn " + product.getStock() + " sản phẩm trong kho.");
            return;
        }

        for (CartItem item : cart) {
            if (item.getProduct() != null && item.getProduct().getId() == productId) {
                item.setQuantity(newQuantity);
                break;
            }
        }
    }
}