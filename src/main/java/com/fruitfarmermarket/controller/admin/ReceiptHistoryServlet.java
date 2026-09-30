package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.InventoryDAO;
import com.fruitfarmermarket.model.GoodsReceipt;
import com.fruitfarmermarket.model.GoodsReceiptDetail;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/inventory/history")
public class ReceiptHistoryServlet extends HttpServlet {
    private InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        // Trả về JSON chi tiết phiếu nhập khi click vào nút "Xem chi tiết"
        if ("getDetails".equals(action)) {
            int receiptId = Integer.parseInt(request.getParameter("id"));
            List<GoodsReceiptDetail> details = inventoryDAO.getReceiptDetails(receiptId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(details));
            return;
        }

        // Mặc định: Hiển thị danh sách trang Lịch sử
        List<GoodsReceipt> receipts = inventoryDAO.getAllReceipts();
        request.setAttribute("receipts", receipts);
        request.getRequestDispatcher("/view/admin/inventory-history.jsp").forward(request, response);
    }
}