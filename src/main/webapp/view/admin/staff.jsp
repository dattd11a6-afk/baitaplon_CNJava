<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhân sự | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* ZOTECH CORE UI */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; --primary-dark: #163D2A;}
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

        .search-box { position: relative; width: 300px; }
        .search-box i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9CA3AF; font-size: 16px; }
        .search-box input { width: 100%; padding: 8px 16px 8px 38px; border-radius: 8px; border: 1px solid rgba(0,0,0,0.08); background: transparent; font-size: 13px; transition: 0.3s; color: var(--z-text-main); }
        .search-box input:focus { border-color: var(--primary); background: #fff; outline: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }

        .btn-primary-custom { background: var(--primary-dark); color: #fff; border: none; padding: 8px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; transition: 0.3s; }
        .btn-primary-custom:hover { background: #0f291c; color: #fff; transform: translateY(-1px); }

        /* TABLE STAFF CSS */
        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); overflow: hidden; }
        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0; min-width: 850px; }
        .admin-table th { padding: 12px 16px; color: #6B7280; background: #F8FAFC; text-transform: uppercase; font-size: 10px; font-weight: 700; border-bottom: 1px solid var(--z-border); white-space: nowrap; }
        .admin-table td { padding: 12px 16px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; font-size: 13px; transition: background 0.2s; }
        .admin-table tbody tr:hover td { background-color: #F8FAFC; }

        .badge-custom { padding: 4px 10px; border-radius: 6px; font-weight: 600; font-size: 11px; white-space: nowrap; display: inline-flex; align-items: center; gap: 4px; width: max-content; }
        .badge-active { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
        .badge-inactive { background: #F3F4F6; color: #6B7280; border: 1px solid #E5E7EB; }

        .action-btns { display: flex; gap: 6px; justify-content: flex-end; flex-wrap: nowrap; }
        .btn-action { width: 30px; height: 30px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; font-size: 15px; transition: 0.2s; border: 1px solid transparent; cursor: pointer; }
        .btn-action-view { color: #4F46E5; background: #EEF2FF; border-color: #C7D2FE; }
        .btn-action-view:hover { background: #E0E7FF; color: #4338CA; border-color: #A5B4FC; }
        .btn-action-del { color: #EF4444; background: #FEF2F2; border-color: #FECACA; }
        .btn-action-del:hover { background: #FEE2E2; color: #DC2626; border-color: #FCA5A5; }
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
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory-manager"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>
                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="z-topbar">
            <div class="d-flex align-items-center gap-3 w-50">
                <h5 class="fw-bold m-0 brand-font text-dark me-3">Nhân sự</h5>
                <div class="search-box">
                    <i class="ph ph-magnifying-glass"></i>
                    <input type="text" id="searchInput" placeholder="Tìm tên, sđt, email nhân viên...">
                </div>
            </div>

            <div class="d-flex align-items-center gap-4">
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="ph-bold ph-user-plus"></i> Tạo tài khoản
                </button>
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
            </div>
        </header>

        <div class="p-4 px-5">
            <div class="admin-card">
                <div class="table-responsive" style="overflow-x: auto;">
                    <table class="admin-table" id="staffTable">
                        <thead>
                            <tr>
                                <th style="width: 8%;">Mã NV</th>
                                <th style="width: 25%;">Hồ sơ nhân viên</th>
                                <th style="width: 22%;">Thông tin liên hệ</th>
                                <th style="width: 20%;">Vai trò / Chức vụ</th>
                                <th class="text-center" style="width: 15%;">Trạng thái</th>
                                <th class="text-end" style="width: 10%;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${staffList}">
                                <tr>
                                    <td><span class="badge bg-light text-secondary border px-2 py-1">#NV${s.id}</span></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img src="https://ui-avatars.com/api/?name=${s.fullName}&background=F4F7F6&color=1F9D55&rounded=true&bold=true" class="rounded-circle border flex-shrink-0" style="width: 36px; height: 36px; object-fit: cover;">
                                            <span class="fw-bold text-dark text-nowrap">${s.fullName}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-muted fw-medium"><i class="ph-fill ph-phone me-1 text-secondary"></i> ${s.phone}</div>
                                        <div class="text-muted"><i class="ph-fill ph-envelope-simple me-1 text-secondary"></i> ${s.email}</div>
                                    </td>
                                    <td>
                                        <span class="badge border ${s.role == 'ADMIN' ? 'bg-danger bg-opacity-10 text-danger border-danger border-opacity-25' : (s.role == 'SHIPPER' ? 'bg-primary bg-opacity-10 text-primary border-primary border-opacity-25' : 'bg-info bg-opacity-10 text-info-emphasis border-info border-opacity-25')} badge-custom">
                                            <i class="ph-fill ${s.role == 'ADMIN' ? 'ph-crown' : (s.role == 'SHIPPER' ? 'ph-motorcycle' : 'ph-identification-badge')}"></i>
                                            ${s.role == 'ADMIN' ? 'Quản trị viên' : (s.role == 'SHIPPER' ? 'Tài xế giao hàng' : 'Nhân viên bán hàng')}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge-custom ${s.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">
                                            <i class="ph-fill ${s.status == 'ACTIVE' ? 'ph-check-circle' : 'ph-lock-key'}"></i>
                                            ${s.status == 'ACTIVE' ? 'Đang làm việc' : 'Đã khóa'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button type="button" class="btn-action btn-action-view" data-bs-toggle="modal" data-bs-target="#editStaffModal${s.id}" title="Sửa"><i class="ph-bold ph-pencil-simple"></i></button>
                                            <c:if test="${sessionScope.user.id != s.id}">
                                                <form action="${pageContext.request.contextPath}/admin/staff" method="POST" class="m-0 p-0" onsubmit="return confirm('Khóa tài khoản [${s.fullName}]?');">
                                                    <input type="hidden" name="action" value="disable">
                                                    <input type="hidden" name="id" value="${s.id}">
                                                    <button type="submit" class="btn-action btn-action-del" title="Khóa"><i class="ph-bold ph-lock-key"></i></button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>

                                <!-- MODAL SỬA -->
                                <div class="modal fade" id="editStaffModal${s.id}">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow-lg rounded-4">
                                            <div class="modal-header border-bottom-0"><h6 class="fw-bold m-0 brand-font text-dark fs-5">Cập nhật Hồ sơ</h6><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                            <form action="${pageContext.request.contextPath}/admin/staff" method="POST">
                                                <div class="modal-body text-start">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="id" value="${s.id}">
                                                    <div class="mb-3"><label class="fw-medium mb-1">Họ và tên</label><input type="text" name="fullName" class="form-control fw-bold" value="${s.fullName}" required></div>
                                                    <div class="row g-3 mb-3">
                                                        <div class="col-md-6"><label class="fw-medium mb-1">SĐT</label><input type="text" name="phone" class="form-control" value="${s.phone}" required></div>
                                                        <div class="col-md-6"><label class="fw-medium mb-1">Email</label><input type="email" name="email" class="form-control text-muted" value="${s.email}" readonly></div>
                                                    </div>
                                                    <div class="mb-3"><label class="fw-medium mb-1">Đổi mật khẩu <small>(Để trống nếu không đổi)</small></label><input type="password" name="password" class="form-control"></div>
                                                    <div class="row g-3">
                                                        <div class="col-md-6"><label class="fw-medium mb-1">Chức vụ</label><select name="role" class="form-select"><option value="STAFF" ${s.role == 'STAFF' ? 'selected' : ''}>NV Bán hàng</option><option value="SHIPPER" ${s.role == 'SHIPPER' ? 'selected' : ''}>Shipper</option><option value="ADMIN" ${s.role == 'ADMIN' ? 'selected' : ''}>Admin</option></select></div>
                                                        <div class="col-md-6"><label class="fw-medium mb-1">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE" ${s.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option><option value="INACTIVE" ${s.status == 'INACTIVE' ? 'selected' : ''}>Khóa</option></select></div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium px-4 w-100">Lưu thay đổi</button></div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM TÀI KHOẢN -->
<div class="modal fade" id="addStaffModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-bottom-0"><h6 class="fw-bold m-0 brand-font text-dark fs-5">Tạo Tài Khoản Nhân Sự</h6><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <form action="${pageContext.request.contextPath}/admin/staff" method="POST">
                <div class="modal-body text-start">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3"><label class="fw-medium mb-1">Họ và tên *</label><input type="text" name="fullName" class="form-control" required></div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6"><label class="fw-medium mb-1">SĐT *</label><input type="text" name="phone" class="form-control" required></div>
                        <div class="col-md-6"><label class="fw-medium mb-1">Email *</label><input type="email" name="email" class="form-control" required></div>
                    </div>
                    <div class="mb-3"><label class="fw-medium mb-1">Mật khẩu tạm *</label><input type="password" name="password" class="form-control" required></div>
                    <div class="mb-3"><label class="fw-medium mb-1">Phân quyền</label><select name="role" class="form-select"><option value="STAFF">NV Bán hàng</option><option value="SHIPPER">Shipper</option><option value="ADMIN">Admin</option></select></div>
                </div>
                <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium w-100">Khởi tạo tài khoản</button></div>
            </form>
        </div>
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
    document.getElementById('searchInput').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let rows = document.querySelectorAll('#staffTable tbody tr');
        rows.forEach(row => {
            row.style.display = (row.cells[1].innerText.toLowerCase().includes(filter) || row.cells[2].innerText.toLowerCase().includes(filter)) ? '' : 'none';
        });
    });
</script>
</body>
</html>