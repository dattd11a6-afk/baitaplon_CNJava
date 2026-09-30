package com.fruitfarmermarket.filter;

import com.fruitfarmermarket.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// BẮT THÊM URL CỦA SHIPPER ĐỂ BẢO VỆ
@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/shipper/*"})
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getRequestURI();
        HttpSession session = req.getSession();

        if (path.startsWith(req.getContextPath() + "/assets") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") ||
                path.endsWith(".jpeg") || path.endsWith(".mp4")) {
            chain.doFilter(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String servletPath = req.getServletPath();
        String role = user.getRole();

        if (role == null) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Tài khoản của bạn chưa được phân quyền.");
            return;
        }

        // Quyền Admin: Không được phép vào khu vực Shipper
        if (servletPath.startsWith("/admin") && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang Quản trị.");
            return;
        }

        // Quyền Staff: Admin được phép vào ké để kiểm tra, nhưng cấm tuyệt đối Shipper
        if (servletPath.startsWith("/staff") && !("STAFF".equals(role) || "ADMIN".equals(role))) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập nghiệp vụ Nhân viên.");
            return;
        }

        // phân quyền riêng cho shipper
        if (servletPath.startsWith("/shipper") && !"SHIPPER".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Giao diện này thiết kế riêng cho Mobile App của Shipper.");
            return;
        }

        chain.doFilter(request, response);
    }
}