package com.fruitfarmermarket.model;

import java.math.BigDecimal;

public class OrderDetail {
    private int id;
    private int productId;
    private String productName;
    private BigDecimal price;

    // Đã đổi sang double
    private double quantity;
    private BigDecimal subtotal;

    // Thuộc tính lưu tên file ảnh để hiển thị UI
    private String productImage;
    private String productUnit;

    // TÍNH NĂNG MỚI: Khối lượng sản phẩm cho Shipper tính toán
    private Double weight;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public String getProductUnit() { return productUnit; }
    public void setProductUnit(String productUnit) { this.productUnit = productUnit; }

    public Double getWeight() { return weight; }
    public void setWeight(Double weight) { this.weight = weight; }
}