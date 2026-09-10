<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Chấm công | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>:root { --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF; --sidebar-bg: #17231A; --sidebar-hover: rgba(220, 238, 216, 0.08); --border-color: #E5E9E3;} body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; } .sidebar { width: 250px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; } .sidebar-menu li a { display: flex; align-items: center; padding: 10px 20px; color: #9CA3AF; text-decoration: none; font-weight: 500; border-left: 3px solid transparent;} .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); } .sidebar-header { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); } .nav-group-label { font-size: 11px; color: #66736A; text-transform: uppercase; font-weight: 600; padding: 16px 20px 8px; margin-top: 8px; } .topbar { height: 64px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; } .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; } .staff-table th { background: #FAFAFA; color: #66736A; font-weight: 500; font-size: 11px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid var(--border-color); } .staff-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); } .btn-checkin { background: #16A34A; color: #fff; font-size: 18px; font-weight: bold; padding: 20px; border-radius: 12px; border: none; width: 100%; transition: 0.2s;} .btn-checkin:hover { background: #15803D; color: #fff; } .btn-checkout { background: #DC2626; color: #fff; font-size: 18px; font-weight: bold; padding: 20px; border-radius: 12px; border: none; width: 100%; transition: 0.2s;} .btn-checkout:hover { background: #B91C1C; color: #fff; } .brand-font { font-family: 'DM Sans', sans-serif; }</style>
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
            <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph ph-package"></i> Xem tồn kho</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph ph-users"></i> Tìm khách hàng</a></li>
            <div class="nav-group-label">Nhân sự</div>
            <li class="active"><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph ph-clock"></i> Ca làm & Chấm công</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center text-muted text-decoration-none fw-medium"><i class="ph ph-sign-out me-2 fs-5"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium"><i class="ph ph-clock me-2"></i>Điểm danh ca làm việc</div></header>
        <div class="p-4">

            <div class="row g-4">
                <!-- CỘT TRÁI: KHU VỰC BẤM CHẤM CÔNG -->
                <div class="col-lg-4">
                    <div class="op-card text-center">
                        <div class="text-muted fw-semibold mb-2">HÔM NAY</div>
                        <h2 class="brand-font fw-bold text-success mb-4"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></h2>

                        <c:choose>
                            <c:when test="${empty today}">
                                <!-- Chưa check-in -->
                                <div class="alert alert-warning border-0 bg-warning-subtle text-warning-emphasis mb-4" style="font-size: 13px;">Bạn chưa điểm danh ca làm việc hôm nay.</div>
                                <form action="${pageContext.request.contextPath}/staff/attendance" method="POST">
                                    <input type="hidden" name="action" value="checkin">
                                    <button type="submit" class="btn-checkin"><i class="ph-bold ph-fingerprint fs-2 d-block mb-2"></i> BẤM ĐỂ CHECK-IN</button>
                                </form>
                            </c:when>
                            <c:when test="${empty today.checkOut}">
                                <!-- Đã check-in, chưa check-out -->
                                <div class="alert alert-success border-0 bg-success-subtle text-success-emphasis mb-4" style="font-size: 13px;">
                                    Đã Check-in lúc: <b><fmt:formatDate value="${today.checkIn}" pattern="HH:mm"/></b>
                                </div>
                                <form action="${pageContext.request.contextPath}/staff/attendance" method="POST">
                                    <input type="hidden" name="action" value="checkout">
                                    <button type="submit" class="btn-checkout"><i class="ph-bold ph-sign-out fs-2 d-block mb-2"></i> KẾT THÚC CA (CHECK-OUT)</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <!-- Đã hoàn thành ca -->
                                <div class="alert alert-secondary border-0 mb-4" style="font-size: 13px;">Bạn đã hoàn thành ca làm việc hôm nay.</div>
                                <div class="p-3 bg-light rounded text-start">
                                    <div class="mb-2"><span class="text-muted">Giờ vào:</span> <span class="fw-bold float-end"><fmt:formatDate value="${today.checkIn}" pattern="HH:mm"/></span></div>
                                    <div><span class="text-muted">Giờ ra:</span> <span class="fw-bold float-end"><fmt:formatDate value="${today.checkOut}" pattern="HH:mm"/></span></div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- CỘT PHẢI: BẢNG LỊCH SỬ -->
                <div class="col-lg-8">
                    <div class="op-card p-0">
                        <div class="p-3 border-bottom"><h6 class="fw-bold m-0 brand-font">Lịch sử đi làm (30 ngày qua)</h6></div>
                        <table class="table staff-table mb-0">
                            <thead><tr><th>Ngày làm việc</th><th>Check In (Giờ vào)</th><th>Check Out (Giờ ra)</th><th>Trạng thái</th></tr></thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr><td colspan="4" class="text-center py-4 text-muted">Chưa có lịch sử chấm công.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td class="fw-bold"><fmt:formatDate value="${h.workDate}" pattern="dd/MM/yyyy"/></td>
                                                <td class="text-success fw-semibold"><fmt:formatDate value="${h.checkIn}" pattern="HH:mm:ss"/></td>
                                                <td class="text-danger fw-semibold">${h.checkOut != null ? '' : 'Đang làm...'} <fmt:formatDate value="${h.checkOut}" pattern="HH:mm:ss"/></td>
                                                <td><span class="badge bg-success-subtle text-success border border-success-subtle">Hợp lệ</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Hệ thống Toast thông báo -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body"><i class="ph-fill ph-check-circle me-2"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body"><i class="ph-fill ph-warning-circle me-2"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var toastList = [].slice.call(document.querySelectorAll('.toast')).map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 3000 }); });
        toastList.forEach(toast => toast.show());
    });
</script>
</body>
</html>