package com.fruitfarmermarket.model;

import java.math.BigDecimal;
import java.util.List;

public class CartItem {
    private Product product;

    // đổi sang double để tính số cân thập phân
    private double quantity;

    public CartItem() {}

    // HÀM KHỞI TẠO QUAN TRỌNG: Tham số số 2 phải là double
    public CartItem(Product product, double quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    // Đã sửa hàm get/set thành double
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }

    public BigDecimal getSubtotal() {
        if (this.product == null || this.product.getPrice() == null) {
            return BigDecimal.ZERO;
        }
        return this.product.getPrice().multiply(BigDecimal.valueOf(this.quantity));
    }

    // Dummy methods cho Đa hình Giỏ Quà
    public String getBasketSessionId() { return null; }
    public List<CartItem> getFruitItems() { return null; }
}