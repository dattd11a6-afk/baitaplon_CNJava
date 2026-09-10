package com.fruitfarmermarket.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Attendance {
    private int id;
    private int staffId;
    private Date workDate;
    private Timestamp checkIn;
    private Timestamp checkOut;
    private String status;
    private String note;

    public Attendance() {}

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getStaffId() { return staffId; } public void setStaffId(int staffId) { this.staffId = staffId; }
    public Date getWorkDate() { return workDate; } public void setWorkDate(Date workDate) { this.workDate = workDate; }
    public Timestamp getCheckIn() { return checkIn; } public void setCheckIn(Timestamp checkIn) { this.checkIn = checkIn; }
    public Timestamp getCheckOut() { return checkOut; } public void setCheckOut(Timestamp checkOut) { this.checkOut = checkOut; }
    public String getStatus() { return status; } public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; } public void setNote(String note) { this.note = note; }
}