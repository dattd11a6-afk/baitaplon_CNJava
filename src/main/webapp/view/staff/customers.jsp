<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Tra cứu Khách hàng | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>:root { --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF; --sidebar-bg: #17231A; --sidebar-hover: rgba(220, 238, 216, 0.08); --border-color: #E5E9E3;} body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; } .sidebar { width: 250px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; } .sidebar-menu li a { display: flex; align-items: center; padding: 10px 20px; color: #9CA3AF; text-decoration: none; font-weight: 500; border-left: 3px solid transparent;} .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); } .sidebar-header { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); } .nav-group-label { font-size: 11px; color: #66736A; text-transform: uppercase; font-weight: 600; padding: 16px 20px 8px; margin-top: 8px; } .topbar { height: 64px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; } .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; } .staff-table th { background: #FAFAFA; color: #66736A; font-weight: 500; font-size: 11px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid var(--border-color); } .staff-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); }</style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="sidebar-header"><i class="ph-fill ph-storefront text-success fs-3 me-2"></i><div><div class="fw-bold fs-6 brand-font">Fruit Farmer</div><div style="font-size: 10px; color:#8E9992; letter-spacing: 1px;">STAFF PANEL</div></div></div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph ph-house"></i> Trang chủ</a></li>
            <div class="nav-group-label">Bán hàng</div>
            <li><a href="${pageContext.request.contextPath}/staff/pos"><i class="ph ph-monitor"></i> Đơn tại quầy (POS)</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph ph-receipt"></i> Quản lý đơn hàng</a></li>
            <div class="nav-group-label">Kho & Khách hàng</div>
            <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph ph-package"></i> Xem tồn kho</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph ph-users"></i> Tìm khách hàng</a></li>
            <div class="nav-group-label">Nhân sự</div>
            <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph ph-clock"></i> Ca làm & Chấm công</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center text-muted text-decoration-none fw-medium"><i class="ph ph-sign-out me-2 fs-5"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium"><i class="ph ph-users me-2"></i>Tra cứu Khách hàng</div></header>
        <div class="p-4">
            <h3 class="fw-bold mb-4 m-0" style="font-family: 'DM Sans', sans-serif;">Thông tin liên hệ Khách</h3>
            <div class="op-card p-0">
                <table class="table staff-table mb-0">
                    <thead><tr><th>Mã KH</th><th>Tên khách hàng</th><th>Số điện thoại</th><th>Email</th><th>Địa chỉ nhận hàng</th></tr></thead>
                    <tbody>
                        <c:forEach var="c" items="${customers}">
                            <tr>
                                <td class="text-muted fw-semibold">#KH${c.id}</td>
                                <td class="fw-bold text-dark"><i class="ph-fill ph-user-circle fs-4 text-primary me-2 align-middle"></i>${c.fullName}</td>
                                <td>${c.phone != null ? c.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</td>
                                <td>${c.email}</td>
                                <td><span class="text-truncate d-inline-block" style="max-width: 250px;">${c.address != null ? c.address : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body></html>