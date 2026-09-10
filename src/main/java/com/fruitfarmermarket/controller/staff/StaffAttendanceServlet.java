package com.fruitfarmermarket.controller.staff;

import com.fruitfarmermarket.dao.AttendanceDAO;
import com.fruitfarmermarket.model.Attendance;
import com.fruitfarmermarket.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/staff/attendance")
public class StaffAttendanceServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO = new AttendanceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User staff = (User) request.getSession().getAttribute("user");

        // Kiểm tra xem hôm nay đã check-in/out chưa
        Attendance today = attendanceDAO.getAttendanceToday(staff.getId());
        List<Attendance> history = attendanceDAO.getHistory(staff.getId());

        request.setAttribute("today", today);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/view/staff/attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User staff = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");

        if ("checkin".equals(action)) {
            if (attendanceDAO.checkIn(staff.getId())) {
                request.getSession().setAttribute("successMsg", "Check-in thành công! Chúc bạn ca làm việc hiệu quả.");
            } else {
                request.getSession().setAttribute("errorMsg", "Lỗi: Bạn đã check-in hôm nay rồi!");
            }
        } else if ("checkout".equals(action)) {
            if (attendanceDAO.checkOut(staff.getId())) {
                request.getSession().setAttribute("successMsg", "Check-out thành công! Nghỉ ngơi thôi nào.");
            } else {
                request.getSession().setAttribute("errorMsg", "Lỗi: Không thể check-out!");
            }
        }

        response.sendRedirect(request.getContextPath() + "/staff/attendance");
    }
}