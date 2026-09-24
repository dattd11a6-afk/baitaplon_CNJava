package com.fruitfarmermarket.model;

import java.math.BigDecimal;

public class Accessory {
    private int id;
    private String type; // BASKET (Vỏ giỏ), DECORATION (Trang trí), PACKAGING (Đóng gói)
    private String name;
    private BigDecimal price;
    private String image;
    private String status;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}