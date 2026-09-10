<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Danh mục sản phẩm | Fruit Admin</title>
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
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 10px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }

        .action-btns { display: flex; gap: 6px; justify-content: flex-end; }
        .btn-icon { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; border: 1px solid var(--border-color); background: var(--surface); transition: 0.2s; text-decoration: none; cursor: pointer; padding: 0;}
        .btn-icon:hover.edit { background: #E0F2FE; color: #0284C7; border-color: #BAE6FD; }
        .btn-icon:hover.delete { background: #FEE2E2; color: #DC2626; border-color: #FECACA; }
    </style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <i class="ph-fill ph-leaf fs-3" style="color: var(--primary);"></i>
            <div><div class="fw-bold fs-6 brand-font">Fruit Farmer</div><div style="font-size: 10px; color:#9CA3AF; letter-spacing: 1px;">ADMIN CONSOLE</div></div>
        </div>
        <ul class="sidebar-menu mt-4">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph ph-squares-four"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph ph-receipt"></i> Đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph ph-package"></i> Sản phẩm</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph ph-tag"></i> Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted">Hệ thống Quản trị</div></header>
        <div class="p-4 px-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold mb-1 brand-font text-dark">Danh mục sản phẩm</h2>
                    <p class="text-muted mb-0">Quản lý các nhóm phân loại hiển thị trên cửa hàng.</p>
                </div>
                <!-- Đã sửa thành nút gọi Popup Modal -->
                <button class="btn btn-success fw-medium" data-bs-toggle="modal" data-bs-target="#addCategoryModal"><i class="ph ph-plus fw-bold me-1"></i> Thêm danh mục</button>
            </div>

            <div class="admin-card p-0">
                <table class="admin-table mb-0">
                    <thead>
                        <tr><th style="width: 80px;">ID</th><th>Tên danh mục</th><th>Mô tả</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td class="text-muted fw-medium">#${c.id}</td>
                                <td class="fw-bold text-dark"><i class="ph-fill ph-folder-open text-warning me-2 fs-5 align-middle"></i>${c.name}</td>
                                <td class="text-muted" style="max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${c.description}</td>
                                <td><span class="badge border ${c.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} px-2 py-1">${c.status == 'ACTIVE' ? 'Hoạt động' : 'Đã ẩn'}</span></td>
                                <td>
                                    <div class="action-btns">
                                        <!-- Nút sửa gọi Modal -->
                                        <button class="btn-icon edit text-primary" data-bs-toggle="modal" data-bs-target="#editCategoryModal${c.id}" title="Sửa danh mục"><i class="ph ph-pencil-simple"></i></button>
                                        <form action="${pageContext.request.contextPath}/admin/categories" method="POST" class="m-0 p-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa/ẩn danh mục [${c.name}] không?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <button type="submit" class="btn-icon delete text-muted" title="Xóa"><i class="ph ph-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>

                            <!-- MODAL SỬA DANH MỤC -->
                            <div class="modal fade" id="editCategoryModal${c.id}">
                                <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
                                    <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Sửa Danh Mục</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                    <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                                        <div class="modal-body text-start">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <div class="mb-3"><label class="form-label fw-medium">Tên danh mục <span class="text-danger">*</span></label><input type="text" name="name" class="form-control" value="${c.name}" required></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Mô tả</label><textarea name="description" class="form-control" rows="3">${c.description}</textarea></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE" ${c.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option><option value="INACTIVE" ${c.status == 'INACTIVE' ? 'selected' : ''}>Ẩn</option></select></div>
                                        </div>
                                        <div class="modal-footer border-0"><button type="submit" class="btn btn-success w-100">Cập nhật</button></div>
                                    </form>
                                </div></div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM DANH MỤC -->
<div class="modal fade" id="addCategoryModal">
    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
        <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Thêm Danh Mục Mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
            <div class="modal-body text-start">
                <input type="hidden" name="action" value="add">
                <div class="mb-3"><label class="form-label fw-medium">Tên danh mục <span class="text-danger">*</span></label><input type="text" name="name" class="form-control" required placeholder="VD: Trái cây nhập khẩu"></div>
                <div class="mb-3"><label class="form-label fw-medium">Mô tả</label><textarea name="description" class="form-control" rows="3" placeholder="Nhập mô tả ngắn..."></textarea></div>
                <div class="mb-3"><label class="form-label fw-medium">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE">Hoạt động</option><option value="INACTIVE">Ẩn</option></select></div>
            </div>
            <div class="modal-footer border-0"><button type="submit" class="btn btn-success w-100">Lưu danh mục</button></div>
        </form>
    </div></div>
</div>

<!-- TOAST -->
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
<script> document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); }); </script>
</body>
</html>