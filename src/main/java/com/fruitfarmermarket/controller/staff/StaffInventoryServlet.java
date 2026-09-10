package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.ProductDAO;
import com.fruitfarmermarket.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/inventory")
public class StaffInventoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Dùng chung DAO với Admin nhưng View của Staff sẽ khóa chức năng Edit/Delete
        List<Product> products = new ProductDAO().getAllProductsForAdmin();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/view/staff/inventory.jsp").forward(request, response);
    }
}