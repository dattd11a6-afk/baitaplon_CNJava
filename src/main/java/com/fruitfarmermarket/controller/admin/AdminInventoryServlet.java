package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.InventoryDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Product;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/inventory")
public class AdminInventoryServlet extends HttpServlet {

    private InventoryDAO inventoryDAO = new InventoryDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy danh sách Nhà cung cấp và Sản phẩm để hiển thị lên Form nhập
        request.setAttribute("suppliers", inventoryDAO.getAllSuppliers());
        request.setAttribute("products", productDAO.getAllProductsForAdmin());

        request.getRequestDispatcher("/view/admin/inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");

        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String note = request.getParameter("note");

            // Nhận mảng Dữ liệu Sản phẩm (Bao gồm nhiều ID, Số lượng, Giá nhập)
            String[] productIds = request.getParameterValues("productIds[]");
            String[] quantities = request.getParameterValues("quantities[]");
            String[] importPrices = request.getParameterValues("importPrices[]");

            if (productIds == null || productIds.length == 0) {
                session.setAttribute("errorMsg", "Phải chọn ít nhất 1 sản phẩm để nhập kho!");
                response.sendRedirect(request.getContextPath() + "/admin/inventory");
                return;
            }

            List<Map<String, Object>> details = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;

            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                BigDecimal importPrice = new BigDecimal(importPrices[i]);

                Map<String, Object> item = new HashMap<>();
                item.put("productId", productId);
                item.put("quantity", quantity);
                item.put("importPrice", importPrice);
                details.add(item);

                totalAmount = totalAmount.add(importPrice.multiply(new BigDecimal(quantity)));
            }

            // Gọi DAO tạo phiếu nhập và cộng kho
            if (inventoryDAO.createGoodsReceipt(supplierId, admin.getId(), totalAmount, note, details)) {
                session.setAttribute("successMsg", "Nhập kho thành công! Số lượng sản phẩm đã được cộng dồn.");
            } else {
                session.setAttribute("errorMsg", "Lỗi CSDL khi nhập kho!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu nhập vào không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/products"); // Nhập xong đá về kho tổng
    }
}