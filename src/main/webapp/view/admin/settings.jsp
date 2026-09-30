<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cấu hình Hệ thống | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F4F7F6; --surface: #FFFFFF; --text-main: #1E293B; --border-color: #E2E8F0; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        .sidebar { width: 250px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 1000;}
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 13px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); }
        .topbar { height: 70px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; position: sticky; top: 0; z-index: 10;}
        .op-card { background: var(--surface); border-radius: 12px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); border: 1px solid var(--border-color);}
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), #10B981);">
                <i class="ph-bold ph-leaf text-white fs-6"></i>
            </div>
            <div class="fw-bold fs-6 brand-font text-white">Fruit Farmer</div>
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
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory-manager"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="topbar">
            <h5 class="fw-bold m-0 brand-font text-dark">Cấu hình Hệ thống (Cước & Thuế)</h5>
            <div class="d-flex align-items-center gap-4">
                <div class="dropdown border-start ps-4">
                    <a href="#" class="d-flex align-items-center text-decoration-none text-dark dropdown-toggle" data-bs-toggle="dropdown">
                        <div class="d-flex flex-column text-end me-2">
                            <span class="fw-bold" style="font-size: 13px;">${sessionScope.user.fullName}</span>
                            <span class="text-muted" style="font-size: 11px;">Quản trị viên</span>
                        </div>
                        <div class="rounded-circle text-white d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; background-color: var(--primary); font-weight: bold;">
                            ${fn:substring(sessionScope.user.fullName, 0, 1)}
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                        <li><a class="dropdown-item py-2 fw-medium" style="font-size: 13px;" href="${pageContext.request.contextPath}/profile"><i class="ph-bold ph-user me-2"></i> Hồ sơ cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="p-4">
            <div class="op-card">
                <form action="${pageContext.request.contextPath}/admin/settings" method="POST">

                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-4"><i class="ph-fill ph-receipt text-primary me-2"></i> Cấu hình Thuế (VAT)</h6>
                    <div class="row mb-5">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Mức thuế VAT (%)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" name="TAX_RATE" value="${settings['TAX_RATE']}" min="0" max="100" required>
                                <span class="input-group-text bg-light">%</span>
                            </div>
                            <div class="form-text mt-2">Áp dụng mặc định ở Việt Nam là 8% hoặc 10%.</div>
                        </div>
                    </div>

                    <h6 class="fw-bold text-dark border-bottom pb-2 mb-4"><i class="ph-fill ph-truck text-primary me-2"></i> Cước phí Giao hàng</h6>
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Giao hàng Tiêu chuẩn (2-3 ngày)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" name="SHIP_STANDARD" value="${settings['SHIP_STANDARD']}" min="0" required>
                                <span class="input-group-text bg-light">VNĐ</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-danger">Giao hàng Hỏa tốc (Nhận ngay trong 2H)</label>
                            <div class="input-group">
                                <input type="number" class="form-control border-danger" name="SHIP_EXPRESS" value="${settings['SHIP_EXPRESS']}" min="0" required>
                                <span class="input-group-text bg-danger bg-opacity-10 text-danger border-danger">VNĐ</span>
                            </div>
                        </div>
                    </div>

                    <div class="text-end mt-4 pt-3 border-top">
                        <button type="submit" class="btn text-white fw-bold px-5 py-2" style="background: var(--primary);">LƯU CẤU HÌNH</button>
                    </div>
                </form>
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
<script>
    document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); });
</script>
</body>
</html>