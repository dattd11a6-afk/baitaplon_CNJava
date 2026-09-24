package com.fruitfarmermarket.api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/vietqr")
public class VietQRServlet extends HttpServlet {

    // QR code
    private static final String BANK_ID = "BIDV"; // Mã ngân hàng
    private static final String ACCOUNT_NO = "4280915299"; // Số tài khoản
    private static final String ACCOUNT_NAME = "DO PHAT DAT"; // Tên chủ tài khoản
    private static final String TEMPLATE = "compact"; // Giao diện QR: compact, compact2, qr_only

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Trả về định dạng JSON để Javascript bên file checkout-success.jsp đọc được
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String orderId = request.getParameter("orderId");
        String amount = request.getParameter("amount");

        if (orderId == null || amount == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Thiếu tham số orderId hoặc amount\"}");
            return;
        }

        try {
            // Nội dung chuyển khoản: DH + Mã Đơn
            String addInfo = "DH" + orderId;

            // Mã hóa URL để tránh lỗi dấu cách hoặc ký tự đặc biệt trong Tên tài khoản
            String encodedAccountName = URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8.toString()).replace("+", "%20");

            // Lắp ráp URL gọi tới API tạo ảnh động của vietqr.io
            String qrUrl = String.format("https://img.vietqr.io/image/%s-%s-%s.png?amount=%s&addInfo=%s&accountName=%s",
                    BANK_ID, ACCOUNT_NO, TEMPLATE, amount, addInfo, encodedAccountName);

            // Trả chuỗi URL ảnh về cho trình duyệt
            String jsonResponse = "{\"qrUrl\": \"" + qrUrl + "\"}";
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi khởi tạo QR Code\"}");
        }
    }
}