<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh mục sản phẩm | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* ZOTECH CORE UI */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; --primary-dark: #163D2A;}
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

        /* CATEGORIES CSS */
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .search-box { position: relative; width: 300px; }
        .search-box i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #9CA3AF; font-size: 18px; }
        .search-box input { width: 100%; padding: 10px 16px 10px 44px; border-radius: 50px; border: 1px solid var(--z-border); background: #fff; font-size: 13px; transition: 0.3s; }
        .search-box input:focus { border-color: var(--primary); outline: none; box-shadow: 0 0 0 3px rgba(31, 157, 85, 0.1); }
        .btn-primary-custom { background: var(--primary-dark); color: #fff; border: none; padding: 10px 24px; border-radius: 50px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; transition: 0.3s;}
        .btn-primary-custom:hover { background: #0f291c; color: #fff; }

        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 16px; overflow: hidden; }
        .admin-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .admin-table th { padding: 18px 24px; color: #4B5563; background: #F8FAFC; text-transform: uppercase; font-size: 11px; font-weight: 700; border-bottom: 1px solid var(--z-border); }
        .admin-table td { padding: 20px 24px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; }
        .admin-table tbody tr:hover td { background-color: #F8FAFC; }
        .admin-table tbody tr:last-child td { border-bottom: none; }
        .cat-icon-wrapper { width: 40px; height: 40px; border-radius: 10px; background: #FFFBEB; color: #F59E0B; display: inline-flex; align-items: center; justify-content: center; font-size: 20px; margin-right: 12px; border: 1px solid #FEF3C7; }
        .id-badge { background: #F3F4F6; color: #4B5563; font-weight: 600; padding: 4px 10px; border-radius: 6px; font-size: 12px; }
        .badge-status { padding: 6px 12px; border-radius: 20px; font-weight: 600; font-size: 12px; display: inline-block; }
        .badge-active { background: #ECFDF5; color: #059669; border: 1px solid #A7F3D0; }
        .badge-inactive { background: #F3F4F6; color: #6B7280; border: 1px solid #E5E7EB; }
        .action-btns { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-icon { width: 36px; height: 36px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; border: 1px solid var(--z-border); background: var(--z-surface); color: #6B7280; transition: 0.2s; cursor: pointer; border: none;}
        .btn-icon:hover.edit { background: #EFF6FF; color: #2563EB; }
        .btn-icon:hover.delete { background: #FEF2F2; color: #DC2626; }
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
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <!-- ZOTECH MAIN WAPPER & HEADER -->
    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="z-topbar">
            <div class="d-flex align-items-center gap-3">
                <div class="search-box">
                    <i class="ph ph-magnifying-glass"></i>
                    <input type="text" id="searchInput" placeholder="Tìm nhanh danh mục...">
                </div>
            </div>
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
            <div class="page-header">
                <div>
                    <h2 class="fw-bold mb-2 brand-font text-dark" style="font-size: 28px;">Danh mục sản phẩm</h2>
                </div>
                <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="ph-bold ph-plus"></i> Thêm danh mục mới
                </button>
            </div>

            <div class="admin-card">
                <table class="admin-table" id="categoryTable">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Mã</th>
                            <th style="width: 30%;">Tên danh mục</th>
                            <th>Mô tả chi tiết</th>
                            <th class="text-center" style="width: 15%;">Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td><span class="id-badge">#${c.id}</span></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="cat-icon-wrapper"><i class="ph-fill ph-folder-open"></i></div>
                                        <span class="fw-bold text-dark fs-6">${c.name}</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="text-muted" style="max-width: 350px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;" title="${c.description}">
                                        ${empty c.description ? '<i>Không có mô tả</i>' : c.description}
                                    </div>
                                </td>
                                <td class="text-center">
                                    <span class="badge-status ${c.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">
                                        ${c.status == 'ACTIVE' ? '<i class="ph-fill ph-check-circle me-1"></i> Hoạt động' : '<i class="ph-fill ph-eye-slash me-1"></i> Đã ẩn'}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <button type="button" class="btn-icon edit" data-bs-toggle="modal" data-bs-target="#editCategoryModal${c.id}" title="Chỉnh sửa"><i class="ph-bold ph-pencil-simple"></i></button>
                                        <form action="${pageContext.request.contextPath}/admin/categories" method="POST" class="m-0 p-0" onsubmit="return confirm('Bạn có chắc chắn muốn xóa/ẩn danh mục [${c.name}] không?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${c.id}">
                                            <button type="submit" class="btn-icon delete" title="Xóa"><i class="ph-bold ph-trash"></i></button>
                                        </form>
                                    </div>
                                </td>
                            </tr>

                            <!-- MODAL SỬA -->
                            <div class="modal fade" id="editCategoryModal${c.id}">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content border-0 shadow-lg rounded-4">
                                        <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font text-dark fs-4">Cập nhật Danh mục</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                        <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${c.id}">
                                                <div class="mb-4"><label class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label><input type="text" name="name" class="form-control fw-bold text-dark" value="${c.name}" required></div>
                                                <div class="mb-4"><label class="form-label fw-semibold">Mô tả ngắn</label><textarea name="description" class="form-control" rows="4">${c.description}</textarea></div>
                                                <div class="mb-2"><label class="form-label fw-semibold">Trạng thái hiển thị</label><select name="status" class="form-select fw-medium"><option value="ACTIVE" ${c.status == 'ACTIVE' ? 'selected' : ''}>Kích hoạt (Hiển thị)</option><option value="INACTIVE" ${c.status == 'INACTIVE' ? 'selected' : ''}>Ẩn khỏi cửa hàng</option></select></div>
                                            </div>
                                            <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium px-4">Lưu thay đổi</button></div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty categories}">
                    <div class="text-center py-5">
                        <i class="ph-light ph-folder-dashed text-muted mb-3" style="font-size: 48px;"></i>
                        <h6 class="fw-bold text-dark">Chưa có danh mục nào</h6>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM -->
<div class="modal fade" id="addCategoryModal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font text-dark fs-4">Thêm Danh Mục Mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-4"><label class="form-label fw-semibold">Tên danh mục <span class="text-danger">*</span></label><input type="text" name="name" class="form-control" required></div>
                    <div class="mb-4"><label class="form-label fw-semibold">Mô tả ngắn</label><textarea name="description" class="form-control" rows="4"></textarea></div>
                    <div class="mb-2"><label class="form-label fw-semibold">Trạng thái hiển thị</label><select name="status" class="form-select fw-medium"><option value="ACTIVE">Kích hoạt</option><option value="INACTIVE">Lưu nháp (Ẩn)</option></select></div>
                </div>
                <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium px-4">Xác nhận tạo</button></div>
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
        let rows = document.querySelectorAll('#categoryTable tbody tr');
        rows.forEach(row => {
            let name = row.cells[1].innerText.toLowerCase();
            let desc = row.cells[2].innerText.toLowerCase();
            row.style.display = (name.includes(filter) || desc.includes(filter)) ? '' : 'none';
        });
    });
</script>
</body>
</html>