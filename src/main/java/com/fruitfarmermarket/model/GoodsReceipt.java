package com.fruitfarmermarket.model;
import java.sql.Timestamp;

public class GoodsReceipt {
    private int id;
    private String supplierName;
    private String userName; // Tên admin nhập
    private double totalAmount;
    private String note;
    private Timestamp createdAt;

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}