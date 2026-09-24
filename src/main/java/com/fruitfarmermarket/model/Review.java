package com.fruitfarmermarket.model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int userId;
    private int productId;
    private int orderId;
    private int rating;
    private String comment;
    private String mediaUrl;
    private String sellerReply; // Phản hồi của cửa hàng
    private Timestamp createdAt;
    private String productName;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    // Thuộc tính phụ để hiển thị trên UI
    private String userName;
    private String userAvatar;

    public Review() {}

    // Getters & Setters
    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; } public void setUserId(int userId) { this.userId = userId; }
    public int getProductId() { return productId; } public void setProductId(int productId) { this.productId = productId; }
    public int getOrderId() { return orderId; } public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getRating() { return rating; } public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; } public void setComment(String comment) { this.comment = comment; }
    public String getMediaUrl() { return mediaUrl; } public void setMediaUrl(String mediaUrl) { this.mediaUrl = mediaUrl; }
    public String getSellerReply() { return sellerReply; } public void setSellerReply(String sellerReply) { this.sellerReply = sellerReply; }
    public Timestamp getCreatedAt() { return createdAt; } public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getUserName() { return userName; } public void setUserName(String userName) { this.userName = userName; }
    public String getUserAvatar() { return userAvatar; } public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }
}