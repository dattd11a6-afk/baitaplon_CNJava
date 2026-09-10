<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Analytics Dashboard | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 24px; box-shadow: none; height: 100%; }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 12px 20px; color: var(--text-muted); background: #F9FAFB; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--border-color); text-align: left; }
        .admin-table td { padding: 16px 20px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-main); text-align: left; }
        .col-number { text-align: right !important; font-family: 'DM Sans', sans-serif; font-weight: 600; }
        .kpi-title { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .kpi-value { font-family: 'DM Sans', sans-serif; font-size: 28px; font-weight: 700; color: #111827; }
        .product-mini-img { width: 36px; height: 36px; object-fit: cover; border-radius: 6px; border: 1px solid var(--border-color); background: #fff;}
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
            <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph ph-squares-four"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph ph-receipt"></i> Đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph ph-package"></i> Sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph ph-tag"></i> Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted"></div></header>
        <div class="p-4 px-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold m-0 brand-font text-dark">Phân tích Kinh doanh</h2>
                    <div class="text-muted mt-1" style="font-size: 13px;">
                        <span class="fw-medium text-dark">${currentRangeText}</span>
                        <span class="mx-2">|</span> So với: ${previousRangeText}
                    </div>
                </div>
                <form id="filterForm" action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="m-0">
                    <select name="period" class="form-select border-secondary text-dark fw-medium shadow-sm py-2" onchange="document.getElementById('filterForm').submit()">
                        <option value="today" ${period == 'today' ? 'selected' : ''}>Hôm nay</option>
                        <option value="yesterday" ${period == 'yesterday' ? 'selected' : ''}>Hôm qua</option>
                        <option value="this_week" ${period == 'this_week' ? 'selected' : ''}>Tuần này</option>
                        <option value="this_month" ${period == 'this_month' ? 'selected' : ''}>Tháng này</option>
                        <option value="this_quarter" ${period == 'this_quarter' ? 'selected' : ''}>Quý này</option>
                        <option value="this_year" ${period == 'this_year' ? 'selected' : ''}>Năm nay</option>
                    </select>
                </form>
            </div>

            <c:set var="aovGrowth" value="${summary.previousAov > 0 ? ((summary.currentAov - summary.previousAov) / summary.previousAov) * 100 : (summary.currentAov > 0 ? 100 : 0)}" />

            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="admin-card">
                        <div class="kpi-title"><i class="ph ph-wallet me-1"></i> Doanh Thu Thuần</div>
                        <div class="kpi-value text-success"><fmt:formatNumber value="${summary.currentRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                        <div class="mt-2" style="font-size: 12px;">
                            <c:choose>
                                <c:when test="${summary.revenueGrowth > 0}"><span class="text-success fw-bold"><i class="ph-bold ph-trend-up"></i> +<fmt:formatNumber value="${summary.revenueGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:when test="${summary.revenueGrowth < 0}"><span class="text-danger fw-bold"><i class="ph-bold ph-trend-down"></i> <fmt:formatNumber value="${summary.revenueGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:otherwise><span class="text-muted fw-bold">0.0%</span></c:otherwise>
                            </c:choose>
                            <span class="text-muted"> so với kỳ trước</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="admin-card">
                        <div class="kpi-title"><i class="ph ph-receipt me-1"></i> Đơn Hàng Thành Công</div>
                        <div class="kpi-value">${summary.currentOrders} <span class="fw-normal text-muted fs-6">đơn</span></div>
                        <div class="mt-2" style="font-size: 12px;">
                            <c:choose>
                                <c:when test="${summary.ordersGrowth > 0}"><span class="text-success fw-bold"><i class="ph-bold ph-trend-up"></i> +<fmt:formatNumber value="${summary.ordersGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:when test="${summary.ordersGrowth < 0}"><span class="text-danger fw-bold"><i class="ph-bold ph-trend-down"></i> <fmt:formatNumber value="${summary.ordersGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:otherwise><span class="text-muted fw-bold">0.0%</span></c:otherwise>
                            </c:choose>
                            <span class="text-muted"> so với kỳ trước</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="admin-card">
                        <div class="kpi-title"><i class="ph ph-shopping-cart me-1"></i> AOV (TB/Đơn)</div>
                        <div class="kpi-value"><fmt:formatNumber value="${summary.currentAov}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                        <div class="mt-2" style="font-size: 12px;">
                            <c:choose>
                                <c:when test="${aovGrowth > 0}"><span class="text-success fw-bold"><i class="ph-bold ph-trend-up"></i> +<fmt:formatNumber value="${aovGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:when test="${aovGrowth < 0}"><span class="text-danger fw-bold"><i class="ph-bold ph-trend-down"></i> <fmt:formatNumber value="${aovGrowth}" maxFractionDigits="1"/>%</span></c:when>
                                <c:otherwise><span class="text-muted fw-bold">0.0%</span></c:otherwise>
                            </c:choose>
                            <span class="text-muted"> so với kỳ trước</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="admin-card">
                        <div class="kpi-title"><i class="ph ph-users me-1"></i> Khách Mới</div>
                        <div class="kpi-value">${summary.currentCustomers} <span class="fw-normal text-muted fs-6">khách mới</span></div>
                        <div class="mt-2" style="font-size: 12px;">
                            <span class="text-muted">Kỳ trước: </span><span class="fw-medium text-dark">${summary.previousCustomers} khách</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="admin-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold m-0 brand-font">Doanh thu & Đơn hàng</h6>
                            <span class="badge bg-light text-dark border">Theo ngày</span>
                        </div>
                        <div style="height: 300px;"><canvas id="comboChart"></canvas></div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="admin-card d-flex flex-column">
                        <h6 class="fw-bold mb-4 brand-font text-dark">Doanh thu theo Kênh</h6>
                        <div class="position-relative d-flex justify-content-center align-items-center mb-4 mt-2" style="height: 180px;">
                            <canvas id="channelDonutChart"></canvas>
                            <div class="position-absolute text-center" style="pointer-events: none;">
                                <div class="text-muted fw-bold" style="font-size: 10px; letter-spacing: 1px;">TỔNG CỘNG</div>
                                <div class="fw-bold text-dark mt-1 brand-font" style="font-size: 20px;">
                                    <fmt:formatNumber value="${summary.currentRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex flex-column gap-3 mt-auto">
                            <c:if test="${webRev > 0 || storeRev == 0}">
                                <div class="d-flex justify-content-between align-items-center p-2 rounded" style="background: #F9FAFB;">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width: 12px; height: 12px; background-color: #10B981; border-radius: 3px;"></div>
                                        <span class="text-dark fw-medium" style="font-size: 13px;">Online (Web)</span>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold text-dark" style="font-size: 13px;"><fmt:formatNumber value="${webRev}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                        <div class="text-muted" style="font-size: 11px;"><fmt:formatNumber value="${webPct}" maxFractionDigits="1"/>% &bull; ${webOrders} đơn</div>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${storeRev > 0 || webRev == 0}">
                                <div class="d-flex justify-content-between align-items-center p-2 rounded" style="background: #F9FAFB;">
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width: 12px; height: 12px; background-color: #3B82F6; border-radius: 3px;"></div>
                                        <span class="text-dark fw-medium" style="font-size: 13px;">Cửa hàng (POS)</span>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold text-dark" style="font-size: 13px;"><fmt:formatNumber value="${storeRev}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                        <div class="text-muted" style="font-size: 11px;"><fmt:formatNumber value="${storePct}" maxFractionDigits="1"/>% &bull; ${storeOrders} đơn</div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tồn kho & Sản phẩm & Action Center -->
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="admin-card p-0 overflow-hidden">
                        <div class="p-4 border-bottom bg-white"><h6 class="fw-bold m-0 brand-font">Top Sản phẩm bán chạy nhất</h6></div>
                        <table class="admin-table">
                            <thead><tr><th>Sản phẩm</th><th class="col-number">SL Bán</th><th class="col-number">Doanh thu</th><th class="col-number">Tỷ trọng</th></tr></thead>
                            <tbody>
                                <c:forEach var="tp" items="${topProducts}">
                                    <tr>
                                        <td class="fw-semibold">${tp.productName}</td>
                                        <td class="col-number text-dark">${tp.quantitySold}</td>
                                        <td class="col-number text-success"><fmt:formatNumber value="${tp.revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="col-number text-muted"><fmt:formatNumber value="${tp.percentage}" maxFractionDigits="1"/>%</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-lg-6">
                    <!-- KHÔI PHỤC CẢNH BÁO TỒN KHO CÓ THANH TRẠNG THÁI & ẢNH -->
                    <div class="admin-card mb-4 border-danger-subtle">
                        <h6 class="fw-bold text-danger mb-4 brand-font"><i class="ph-fill ph-warning-circle"></i> Cảnh báo Tồn kho</h6>
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="p" items="${lowStockProducts}">
                                <div class="d-flex justify-content-between align-items-center pb-3 border-bottom border-light">
                                    <div class="d-flex align-items-center gap-3 w-75">
                                        <!-- Xử lý ảnh không bị vỡ -->
                                        <c:set var="imgs" value="${fn:split(p.image, ',')}" />
                                        <c:set var="fallbackImg" value="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200" />
                                        <c:choose>
                                            <c:when test="${not empty imgs[0] && fn:startsWith(fn:trim(imgs[0]), 'http')}">
                                                <img src="${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:when test="${not empty imgs[0]}">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${fn:trim(imgs[0])}" onerror="this.onerror=null; this.src='${fallbackImg}';" class="product-mini-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${fallbackImg}" class="product-mini-img">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="flex-grow-1">
                                            <div class="fw-semibold text-dark text-truncate mb-1" style="font-size: 13px;">${p.name}</div>
                                            <!-- Thanh Progress bar -->
                                            <div class="d-flex align-items-center gap-2">
                                                <div style="height:6px; background:#EAEAEC; border-radius:99px; width:100px;">
                                                    <div class="${p.stock == 0 ? 'bg-danger' : 'bg-warning'}" style="height:100%; border-radius:99px; width: ${p.stock > 10 ? 100 : p.stock * 10}%;"></div>
                                                </div>
                                                <span class="fw-bold ${p.stock == 0 ? 'text-danger' : 'text-warning text-dark'}" style="font-size: 11px;">Còn ${p.stock} ${p.unit}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Label và Nút Nhập hàng -->
                                    <div class="d-flex flex-column align-items-end gap-1">
                                        <span class="badge ${p.stock == 0 ? 'bg-danger' : 'bg-warning text-dark'} rounded-pill" style="font-size: 10px;">${p.stock == 0 ? 'Nguy cấp' : 'Sắp hết'}</span>
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="text-primary text-decoration-none" style="font-size: 12px; font-weight: 500;">Nhập hàng</a>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty lowStockProducts}">
                                <div class="text-muted" style="font-size: 13px;"><i class="ph-fill ph-check-circle text-success me-1"></i> Kho hàng đang ở mức an toàn.</div>
                            </c:if>
                        </div>
                    </div>

                    <!-- ACTION CENTER PHẲNG (Đã xóa viền trắng luộm thuộm) -->
                    <div class="admin-card bg-light border-0">
                        <h6 class="fw-bold text-dark mb-3 brand-font"><i class="ph-fill ph-lightning text-warning fs-5 align-bottom me-1"></i> Cần Xử Lý Ngay</h6>
                        <div class="d-flex flex-column">
                            <a href="${pageContext.request.contextPath}/admin/orders" class="d-flex justify-content-between align-items-center py-2 text-decoration-none border-bottom border-light">
                                <span class="text-dark fw-medium" style="font-size: 13px;"><span class="badge bg-danger rounded-pill me-2">${pendingOrdersCount}</span> Đơn hàng chờ xác nhận</span>
                                <i class="ph ph-caret-right text-muted"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/products" class="d-flex justify-content-between align-items-center py-2 text-decoration-none">
                                <span class="text-dark fw-medium" style="font-size: 13px;"><span class="badge bg-warning text-dark rounded-pill me-2">${fn:length(lowStockProducts)}</span> Sản phẩm dưới mức an toàn</span>
                                <i class="ph ph-caret-right text-muted"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const comboLabels = [ <c:forEach items="${comboChartData}" var="entry">"${entry.key}",</c:forEach> ];
    const revenueData = [ <c:forEach items="${comboChartData}" var="entry">${entry.value[0]},</c:forEach> ];
    const ordersData = [ <c:forEach items="${comboChartData}" var="entry">${entry.value[1]},</c:forEach> ];
    const isLongPeriod = comboLabels.length > 31;

    new Chart(document.getElementById('comboChart'), {
        type: 'line',
        data: {
            labels: comboLabels,
            datasets: [
                { label: 'Số lượng đơn', type: 'line', data: ordersData, borderColor: '#F59E0B', backgroundColor: 'rgba(245, 158, 11, 0.1)', borderWidth: 2.5, fill: true, pointBackgroundColor: '#F59E0B', pointRadius: isLongPeriod ? 0 : 3, pointHoverRadius: 6, tension: 0.4, yAxisID: 'y1' },
                { label: 'Doanh thu (VNĐ)', type: 'bar', data: revenueData, backgroundColor: 'rgba(16, 185, 129, 0.85)', borderRadius: 4, barThickness: isLongPeriod ? 10 : 'flex', maxBarThickness: 35, yAxisID: 'y' }
            ]
        },
        options: {
            responsive: true, maintainAspectRatio: false, interaction: { mode: 'index', intersect: false },
            scales: {
                x: { ticks: { maxTicksLimit: 8, maxRotation: 0, align: 'center', font: {size: 11} }, grid: { display: false } },
                y: { type: 'linear', position: 'left', grid: { borderDash: [4, 4], color: '#EAEAEC' }, ticks: { font: {size: 11} } },
                y1: { type: 'linear', position: 'right', grid: { drawOnChartArea: false }, min: 0, ticks: { precision: 0, font: {size: 11} } }
            }
        }
    });

    const channelLabels = ['Online (Website)', 'Tại cửa hàng (POS)'];
    const channelRevenues = [${webRev}, ${storeRev}];
    const hasData = channelRevenues[0] > 0 || channelRevenues[1] > 0;

    new Chart(document.getElementById('channelDonutChart'), {
        type: 'doughnut',
        data: {
            labels: hasData ? channelLabels : ['Chưa có dữ liệu'],
            datasets: [{
                data: hasData ? channelRevenues : [1], backgroundColor: hasData ? ['#10B981', '#3B82F6'] : ['#E5E7EB'], borderWidth: 0, cutout: '75%', hoverOffset: 4
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: { enabled: hasData, callbacks: { label: function(ctx) { return ' ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(ctx.raw); } } }
            }
        }
    });
</script>
</body>
</html>