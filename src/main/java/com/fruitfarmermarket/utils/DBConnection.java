package com.fruitfarmermarket.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // 1. Cấu hình thông tin Database
    private static final String DB_URL = "jdbc:mysql://localhost:3306/fruit_farmer_market?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "Dat1234566";

    /**
     * Phương thức này sẽ được các class DAO gọi mỗi khi cần lấy dữ liệu từ Database
     */
    public static Connection getConnection() {
        Connection connection = null;
        try {

            // Gọi Driver của MySQL vào bộ nhớ
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Tạo kết nối thông qua DriverManager
            connection = DriverManager.getConnection(DB_URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.out.println("❌ LỖI: Không tìm thấy thư viện MySQL Driver. Hãy kiểm tra lại file pom.xml!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ LỖI: Không thể kết nối tới Database. Hãy kiểm tra xem MySQL đã bật chưa, hoặc sai mật khẩu/tên database!");
            e.printStackTrace();
        }

        return connection;
    }

    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("✅ KẾT NỐI DATABASE FRUIT_FARMER_MARKET THÀNH CÔNG!");
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("❌ KẾT NỐI THẤT BẠI!");
        }
    }
}