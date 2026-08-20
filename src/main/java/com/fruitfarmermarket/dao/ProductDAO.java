package com.fruitfarmermarket.dao;

import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    /**
     * Hàm lấy danh sách sản phẩm TỔNG HỢP (Search + Filter + Sort + Pagination)
     */
    public List<Product> getProducts(String keyword, Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice, String sort, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        List<Object> params = new ArrayList<>(); // Chứa các giá trị truyền vào PreparedStatement

        // Dùng StringBuilder để nối SQL động
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name AS category_name " +
                        "FROM products p " +
                        "JOIN categories c ON p.category_id = c.id " +
                        "WHERE p.status = 'ACTIVE' AND c.status = 'ACTIVE'"
        );

        // 1. Điều kiện SEARCH
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ? OR p.origin LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // 2. Điều kiện FILTER CATEGORY
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }

        // 3. Điều kiện FILTER PRICE
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice);
        }

        // 4. Xử lý SORT bằng Whitelist (Chống SQL Injection triệt để)
        if (sort != null) {
            switch (sort) {
                case "price_asc": sql.append(" ORDER BY p.price ASC"); break;
                case "price_desc": sql.append(" ORDER BY p.price DESC"); break;
                case "name_asc": sql.append(" ORDER BY p.name ASC"); break;
                case "name_desc": sql.append(" ORDER BY p.name DESC"); break;
                case "newest": sql.append(" ORDER BY p.created_at DESC"); break;
                default: sql.append(" ORDER BY p.id DESC"); break;
            }
        } else {
            sql.append(" ORDER BY p.id DESC"); // Mặc định hiển thị sản phẩm mới nhất
        }

        // 5. Xử lý PAGINATION (Phân trang tại Database)
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        // THỰC THI QUERY
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Map params vào PreparedStatement
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hàm đếm TỔNG SỐ SẢN PHẨM phục vụ tính toán số trang (Pagination)
     * (Logic WHERE copy y hệt như hàm getProducts ở trên, chỉ bỏ ORDER BY và LIMIT)
     */
    public int countProducts(String keyword, Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice) {
        int total = 0;
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(p.id) " +
                        "FROM products p " +
                        "JOIN categories c ON p.category_id = c.id " +
                        "WHERE p.status = 'ACTIVE' AND c.status = 'ACTIVE'"
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ? OR p.origin LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        if (minPrice != null) {
            sql.append(" AND p.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND p.price <= ?");
            params.add(maxPrice);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    /**
     * Lấy 1 sản phẩm chi tiết theo ID (Dùng cho trang Product Detail)
     */
    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE p.id = ? AND p.status = 'ACTIVE'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    // Hàm tiện ích map ResultSet thành Object Product (Tránh duplicate code)
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price")); // An toàn map từ DOUBLE sang BigDecimal
        p.setUnit(rs.getString("unit"));
        p.setStock(rs.getInt("stock"));
        p.setImage(rs.getString("image"));
        p.setOrigin(rs.getString("origin"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}