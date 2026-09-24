package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.GiftBasketCartItem;
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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        String checkoutType = request.getParameter("type");

        if (user == null && !"guest".equals(checkoutType)) {
            request.getRequestDispatcher("/view/user/checkout-options.jsp").forward(request, response);
            return;
        }

        request.setAttribute("isGuest", (user == null));
        request.getRequestDispatcher("/view/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        User user = (User) session.getAttribute("user");
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String receiverAddress = request.getParameter("fullAddress");
        String rawNote = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");
        boolean usePoints = Boolean.parseBoolean(request.getParameter("usePoints"));

        String deliveryTime = request.getParameter("deliveryTime");
        String shippingFeeStr = request.getParameter("shippingFee");
        BigDecimal shippingFee = (shippingFeeStr != null && !shippingFeeStr.isEmpty()) ? new BigDecimal(shippingFeeStr) : BigDecimal.ZERO;

        String finalNote = "";
        if (deliveryTime != null && !deliveryTime.isEmpty()) finalNote = "Giờ nhận: " + deliveryTime + " | ";
        if (rawNote != null && !rawNote.isEmpty()) finalNote += rawNote;

        Order order = new Order();
        order.setUserId(user != null ? user.getId() : 0);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setPaymentMethod(paymentMethod);

        // ==========================================
        // 1. LÀM PHẲNG GIỎ HÀNG & TÍNH TỒN KHO
        // ==========================================
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<CartItem> flatCartForDb = new ArrayList<>(); // Danh sách chỉ chứa Sản Phẩm Thực Tế để lưu Database
        StringBuilder bundleNotes = new StringBuilder(); // Trích xuất phụ kiện ghi vào Note

        for (CartItem item : cart) {
            // Xử lý nhánh Đa hình: Giỏ Quà Mix
            if (item instanceof GiftBasketCartItem) {
                GiftBasketCartItem giftBasket = (GiftBasketCartItem) item;

                // Quét từng trái cây thực tế bên trong giỏ xem kho còn đủ không
                for (CartItem fruitItem : giftBasket.getFruitItems()) {
                    Product dbProduct = productDAO.getProductById(fruitItem.getProduct().getId());
                    if (dbProduct == null || dbProduct.getStock() < fruitItem.getQuantity()) {
                        session.setAttribute("errorMsg", "Trái cây " + fruitItem.getProduct().getName() + " trong giỏ quà đã hết hàng.");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    fruitItem.setProduct(dbProduct); // Cập nhật giá mới nhất
                }

                // Cộng tổng bill (đã bao gồm vỏ, trang trí từ hàm Override)
                totalAmount = totalAmount.add(giftBasket.getSubtotal());

                // Chuyển toàn bộ trái cây thực tế sang danh sách DB để trừ kho và lưu OrderDetail
                flatCartForDb.addAll(giftBasket.getFruitItems());

                // Ghi chú phụ kiện vào đơn cho Nhân viên kho biết đường đóng gói
                bundleNotes.append("\n[GIỎ MIX YÊU CẦU: Vỏ ").append(giftBasket.getBasket().getName())
                        .append(" | Phụ kiện: ").append(giftBasket.getDecoration().getName()).append("]");
                if (giftBasket.getCardMessage() != null && !giftBasket.getCardMessage().isEmpty()) {
                    bundleNotes.append(" - Ghi thiệp: '").append(giftBasket.getCardMessage()).append("'");
                }
            }
            // Xử lý nhánh Đa hình: Mua Lẻ Bình Thường
            else {
                Product dbProduct = productDAO.getProductById(item.getProduct().getId());
                if (dbProduct == null || dbProduct.getStock() < item.getQuantity()) {
                    session.setAttribute("errorMsg", "Sản phẩm " + item.getProduct().getName() + " không đủ số lượng trong kho.");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                item.setProduct(dbProduct);
                totalAmount = totalAmount.add(item.getSubtotal());

                // Thêm thẳng vào DB
                flatCartForDb.add(item);
            }
        }

        // Chốt Ghi chú cuối cùng lưu DB
        order.setNote(finalNote + bundleNotes.toString());

        totalAmount = totalAmount.add(shippingFee);
        BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
        if (discount != null) totalAmount = totalAmount.subtract(discount);

        int pointsUsed = 0;
        if (usePoints && user != null && user.getRewardPoints() > 0) {
            pointsUsed = Math.min(user.getRewardPoints(), totalAmount.intValue());
            totalAmount = totalAmount.subtract(new BigDecimal(pointsUsed));
        }

        if (totalAmount.compareTo(BigDecimal.ZERO) < 0) totalAmount = BigDecimal.ZERO;
        order.setTotalAmount(totalAmount);

        // Lưu đơn hàng với danh sách đã làm phẳng, loại bỏ vật phẩm ảo.
        int orderId = orderDAO.createOrder(order, flatCartForDb);

        if (orderId > 0) {
            if (pointsUsed > 0 && user != null) {
                userDAO.deductRewardPoints(user.getId(), pointsUsed);
                user.setRewardPoints(user.getRewardPoints() - pointsUsed);
                session.setAttribute("user", user);
            }

            session.removeAttribute("cart");
            session.removeAttribute("cartSubtotal");
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");

            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderTotal", totalAmount);
            session.setAttribute("lastPaymentMethod", paymentMethod);
            session.setAttribute("successMsg", "Đặt hàng thành công!");

            if ("VIETQR".equals(paymentMethod)) {
                response.sendRedirect(request.getContextPath() + "/checkout-success");
            } else {
                response.sendRedirect(request.getContextPath() + "/checkout-success");
            }
        } else {
            session.setAttribute("errorMsg", "Có lỗi xảy ra khi lưu đơn, vui lòng kiểm tra lại thông tin!");
            String redirectUrl = request.getContextPath() + "/checkout";
            if (user == null) redirectUrl += "?type=guest";
            response.sendRedirect(redirectUrl);
        }
    }
}