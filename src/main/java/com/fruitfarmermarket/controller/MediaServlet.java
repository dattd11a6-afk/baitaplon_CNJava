package com.fruitfarmermarket.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

// Bất cứ khi nào URL có dạng /uploads/... thì Servlet này sẽ bắt lấy
@WebServlet("/uploads/*")
public class MediaServlet extends HttpServlet {

    // Đường dẫn tuyệt đối tới thư mục của sếp trên ổ C
    private static final String UPLOAD_DIR = "C:/uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Cắt lấy tên file từ URL (VD: /uploads/tao-envy.jpg -> lấy chữ "tao-envy.jpg")
        String filename = request.getPathInfo();
        if (filename == null || filename.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Bỏ dấu gạch chéo đầu tiên để ghép chuỗi
        filename = filename.substring(1);
        File file = new File(UPLOAD_DIR, filename);

        // Kiểm tra xem file có tồn tại trong C:/uploads không
        if (file.exists()) {
            // Tự động nhận diện định dạng file (ảnh jpg, png hay video mp4) để trình duyệt hiển thị đúng
            String mimeType = getServletContext().getMimeType(filename);
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            response.setContentType(mimeType);

            // Đọc file từ ổ C và bắn thẳng ra giao diện web
            Files.copy(file.toPath(), response.getOutputStream());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}