<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Console | Fruit Farmer</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF;
            --sidebar-bg: #17231A; --sidebar-hover: rgba(220, 238, 216, 0.08);
            --text-main: #17231A; --text-muted: #66736A; --border-color: #E5E9E3;
            --pending: #D97706; --processing: #2563EB; --success: #16A34A;
        }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; color: var(--text-main); font-size: 14px; }
        h1, h2, h3, h4, h5, .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR STAFF */
        .sidebar { width: 250px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-header { padding: 24px 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .nav-group-label { font-size: 11px; color: #66736A; text-transform: uppercase; font-weight: 600; padding: 16px 20px 8px; margin-top: 8px; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; overflow-y: auto; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 20px; color: #9CA3AF; text-decoration: none; font-weight: 500; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: var(--sidebar-hover); border-left-color: var(--primary); }

        /* TOPBAR & MAIN */
        .topbar { height: 64px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; }
        .main-content { height: calc(100vh - 64px); overflow-y: auto; padding: 32px; }
        .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 20px; box-shadow: 0 1px 2px rgba(0,0,0,0.02); }

        /* ACTIONS */
        .btn-pos { background: var(--primary); color: #fff; border-radius: 8px; font-weight: 600; padding: 10px 20px; border: none; }
        .btn-pos:hover { background: #245530; color: #fff; }
        .btn-checkin { background: #16A34A; color: #fff; border: none; border-radius: 8px; font-weight: 600; padding: 12px; width: 100%; transition: 0.2s; }
        .btn-checkin:hover { background: #15803D; color: #fff; }

        /* TABLE */
        .staff-table th { background: #FAFAFA; color: var(--text-muted); font-weight: 500; font-size: 12px; text-transform: uppercase; padding: 12px 16px; border-bottom: 1px solid var(--border-color); }
        .staff-table td { padding: 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .badge-status { padding: 6px 12px; border-radius: 6px; font-weight: 500; font-size: 12px; }
        .bg-pending { background: #FEF3C7; color: #B45309; }
    </style>
</head>
<body>

<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <i class="ph-fill ph-storefront text-success fs-3"></i>
            <div>
                <div class="fw-bold fs-6 brand-font">Fruit Farmer</div>
                <div style="font-size: 10px; color:#8E9992; letter-spacing: 1px;">STAFF PANEL</div>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph ph-house"></i> Trang chủ</a></li>

            <div class="nav-group-label">Bán hàng</div>
            <li><a href="${pageContext.request.contextPath}/staff/pos"><i class="ph ph-monitor"></i> Đơn tại quầy (POS)</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph ph-receipt"></i> Quản lý đơn hàng</a></li>

            <div class="nav-group-label">Kho & Khách hàng</div>
            <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph ph-package"></i> Xem tồn kho</a></li>
            <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph ph-users"></i> Tìm khách hàng</a></li>

            <div class="nav-group-label">Nhân sự</div>
            <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph ph-clock"></i> Ca làm & Chấm công</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;">
            <a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center text-muted text-decoration-none fw-medium"><i class="ph ph-sign-out me-2 fs-5"></i> Đăng xuất</a>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="flex-grow-1 overflow-hidden d-flex flex-column">
        <header class="topbar">
            <div class="fw-medium text-dark"><i class="ph ph-clock me-2"></i>Hôm nay: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/></div>
            <div class="d-flex align-items-center gap-3">
                <!-- NÚT TẠO ĐƠN TẠI QUẦY ĐÃ GẮN LINK -->
                <a href="${pageContext.request.contextPath}/staff/pos" class="btn-pos d-flex align-items-center text-decoration-none"><i class="ph ph-plus-circle fs-5 me-2"></i> Tạo đơn tại quầy</a>
                <div class="d-flex align-items-center gap-2 ms-3 pl-3 border-start">
                    <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 35px; height: 35px; font-weight: bold;">
                        ${sessionScope.user.fullName.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <div class="fw-bold" style="font-size: 13px;">${sessionScope.user.fullName}</div>
                        <div class="text-muted" style="font-size: 11px;">Nhân viên bán hàng</div>
                    </div>
                </div>
            </div>
        </header>

        <div class="main-content">
            <div class="row g-4">

                <!-- CỘT TRÁI: HOẠT ĐỘNG CHÍNH -->
                <div class="col-lg-8">
                    <h4 class="brand-font fw-bold mb-4">Cần xử lý hôm nay</h4>

                    <!-- KPI Vận hành -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-3">
                            <div class="op-card text-center border-warning">
                                <div class="fs-1 fw-bold text-warning mb-1">${pendingOrders}</div>
                                <div class="text-muted fw-medium" style="font-size: 12px;">CHỜ XÁC NHẬN</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="op-card text-center border-info">
                                <div class="fs-1 fw-bold text-info mb-1">${preparingOrders}</div>
                                <div class="text-muted fw-medium" style="font-size: 12px;">ĐANG CHUẨN BỊ</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="op-card text-center border-primary">
                                <div class="fs-1 fw-bold text-primary mb-1">${shippingOrders}</div>
                                <div class="text-muted fw-medium" style="font-size: 12px;">ĐANG GIAO HÀNG</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="op-card text-center border-success bg-success-subtle bg-opacity-10">
                                <div class="fs-1 fw-bold text-success mb-1">${completedToday}</div>
                                <div class="text-muted fw-medium" style="font-size: 12px;">HOÀN THÀNH</div>
                            </div>
                        </div>
                    </div>

                    <!-- Bảng Đơn hàng chờ xử lý -->
                    <div class="op-card p-0 overflow-hidden">
                        <div class="p-3 border-bottom d-flex justify-content-between align-items-center bg-light">
                            <h6 class="m-0 fw-bold"><i class="ph-fill ph-warning-circle text-warning me-2"></i>Đơn hàng đang chờ xử lý</h6>
                            <a href="${pageContext.request.contextPath}/staff/orders" class="text-decoration-none text-primary" style="font-size: 13px;">Xem tất cả</a>
                        </div>
                        <table class="table staff-table mb-0">
                            <thead><tr><th>Mã Đơn</th><th>Khách hàng</th><th>Thanh toán</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                            <tbody>
                                <c:forEach var="o" items="${recentOrders}">
                                    <tr>
                                        <td class="fw-bold">#DH${o.id}</td>
                                        <td>${o.receiverName}</td>
                                        <td class="fw-semibold text-dark"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td><span class="badge-status ${o.orderStatus == 'PENDING' ? 'bg-pending' : 'bg-light text-dark border'}">${o.orderStatus}</span></td>
                                        <td class="text-end">
                                            <!-- NÚT XỬ LÝ ĐÃ GẮN LINK -->
                                            <a href="${pageContext.request.contextPath}/staff/order-detail?id=${o.id}" class="btn btn-sm btn-dark px-3" style="border-radius: 6px;">Xử lý ngay</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- CỘT PHẢI: CA LÀM VIỆC & CẢNH BÁO -->
                <div class="col-lg-4">
                    <!-- Widget Chấm công -->
                    <div class="op-card mb-4" style="background: linear-gradient(145deg, #17231A 0%, #245530 100%); border: none;">
                        <h6 class="text-white-50 mb-3 fw-medium">CA LÀM VIỆC HÔM NAY</h6>
                        <div class="d-flex align-items-center gap-3 mb-4">
                            <div class="bg-white bg-opacity-25 rounded p-3 text-center text-white" style="width: 80px;">
                                <div class="fw-bold fs-4"><fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd"/></div>
                                <div style="font-size: 11px; text-transform: uppercase;">THÁNG <fmt:formatDate value="<%=new java.util.Date()%>" pattern="MM"/></div>
                            </div>
                            <div class="text-white">
                                <div class="fs-5 fw-bold brand-font mb-1">Ca Sáng</div>
                                <div class="text-white-50"><i class="ph ph-clock me-1"></i> 07:00 - 12:00</div>
                            </div>
                        </div>
                        <!-- NÚT CHẤM CÔNG ĐÃ GẮN LINK SANG TRANG ĐIỂM DANH -->
                        <a href="${pageContext.request.contextPath}/staff/attendance" class="btn-checkin d-flex align-items-center justify-content-center gap-2 text-decoration-none">
                            <i class="ph-bold ph-fingerprint fs-5"></i> BẤM ĐỂ ĐIỂM DANH
                        </a>
                    </div>

                    <!-- Cảnh báo tồn kho -->
                    <div class="op-card">
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
                                    <button class="btn btn-sm btn-outline-secondary" style="font-size: 11px;">Báo nhập</button>
                                </div>
                            </c:forEach>
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