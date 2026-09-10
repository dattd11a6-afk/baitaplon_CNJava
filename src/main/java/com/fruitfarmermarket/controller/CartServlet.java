package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.OrderDetail;

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

    @Override
    public void init() {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
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

        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/view/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        try {
            // LUỒNG 1: KHÁCH HÀNG BẤM "MUA LẠI" TỪ TRANG LỊCH SỬ ĐƠN HÀNG
            if ("repurchase".equals(action)) {
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

            // LUỒNG 2: CÁC ACTION CŨ (THÊM, SỬA, XÓA) - BẮT BUỘC CÓ ID
            if ("clear".equals(action)) {
                cart.clear();
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
                        cart.removeIf(item -> item.getProduct().getId() == productId);
                        session.setAttribute("successMsg", "Đã xóa sản phẩm khỏi giỏ hàng.");
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại!");
        }

        session.setAttribute("cart", cart);

        // Chuyển hướng
        if ("add".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/product?id=" + request.getParameter("id"));
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    // --- CÁC HÀM XỬ LÝ LOGIC (Giữ nguyên của pác) ---
    private void addToCart(List<CartItem> cart, int productId, int quantityToAdd, HttpServletRequest request) {
        Product product = productDAO.getProductById(productId);
        if (product == null || product.getStock() <= 0) return;

        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
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
            cart.removeIf(item -> item.getProduct().getId() == productId);
            return;
        }

        if (newQuantity > product.getStock()) {
            request.getSession().setAttribute("errorMsg", "Chỉ còn " + product.getStock() + " sản phẩm trong kho.");
            return;
        }

        for (CartItem item : cart) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(newQuantity);
                break;
            }
        }
    }
}