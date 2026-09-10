package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Attendance;
import com.fruitfarmermarket.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO {

    // Lấy thông tin chấm công ngày HÔM NAY của 1 nhân viên
    public Attendance getAttendanceToday(int staffId) {
        Attendance att = null;
        String sql = "SELECT * FROM attendance WHERE staff_id = ? AND work_date = CURRENT_DATE()";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    att = new Attendance();
                    att.setId(rs.getInt("id"));
                    att.setCheckIn(rs.getTimestamp("check_in"));
                    att.setCheckOut(rs.getTimestamp("check_out"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return att;
    }

    // Xử lý Check-In (Thêm record mới cho hôm nay)
    public boolean checkIn(int staffId) {
        String sql = "INSERT INTO attendance (staff_id, work_date, check_in) VALUES (?, CURRENT_DATE(), CURRENT_TIMESTAMP())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Xử lý Check-Out (Cập nhật record hôm nay)
    public boolean checkOut(int staffId) {
        String sql = "UPDATE attendance SET check_out = CURRENT_TIMESTAMP() WHERE staff_id = ? AND work_date = CURRENT_DATE()";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Lấy lịch sử 30 ngày gần nhất
    public List<Attendance> getHistory(int staffId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance WHERE staff_id = ? ORDER BY work_date DESC LIMIT 30";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attendance att = new Attendance();
                    att.setWorkDate(rs.getDate("work_date"));
                    att.setCheckIn(rs.getTimestamp("check_in"));
                    att.setCheckOut(rs.getTimestamp("check_out"));
                    list.add(att);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}