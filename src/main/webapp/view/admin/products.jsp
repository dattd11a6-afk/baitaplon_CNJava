<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý Sản phẩm | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* ZOTECH CORE UI */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* ZOTECH SIDEBAR */
        .sidebar { width: 250px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 13px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        /* ZOTECH MAIN & HEADER */
        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); display: flex; flex-direction: column; min-height: 100vh;}
        .z-topbar { height: 70px; background: var(--z-surface); border-bottom: 1px solid var(--z-border); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; position: sticky; top: 0; z-index: 10; }

        /* TABLE PRODUCTS CSS */
        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 8px; box-shadow: none; overflow: hidden; }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 24px; color: var(--z-text-muted); background: #F8FAFC; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--z-border); text-align: left; }
        .admin-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid var(--z-border); color: var(--z-text-main); text-align: left; }
        .col-number { text-align: right !important; font-family: 'DM Sans', sans-serif; font-weight: 600; }
        .product-mini-img { width: 42px; height: 42px; object-fit: cover; border-radius: 6px; border: 1px solid var(--z-border); background: #fff;}
        .action-btns { display: flex; gap: 6px; justify-content: flex-end; }
        .btn-icon { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid var(--z-border); background: var(--z-surface); transition: 0.2s; text-decoration: none; cursor: pointer; padding: 0;}
        .btn-icon:hover.edit { background: #E0F2FE; color: #0284C7; border-color: #BAE6FD; }
        .btn-icon:hover.delete { background: #FEE2E2; color: #DC2626; border-color: #FECACA; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- ZOTECH SIDEBAR ĐỒNG BỘ -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), #10B981);">
                <i class="ph-bold ph-leaf text-white fs-6"></i>
            </div>
            <div><div class="fw-bold fs-6 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div></div>
        </div>
        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo</a></li>

                <div class="menu-label">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>

                <div class="menu-label">Kho & Vận hành</div>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <!-- ZOTECH MAIN & HEADER -->
    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="z-topbar">
            <div class="d-flex align-items-center gap-3"></div>
            <div class="dropdown border-start ps-4">
                <a href="#" class="d-flex align-items-center text-decoration-none text-dark dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" style="outline: none;">
                    <div class="d-flex flex-column text-end me-2">
                        <span class="fw-bold" style="font-size: 13px;">${not empty sessionScope.user ? sessionScope.user.fullName : 'Admin'}</span>
                        <span class="text-muted" style="font-size: 11px;">Quản trị viên</span>
                    </div>
                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; font-weight: bold; font-size: 15px;">
                        ${not empty sessionScope.user ? fn:substring(sessionScope.user.fullName, 0, 1) : 'A'}
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3" style="border-radius: 8px;">
                    <li><a class="dropdown-item py-2 fw-medium" style="font-size: 13px;" href="${pageContext.request.contextPath}/profile"><i class="ph-bold ph-user me-2"></i> Hồ sơ cá nhân</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item py-2 fw-medium text-danger" style="font-size: 13px;" href="${pageContext.request.contextPath}/logout"><i class="ph-bold ph-sign-out me-2"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="p-4 px-5 overflow-auto">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold mb-1 brand-font text-dark">Sản phẩm</h2>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-primary fw-medium"><i class="ph ph-box-arrow-down fw-bold me-1"></i> Lập Phiếu Nhập</a>
                    <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-success fw-medium"><i class="ph ph-plus fw-bold me-1"></i> Thêm sản phẩm</a>
                </div>
            </div>

            <div class="admin-card p-0 overflow-hidden">
                <table class="admin-table">
                    <thead><tr><th>Sản phẩm</th><th>Danh mục</th><th class="col-number">Giá bán</th><th class="col-number">Tồn kho</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <c:set var="imgs" value="${fn:split(p.image, ',')}" />
                                        <c:set var="fallbackImg" value="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200" />
                                        <c:choose>
                                            <c:when test="${not empty imgs[0] && fn:startsWith(fn:trim(imgs[0]), 'http')}">
                                                <img src="${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:when test="${not empty imgs[0]}">
                                                <img src="${pageContext.request.contextPath}/assets/images/${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:otherwise><img src="${fallbackImg}" class="product-mini-img"></c:otherwise>
                                        </c:choose>
                                        <div class="fw-semibold text-dark">${p.name}</div>
                                    </div>
                                </td>
                                <td class="text-muted">${p.categoryName}</td>
                                <td class="col-number text-dark"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> / ${p.unit}</td>
                                <td class="col-number"><span class="${p.stock <= 5 ? 'text-danger fw-bold' : 'text-dark'}">${p.stock}</span></td>
                                <td><span class="badge border ${p.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} px-2 py-1">${p.status}</span></td>
                                <td>
                                    <div class="action-btns">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="btn-icon edit text-primary" title="Sửa"><i class="ph ph-pencil-simple"></i></a>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="POST" class="m-0 p-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm [${p.name}]?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn-icon delete text-muted" title="Xóa"><i class="ph ph-trash"></i></button>
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

<!-- TOAST THÔNG BÁO ĐỒNG BỘ -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-medium px-3 py-2 d-flex align-items-center" style="font-size: 14px;">
                    <i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}
                </div>
                <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-medium px-3 py-2 d-flex align-items-center" style="font-size: 14px;">
                    <i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}
                </div>
                <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script> document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); }); </script>
</body>
</html>