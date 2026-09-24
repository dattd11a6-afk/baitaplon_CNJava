package com.fruitfarmermarket.model;

import java.math.BigDecimal;

public class CartItem {
    private Product product;
    private int quantity;

    public CartItem() {}

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // --- FIX LỖI ĐA HÌNH EL ---
    // Khai báo hàm ảo để JSP có thể gọi ${item.basketSessionId} an toàn mà không bị lỗi PropertyNotFound
    // Lớp con GiftBasketCartItem sẽ tự động ghi đè (override) hàm này và trả về chuỗi ID thật.
    public String getBasketSessionId() {
        return null;
    }

    public BigDecimal getSubtotal() {
        if (this.product == null || this.product.getPrice() == null) {
            return BigDecimal.ZERO;
        }
        return this.product.getPrice().multiply(BigDecimal.valueOf(this.quantity));
    }
}