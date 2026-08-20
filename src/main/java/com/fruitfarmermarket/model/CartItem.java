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

    /**
     * Tính thành tiền của 1 sản phẩm trong giỏ
     * Trả về BigDecimal để đồng bộ với kiểu dữ liệu giá tiền
     */
    public BigDecimal getSubtotal() {
        if (this.product == null || this.product.getPrice() == null) {
            return BigDecimal.ZERO;
        }
        // Ép kiểu quantity sang BigDecimal và sử dụng hàm multiply() thay vì dấu *
        return this.product.getPrice().multiply(BigDecimal.valueOf(this.quantity));
    }
}