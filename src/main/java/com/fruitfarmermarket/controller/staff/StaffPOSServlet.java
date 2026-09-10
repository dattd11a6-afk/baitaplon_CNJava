package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.Order;
import com.fruitfarmermarket.model.Product;
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

@WebServlet("/staff/pos")
public class StaffPOSServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> products = productDAO.getProducts(keyword, null, null, null, "newest", 1, 50);

        HttpSession session = request.getSession();
        List<CartItem> posCart = (List<CartItem>) session.getAttribute("posCart");
        BigDecimal totalAmount = BigDecimal.ZERO;
        if (posCart != null) {
            for (CartItem item : posCart) totalAmount = totalAmount.add(item.getSubtotal());
        }

        request.setAttribute("keyword", keyword);
        request.setAttribute("products", products);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/view/staff/pos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        List<CartItem> posCart = (List<CartItem>) session.getAttribute("posCart");
        if (posCart == null) posCart = new ArrayList<>();

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product product = productDAO.getProductById(productId);
            if (product != null && product.getStock() > 0) {
                boolean exists = false;
                for (CartItem item : posCart) {
                    if (item.getProduct().getId() == productId) {
                        if (item.getQuantity() < product.getStock()) item.setQuantity(item.getQuantity() + 1);
                        exists = true; break;
                    }
                }
                if (!exists) posCart.add(new CartItem(product, 1));
            }
        } else if ("decrease".equals(action)) { // TÍNH NĂNG MỚI: GIẢM SỐ LƯỢNG
            int productId = Integer.parseInt(request.getParameter("productId"));
            for (int i = 0; i < posCart.size(); i++) {
                CartItem item = posCart.get(i);
                if (item.getProduct().getId() == productId) {
                    if (item.getQuantity() > 1) {
                        item.setQuantity(item.getQuantity() - 1);
                    } else {
                        posCart.remove(i); // Giảm về 0 thì tự xóa khỏi giỏ
                    }
                    break;
                }
            }
        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            posCart.removeIf(item -> item.getProduct().getId() == productId);
        } else if ("clear".equals(action)) {
            posCart.clear();
        } else if ("checkout".equals(action)) {
            if (!posCart.isEmpty()) {
                User staff = (User) session.getAttribute("user");
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (CartItem item : posCart) totalAmount = totalAmount.add(item.getSubtotal());

                Order order = new Order();
                order.setReceiverName(request.getParameter("customerName"));
                order.setReceiverPhone(request.getParameter("customerPhone"));
                order.setPaymentMethod(request.getParameter("paymentMethod"));
                order.setTotalAmount(totalAmount);
                order.setNote("Nhân viên " + staff.getFullName() + " tạo đơn.");

                int orderId = orderDAO.createStoreOrder(order, posCart, staff.getId());

                if (orderId > 0) {
                    session.removeAttribute("posCart");
                    response.sendRedirect(request.getContextPath() + "/staff/invoice?id=" + orderId);
                    return;
                }
            }
        }

        session.setAttribute("posCart", posCart);
        response.sendRedirect(request.getContextPath() + "/staff/pos");
    }
}