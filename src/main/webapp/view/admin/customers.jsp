<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Khách hàng | Fruit Admin</title>
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
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 10px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }

        .tier-DIAMOND { background: #0EA5E9; color: #fff; }
        .tier-GOLD { background: #F59E0B; color: #fff; }
        .tier-SILVER { background: #9CA3AF; color: #fff; }
        .tier-BRONZE { background: #F3F4F6; color: #4B5563; border: 1px solid #D1D5DB; }
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
            <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted"></div></header>
        <div class="p-4 px-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold m-0 brand-font text-dark">Hội Viên & Khách Hàng</h2>
                </div>
            </div>

            <div class="admin-card p-0">
                <table class="admin-table mb-0">
                    <thead>
                        <tr>
                            <th>Khách hàng</th>
                            <th>Liên hệ</th>
                            <th>Ngày tham gia</th>
                            <th class="col-number">Tổng chi tiêu</th>
                            <th class="text-center">Hạng thành viên</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${customers}">
                            <tr>
                                <td class="fw-bold text-dark">${c.fullName}</td>
                                <td>
                                    <div class="text-dark">${c.phone}</div>
                                    <div class="text-muted" style="font-size: 12px;">${c.email}</div>
                                </td>
                                <td class="text-muted"><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/></td>
                                <td class="col-number fw-bold text-success"><fmt:formatNumber value="${c.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>

                                <td class="text-center">
                                    <span class="badge tier-${c.tier} px-3 py-1 rounded-pill" style="font-size: 11px; letter-spacing: 0.5px;">${c.tier}</span>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 'ACTIVE'}"><span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Hoạt động</span></c:when>
                                        <c:otherwise><span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Khóa (INACTIVE)</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-end">
                                    <form action="${pageContext.request.contextPath}/admin/customers" method="POST" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn ${c.status == 'ACTIVE' ? 'KHÓA' : 'MỞ KHÓA'} tài khoản này?');">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="id" value="${c.id}">
                                        <input type="hidden" name="currentStatus" value="${c.status}">
                                        <c:choose>
                                            <c:when test="${c.status == 'ACTIVE'}">
                                                <button type="submit" class="btn btn-sm btn-light border text-danger" title="Khóa tài khoản"><i class="ph ph-lock-key"></i> Khóa</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="btn btn-sm btn-light border text-success" title="Mở khóa tài khoản"><i class="ph ph-lock-key-open"></i> Mở khóa</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true"><div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div></div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true"><div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div></div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script> document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); }); </script>
</body>
</html>