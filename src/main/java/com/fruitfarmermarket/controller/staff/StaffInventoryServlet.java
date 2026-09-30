package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.InventoryDAO;
import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.dao.SupplierDAO;
import com.fruitfarmermarket.model.GoodsReceiptDetail;
import com.fruitfarmermarket.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/staff/inventory")
public class StaffInventoryServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private InventoryDAO inventoryDAO = new InventoryDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // API TRẢ VỀ JSON CHO NÚT "XEM CHI TIẾT" PHIẾU NHẬP
        if ("getDetails".equals(action)) {
            int receiptId = Integer.parseInt(request.getParameter("id"));
            List<GoodsReceiptDetail> details = inventoryDAO.getReceiptDetails(receiptId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < details.size(); i++) {
                GoodsReceiptDetail d = details.get(i);
                json.append("{")
                        .append("\"productName\":\"").append(d.getProductName().replace("\"", "\\\"")).append("\",")
                        .append("\"quantity\":").append(d.getQuantity()).append(",")
                        .append("\"importPrice\":").append(d.getImportPrice()).append(",")
                        .append("\"subtotal\":").append(d.getSubtotal())
                        .append("}");
                if (i < details.size() - 1) json.append(",");
            }
            json.append("]");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json.toString());
            return;
        }

        // LẤY DỮ LIỆU ĐỂ STAFF XEM (READ-ONLY)
        request.setAttribute("productList", productDAO.getActiveProducts());
        request.setAttribute("supplierList", supplierDAO.getAllSuppliersAdmin());

        List<Map<String, Object>> receiptList = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sqlRec = "SELECT r.*, s.name as supplierName, u.full_name as userName " +
                    "FROM goods_receipts r " +
                    "LEFT JOIN suppliers s ON r.supplier_id = s.id " +
                    "LEFT JOIN users u ON r.user_id = u.id ORDER BY r.id DESC";
            try (PreparedStatement ps = conn.prepareStatement(sqlRec); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> rec = new HashMap<>();
                    rec.put("id", rs.getInt("id"));
                    rec.put("createdAt", rs.getTimestamp("created_at"));
                    rec.put("supplierName", rs.getString("supplierName"));
                    rec.put("userName", rs.getString("userName") != null ? rs.getString("userName") : "Staff");
                    rec.put("totalAmount", rs.getDouble("total_amount"));
                    receiptList.add(rec);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("receiptList", receiptList);
        request.getRequestDispatcher("/view/staff/inventory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Khóa toàn quyền Thêm/Sửa/Xóa của Staff
        request.getSession().setAttribute("errorMsg", "Quyền truy cập bị từ chối! Chỉ Quản trị viên mới được phép thao tác Dữ liệu Kho.");
        response.sendRedirect(request.getContextPath() + "/staff/inventory");
    }
}