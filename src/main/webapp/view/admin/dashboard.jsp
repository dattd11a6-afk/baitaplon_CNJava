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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>

    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --sidebar-bg: #111827; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #EAEAEC; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 14px; }
        .sidebar-menu li a:hover, .sidebar-menu li.active a { color: #fff; background-color: rgba(255,255,255,0.08); border-left-color: var(--primary); }
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 24px; box-shadow: none; height: 100%; }
        .kpi-title { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .kpi-value { font-family: 'DM Sans', sans-serif; font-size: 28px; font-weight: 700; color: #111827; }
        .flatpickr-input[readonly] { background-color: #fff; cursor: pointer; }
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 24px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar d-flex flex-column">
        <div class="p-4 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="fw-bold fs-5 brand-font text-white"><i class="ph-fill ph-leaf text-success me-2"></i>Fruit Farmer</div>
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
        <div class="mt-auto pb-4 border-top pt-4" style="border-color: rgba(255,255,255,0.05)!important;">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a>
        </div>
    </aside>

    <main class="flex-grow-1 overflow-auto p-4 px-5" style="height: 100vh;">
        <!-- HEADER & BỘ LỌC NGÀY -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold m-0 brand-font text-dark">Phân tích Kinh doanh</h2>
                <div class="text-muted mt-1" style="font-size: 13px;">
                    <span class="fw-medium text-dark">${currentRangeText}</span>
                </div>
            </div>

            <form id="filterForm" action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="d-flex gap-2 m-0">
                <select name="period" id="periodSelect" class="form-select fw-medium shadow-sm" onchange="toggleCustomDate()">
                    <option value="today" ${period == 'today' ? 'selected' : ''}>Hôm nay</option>
                    <option value="this_week" ${period == 'this_week' ? 'selected' : ''}>Tuần này</option>
                    <option value="this_month" ${period == 'this_month' ? 'selected' : ''}>Tháng này</option>
                    <option value="this_quarter" ${period == 'this_quarter' ? 'selected' : ''}>Quý này</option>
                    <option value="this_year" ${period == 'this_year' ? 'selected' : ''}>Năm nay</option>
                    <option value="custom" ${period == 'custom' ? 'selected' : ''}>Tùy chỉnh...</option>
                </select>
                <input type="text" name="custom_dates" id="customDateRange" class="form-control shadow-sm ${period != 'custom' ? 'd-none' : ''}" placeholder="Chọn khoảng ngày...">
                <button type="submit" class="btn btn-dark shadow-sm">Lọc</button>
            </form>
        </div>

        <!-- 4 KPI -->
        <div class="row g-4 mb-4">
            <div class="col-md-3"><div class="admin-card">
                <div class="kpi-title">Doanh Thu Thuần</div>
                <div class="kpi-value text-success"><fmt:formatNumber value="${summary.currentRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                <div class="mt-2 text-muted" style="font-size: 12px;"><span class="${summary.revenueGrowth >= 0 ? 'text-success' : 'text-danger'} fw-bold">${summary.revenueGrowth >= 0 ? '↑' : '↓'} <fmt:formatNumber value="${summary.revenueGrowth}" maxFractionDigits="1"/>%</span> so với ${compareText}</div>
            </div></div>
            <div class="col-md-3"><div class="admin-card">
                <div class="kpi-title">Đơn Thành Công</div>
                <div class="kpi-value">${summary.currentOrders}</div>
                <div class="mt-2 text-muted" style="font-size: 12px;"><span class="${summary.ordersGrowth >= 0 ? 'text-success' : 'text-danger'} fw-bold">${summary.ordersGrowth >= 0 ? '↑' : '↓'} <fmt:formatNumber value="${summary.ordersGrowth}" maxFractionDigits="1"/>%</span> so với ${compareText}</div>
            </div></div>
            <div class="col-md-3"><div class="admin-card">
                <div class="kpi-title">Giá trị TB Đơn (AOV)</div>
                <div class="kpi-value"><fmt:formatNumber value="${summary.currentAov}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                <div class="mt-2 text-muted" style="font-size: 12px;">Đo lường sức mua khách hàng</div>
            </div></div>
            <div class="col-md-3"><div class="admin-card">
                <div class="kpi-title">Khách Mới</div>
                <div class="kpi-value">${summary.currentCustomers}</div>
                <div class="mt-2 text-muted" style="font-size: 12px;">Kỳ trước: ${summary.previousCustomers} khách</div>
            </div></div>
        </div>

        <!-- 2 BIỂU ĐỒ TÁCH RỜI -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="admin-card">
                    <h6 class="fw-bold mb-4 brand-font text-dark">Biểu đồ Doanh Thu (VNĐ)</h6>
                    <div style="height: 250px;"><canvas id="revenueChart"></canvas></div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="admin-card">
                    <h6 class="fw-bold mb-4 brand-font text-dark">Biểu đồ Lượng Đơn Hàng</h6>
                    <div style="height: 250px;"><canvas id="ordersChart"></canvas></div>
                </div>
            </div>
        </div>

        <!-- TOP 5 SẢN PHẨM & KÊNH DONUT -->
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="admin-card">
                    <h6 class="fw-bold mb-4 brand-font text-dark">Top 5 Sản Phẩm Chạy Nhất</h6>
                    <div style="height: 280px;"><canvas id="topProductsChart"></canvas></div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="admin-card d-flex flex-column">
                    <h6 class="fw-bold mb-2 brand-font text-dark">Tỷ trọng Kênh Bán Hàng</h6>
                    <div class="position-relative d-flex justify-content-center align-items-center mb-4 mt-2" style="height: 160px;">
                        <canvas id="channelDonutChart"></canvas>
                        <div class="position-absolute text-center" style="pointer-events: none;">
                            <div class="text-muted fw-bold" style="font-size: 10px; letter-spacing: 1px;">TỔNG CỘNG</div>
                            <div class="fw-bold text-dark mt-1 brand-font" style="font-size: 18px;">
                                <fmt:formatNumber value="${summary.currentRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex flex-column gap-2 mt-auto">
                        <div class="d-flex justify-content-between align-items-center p-2 rounded" style="background: #F9FAFB;">
                            <div class="d-flex align-items-center gap-2"><div style="width: 12px; height: 12px; background-color: #10B981; border-radius: 3px;"></div><span class="text-dark fw-medium" style="font-size: 13px;">Online (Web)</span></div>
                            <div class="text-end"><div class="fw-bold text-dark" style="font-size: 13px;"><fmt:formatNumber value="${empty webRev ? 0 : webRev}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div><div class="text-muted" style="font-size: 11px;"><fmt:formatNumber value="${empty webPct ? 0 : webPct}" maxFractionDigits="1"/>%</div></div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center p-2 rounded" style="background: #F9FAFB;">
                            <div class="d-flex align-items-center gap-2"><div style="width: 12px; height: 12px; background-color: #3B82F6; border-radius: 3px;"></div><span class="text-dark fw-medium" style="font-size: 13px;">Cửa hàng (POS)</span></div>
                            <div class="text-end"><div class="fw-bold text-dark" style="font-size: 13px;"><fmt:formatNumber value="${empty storeRev ? 0 : storeRev}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div><div class="text-muted" style="font-size: 11px;"><fmt:formatNumber value="${empty storePct ? 0 : storePct}" maxFractionDigits="1"/>%</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ACTION CENTER & INVENTORY ALERT -->
        <div class="row g-4">
            <!-- Cần Xử Lý Ngay -->
            <div class="col-lg-6">
                <div class="admin-card bg-light border-0">
                    <h6 class="fw-bold text-dark mb-3 brand-font"><i class="ph-fill ph-lightning text-warning fs-5 align-bottom me-1"></i> Cần Xử Lý Ngay</h6>
                    <div class="d-flex flex-column">
                        <c:if test="${pendingOrdersCount > 0}">
                            <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING" class="d-flex justify-content-between align-items-center py-3 text-decoration-none border-bottom border-light">
                                <span class="text-dark fw-medium" style="font-size: 14px;"><span class="badge bg-danger rounded-pill me-2">${pendingOrdersCount}</span> Đơn hàng chờ xác nhận</span>
                                <i class="ph ph-caret-right text-muted"></i>
                            </a>
                        </c:if>
                        <c:if test="${not empty lowStockProducts}">
                            <a href="${pageContext.request.contextPath}/admin/products" class="d-flex justify-content-between align-items-center py-3 text-decoration-none">
                                <span class="text-dark fw-medium" style="font-size: 14px;"><span class="badge bg-warning text-dark rounded-pill me-2">${fn:length(lowStockProducts)}</span> Sản phẩm dưới mức an toàn</span>
                                <i class="ph ph-caret-right text-muted"></i>
                            </a>
                        </c:if>
                        <c:if test="${pendingOrdersCount == 0 && empty lowStockProducts}">
                            <div class="text-muted py-3" style="font-size: 14px;"><i class="ph-fill ph-check-circle text-success me-2"></i> Không có công việc khẩn cấp.</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Cảnh Báo Tồn Kho & Nút Nhập Hàng -->
            <div class="col-lg-6">
                <div class="admin-card border-danger-subtle h-100">
                    <h6 class="fw-bold text-danger mb-4 brand-font"><i class="ph-fill ph-warning-circle"></i> Cảnh báo Tồn kho</h6>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="p" items="${lowStockProducts}">
                            <div class="d-flex justify-content-between align-items-center pb-3 border-bottom border-light">
                                <div class="flex-grow-1 pe-3">
                                    <div class="fw-semibold text-dark text-truncate mb-1" style="font-size: 14px;">${p.name}</div>
                                    <span class="badge ${p.stock == 0 ? 'bg-danger' : 'bg-warning text-dark'}" style="font-size: 11px;">Còn ${p.stock} ${p.unit}</span>
                                </div>
                                <!-- Nút Nhập Hàng -->
                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}" class="btn btn-sm ${p.stock == 0 ? 'btn-danger' : 'btn-warning'} fw-bold px-3">Nhập hàng</a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty lowStockProducts}">
                            <div class="text-muted" style="font-size: 14px;"><i class="ph-fill ph-check-circle text-success me-1"></i> Kho hàng đang ở mức an toàn.</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
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

    if (trendLabels.length > 0) {
        const xAxisConfig = {
            grid: { display: false },
            ticks: {
                maxRotation: 0,
                maxTicksLimit: 8,
                font: { size: 11 },
                callback: function(value) {
                    let label = this.getLabelForValue(value);
                    if (label && label.length === 10) {
                        let parts = label.split('-');
                        return parts[2] + '/' + parts[1];
                    }
                    return label;
                }
            }
        };

        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: { labels: trendLabels, datasets: [{ label: 'Doanh thu (₫)', data: revData, backgroundColor: '#10B981', borderRadius: 4 }] },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: xAxisConfig, y: { border: { dash: [4, 4] } } } }
        });

        new Chart(document.getElementById('ordersChart'), {
            type: 'line',
            data: { labels: trendLabels, datasets: [{ label: 'Số lượng đơn', data: ordData, borderColor: '#3B82F6', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderWidth: 3, fill: true, tension: 0.4 }] },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: xAxisConfig, y: { border: { dash: [4, 4] }, ticks: { stepSize: 1 } } } }
        });
    }

    const topProdLabels = [ <c:forEach items="${topProductsBar}" var="p">"${fn:escapeXml(p.name)}",</c:forEach> ];
    const topProdRevs = [ <c:forEach items="${topProductsBar}" var="p">${p.rev},</c:forEach> ];
    const totalRevenue = ${summary.currentRevenue > 0 ? summary.currentRevenue : 1};

    if (topProdLabels.length > 0) {
        new Chart(document.getElementById('topProductsChart'), {
            type: 'bar',
            data: {
                labels: topProdLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: topProdRevs,
                    backgroundColor: '#F59E0B',
                    borderRadius: 4,
                    barThickness: 24
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        padding: 12,
                        callbacks: {
                            label: function(ctx) {
                                let rev = ctx.raw;
                                let percentage = ((rev / totalRevenue) * 100).toFixed(1);
                                let formattedRev = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(rev);
                                return ' Doanh thu: ' + formattedRev + ' (' + percentage + '%)';
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { borderDash: [4, 4] },
                        ticks: {
                            callback: function(value) {
                                if (value >= 1000000) return (value / 1000000) + 'M';
                                if (value >= 1000) return (value / 1000) + 'k';
                                return value;
                            }
                        }
                    },
                    y: {
                        grid: { display: false },
                        ticks: { font: { weight: '500', size: 12 } }
                    }
                }
            }
        });
    }

    const channelLabels = ['Online (Website)', 'Tại cửa hàng (POS)'];
    const channelRevenues = [${empty webRev ? 0 : webRev}, ${empty storeRev ? 0 : storeRev}];
    const hasData = channelRevenues[0] > 0 || channelRevenues[1] > 0;

    new Chart(document.getElementById('channelDonutChart'), {
        type: 'doughnut',
        data: {
            labels: hasData ? channelLabels : ['Chưa có dữ liệu'],
            datasets: [{ data: hasData ? channelRevenues : [1], backgroundColor: hasData ? ['#10B981', '#3B82F6'] : ['#E5E7EB'], borderWidth: 0, cutout: '75%', hoverOffset: 4 }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false }, tooltip: { enabled: hasData } } }
    });
</script>
</body>
</html>