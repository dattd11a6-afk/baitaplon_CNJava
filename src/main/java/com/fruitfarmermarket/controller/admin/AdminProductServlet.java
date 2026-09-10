package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.CategoryDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Category;
import com.fruitfarmermarket.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showForm(request, response, null);
                break;
            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                Product product = productDAO.getProductById(id);
                showForm(request, response, product);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            // 1. CHỨC NĂNG XÓA SẢN PHẨM
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (productDAO.deleteProduct(id)) {
                    session.setAttribute("successMsg", "Đã xóa sản phẩm thành công!");
                } else {
                    session.setAttribute("errorMsg", "Không thể xóa sản phẩm này.");
                }
            }
            // 2. CHỨC NĂNG THÊM / CẬP NHẬT SẢN PHẨM
            else {
                Product p = new Product();

                // Ép kiểu ID an toàn
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    p.setId(Integer.parseInt(idStr));
                }

                // Lấy dữ liệu Text
                p.setName(request.getParameter("name"));
                p.setDescription(request.getParameter("description"));
                p.setUnit(request.getParameter("unit"));
                p.setOrigin(request.getParameter("origin"));
                p.setStatus(request.getParameter("status"));
                p.setImage(request.getParameter("image"));

                // Ép kiểu Số an toàn (Tránh NumberFormatException gây lỗi không thêm được)
                String catIdStr = request.getParameter("categoryId");
                p.setCategoryId((catIdStr != null && !catIdStr.isEmpty()) ? Integer.parseInt(catIdStr) : 0);

                String priceStr = request.getParameter("price");
                p.setPrice((priceStr != null && !priceStr.isEmpty()) ? new BigDecimal(priceStr) : BigDecimal.ZERO);

                String stockStr = request.getParameter("stock");
                p.setStock((stockStr != null && !stockStr.isEmpty()) ? Integer.parseInt(stockStr) : 0);

                // Thực thi DB
                if (p.getId() == 0) {
                    if (productDAO.insertProduct(p)) {
                        session.setAttribute("successMsg", "Đã thêm sản phẩm thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi CSDL khi thêm sản phẩm.");
                    }
                } else {
                    if (productDAO.updateProduct(p)) {
                        session.setAttribute("successMsg", "Cập nhật sản phẩm thành công!");
                    } else {
                        session.setAttribute("errorMsg", "Lỗi CSDL khi cập nhật.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug thay vì giấu đi
            session.setAttribute("errorMsg", "Dữ liệu nhập vào không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> products = productDAO.getAllProductsForAdmin();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/view/admin/products.jsp").forward(request, response);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, Product product) throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllActiveCategories();
        request.setAttribute("categories", categories);
        if (product != null) {
            request.setAttribute("product", product);
        }
        request.getRequestDispatcher("/view/admin/product-form.jsp").forward(request, response);
    }
}