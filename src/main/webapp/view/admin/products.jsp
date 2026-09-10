<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý Sản phẩm | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --sidebar-bg: #111827; --sidebar-hover: rgba(255,255,255,0.08); --border-color: #EAEAEC; --text-main: #1F2937; --text-muted: #6B7280; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 14px; }
        .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); }
        .topbar { height: 70px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 40px; }
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: none; overflow: hidden; }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 24px; color: var(--text-muted); background: #F9FAFB; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--border-color); text-align: left; }
        .admin-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-main); text-align: left; }
        .col-number { text-align: right !important; font-family: 'DM Sans', sans-serif; font-weight: 600; }
        .product-mini-img { width: 42px; height: 42px; object-fit: cover; border-radius: 6px; border: 1px solid var(--border-color); background: #fff;}
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 10px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }
        /* Tùy chỉnh Nút Thao tác */
        .action-btns { display: flex; gap: 6px; justify-content: flex-end; }
        .btn-icon { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid var(--border-color); background: var(--surface); transition: 0.2s; text-decoration: none; cursor: pointer; padding: 0;}
        .btn-icon:hover.edit { background: #E0F2FE; color: #0284C7; border-color: #BAE6FD; }
        .btn-icon:hover.delete { background: #FEE2E2; color: #DC2626; border-color: #FECACA; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <i class="ph-fill ph-leaf fs-3" style="color: var(--primary);"></i>
            <div><div class="fw-bold fs-6 brand-font">Fruit Farmer</div><div style="font-size: 10px; color:#9CA3AF; letter-spacing: 1px;">ADMIN CONSOLE</div></div>
        </div>
        <ul class="sidebar-menu mt-4">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph ph-squares-four"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph ph-receipt"></i> Đơn hàng</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/products"><i class="ph ph-package"></i> Sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph ph-tag"></i> Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 d-flex flex-column" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted"></div></header>
        <div class="p-4 px-5 overflow-auto">

            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold mb-1 brand-font text-dark">Sản phẩm</h2>
                    <p class="text-muted mb-0">Quản lý danh sách trái cây, giá bán và tồn kho.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-success fw-medium"><i class="ph ph-plus fw-bold me-1"></i> Thêm sản phẩm</a>
            </div>

            <!-- BẢNG SẢN PHẨM -->
            <div class="admin-card p-0 overflow-hidden">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Danh mục</th>
                            <th class="col-number">Giá bán</th>
                            <th class="col-number">Tồn kho</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <c:set var="imgs" value="${fn:split(p.image, ',')}" />
                                        <c:set var="fallbackImg" value="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200" />

                                        <!-- FIX LỖI RÁCH ẢNH: Thêm onerror tự động thế ảnh phụ vào nếu ảnh chính lỗi -->
                                        <c:choose>
                                            <c:when test="${not empty imgs[0] && fn:startsWith(fn:trim(imgs[0]), 'http')}">
                                                <img src="${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:when test="${not empty imgs[0]}">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${fallbackImg}" class="product-mini-img">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="fw-semibold text-dark">${p.name}</div>
                                    </div>
                                </td>
                                <td class="text-muted">${p.categoryName}</td>
                                <td class="col-number text-dark"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> / ${p.unit}</td>
                                <td class="col-number"><span class="${p.stock <= 5 ? 'text-danger fw-bold' : 'text-dark'}">${p.stock}</span></td>
                                <td>
                                    <span class="badge border ${p.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} px-2 py-1">${p.status}</span>
                                </td>

                                <!-- CỘT THAO TÁC (SỬA + XÓA) -->
                                <td>
                                    <div class="action-btns">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="btn-icon edit text-primary" title="Sửa">
                                            <i class="ph ph-pencil-simple"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="m-0 p-0" onsubmit="return confirm('⚠️ CẢNH BÁO:\nBạn có chắc chắn muốn xóa sản phẩm [${p.name}] không?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn-icon delete text-muted" title="Xóa">
                                                <i class="ph ph-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- TOAST THÔNG BÁO -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); });
</script>
</body>
</html>