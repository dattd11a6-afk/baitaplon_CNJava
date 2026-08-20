package com.fruitfarmermarket.filter;

import com.fruitfarmermarket.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/staff/*"})
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        String role = user.getRole(); // Cần đảm bảo Model User đã có phương thức getRole()

        if (path.startsWith("/admin") && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang Quản trị.");
            return;
        }

        if (path.startsWith("/staff") && !("STAFF".equals(role) || "ADMIN".equals(role))) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập nghiệp vụ Nhân viên.");
            return;
        }

        chain.doFilter(request, response);
    }
}