package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.GiftBasketDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.CartItem;
import com.fruitfarmermarket.model.GiftBasketCartItem;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.service.GiftBasketService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/gift-basket")
public class GiftBasketServlet extends HttpServlet {

    private GiftBasketService gbService = new GiftBasketService();
    private ProductDAO productDAO = new ProductDAO(); // Tái sử dụng DAO có sẵn của ông

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Load toàn bộ Dữ liệu từ Master Data lên Giao diện
        request.setAttribute("fruits", productDAO.getActiveProducts()); // Giả sử ông có hàm lấy trái cây
        request.setAttribute("baskets", gbService.getAvailableBaskets());
        request.setAttribute("decorations", gbService.getAvailableDecorations());
        request.setAttribute("packagings", gbService.getAvailablePackagings());

        request.getRequestDispatcher("/view/user/gift-basket.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        try {
            // 1. Tạo mới một Object Giỏ Quà
            GiftBasketCartItem giftCartItem = new GiftBasketCartItem();
            giftCartItem.setBasketSessionId("GB-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());

            // 2. Lấy & Validate Giỏ, Trang trí, Đóng gói
            int basketId = Integer.parseInt(request.getParameter("basketId"));
            int decorationId = Integer.parseInt(request.getParameter("decorationId"));
            int packagingId = Integer.parseInt(request.getParameter("packagingId"));
            String cardMessage = request.getParameter("cardMessage");

            giftCartItem.setBasket(gbService.getBasket(basketId));
            giftCartItem.setDecoration(gbService.getDecoration(decorationId));
            giftCartItem.setPackaging(gbService.getPackaging(packagingId));

            // Xử lý chống XSS cơ bản cho lời chúc
            if (cardMessage != null) {
                cardMessage = cardMessage.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                giftCartItem.setCardMessage(cardMessage);
            }

            // 3. Quét toàn bộ Request để tìm các loại trái cây được chọn
            // Giao diện sẽ gửi data dạng: fruit_qty_1 = 2 (id=1, số lượng=2)
            List<CartItem> selectedFruits = new ArrayList<>();
            request.getParameterMap().forEach((key, values) -> {
                if (key.startsWith("fruit_qty_")) {
                    int qty = Integer.parseInt(values[0]);
                    if (qty > 0) {
                        int productId = Integer.parseInt(key.replace("fruit_qty_", ""));
                        Product p = productDAO.getProductById(productId);
                        if (p != null) {
                            CartItem fruitItem = new CartItem(p, qty);
                            selectedFruits.add(fruitItem);
                        }
                    }
                }
            });

            // Nếu hacker cố tình submit khi chưa chọn trái cây
            if (selectedFruits.isEmpty()) {
                session.setAttribute("errorMsg", "Vui lòng chọn ít nhất 1 loại trái cây!");
                response.sendRedirect(request.getContextPath() + "/gift-basket");
                return;
            }

            giftCartItem.setFruitItems(selectedFruits);

            // 4. Nhét Giỏ Quà vào Giỏ Hàng Chung (Session Cart)
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
            }
            cart.add(giftCartItem); // Hoạt động hoàn hảo vì nó kế thừa CartItem
            session.setAttribute("cart", cart);

            // Set thông báo và ném khách về trang Cart
            session.setAttribute("successMsg", "Đã thêm Giỏ quà tùy chỉnh vào giỏ hàng!");
            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Lỗi xử lý dữ liệu giỏ quà, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/gift-basket");
        }
    }
}