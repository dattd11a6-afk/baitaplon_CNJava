package com.fruitfarmermarket.controller.admin;

import com.fruitfarmermarket.dao.VoucherDAO;
import com.fruitfarmermarket.model.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/vouchers")
public class AdminVoucherServlet extends HttpServlet {
    private VoucherDAO voucherDAO = new VoucherDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Voucher> vouchers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            vouchers = voucherDAO.searchVouchers(keyword.trim());
            request.setAttribute("keyword", keyword.trim());
        } else {
            vouchers = voucherDAO.getAllVouchers();
        }

        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/view/admin/vouchers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                if (voucherDAO.deleteVoucher(id)) {
                    session.setAttribute("successMsg", "Đã xóa mã khuyến mãi!");
                } else {
                    session.setAttribute("errorMsg", "Không thể xóa mã (Đã có đơn hàng áp dụng mã này)!");
                }
            } else {
                Voucher v = new Voucher();
                v.setCode(request.getParameter("code"));

                // Lấy Enum Type (PERCENT, AMOUNT, FREE_SHIP)
                v.setType(request.getParameter("type"));

                // Ép kiểu an toàn các biến số
                String discountStr = request.getParameter("discountValue");
                v.setDiscountValue((discountStr != null && !discountStr.isEmpty()) ? new BigDecimal(discountStr) : BigDecimal.ZERO);

                String maxDiscountStr = request.getParameter("maxDiscountAmount");
                v.setMaxDiscountAmount((maxDiscountStr != null && !maxDiscountStr.isEmpty()) ? new BigDecimal(maxDiscountStr) : BigDecimal.ZERO);

                String minOrderStr = request.getParameter("minOrderAmount");
                v.setMinOrderAmount((minOrderStr != null && !minOrderStr.isEmpty()) ? new BigDecimal(minOrderStr) : BigDecimal.ZERO);

                String limitStr = request.getParameter("usageLimit");
                v.setUsageLimit((limitStr != null && !limitStr.isEmpty()) ? Integer.parseInt(limitStr) : 100);

                String expiryDateStr = request.getParameter("expiryDate");
                if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                    v.setExpiryDate(Date.valueOf(expiryDateStr));
                } else {
                    v.setExpiryDate(Date.valueOf(java.time.LocalDate.now().plusDays(1)));
                }

                v.setStatus(request.getParameter("status"));

                if ("add".equals(action)) {
                    String result = voucherDAO.insertVoucher(v);
                    if ("SUCCESS".equals(result)) {
                        session.setAttribute("successMsg", "Thêm mã khuyến mãi thành công!");
                    } else {
                        session.setAttribute("errorMsg", "LỖI CSDL: " + result);
                    }
                } else if ("update".equals(action)) {
                    v.setId(Integer.parseInt(request.getParameter("id")));
                    String result = voucherDAO.updateVoucher(v);
                    if ("SUCCESS".equals(result)) {
                        session.setAttribute("successMsg", "Cập nhật mã khuyến mãi thành công!");
                    } else {
                        session.setAttribute("errorMsg", "LỖI CSDL: " + result);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Dữ liệu nhập vào không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }
}