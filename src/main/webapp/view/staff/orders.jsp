<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý Đơn hàng | Staff Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>:root { --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF; --sidebar-bg: #17231A; --sidebar-hover: rgba(220, 238, 216, 0.08); --border-color: #E5E9E3;} body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; } .sidebar { width: 250px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; } .sidebar-menu li a { display: flex; align-items: center; padding: 10px 20px; color: #9CA3AF; text-decoration: none; font-weight: 500; border-left: 3px solid transparent; } .sidebar-menu li a i { font-size: 18px; margin-right: 12px; } .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); } .topbar { height: 64px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; } .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; } .staff-table th { background: #FAFAFA; color: #66736A; font-weight: 500; font-size: 11px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid var(--border-color); } .staff-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: #17231A; } .badge-status { padding: 6px 12px; border-radius: 6px; font-weight: 500; font-size: 12px; } .bg-pending { background: #FEF3C7; color: #B45309; } .bg-processing { background: #DBEAFE; color: #1D4ED8; } .bg-success-soft { background: #DCFCE7; color: #15803D; }</style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-2 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <i class="ph-fill ph-storefront text-success fs-3"></i><div><div class="fw-bold fs-6 brand-font">Fruit Farmer</div><div style="font-size: 10px; color:#8E9992; letter-spacing: 1px;">STAFF PANEL</div></div>
        </div>
        <ul class="sidebar-menu mt-3">
            <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph ph-house"></i> Trang chủ</a></li>
            <div class="px-4 py-2 mt-2" style="font-size: 11px; color: #66736A; font-weight: 600; text-transform: uppercase;">Bán hàng</div>
            <li><a href="#"><i class="ph ph-monitor"></i> Đơn tại quầy (POS)</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph ph-receipt"></i> Quản lý đơn hàng</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center text-muted text-decoration-none fw-medium"><i class="ph ph-sign-out me-2 fs-5"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium"><i class="ph ph-receipt me-2"></i>Đơn hàng cần xử lý</div></header>
        <div class="p-4">
            <h3 class="fw-bold brand-font mb-4">Tất cả Đơn hàng</h3>
            <div class="op-card p-0">
                <table class="table staff-table mb-0">
                    <thead><tr><th>Mã Đơn</th><th>Ngày đặt</th><th>Khách hàng</th><th>Thanh toán</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="fw-bold">#DH${o.id}</td>
                                <td class="text-muted"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM HH:mm"/></td>
                                <td class="fw-semibold">${o.receiverName}</td>
                                <td class="fw-medium"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 'PENDING'}"><span class="badge-status bg-pending">Chờ xác nhận</span></c:when>
                                        <c:when test="${o.orderStatus == 'CONFIRMED' || o.orderStatus == 'PREPARING' || o.orderStatus == 'SHIPPING'}"><span class="badge-status bg-processing">${o.orderStatus}</span></c:when>
                                        <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="badge-status bg-success-soft">Hoàn thành</span></c:when>
                                        <c:otherwise><span class="badge-status bg-light text-danger border">Đã hủy</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end"><a href="${pageContext.request.contextPath}/staff/order-detail?id=${o.id}" class="btn btn-sm btn-dark px-3 rounded-3">Xử lý</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body></html>