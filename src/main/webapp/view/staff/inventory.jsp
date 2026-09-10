<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Tra cứu Kho | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>:root { --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF; --sidebar-bg: #17231A; --sidebar-hover: rgba(220, 238, 216, 0.08); --border-color: #E5E9E3;} body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; } .sidebar { width: 250px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; } .sidebar-menu li a { display: flex; align-items: center; padding: 10px 20px; color: #9CA3AF; text-decoration: none; font-weight: 500; border-left: 3px solid transparent;} .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); } .sidebar-header { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); } .nav-group-label { font-size: 11px; color: #66736A; text-transform: uppercase; font-weight: 600; padding: 16px 20px 8px; margin-top: 8px; } .topbar { height: 64px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; } .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; } .staff-table th { background: #FAFAFA; color: #66736A; font-weight: 500; font-size: 11px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid var(--border-color); } .staff-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); } .product-thumbnail { width: 35px; height: 35px; border-radius: 6px; object-fit: cover; border: 1px solid var(--border-color); background: #FAFAFA;}</style>
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
            <li class="active"><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph ph-package"></i> Xem tồn kho</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph ph-users"></i> Tìm khách hàng</a></li>
            <div class="nav-group-label">Nhân sự</div>
            <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph ph-clock"></i> Ca làm & Chấm công</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center text-muted text-decoration-none fw-medium"><i class="ph ph-sign-out me-2 fs-5"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium"><i class="ph ph-package me-2"></i>Tra cứu Tồn kho</div></header>
        <div class="p-4">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h3 class="fw-bold m-0" style="font-family: 'DM Sans', sans-serif;">Kiểm tra Sản phẩm</h3>
            </div>

            <div class="op-card p-0">
                <table class="table staff-table mb-0">
                    <thead><tr><th>Sản phẩm</th><th>Danh mục</th><th>Đơn giá</th><th>Số lượng Tồn kho</th><th>Trạng thái</th></tr></thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <c:choose>
                                            <c:when test="${not empty p.image && fn:startsWith(p.image, 'http')}"><img src="${p.image}" class="product-thumbnail"></c:when>
                                            <c:when test="${not empty p.image}"><img src="${pageContext.request.contextPath}/assets/images/products/${p.image}" class="product-thumbnail"></c:when>
                                            <c:otherwise><img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200&auto=format&fit=crop" class="product-thumbnail"></c:otherwise>
                                        </c:choose>
                                        <div class="fw-semibold">${p.name}</div>
                                    </div>
                                </td>
                                <td class="text-muted">${p.categoryName}</td>
                                <td class="fw-medium"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> / ${p.unit}</td>
                                <td>
                                    <!-- Cảnh báo nếu tồn kho thấp -->
                                    <div class="${p.stock <= 5 ? 'text-danger fw-bold fs-6' : 'text-dark fw-semibold fs-6'}">${p.stock}</div>
                                    <c:choose>
                                        <c:when test="${p.stock == 0}"><span class="badge bg-danger text-white mt-1">Hết hàng</span></c:when>
                                        <c:when test="${p.stock <= 5}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle mt-1" style="font-size: 10px;">Sắp hết</span></c:when>
                                    </c:choose>
                                </td>
                                <td><span class="badge ${p.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${p.status}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body></html>