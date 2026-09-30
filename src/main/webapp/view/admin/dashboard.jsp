<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Analytics Dashboard | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>

    <style>
        /* === ZOTECH COLOR PALETTE & VARIABLES === */
        :root {
            --primary: #2F6B3F;
            --z-bg: #F3F4F6;
            --z-surface: #FFFFFF;
            --z-text-main: #1E293B;
            --z-text-muted: #64748B;
            --z-border: #E2E8F0;

            --z-blue: #3B82F6; --z-blue-bg: #EFF6FF;
            --z-green: #10B981; --z-green-bg: #ECFDF5;
            --z-purple: #8B5CF6; --z-purple-bg: #F5F3FF;
            --z-orange: #F59E0B; --z-orange-bg: #FFFBEB;
        }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR */
        .sidebar { width: 250px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0;}
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 13px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); }

        /* ZOTECH CARD UI */
        .z-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 8px; padding: 16px; box-shadow: 0 1px 2px rgba(0,0,0,0.02); height: 100%; display: flex; flex-direction: column;}
        .z-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; border-bottom: 1px solid #f1f5f9; padding-bottom: 12px;}
        .z-card-title { font-size: 14px; font-weight: 700; color: var(--z-text-main); margin: 0; display: flex; align-items: center; gap: 8px;}

        /* KPI BOX */
        .kpi-wrapper { display: flex; align-items: flex-start; gap: 16px; }
        .kpi-icon-box { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .kpi-info { flex-grow: 1; }
        .kpi-label { font-size: 12px; font-weight: 600; color: var(--z-text-muted); margin-bottom: 4px; }
        .kpi-value { font-family: 'DM Sans', sans-serif; font-size: 22px; font-weight: 700; color: var(--z-text-main); line-height: 1.2; margin-bottom: 6px; }
        .kpi-trend { font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; }

        /* BẢNG DỮ LIỆU */
        .z-table-wrap { overflow-x: auto; flex-grow: 1; }
        .z-table { width: 100%; border-collapse: collapse; min-width: 500px;}
        .z-table th { padding: 10px; text-transform: none; color: var(--z-text-muted); font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--z-border); background: #F8FAFC; white-space: nowrap;}
        .z-table td { padding: 12px 10px; font-size: 12px; color: var(--z-text-main); border-bottom: 1px dashed #F1F5F9; vertical-align: middle; }
        .z-table tr:last-child td { border-bottom: none; }

        .badge-z { padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; }
        .badge-cod { background: #EEF2FF; color: #4F46E5; }
        .badge-qr { background: #ECFDF5; color: #10B981; }

        .chart-container-donut { position: relative; height: 180px; width: 100%; display: flex; justify-content: center; align-items: center; margin-top: 10px;}
        .donut-inner-text { position: absolute; text-align: center; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 100%; }
        .donut-inner-text .val { font-size: 12px; font-weight: 700; color: var(--z-text-main); font-family: 'DM Sans', sans-serif;}

        .z-scroll::-webkit-scrollbar { width: 4px; height: 4px; }
        .z-scroll::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 4px; }
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
            <div>
                <div class="fw-bold fs-6 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div>
            </div>
        </div>

        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
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
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-wrapper overflow-auto" style="height: 100vh;">

        <!-- HEADER TOP & BỘ LỌC ĐỘNG & ADMIN DROPDOWN -->
        <div class="d-flex justify-content-between align-items-center bg-white px-4 py-3 border-bottom sticky-top" style="z-index: 10;">
            <div class="d-flex align-items-center gap-3">
                <h6 class="fw-bold m-0 brand-font text-dark">Tổng quan</h6>
                <div class="vr text-muted opacity-25"></div>
                <span class="text-muted fw-medium" style="font-size: 12px;"><i class="ph-fill ph-calendar-blank me-1"></i> ${currentRangeText}</span>
            </div>

            <div class="d-flex align-items-center gap-4">
                <!-- FORM LỌC -->
                <form id="filterForm" action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="d-flex gap-2 m-0">
                    <select name="period" id="periodSelect" class="form-select form-select-sm fw-medium shadow-sm border-0 bg-light" style="width: 150px;" onchange="toggleCustomDate()">
                        <option value="today" ${period == 'today' ? 'selected' : ''}>Hôm nay</option>
                        <option value="this_week" ${period == 'this_week' ? 'selected' : ''}>Tuần này</option>
                        <option value="this_month" ${period == 'this_month' ? 'selected' : ''}>Tháng này</option>
                        <option value="this_quarter" ${period == 'this_quarter' ? 'selected' : ''}>Quý này</option>
                        <option value="this_year" ${period == 'this_year' ? 'selected' : ''}>Năm nay</option>
                        <option value="custom" ${period == 'custom' ? 'selected' : ''}>Tùy chỉnh...</option>
                    </select>
                    <input type="text" name="custom_dates" id="customDateRange" class="form-control form-control-sm shadow-sm ${period != 'custom' ? 'd-none' : ''}" style="width: 220px;" placeholder="Chọn khoảng ngày...">
                    <button type="submit" class="btn btn-dark btn-sm shadow-sm px-3 fw-medium">Lọc</button>
                </form>

                <!-- ADMIN DROPDOWN -->
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
        </div>

        <div class="p-4">

            <!-- ROW 1: 4 KPI CARDS -->
            <div class="row g-3 mb-3">
                <div class="col-md-3">
                    <div class="z-card py-3">
                        <div class="kpi-wrapper">
                            <div class="kpi-icon-box" style="background: var(--z-blue-bg); color: var(--z-blue);"><i class="ph-fill ph-wallet"></i></div>
                            <div class="kpi-info">
                                <div class="kpi-label">Doanh thu</div>
                                <div class="kpi-value"><fmt:formatNumber value="${summary.currentRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                <div class="kpi-trend ${summary.revenueGrowth >= 0 ? 'text-success' : 'text-danger'}">
                                    <i class="ph-bold ${summary.revenueGrowth >= 0 ? 'ph-trend-up' : 'ph-trend-down'}"></i>
                                    <span><fmt:formatNumber value="${summary.revenueGrowth}" maxFractionDigits="1"/>% so với ${compareText}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="z-card py-3">
                        <div class="kpi-wrapper">
                            <div class="kpi-icon-box" style="background: var(--z-green-bg); color: var(--z-green);"><i class="ph-fill ph-receipt"></i></div>
                            <div class="kpi-info">
                                <div class="kpi-label">Tổng đơn hàng</div>
                                <div class="kpi-value">${summary.currentOrders}</div>
                                <div class="kpi-trend ${summary.ordersGrowth >= 0 ? 'text-success' : 'text-danger'}">
                                    <i class="ph-bold ${summary.ordersGrowth >= 0 ? 'ph-trend-up' : 'ph-trend-down'}"></i>
                                    <span><fmt:formatNumber value="${summary.ordersGrowth}" maxFractionDigits="1"/>% so với ${compareText}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="z-card py-3">
                        <div class="kpi-wrapper">
                            <div class="kpi-icon-box" style="background: var(--z-purple-bg); color: var(--z-purple);"><i class="ph-fill ph-chart-polar"></i></div>
                            <div class="kpi-info">
                                <div class="kpi-label">Giá trị TB Đơn (AOV)</div>
                                <div class="kpi-value"><fmt:formatNumber value="${summary.currentAov}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                <div class="kpi-trend ${summary.aovGrowth >= 0 ? 'text-success' : 'text-danger'}">
                                    <i class="ph-bold ${summary.aovGrowth >= 0 ? 'ph-trend-up' : 'ph-trend-down'}"></i>
                                    <span><fmt:formatNumber value="${summary.aovGrowth}" maxFractionDigits="1"/>% so với ${compareText}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="z-card py-3">
                        <div class="kpi-wrapper">
                            <div class="kpi-icon-box" style="background: var(--z-orange-bg); color: var(--z-orange);"><i class="ph-fill ph-users"></i></div>
                            <div class="kpi-info">
                                <div class="kpi-label">Khách hàng</div>
                                <div class="kpi-value">${summary.currentCustomers}</div>
                                <div class="kpi-trend text-muted"><i class="ph-bold ph-clock-counter-clockwise"></i> ${compareText}: ${summary.previousCustomers} khách</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ROW 2: DOANH THU & TỶ TRỌNG KÊNH BÁN HÀNG -->
            <div class="row g-3 mb-3">
                <div class="col-lg-8">
                    <div class="z-card">
                        <div class="z-card-header">
                            <h6 class="z-card-title">Hiệu suất Doanh Thu</h6>
                        </div>
                        <div style="height: 220px; width: 100%;"><canvas id="revenueChart"></canvas></div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="z-card">
                        <div class="z-card-header">
                            <h6 class="z-card-title">Doanh thu theo Kênh</h6>
                        </div>
                        <div class="d-flex align-items-center justify-content-between h-100">
                            <!-- Bên trái: Biểu đồ -->
                            <div style="width: 45%;">
                                <div class="chart-container-donut">
                                    <canvas id="donutChart"></canvas>
                                    <div class="donut-inner-text">
                                        <div style="font-size: 10px; color: var(--z-text-muted);">Tổng doanh thu</div>
                                        <div class="val">
                                            <fmt:formatNumber value="${websiteRev + storeRev}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bên phải: Chú thích (Legend) -->
                            <div class="d-flex flex-column justify-content-center" style="width: 55%; padding-left: 15px;">
                                <!-- Item: Kênh Online -->
                                <div class="mb-3">
                                    <div class="d-flex align-items-center mb-1">
                                        <span style="color: #3B82F6; font-size: 10px;" class="me-2">●</span>
                                        <span style="font-size: 11px; font-weight: 600; color: var(--z-text-muted);">Online</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 ps-3">
                                        <span class="fw-bold text-dark" style="font-size: 11.5px;"><fmt:formatNumber value="${not empty websiteRev ? websiteRev : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                        <span class="badge bg-primary bg-opacity-10 text-primary px-2 py-1" style="font-size: 10px; border-radius: 4px;">${not empty websitePercent ? websitePercent : '0'}%</span>
                                    </div>
                                </div>
                                <!-- Item: Kênh Trực tiếp -->
                                <div>
                                    <div class="d-flex align-items-center mb-1">
                                        <span style="color: #10B981; font-size: 10px;" class="me-2">●</span>
                                        <span style="font-size: 11px; font-weight: 600; color: var(--z-text-muted);">Trực tiếp</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-2 ps-3">
                                        <span class="fw-bold text-dark" style="font-size: 11.5px;"><fmt:formatNumber value="${not empty storeRev ? storeRev : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                        <span class="badge bg-success bg-opacity-10 text-success px-2 py-1" style="font-size: 10px; border-radius: 4px;">${not empty storePercent ? storePercent : '0'}%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ROW 3: ĐƠN HÀNG GẦN ĐÂY -->
            <div class="row g-3 mb-3">
                <div class="col-12">
                    <div class="z-card p-0">
                        <div class="p-3 pb-2 z-card-header border-bottom">
                            <h6 class="z-card-title">Đơn hàng mới nhất</h6>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="text-decoration-none text-primary" style="font-size: 12px; font-weight: 500;">Quản lý toàn bộ <i class="ph-bold ph-arrow-right"></i></a>
                        </div>
                        <div class="z-table-wrap z-scroll" style="max-height: 280px;">
                            <table class="z-table">
                                <thead>
                                    <tr>
                                        <th>Mã đơn</th>
                                        <th>Phương thức</th>
                                        <th>Khách hàng</th>
                                        <th class="text-end">Giá trị đơn</th>
                                        <th class="text-center">Trạng thái</th>
                                        <th class="text-end pe-4">Thời gian đặt</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="o" items="${recentOrders}">
                                        <tr>
                                            <td><span class="fw-bold text-dark">#${o.id}</span></td>
                                            <td>
                                                <span class="badge-z ${o.paymentMethod == 'VIETQR' ? 'badge-online' : 'badge-cod'}">
                                                    ${o.paymentMethod}
                                                </span>
                                            </td>
                                            <td><div class="fw-medium">${o.receiverName}</div></td>
                                            <td class="text-end fw-bold text-dark"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td class="text-center">
                                                <span class="fw-bold ${o.orderStatus == 'COMPLETED' ? 'text-success' : (o.orderStatus == 'CANCELLED' ? 'text-danger' : 'text-warning')}">
                                                    ${o.orderStatus == 'COMPLETED' ? 'Đã giao' : (o.orderStatus == 'CANCELLED' ? 'Đã hủy' : 'Đang xử lý')}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4 text-muted"><fmt:formatDate value="${o.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentOrders}">
                                        <tr><td colspan="6" class="text-center text-muted py-5">
                                            <i class="ph-light ph-receipt fs-1 mb-2"></i><br>Chưa có đơn hàng mới nào.
                                        </td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ROW 4: TOP SẢN PHẨM BÁN CHẠY & CẢNH BÁO TỒN KHO -->
            <div class="row g-3 mb-4">
                <div class="col-lg-7">
                    <div class="z-card p-0">
                        <div class="p-3 pb-2 z-card-header border-bottom">
                            <h6 class="z-card-title">Top sản phẩm bán chạy (Theo Doanh thu)</h6>
                        </div>
                        <div class="px-3 pb-3 pt-3">
                            <div style="height: 240px;"><canvas id="topProductsChart"></canvas></div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="z-card p-0" style="border-top: 3px solid var(--z-orange);">
                        <div class="p-3 pb-2 z-card-header border-bottom">
                            <h6 class="z-card-title text-dark">Cảnh báo Tồn kho</h6>
                        </div>
                        <div class="z-table-wrap z-scroll" style="height: 240px;">
                            <table class="z-table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th class="text-center">Tồn kho</th>
                                        <th class="text-end pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${lowStockProducts}">
                                        <tr>
                                            <td><div class="fw-medium text-dark text-truncate" style="max-width: 180px;" title="${p.name}">${p.name}</div></td>
                                            <td class="text-center fw-bold ${p.stock == 0 ? 'text-danger' : 'text-warning'}">${p.stock}</td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-sm btn-primary py-1 px-3 text-white fw-medium" style="font-size: 11px; border-radius: 6px;">
                                                    <i class="ph-bold ph-plus me-1"></i> Nhập hàng
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty lowStockProducts}">
                                        <tr><td colspan="3" class="text-center text-muted py-5"><i class="ph-fill ph-check-circle text-success fs-2 mb-2 d-block"></i> Kho hàng an toàn</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
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

<!-- SCRIPTS VẼ BIỂU ĐỒ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); });

    flatpickr("#customDateRange", { mode: "range", dateFormat: "d/m/Y", locale: "vn" });
    function toggleCustomDate() {
        var sel = document.getElementById("periodSelect").value;
        var dateInput = document.getElementById("customDateRange");
        if (sel === 'custom') { dateInput.classList.remove('d-none'); dateInput.focus(); }
        else { dateInput.classList.add('d-none'); document.getElementById("filterForm").submit(); }
    }

    const trendLabels = [ <c:forEach items="${trendData}" var="entry">"${entry.key}",</c:forEach> ];
    const revData = [ <c:forEach items="${trendData}" var="entry">${entry.value[0]},</c:forEach> ];
    const ordData = [ <c:forEach items="${trendData}" var="entry">${entry.value[1]},</c:forEach> ];

    Chart.defaults.font.family = "'Inter', sans-serif";
    Chart.defaults.color = "#64748B";

    if (trendLabels.length > 0) {
        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: {
                labels: trendLabels,
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: revData,
                    backgroundColor: '#3B82F6',
                    borderRadius: 2,
                    maxBarThickness: 40,
                    barPercentage: 0.8,
                    categoryPercentage: 0.9
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false }, ticks: {font:{size: 10}} },
                    y: {
                        border: { display: false },
                        grid: { color: '#F1F5F9' },
                        ticks: {
                            font:{size: 10},
                            callback: function(value) {
                                if (value >= 1000000000) return (value / 1000000000) + ' Tỷ';
                                if (value >= 1000000) return (value / 1000000) + ' Tr';
                                return value;
                            }
                        }
                    }
                }
            }
        });
    }

    // BIỂU ĐỒ TRÒN: DOANH THU THEO KÊNH BÁN HÀNG
    const websiteRev = ${not empty websiteRev ? websiteRev : 0};
    const storeRev = ${not empty storeRev ? storeRev : 0};
    const safeWeb = (websiteRev === 0 && storeRev === 0) ? 1 : websiteRev;
    const safeStore = (websiteRev === 0 && storeRev === 0) ? 0 : storeRev;
    const bgColors = (websiteRev === 0 && storeRev === 0) ? ['#E2E8F0', '#E2E8F0'] : ['#3B82F6', '#10B981'];

    new Chart(document.getElementById('donutChart'), {
        type: 'doughnut',
        data: {
            labels: ['Kênh Online (Website)', 'Trực tiếp (Cửa hàng)'],
            datasets: [{ data: [safeWeb, safeStore], backgroundColor: bgColors, borderWidth: 0, cutout: '75%' }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: { enabled: false }
            }
        }
    });

    // Biểu đồ Top Sản phẩm
    const topProdLabels = [ <c:forEach items="${topProductsBar}" var="p">"${fn:escapeXml(p.name)}",</c:forEach> ];
    const topProdRevs = [ <c:forEach items="${topProductsBar}" var="p">${p.rev},</c:forEach> ];

    if (topProdLabels.length > 0) {
        new Chart(document.getElementById('topProductsChart'), {
            type: 'bar',
            data: {
                labels: topProdLabels,
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: topProdRevs,
                    backgroundColor: '#F59E0B',
                    borderRadius: 4,
                    maxBarThickness: 24
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { color: '#F1F5F9' }, ticks:{font:{size:10}} },
                    y: { grid: { display: false }, ticks:{font:{size:10}} }
                }
            }
        });
    }
</script>
</body>
</html>