<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Khuyến mãi | Fruit Admin</title>
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
        .admin-table th { padding: 16px 20px; color: var(--text-muted); background: #F9FAFB; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--border-color); text-align: left; }
        .admin-table td { padding: 16px 20px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-main); text-align: left; }
        .col-number { text-align: right !important; font-family: 'DM Sans', sans-serif; font-weight: 600; }
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 10px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }
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
            <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph ph-tag"></i> Danh mục</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted"></div></header>
        <div class="p-4 px-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h2 class="fw-bold m-0 brand-font text-dark">Mã Khuyến Mãi</h2>
                <button class="btn btn-success fw-medium" data-bs-toggle="modal" data-bs-target="#addVoucherModal"><i class="ph ph-plus me-1"></i> Thêm Voucher</button>
            </div>

            <div class="admin-card p-0">
                <table class="admin-table mb-0">
                    <thead><tr><th>Mã Code</th><th>Loại</th><th class="col-number">Mức giảm</th><th class="col-number">Giới hạn dùng</th><th>Hạn sử dụng</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                    <tbody>
                        <c:forEach var="v" items="${vouchers}">
                            <tr>
                                <td class="fw-bold text-success"><i class="ph-fill ph-ticket me-2"></i>${v.code}</td>

                                <!-- Hiển thị Badge theo Loại Voucher -->
                                <td>
                                    <c:choose>
                                        <c:when test="${v.type == 'PERCENT'}"><span class="badge bg-info text-dark">Giảm %</span></c:when>
                                        <c:when test="${v.type == 'AMOUNT'}"><span class="badge bg-warning text-dark">Giảm tiền</span></c:when>
                                        <c:when test="${v.type == 'FREE_SHIP'}"><span class="badge bg-primary">Freeship</span></c:when>
                                    </c:choose>
                                </td>

                                <td class="col-number text-danger">
                                    <c:choose>
                                        <c:when test="${v.type == 'PERCENT'}">- <fmt:formatNumber value="${v.discountValue}" maxFractionDigits="0"/> %</c:when>
                                        <c:otherwise>- <fmt:formatNumber value="${v.discountValue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="col-number">${v.usedCount} / ${v.usageLimit}</td>
                                <td><fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                <td><span class="badge border ${v.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} px-2 py-1">${v.status}</span></td>
                                <td class="text-end">
                                    <button class="btn btn-sm btn-light border text-primary" data-bs-toggle="modal" data-bs-target="#editVoucherModal${v.id}"><i class="ph ph-pencil-simple"></i></button>
                                    <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn xóa vĩnh viễn?');">
                                        <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${v.id}">
                                        <button type="submit" class="btn btn-sm btn-light border text-danger"><i class="ph ph-trash"></i></button>
                                    </form>
                                </td>
                            </tr>

                            <!-- MODAL SỬA VOUCHER -->
                            <div class="modal fade" id="editVoucherModal${v.id}">
                                <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
                                    <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Sửa Voucher</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                    <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST">
                                        <div class="modal-body text-start">
                                            <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${v.id}">
                                            <div class="mb-3"><label class="form-label">Mã Code</label><input type="text" name="code" class="form-control text-uppercase fw-bold" value="${v.code}" required></div>

                                            <div class="row">
                                                <div class="col-6 mb-3">
                                                    <label class="form-label">Loại Voucher</label>
                                                    <select name="type" class="form-select">
                                                        <option value="AMOUNT" ${v.type == 'AMOUNT' ? 'selected' : ''}>Giảm số tiền</option>
                                                        <option value="PERCENT" ${v.type == 'PERCENT' ? 'selected' : ''}>Giảm phần trăm (%)</option>
                                                        <option value="FREE_SHIP" ${v.type == 'FREE_SHIP' ? 'selected' : ''}>Miễn phí vận chuyển</option>
                                                    </select>
                                                </div>
                                                <div class="col-6 mb-3"><label class="form-label">Giá trị giảm</label><input type="number" name="discountValue" class="form-control" value="${v.discountValue}" min="0" required></div>
                                            </div>

                                            <div class="row">
                                                <div class="col-6 mb-3"><label class="form-label">Đơn tối thiểu (VNĐ)</label><input type="number" name="minOrderAmount" class="form-control" value="${v.minOrderAmount}" min="0"></div>
                                                <div class="col-6 mb-3"><label class="form-label">Giảm tối đa (VNĐ)</label><input type="number" name="maxDiscountAmount" class="form-control" value="${v.maxDiscountAmount}" min="0"></div>
                                            </div>

                                            <div class="row">
                                                <div class="col-6 mb-3"><label class="form-label">Lượt dùng tối đa</label><input type="number" name="usageLimit" class="form-control" value="${v.usageLimit}" min="1" required></div>
                                                <div class="col-6 mb-3"><label class="form-label">Ngày hết hạn</label><input type="date" name="expiryDate" class="form-control" value="${fn:substring(v.expiryDate, 0, 10)}" required></div>
                                            </div>

                                            <div class="mb-3"><label class="form-label">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE" ${v.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option><option value="INACTIVE" ${v.status == 'INACTIVE' ? 'selected' : ''}>Khóa</option></select></div>
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

<!-- MODAL THÊM VOUCHER -->
<div class="modal fade" id="addVoucherModal">
    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
        <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Tạo Voucher Mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST">
            <div class="modal-body text-start">
                <input type="hidden" name="action" value="add">
                <div class="mb-3"><label class="form-label">Mã Code</label><input type="text" name="code" class="form-control text-uppercase fw-bold" required></div>

                <div class="row">
                    <div class="col-6 mb-3">
                        <label class="form-label">Loại Voucher</label>
                        <select name="type" class="form-select">
                            <option value="AMOUNT">Giảm số tiền</option>
                            <option value="PERCENT">Giảm phần trăm (%)</option>
                            <option value="FREE_SHIP">Miễn phí vận chuyển</option>
                        </select>
                    </div>
                    <div class="col-6 mb-3"><label class="form-label">Giá trị giảm</label><input type="number" name="discountValue" class="form-control" min="0" required></div>
                </div>

                <div class="row">
                    <div class="col-6 mb-3"><label class="form-label">Đơn tối thiểu (VNĐ)</label><input type="number" name="minOrderAmount" class="form-control" value="0" min="0"></div>
                    <div class="col-6 mb-3"><label class="form-label">Giảm tối đa (VNĐ)</label><input type="number" name="maxDiscountAmount" class="form-control" value="0" min="0"></div>
                </div>

                <div class="row">
                    <div class="col-6 mb-3"><label class="form-label">Lượt dùng tối đa</label><input type="number" name="usageLimit" class="form-control" value="100" min="1" required></div>
                    <div class="col-6 mb-3"><label class="form-label">Ngày hết hạn</label><input type="date" name="expiryDate" class="form-control" required></div>
                </div>

                <div class="mb-3"><label class="form-label">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE">Hoạt động</option><option value="INACTIVE">Khóa</option></select></div>
            </div>
            <div class="modal-footer border-0"><button type="submit" class="btn btn-success w-100">Lưu Voucher</button></div>
        </form>
    </div></div>
</div>

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