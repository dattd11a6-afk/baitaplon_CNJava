package com.fruitfarmermarket.controller.staff;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/staff/pos")
public class StaffPOSServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> products = productDAO.getProducts(keyword, null, null, null, "newest", 1, 50);

        HttpSession session = request.getSession();
        List<CartItem> posCart = (List<CartItem>) session.getAttribute("posCart");

        BigDecimal subTotalAmount = BigDecimal.ZERO;
        if (posCart != null) {
            for (CartItem item : posCart) subTotalAmount = subTotalAmount.add(item.getSubtotal());
        }

        List<Voucher> availableVouchers = voucherDAO.getAllVouchers();

        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("keyword", keyword);
        request.setAttribute("products", products);
        request.setAttribute("subTotalAmount", subTotalAmount);

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
                // FIX LỖI 3: Xác định bước nhảy thập phân theo đơn vị
                double step = (product.getUnit() != null && product.getUnit().toLowerCase().contains("kg")) ? 0.5 : 1.0;

                boolean exists = false;
                for (CartItem item : posCart) {
                    if (item.getProduct().getId() == productId) {
                        if (item.getQuantity() + step <= product.getStock()) {
                            item.setQuantity(item.getQuantity() + step);
                        }
                        exists = true; break;
                    }
                }
                if (!exists) posCart.add(new CartItem(product, step));
            }
            session.removeAttribute("posAppliedVoucher");
            session.removeAttribute("posDiscountAmount");

        } else if ("decrease".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            for (int i = 0; i < posCart.size(); i++) {
                CartItem item = posCart.get(i);
                if (item.getProduct().getId() == productId) {
                    // FIX LỖI 3: Giảm theo bước nhảy
                    double step = (item.getProduct().getUnit() != null && item.getProduct().getUnit().toLowerCase().contains("kg")) ? 0.5 : 1.0;

                    if (item.getQuantity() > step) {
                        item.setQuantity(item.getQuantity() - step);
                    } else {
                        posCart.remove(i);
                    }
                    break;
                }
            }
            session.removeAttribute("posAppliedVoucher");
            session.removeAttribute("posDiscountAmount");

        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            posCart.removeIf(item -> item.getProduct().getId() == productId);
            session.removeAttribute("posAppliedVoucher");
            session.removeAttribute("posDiscountAmount");

        } else if ("clear".equals(action)) {
            posCart.clear();
            session.removeAttribute("posAppliedVoucher");
            session.removeAttribute("posDiscountAmount");

        } else if ("apply_voucher".equals(action)) {
            String code = request.getParameter("voucherCode");
            BigDecimal subTotal = BigDecimal.ZERO;
            for (CartItem item : posCart) subTotal = subTotal.add(item.getSubtotal());

            if (code == null || code.trim().isEmpty()) {
                session.removeAttribute("posAppliedVoucher");
                session.removeAttribute("posDiscountAmount");
            } else {
                Voucher v = voucherDAO.getVoucherByCode(code.trim().toUpperCase());
                if (v != null && "ACTIVE".equals(v.getStatus()) && v.getUsageLimit() > 0 && !v.getExpiryDate().before(new java.util.Date()) && subTotal.compareTo(v.getMinOrderAmount()) >= 0) {
                    BigDecimal discount = BigDecimal.ZERO;
                    if ("PERCENT".equals(v.getType())) {
                        discount = subTotal.multiply(v.getDiscountValue().divide(new BigDecimal(100)));
                        if (v.getMaxDiscountAmount() != null && discount.compareTo(v.getMaxDiscountAmount()) > 0) {
                            discount = v.getMaxDiscountAmount();
                        }
                    } else {
                        discount = v.getDiscountValue();
                    }
                    if (discount.compareTo(subTotal) > 0) discount = subTotal;

                    session.setAttribute("posAppliedVoucher", v);
                    session.setAttribute("posDiscountAmount", discount);
                }
            }
        } else if ("checkout".equals(action)) {
            if (!posCart.isEmpty()) {
                User staff = (User) session.getAttribute("user");
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (CartItem item : posCart) totalAmount = totalAmount.add(item.getSubtotal());

                BigDecimal discount = (BigDecimal) session.getAttribute("posDiscountAmount");
                Voucher appliedVoucher = (Voucher) session.getAttribute("posAppliedVoucher");
                if (discount != null) {
                    totalAmount = totalAmount.subtract(discount);
                    if (totalAmount.compareTo(BigDecimal.ZERO) < 0) totalAmount = BigDecimal.ZERO;
                }

                Order order = new Order();
                order.setReceiverName(request.getParameter("customerName"));
                order.setReceiverPhone(request.getParameter("customerPhone"));
                order.setPaymentMethod(request.getParameter("paymentMethod"));
                order.setTotalAmount(totalAmount);

                String note = "Nhân viên " + staff.getFullName() + " tạo đơn.";
                if (appliedVoucher != null) note += " (Áp dụng mã: " + appliedVoucher.getCode() + ")";
                order.setNote(note);

                int orderId = orderDAO.createStoreOrder(order, posCart, staff.getId());

                if (orderId > 0) {
                    if (appliedVoucher != null) voucherDAO.decreaseVoucherUsage(appliedVoucher.getId());

                    session.removeAttribute("posCart");
                    session.removeAttribute("posAppliedVoucher");
                    session.removeAttribute("posDiscountAmount");
                    response.sendRedirect(request.getContextPath() + "/staff/invoice?id=" + orderId);
                    return;
                }
            }
        }

        session.setAttribute("posCart", posCart);
        response.sendRedirect(request.getContextPath() + "/staff/pos");
    }
}