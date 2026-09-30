package com.fruitfarmermarket.controller;

import com.fruitfarmermarket.dao.UserDAO;
import com.fruitfarmermarket.model.User;
import com.fruitfarmermarket.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        request.getRequestDispatcher("/view/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        String hashedPassword = PasswordUtil.hashPassword(password);
        User user = userDAO.login(email, hashedPassword);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if (remember != null && remember.equals("on")) {
                Cookie emailCookie = new Cookie("rememberedEmail", email);
                emailCookie.setMaxAge(30 * 24 * 60 * 60);
                response.addCookie(emailCookie);
            } else {
                Cookie emailCookie = new Cookie("rememberedEmail", "");
                emailCookie.setMaxAge(0);
                response.addCookie(emailCookie);
            }

            // TỰ ĐỘNG ĐIỀU HƯỚNG THEO ROLE
            String userRole = user.getRole().toUpperCase();
            switch (userRole) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case "STAFF":
                    response.sendRedirect(request.getContextPath() + "/staff/orders");
                    break;
                // BỔ SUNG LUỒNG SHIPPER
                case "SHIPPER":
                    response.sendRedirect(request.getContextPath() + "/shipper/home");
                    break;
                case "USER":
                case "CUSTOMER":
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/");
                    break;
            }
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác.");
            request.getRequestDispatcher("/view/user/login.jsp").forward(request, response);
        }
    }
}