<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Bảng điều khiển | Staff Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --staff-sidebar-bg: #102C1F; --staff-primary: #1C8D50; --staff-bg-light: #F9FAFB;
            --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E5E7EB;
        }
        body { background-color: var(--staff-bg-light); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; padding: 0;}
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR */
        .sidebar { width: 250px; background-color: var(--staff-sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--staff-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .menu-label { padding: 20px 20px 8px; font-size: 11px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 20px; color: #D1D5DB; text-decoration: none; font-weight: 500; font-size: 13px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(31, 157, 85, 0.15); border-left-color: var(--staff-primary); font-weight: 600; }

        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }

        /* HEADER */
        .staff-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .btn-pos { background-color: var(--staff-primary); color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.2s; box-shadow: 0 2px 6px rgba(28,141,80,0.2); }
        .btn-pos:hover { background-color: #156d3e; color: #fff; transform: translateY(-1px); }
        .user-chip { display: flex; align-items: center; gap: 10px; background: var(--staff-bg-light); padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #f3f4f6; }
        .user-avatar { width: 32px; height: 32px; background: #3B82F6; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        .page-body { padding: 30px; flex-grow: 1; }
        .op-card { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }

        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px; background: #F9FAFB; color: var(--text-muted); font-size: 11px; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        .admin-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; }
        .admin-table tbody tr:hover td { background: #F9FAFB; }

        .badge-status { padding: 6px 12px; border-radius: 6px; font-weight: 600; font-size: 11px; text-transform: uppercase; display: inline-block;}
        .bg-pending { background: #FEF3C7; color: #B45309; }
        .bg-processing { background: #DBEAFE; color: #1D4ED8; }
        .bg-success-soft { background: #DCFCE7; color: #15803D; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR (ĐÃ BỎ NÚT ĐĂNG XUẤT) -->
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
                <li class="active"><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph-fill ph-house"></i> Trang chủ</a></li>
                <div class="menu-label mt-2">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/pos"><i class="ph-fill ph-desktop"></i> Đơn tại quầy (POS)</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph-fill ph-receipt"></i> Quản lý đơn hàng</a></li>
                <div class="menu-label">Kho & Khách hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph-fill ph-box-arrow-down"></i> Tra cứu Kho</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph-fill ph-users"></i> Tìm khách hàng</a></li>
                <div class="menu-label">Nhân sự</div>
                <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph-fill ph-clock-user"></i> Ca làm & Chấm công</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <!-- HEADER CÓ DROPDOWN BỎ CARET -->
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
                         data-bs-toggle="dropdown" aria-expanded="false"
                         style="cursor: pointer; border: 1px solid var(--border-color); background: var(--staff-bg-light);">

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
                        <li>
                            <a class="dropdown-item py-2 fw-medium d-flex align-items-center" style="font-size: 13px; color: var(--text-main);" href="${pageContext.request.contextPath}/staff/profile">
                                <i class="ph-bold ph-user-circle me-2 fs-5" style="color: var(--staff-primary);"></i> Hồ sơ cá nhân
                            </a>
                        </li>
                        <li><hr class="dropdown-divider my-1"></li>
                        <li>
                            <a class="dropdown-item py-2 fw-bold text-danger d-flex align-items-center" style="font-size: 13px;" href="${pageContext.request.contextPath}/logout">
                                <i class="ph-bold ph-sign-out me-2 fs-5"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="row g-4">
                <div class="col-xl-8 col-lg-7">
                    <h3 class="brand-font fw-bold mb-4 text-dark">Cần xử lý hôm nay</h3>

                    <div class="row g-3 mb-4">
                        <div class="col-sm-6 col-md-3">
                            <div class="op-card text-center border border-warning justify-content-center" style="background: #FFFBEB; padding: 20px 10px;">
                                <div class="fs-2 fw-bold text-warning mb-1">${pendingOrders}</div>
                                <div class="text-muted fw-bold" style="font-size: 10px;">CHỜ XÁC NHẬN</div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="op-card text-center border border-info justify-content-center" style="background: #EFF6FF; padding: 20px 10px;">
                                <div class="fs-2 fw-bold text-info mb-1">${preparingOrders}</div>
                                <div class="text-muted fw-bold" style="font-size: 10px;">ĐANG CHUẨN BỊ</div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="op-card text-center border border-primary justify-content-center" style="background: #EEF2FF; padding: 20px 10px;">
                                <div class="fs-2 fw-bold text-primary mb-1">${shippingOrders}</div>
                                <div class="text-muted fw-bold" style="font-size: 10px;">ĐANG GIAO HÀNG</div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-3">
                            <div class="op-card text-center border border-success justify-content-center" style="background: #ECFDF5; padding: 20px 10px;">
                                <div class="fs-2 fw-bold text-success mb-1">${completedToday}</div>
                                <div class="text-muted fw-bold" style="font-size: 10px;">HOÀN THÀNH</div>
                            </div>
                        </div>
                    </div>

                    <div class="op-card p-0 overflow-hidden" style="height: auto;">
                        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-light">
                            <h6 class="m-0 fw-bold"><i class="ph-fill ph-warning-circle text-warning me-2"></i>Đơn hàng đang chờ xử lý</h6>
                            <a href="${pageContext.request.contextPath}/staff/orders" class="text-decoration-none" style="color: var(--staff-primary); font-size: 13px; font-weight: 600;">Xem tất cả</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table admin-table mb-0">
                                <thead><tr><th>Mã Đơn</th><th>Khách hàng</th><th class="text-end">Thanh toán</th><th class="text-center">Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                                <tbody>
                                    <c:forEach var="o" items="${recentOrders}">
                                        <tr>
                                            <td class="fw-bold">#DH${o.id}</td>
                                            <td class="fw-medium">${o.receiverName}</td>
                                            <td class="fw-bold text-dark text-end"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</td>
                                            <td class="text-center">
                                                <!-- TIẾNG VIỆT 100% -->
                                                <c:choose>
                                                    <c:when test="${o.orderStatus == 'PENDING'}"><span class="badge-status bg-pending">Chờ xác nhận</span></c:when>
                                                    <c:when test="${o.orderStatus == 'CONFIRMED'}"><span class="badge-status bg-processing">Đã xác nhận</span></c:when>
                                                    <c:when test="${o.orderStatus == 'PREPARING'}"><span class="badge-status bg-processing">Đang chuẩn bị</span></c:when>
                                                    <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge-status bg-processing">Đang giao hàng</span></c:when>
                                                    <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="badge-status bg-success-soft">Hoàn thành</span></c:when>
                                                    <c:otherwise><span class="badge-status bg-light text-danger border">Đã hủy</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/staff/order-detail?id=${o.id}" class="btn btn-sm text-white px-3" style="background-color: var(--staff-primary); border-radius: 6px;">Xử lý ngay</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-xl-4 col-lg-5">
                    <div class="op-card mb-4" style="background: var(--staff-sidebar-bg); border: none; height: auto;">
                        <h6 class="text-white-50 mb-3 fw-medium" style="font-size: 11px; letter-spacing: 1px;">CA LÀM VIỆC HÔM NAY</h6>
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="bg-white bg-opacity-25 rounded p-3 text-center text-white" style="width: 80px;">
                                <div class="fw-bold fs-3"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd"/></div>
                                <div style="font-size: 11px; text-transform: uppercase;">THÁNG <fmt:formatDate value="<%=new java.util.Date()%>" pattern="MM"/></div>
                            </div>
                            <div class="text-white">
                                <div class="fs-4 fw-bold brand-font mb-1">Ca Sáng</div>
                                <div class="text-white-50" style="font-size: 13px;"><i class="ph ph-clock me-1"></i> 07:00 - 12:00</div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/attendance" class="btn btn-success border-0 rounded-3 fw-bold p-3 text-center d-block text-decoration-none w-100" style="background-color: var(--staff-primary);">
                            <i class="ph-bold ph-fingerprint fs-5 align-middle me-1"></i> BẤM ĐỂ ĐIỂM DANH
                        </a>
                    </div>

                    <div class="op-card" style="height: auto;">
                        <h6 class="fw-bold mb-3 text-danger"><i class="ph-fill ph-warning me-2"></i>Sản phẩm sắp hết</h6>
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="p" items="${lowStockProducts}">
                                <div class="d-flex justify-content-between align-items-center pb-3 border-bottom">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-light rounded d-flex align-items-center justify-content-center text-muted" style="width: 40px; height: 40px;"><i class="ph ph-package fs-4"></i></div>
                                        <div>
                                            <div class="fw-medium text-dark text-truncate" style="font-size: 13px; max-width: 150px;">${p.name}</div>
                                            <div class="text-danger fw-bold" style="font-size: 12px;">Còn: ${p.stock} ${p.unit}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty lowStockProducts}">
                                <div class="text-center text-muted py-3"><i class="ph-fill ph-check-circle text-success fs-3 mb-2 d-block"></i> Kho hàng đảm bảo.</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>