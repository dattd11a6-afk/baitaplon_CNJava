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

    // ==========================================
    // CÁC HÀM DÀNH CHO TRANG KHÁCH HÀNG (SHOP)
    // ==========================================
    public List<Product> getProducts(String keyword, Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice, String sort, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name AS category_name " +
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
            sql.append(" ORDER BY p.id DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

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

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setUnit(rs.getString("unit"));
        p.setStock(rs.getInt("stock"));
        p.setImage(rs.getString("image"));
        p.setOrigin(rs.getString("origin"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }

    // ==========================================
    // CÁC HÀM DÀNH RIÊNG CHO ADMIN (CRUD)
    // ==========================================

    public List<Product> getAllProductsForAdmin() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO products (category_id, name, description, price, unit, stock, image, origin, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setString(5, p.getUnit());
            ps.setInt(6, p.getStock());
            ps.setString(7, p.getImage());
            ps.setString(8, p.getOrigin());
            ps.setString(9, p.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE products SET category_id=?, name=?, description=?, price=?, unit=?, stock=?, image=?, origin=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setBigDecimal(4, p.getPrice());
            ps.setString(5, p.getUnit());
            ps.setInt(6, p.getStock());
            ps.setString(7, p.getImage());
            ps.setString(8, p.getOrigin());
            ps.setString(9, p.getStatus());
            ps.setInt(10, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean disableProduct(int id) {
        String sql = "UPDATE products SET status = 'INACTIVE' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // HÀM MỚI: XÓA SẢN PHẨM THÔNG MINH
    public boolean deleteProduct(int id) {
        // Thử xóa cứng khỏi Database
        String sqlDelete = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Lỗi khóa ngoại (đã có hóa đơn mua sản phẩm này) -> Chuyển sang Xóa mềm
            return disableProduct(id);
        }
    }

    public List<Product> getLowStockProducts(int threshold, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE p.stock <= ? AND p.status = 'ACTIVE' ORDER BY p.stock ASC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToProduct(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}