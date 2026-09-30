package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.OrderDAO;
import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.SettingDAO; // BỔ SUNG
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
import java.util.Map; // BỔ SUNG

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();
    private ProductDAO productDAO = new ProductDAO();
    private SettingDAO settingDAO = new SettingDAO(); // BỔ SUNG DAO ĐỂ LẤY CẤU HÌNH

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

        // BỔ SUNG: LẤY CẤU HÌNH HỆ THỐNG GỬI RA GIAO DIỆN
        Map<String, String> settings = settingDAO.getAllSettings();
        request.setAttribute("settings", settings);

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

        // Lấy thông tin Phương thức giao hàng & Tiền ship từ Form
        String deliveryTime = request.getParameter("deliveryTime");
        String shippingType = request.getParameter("shippingType"); // STANDARD HOẶC EXPRESS
        String shippingFeeStr = request.getParameter("shippingFee");
        BigDecimal shippingFee = (shippingFeeStr != null && !shippingFeeStr.isEmpty()) ? new BigDecimal(shippingFeeStr) : BigDecimal.ZERO;

        String finalNote = "";
        if (deliveryTime != null && !deliveryTime.isEmpty()) finalNote = "Giờ nhận: " + deliveryTime + " | ";
        if (rawNote != null && !rawNote.isEmpty()) finalNote += rawNote;

        // Bổ sung ghi chú Loại vận chuyển cho Shipper
        if ("EXPRESS".equals(shippingType)) {
            finalNote = "[GIAO HỎA TỐC 2H] " + finalNote;
        }

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
        List<CartItem> flatCartForDb = new ArrayList<>();
        StringBuilder bundleNotes = new StringBuilder();

        for (CartItem item : cart) {
            if (item instanceof GiftBasketCartItem) {
                GiftBasketCartItem giftBasket = (GiftBasketCartItem) item;

                for (CartItem fruitItem : giftBasket.getFruitItems()) {
                    Product dbProduct = productDAO.getProductById(fruitItem.getProduct().getId());
                    if (dbProduct == null || dbProduct.getStock() < fruitItem.getQuantity()) {
                        session.setAttribute("errorMsg", "Trái cây " + fruitItem.getProduct().getName() + " trong giỏ quà đã hết hàng.");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                    fruitItem.setProduct(dbProduct);
                }

                totalAmount = totalAmount.add(giftBasket.getSubtotal());
                flatCartForDb.addAll(giftBasket.getFruitItems());

                bundleNotes.append("\n[GIỎ MIX YÊU CẦU: Vỏ ").append(giftBasket.getBasket().getName())
                        .append(" | Phụ kiện: ").append(giftBasket.getDecoration().getName()).append("]");
                if (giftBasket.getCardMessage() != null && !giftBasket.getCardMessage().isEmpty()) {
                    bundleNotes.append(" - Ghi thiệp: '").append(giftBasket.getCardMessage()).append("'");
                }
            } else {
                Product dbProduct = productDAO.getProductById(item.getProduct().getId());
                if (dbProduct == null || dbProduct.getStock() < item.getQuantity()) {
                    session.setAttribute("errorMsg", "Sản phẩm " + item.getProduct().getName() + " không đủ số lượng trong kho.");
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                item.setProduct(dbProduct);
                totalAmount = totalAmount.add(item.getSubtotal());
                flatCartForDb.add(item);
            }
        }

        order.setNote(finalNote + bundleNotes.toString());

        // TÍNH TOÁN THUẾ VAT TỪ BẢNG SETTINGS (MỚI)
        Map<String, String> settings = settingDAO.getAllSettings();
        String taxRateStr = settings.get("TAX_RATE");
        BigDecimal taxRate = (taxRateStr != null) ? new BigDecimal(taxRateStr).divide(new BigDecimal(100)) : BigDecimal.ZERO;
        BigDecimal taxFee = totalAmount.multiply(taxRate); // Tiền thuế = Tạm tính * Thuế suất

        // Cộng dồn Phí Ship & Thuế
        totalAmount = totalAmount.add(shippingFee).add(taxFee);

        // Trừ mã giảm giá (Nếu có)
        BigDecimal discount = (BigDecimal) session.getAttribute("discountAmount");
        if (discount != null) totalAmount = totalAmount.subtract(discount);

        // Trừ điểm thưởng (Nếu có dùng)
        int pointsUsed = 0;
        if (usePoints && user != null && user.getRewardPoints() > 0) {
            pointsUsed = Math.min(user.getRewardPoints(), totalAmount.intValue());
            totalAmount = totalAmount.subtract(new BigDecimal(pointsUsed));
        }

        if (totalAmount.compareTo(BigDecimal.ZERO) < 0) totalAmount = BigDecimal.ZERO;
        order.setTotalAmount(totalAmount);
        order.setShippingType(shippingType);
        order.setShippingFee(shippingFee);
        order.setTaxFee(taxFee);

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

            response.sendRedirect(request.getContextPath() + "/checkout-success");
        } else {
            session.setAttribute("errorMsg", "Có lỗi xảy ra khi lưu đơn, vui lòng kiểm tra lại thông tin!");
            String redirectUrl = request.getContextPath() + "/checkout";
            if (user == null) redirectUrl += "?type=guest";
            response.sendRedirect(redirectUrl);
        }
    }
}