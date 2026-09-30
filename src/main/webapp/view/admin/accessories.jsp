<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phụ kiện Mix Giỏ | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* ZOTECH CORE UI */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR */
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

        /* MAIN & HEADER */
        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); display: flex; flex-direction: column; min-height: 100vh;}
        .z-topbar { height: 70px; background: var(--z-surface); border-bottom: 1px solid var(--z-border); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; position: sticky; top: 0; z-index: 10; }

        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); overflow: hidden; }
        .nav-tabs-custom { border-bottom: 2px solid var(--z-border); display: flex; gap: 32px; padding: 0 24px; }
        .nav-tabs-custom .nav-link { color: var(--z-text-muted); font-weight: 600; font-size: 14px; padding: 16px 0; border: none; border-bottom: 3px solid transparent; background: transparent; cursor: pointer; transition: 0.2s; }
        .nav-tabs-custom .nav-link:hover { color: var(--primary); }
        .nav-tabs-custom .nav-link.active { color: var(--primary); border-bottom-color: var(--primary); }

        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 24px; color: var(--z-text-muted); background: #F8FAFC; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--z-border); text-align: left; }
        .admin-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px dashed var(--z-border); color: var(--z-text-main); text-align: left; }
        .admin-table tr:last-child td { border-bottom: none; }
        .admin-table tbody tr:hover { background-color: #F8FAFC; }

        .item-img { width: 50px; height: 50px; object-fit: contain; border: 1px solid var(--z-border); border-radius: 8px; background: #fff; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR ĐỒNG BỘ CÓ CLASS ACTIVE -->
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
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory-manager"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

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

        <div class="p-4 px-5 pb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div><h2 class="fw-bold mb-0 brand-font text-dark" style="font-size: 28px;">Phụ kiện Mix Giỏ Quà</h2></div>
                <button class="btn btn-success fw-bold px-4" data-bs-toggle="modal" data-bs-target="#addModal"><i class="ph-bold ph-plus me-1"></i> Thêm Phụ kiện</button>
            </div>

            <div class="admin-card">
                <ul class="nav nav-tabs-custom" id="myTab" role="tablist">
                    <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#baskets">Vỏ Giỏ</button></li>
                    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#decorations">Đồ Trang Trí</button></li>
                    <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#packagings">Vật liệu Đóng Gói</button></li>
                </ul>

                <div class="tab-content">
                    <!-- TAB VỎ GIỎ -->
                    <div class="tab-pane fade show active" id="baskets">
                        <table class="admin-table">
                            <thead><tr><th style="width: 15%;">Ảnh minh họa</th><th>Tên vỏ giỏ</th><th>Mô tả</th><th class="text-end">Giá cộng thêm (VNĐ)</th><th class="text-center" style="width: 10%;">Xóa</th></tr></thead>
                            <tbody>
                                <c:forEach var="item" items="${baskets}">
                                    <tr>
                                        <td><img src="${item.image}" class="item-img" onerror="this.onerror=null; this.src='https://placehold.co/100x100?text=No+Image';"></td>
                                        <td class="fw-bold text-dark">${item.name}</td>
                                        <td class="text-muted">${item.description}</td>
                                        <td class="text-end fw-bold text-success"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa Vỏ giỏ này?');">
                                                <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="basket"><input type="hidden" name="id" value="${item.id}">
                                                <button class="btn btn-sm btn-light border text-danger"><i class="ph-bold ph-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- TAB TRANG TRÍ -->
                    <div class="tab-pane fade" id="decorations">
                        <table class="admin-table">
                            <thead><tr><th style="width: 15%;">Ảnh minh họa</th><th>Tên đồ trang trí</th><th>Mô tả</th><th class="text-end">Giá cộng thêm (VNĐ)</th><th class="text-center" style="width: 10%;">Xóa</th></tr></thead>
                            <tbody>
                                <c:forEach var="item" items="${decorations}">
                                    <tr>
                                        <td><img src="${item.image}" class="item-img" onerror="this.onerror=null; this.src='https://placehold.co/100x100?text=No+Image';"></td>
                                        <td class="fw-bold text-dark">${item.name}</td>
                                        <td class="text-muted">${item.description}</td>
                                        <td class="text-end fw-bold text-success"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa Đồ trang trí này?');">
                                                <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="decoration"><input type="hidden" name="id" value="${item.id}">
                                                <button class="btn btn-sm btn-light border text-danger"><i class="ph-bold ph-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- TAB ĐÓNG GÓI -->
                    <div class="tab-pane fade" id="packagings">
                         <table class="admin-table">
                            <thead><tr><th style="width: 15%;">Ảnh minh họa</th><th>Tên đóng gói</th><th>Mô tả</th><th class="text-end">Giá cộng thêm (VNĐ)</th><th class="text-center" style="width: 10%;">Xóa</th></tr></thead>
                            <tbody>
                                <c:forEach var="item" items="${packagings}">
                                    <tr>
                                        <td><img src="${item.image}" class="item-img" onerror="this.onerror=null; this.src='https://placehold.co/100x100?text=No+Image';"></td>
                                        <td class="fw-bold text-dark">${item.name}</td>
                                        <td class="text-muted">${item.description}</td>
                                        <td class="text-end fw-bold text-success"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa Vật liệu này?');">
                                                <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="packaging"><input type="hidden" name="id" value="${item.id}">
                                                <button class="btn btn-sm btn-light border text-danger"><i class="ph-bold ph-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM MỚI -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="modal-content rounded-4 border-0 shadow-lg">
            <input type="hidden" name="action" value="add">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="fw-bold brand-font m-0 text-dark">Thêm phụ kiện mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4">
                <div class="mb-3">
                    <label class="form-label fw-bold">Phân loại phụ kiện</label>
                    <select name="type" class="form-select bg-light" required>
                        <option value="basket">Vỏ Giỏ</option><option value="decoration">Đồ Trang Trí</option><option value="packaging">Vật liệu Đóng Gói</option>
                    </select>
                </div>
                <div class="mb-3"><label class="form-label fw-bold">Tên phụ kiện</label><input type="text" name="name" class="form-control" required></div>
                <div class="mb-3"><label class="form-label fw-bold">Mức giá cộng thêm (VNĐ)</label><input type="number" name="price" class="form-control" value="0" required></div>
                <div class="mb-3"><label class="form-label fw-bold">Link Ảnh URL (Tùy chọn)</label><input type="text" name="image" class="form-control" placeholder="https://..."></div>
                <div class="mb-2"><label class="form-label fw-bold">Mô tả thêm</label><textarea name="description" class="form-control" rows="2"></textarea></div>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="submit" class="btn btn-success fw-bold w-100 py-2">LƯU PHỤ KIỆN</button>
            </div>
        </form>
    </div>
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
<script>
    document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); });
</script>
</body>
</html>