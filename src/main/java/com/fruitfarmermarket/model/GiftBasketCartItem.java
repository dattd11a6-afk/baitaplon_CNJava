package com.fruitfarmermarket.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class GiftBasketCartItem extends CartItem {
    private String basketSessionId; // Mã ngẫu nhiên để phân biệt nếu khách tạo 2 giỏ quà khác nhau
    private List<CartItem> fruitItems; // Danh sách các loại trái cây khách nhét vào giỏ
    private Basket basket;             // Mẫu giỏ đã chọn
    private Decoration decoration;     // Mẫu trang trí đã chọn
    private Packaging packaging;       // Kiểu đóng gói đã chọn
    private String cardMessage;        // Lời nhắn trên thiệp

    public GiftBasketCartItem() {
        super(); // Khởi tạo các thuộc tính của CartItem gốc
        this.fruitItems = new ArrayList<>();
        this.setQuantity(1); // Mặc định một cấu hình giỏ quà là 1 bộ
    }

    // --- CÁC HÀM GHI ĐÈ (OVERRIDE) ĐỂ QUA MẶT HỆ THỐNG CŨ ---

    @Override
    public Product getProduct() {
        // Tạo một sản phẩm "ảo" để hiển thị trên màn hình Giỏ Hàng (Cart) và Thanh Toán (Checkout)
        Product virtualProduct = new Product();
        virtualProduct.setName("🎁 Giỏ quà tùy chỉnh");
        virtualProduct.setPrice(calculateTotalBundlePrice());
        virtualProduct.setImage("gift-basket-default.png"); // Tên file ảnh mặc định của giỏ quà
        return virtualProduct;
    }

    @Override
    public BigDecimal getSubtotal() {
        // Thay vì lấy (Giá sản phẩm x Số lượng) như CartItem bình thường,
        // hệ thống sẽ gọi hàm này và tự động cộng dồn toàn bộ phụ kiện bên trong.
        return calculateTotalBundlePrice().multiply(new BigDecimal(this.getQuantity()));
    }

    // --- HÀM TÍNH TOÁN CORE LOGIC (SERVER-SIDE) ---
    private BigDecimal calculateTotalBundlePrice() {
        BigDecimal total = BigDecimal.ZERO;

        // 1. Cộng tiền tất cả trái cây có trong giỏ
        if (fruitItems != null) {
            for (CartItem fruit : fruitItems) {
                total = total.add(fruit.getSubtotal());
            }
        }
        // 2. Cộng tiền vỏ giỏ
        if (basket != null && basket.getPrice() != null) {
            total = total.add(basket.getPrice());
        }
        // 3. Cộng tiền trang trí
        if (decoration != null && decoration.getPrice() != null) {
            total = total.add(decoration.getPrice());
        }
        // 4. Cộng tiền đóng gói
        if (packaging != null && packaging.getPrice() != null) {
            total = total.add(packaging.getPrice());
        }
        // * Lưu ý: Tiền thiệp = 0đ nên không cộng.

        return total;
    }

    // --- GETTERS VÀ SETTERS ---

    public String getBasketSessionId() { return basketSessionId; }
    public void setBasketSessionId(String basketSessionId) { this.basketSessionId = basketSessionId; }

    public List<CartItem> getFruitItems() { return fruitItems; }
    public void setFruitItems(List<CartItem> fruitItems) { this.fruitItems = fruitItems; }

    public Basket getBasket() { return basket; }
    public void setBasket(Basket basket) { this.basket = basket; }

    public Decoration getDecoration() { return decoration; }
    public void setDecoration(Decoration decoration) { this.decoration = decoration; }

    public Packaging getPackaging() { return packaging; }
    public void setPackaging(Packaging packaging) { this.packaging = packaging; }

    public String getCardMessage() { return cardMessage; }
    public void setCardMessage(String cardMessage) { this.cardMessage = cardMessage; }
}