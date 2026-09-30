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
                "SELECT COUNT(p.id) FROM products p JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' AND c.status = 'ACTIVE'"
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
                if (rs.next()) total = rs.getInt(1);
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
        p.setId(rs.getInt("id")); // Fix: ID luôn là Int
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setUnit(rs.getString("unit"));

        // ĐÃ KHẮC PHỤC LỖI TẠI DÒNG 162
        p.setStock(rs.getDouble("stock"));

        p.setImage(rs.getString("image"));
        p.setOrigin(rs.getString("origin"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }

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
            ps.setDouble(6, p.getStock());
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
            ps.setDouble(6, p.getStock());
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

    public boolean deleteProduct(int id) {
        String sqlDelete = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
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

    public List<Product> getFeaturedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setImage(rs.getString("image"));
                    p.setUnit(rs.getString("unit"));
                    // ĐÃ KHẮC PHỤC LỖI TẠI DÒNG 284
                    p.setStock(rs.getDouble("stock"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getActiveProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' AND p.stock > 0 ORDER BY p.name ASC";

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

    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name FROM products p " +
                "JOIN categories c ON p.category_id = c.id " +
                "WHERE p.status = 'ACTIVE' AND (p.name LIKE ? OR p.description LIKE ? OR p.origin LIKE ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
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

    public List<Product> getFilteredProducts(String category, String[] origins, String priceRange, String sortOption) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name AS category_name FROM products p " +
                        "JOIN categories c ON p.category_id = c.id WHERE p.status = 'ACTIVE' "
        );

        if (category != null && !category.isEmpty()) {
            if (category.equals("nhapkhau")) sql.append(" AND c.name LIKE '%nhập khẩu%' ");
            else if (category.equals("vietnam")) sql.append(" AND c.name LIKE '%Việt Nam%' ");
            else if (category.equals("huuco")) sql.append(" AND c.name LIKE '%hữu cơ%' ");
            else if (category.equals("muavum")) sql.append(" AND (c.name LIKE '%mùa%' OR c.name LIKE '%Mùa%') ");
            else if (category.equals("combo")) sql.append(" AND (c.name LIKE '%Combo%' OR c.name LIKE '%Giỏ%') ");
        }

        if (origins != null && origins.length > 0) {
            sql.append(" AND (");
            for (int i = 0; i < origins.length; i++) {
                sql.append("p.origin = '").append(origins[i]).append("'");
                if (i < origins.length - 1) sql.append(" OR ");
            }
            sql.append(") ");
        }

        if ("under500".equals(priceRange)) {
            sql.append(" AND p.price < 500000 ");
        } else if ("500to1000".equals(priceRange)) {
            sql.append(" AND p.price >= 500000 AND p.price <= 1000000 ");
        } else if ("over1000".equals(priceRange)) {
            sql.append(" AND p.price > 1000000 ");
        }

        if ("priceAsc".equals(sortOption)) {
            sql.append(" ORDER BY p.price ASC");
        } else if ("priceDesc".equals(sortOption)) {
            sql.append(" ORDER BY p.price DESC");
        } else if ("nameAsc".equals(sortOption)) {
            sql.append(" ORDER BY p.name ASC");
        } else {
            sql.append(" ORDER BY p.id DESC");
        }

        try (java.sql.Connection conn = com.fruitfarmermarket.utils.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql.toString());
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}