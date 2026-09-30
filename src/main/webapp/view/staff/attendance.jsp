<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Chấm công | Staff Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --staff-primary: #1C8D50; --staff-sidebar-bg: #102C1F; --staff-bg-light: #F9FAFB;
            --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E5E9E3;
        }
        body { background-color: var(--staff-bg-light); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; padding: 0; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR ĐỒNG BỘ */
        .sidebar { width: 250px; background-color: var(--staff-sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--staff-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .menu-label { padding: 20px 20px 8px; font-size: 11px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 20px; color: #D1D5DB; text-decoration: none; font-weight: 500; font-size: 13px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(31, 157, 85, 0.15); border-left-color: var(--staff-primary); font-weight: 600; }

        /* MAIN CONTENT TRÀN VIỀN */
        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }

        /* HEADER ĐỒNG BỘ CÓ DROPDOWN */
        .staff-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .btn-pos { background-color: var(--staff-primary); color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.2s; box-shadow: 0 2px 6px rgba(28,141,80,0.2); }
        .btn-pos:hover { background-color: #156d3e; color: #fff; transform: translateY(-1px); }
        .user-chip { display: flex; align-items: center; gap: 10px; background: var(--staff-bg-light); padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #f3f4f6; }
        .user-avatar { width: 32px; height: 32px; background: #3B82F6; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        /* NỘI DUNG */
        .page-body { padding: 30px; flex-grow: 1; }
        .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); height: 100%; display: flex; flex-direction: column;}

        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px; background: #F9FAFB; color: var(--text-muted); font-size: 11px; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        .admin-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; }

        .btn-checkin { background: #16A34A; color: #fff; font-size: 16px; font-weight: bold; padding: 16px; border-radius: 12px; border: none; width: 100%; transition: 0.2s; box-shadow: 0 4px 10px rgba(22, 163, 74, 0.2);}
        .btn-checkin:hover { background: #15803D; color: #fff; transform: translateY(-2px); }
        .btn-checkout { background: #DC2626; color: #fff; font-size: 16px; font-weight: bold; padding: 16px; border-radius: 12px; border: none; width: 100%; transition: 0.2s; box-shadow: 0 4px 10px rgba(220, 38, 38, 0.2);}
        .btn-checkout:hover { background: #B91C1C; color: #fff; transform: translateY(-2px); }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR (Đã bỏ đăng xuất) -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="ph-bold ph-storefront text-white"></i></div>
            <div>
                <div class="fw-bold brand-font text-white" style="font-size: 15px;">Fruit Farmer</div>
                <div style="font-size: 10px; color: var(--staff-primary); font-weight: 700; letter-spacing: 1px;">STAFF PANEL</div>
            </div>
        </div>
        <div class="overflow-auto flex-grow-1 py-3">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph-fill ph-house"></i> Trang chủ</a></li>
                <div class="menu-label mt-2">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/pos"><i class="ph-fill ph-desktop"></i> Đơn tại quầy (POS)</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph-fill ph-receipt"></i> Quản lý đơn hàng</a></li>
                <div class="menu-label">Kho & Khách hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph-fill ph-box-arrow-down"></i> Tra cứu Kho</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph-fill ph-users"></i> Tìm khách hàng</a></li>
                <div class="menu-label">Nhân sự</div>
                <li class="active"><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph-fill ph-clock-user"></i> Ca làm & Chấm công</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <!-- HEADER CÓ DROPDOWN -->
        <header class="staff-header">
            <div class="header-date">
                <i class="ph-light ph-clock fs-5"></i>
                <span class="ms-2 fw-medium text-muted">Hôm nay: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></span>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/staff/pos" class="btn-pos">
                    <i class="ph-bold ph-shopping-cart"></i> Tạo đơn tại quầy
                </a>
                <div class="dropdown ms-2">
                    <div class="user-chip dropdown-toggle d-flex align-items-center gap-2 px-2 py-1 rounded"
                         data-bs-toggle="dropdown" aria-expanded="false" style="border: 1px solid var(--border-color); background: var(--staff-bg-light);">
                        <div class="user-avatar">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                        <div class="user-info d-flex flex-column text-start">
                            <span class="user-name fw-bold" style="font-size: 13px; line-height: 1;">${sessionScope.user != null ? sessionScope.user.fullName : 'Staff Name'}</span>
                            <span class="user-role text-muted" style="font-size: 11px;">Nhân viên bán hàng</span>
                        </div>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2" style="border-radius: 12px; width: 220px; box-shadow: 0 4px 15px rgba(0,0,0,0.05) !important;">
                        <li>
                            <div class="px-3 py-2 border-bottom mb-1 bg-light rounded-top" style="border-radius: 12px 12px 0 0;">
                                <div class="fw-bold text-dark" style="font-size: 13px;">${sessionScope.user != null ? sessionScope.user.fullName : 'Staff'}</div>
                                <div class="text-muted text-truncate" style="font-size: 11px;">${sessionScope.user != null ? sessionScope.user.email : 'Chưa cập nhật email'}</div>
                            </div>
                        </li>
                        <li><a class="dropdown-item py-2 fw-medium d-flex align-items-center" style="font-size: 13px; color: var(--text-main);" href="${pageContext.request.contextPath}/staff/profile"><i class="ph-bold ph-user-circle me-2 fs-5" style="color: var(--staff-primary);"></i> Hồ sơ cá nhân</a></li>
                        <li><hr class="dropdown-divider my-1"></li>
                        <li><a class="dropdown-item py-2 fw-bold text-danger d-flex align-items-center" style="font-size: 13px;" href="${pageContext.request.contextPath}/logout"><i class="ph-bold ph-sign-out me-2 fs-5"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="page-body">
            <h3 class="fw-bold brand-font mb-4 text-dark"><i class="ph-bold ph-fingerprint text-success me-2"></i>Điểm danh ca làm việc</h3>

            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="op-card text-center d-flex flex-column justify-content-center">
                        <div class="text-muted fw-bold mb-2" style="font-size: 11px; letter-spacing: 1px;">HÔM NAY</div>
                        <h2 class="brand-font fw-bold text-success mb-4"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></h2>

                        <c:choose>
                            <c:when test="${empty today}">
                                <div class="alert alert-warning border-0 bg-warning-subtle text-warning-emphasis mb-4 rounded-3" style="font-size: 13px;">Bạn chưa điểm danh ca làm việc hôm nay.</div>
                                <form action="${pageContext.request.contextPath}/staff/attendance" method="POST">
                                    <input type="hidden" name="action" value="checkin">
                                    <button type="submit" class="btn-checkin"><i class="ph-bold ph-fingerprint fs-1 d-block mb-2"></i> BẤM ĐỂ CHECK-IN</button>
                                </form>
                            </c:when>
                            <c:when test="${empty today.checkOut}">
                                <div class="alert alert-success border-0 bg-success-subtle text-success-emphasis mb-4 rounded-3" style="font-size: 13px;">
                                    Đã Check-in lúc: <b class="fs-5"><fmt:formatDate value="${today.checkIn}" pattern="HH:mm"/></b>
                                </div>
                                <form action="${pageContext.request.contextPath}/staff/attendance" method="POST">
                                    <input type="hidden" name="action" value="checkout">
                                    <button type="submit" class="btn-checkout"><i class="ph-bold ph-sign-out fs-1 d-block mb-2"></i> KẾT THÚC CA LÀM</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-secondary border-0 mb-4 rounded-3" style="font-size: 13px;">Bạn đã hoàn thành ca làm việc hôm nay.</div>
                                <div class="p-4 bg-light rounded-4 text-start border">
                                    <div class="mb-3 border-bottom pb-3"><span class="text-muted fw-medium">Giờ vào:</span> <span class="fw-bold fs-5 text-dark float-end"><fmt:formatDate value="${today.checkIn}" pattern="HH:mm"/></span></div>
                                    <div><span class="text-muted fw-medium">Giờ ra:</span> <span class="fw-bold fs-5 text-dark float-end"><fmt:formatDate value="${today.checkOut}" pattern="HH:mm"/></span></div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="op-card p-0 h-100 overflow-hidden">
                        <div class="p-4 border-bottom bg-light"><h6 class="fw-bold m-0 brand-font text-dark">Lịch sử đi làm (30 ngày qua)</h6></div>
                        <div class="table-responsive">
                            <table class="table admin-table mb-0">
                                <thead><tr><th>Ngày làm việc</th><th>Check In (Vào)</th><th>Check Out (Ra)</th><th class="text-center">Trạng thái</th></tr></thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty history}">
                                            <tr><td colspan="4" class="text-center py-5 text-muted">Chưa có lịch sử chấm công.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="h" items="${history}">
                                                <tr>
                                                    <td class="fw-bold text-dark"><fmt:formatDate value="${h.workDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td class="text-success fw-bold"><i class="ph-bold ph-arrow-down-left me-1"></i><fmt:formatDate value="${h.checkIn}" pattern="HH:mm:ss"/></td>
                                                    <td class="text-danger fw-bold">
                                                        <c:if test="${not empty h.checkOut}"><i class="ph-bold ph-arrow-up-right me-1"></i></c:if>
                                                        ${h.checkOut != null ? '' : '<span class="badge bg-warning text-dark border fw-medium">Đang làm...</span>'}
                                                        <fmt:formatDate value="${h.checkOut}" pattern="HH:mm:ss"/>
                                                    </td>
                                                    <td class="text-center"><span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1" style="font-size: 11px; border-radius: 6px;">Hợp lệ</span></td>
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
        </div>
    </main>
</div>

<!-- TOAST THÔNG BÁO -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium"><i class="ph-fill ph-check-circle me-2 fs-5 align-middle"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium"><i class="ph-fill ph-warning-circle me-2 fs-5 align-middle"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var toastList = [].slice.call(document.querySelectorAll('.toast')).map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 3500 }); });
        toastList.forEach(toast => toast.show());
    });
</script>
</body>
</html>