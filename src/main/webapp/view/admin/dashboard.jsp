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
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #EAEAEC; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* CSS CHUẨN MỚI CHO SIDEBAR */
        .sidebar { width: 260px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 14px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li a:hover i { color: var(--primary); transform: scale(1.1); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.2); }

        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 24px; box-shadow: none; height: 100%; }
        .kpi-title { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .kpi-value { font-family: 'DM Sans', sans-serif; font-size: 28px; font-weight: 700; color: #111827; }
        .flatpickr-input[readonly] { background-color: #fff; cursor: pointer; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 36px; height: 36px; background: linear-gradient(135deg, var(--primary), #10B981);">
                <i class="ph-bold ph-leaf text-white fs-5"></i>
            </div>
            <div>
                <div class="fw-bold fs-5 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div>
                <div style="font-size: 10px; color: #10B981; font-weight: 600; letter-spacing: 1px;">ADMIN WORKSPACE</div>
            </div>
        </div>

        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li class="${pageContext.request.servletPath == '/view/admin/dashboard.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
                <li class="${pageContext.request.servletPath == '/view/admin/reports.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo kinh doanh</a></li>

                <div class="menu-label">Bán hàng</div>
                <li class="${pageContext.request.servletPath == '/view/admin/orders.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                <li class="${pageContext.request.servletPath == '/view/admin/customers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                <li class="${pageContext.request.servletPath == '/view/admin/vouchers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>

                <li class="${pageContext.request.servletPath == '/view/admin/reviews.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>

                <div class="menu-label">Kho & Hàng hóa</div>
                <li class="${pageContext.request.servletPath == '/view/admin/products.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Danh sách Sản phẩm</a></li>
                <li class="${pageContext.request.servletPath == '/view/admin/categories.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>

                <li class="${pageContext.request.servletPath == '/view/admin/admin-accessories.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>

                <li class="${pageContext.request.servletPath == '/view/admin/inventory.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập kho</a></li>
                <li class="${pageContext.request.servletPath == '/view/admin/suppliers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/suppliers"><i class="ph-fill ph-truck"></i> Nhà cung cấp</a></li>

                <div class="menu-label">Cấu hình</div>
                <li class="${pageContext.request.servletPath == '/view/admin/staff.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân viên</a></li>
                <li><a href="${pageContext.request.contextPath}/shipper" target="_blank"><i class="ph-fill ph-motorcycle"></i> Giao diện Shipper</a></li>
            </ul>
        </div>

        <div class="p-4 border-top" style="border-color: rgba(255,255,255,0.05)!important;">
            <a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center justify-content-center py-2 px-3 text-decoration-none rounded" style="background: rgba(239, 68, 68, 0.1); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.2); transition: 0.2s;">
                <i class="ph-bold ph-sign-out fs-5 me-2"></i> Đăng xuất
            </a>
        </div>
    </aside>

    <main class="flex-grow-1 overflow-auto p-4 px-5" style="height: 100vh;">
        <!-- BỘ LỌC NGÀY -->
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

        <!-- 2 BIỂU ĐỒ -->
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

        <!-- SẢN PHẨM & CẢNH BÁO -->
        <div class="row g-4 mb-4">
            <div class="col-lg-7">
                <div class="admin-card">
                    <h6 class="fw-bold mb-4 brand-font text-dark">Top 5 Sản Phẩm Chạy Nhất</h6>
                    <div style="height: 280px;"><canvas id="topProductsChart"></canvas></div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="admin-card border-danger-subtle h-100">
                    <h6 class="fw-bold text-danger mb-4 brand-font"><i class="ph-fill ph-warning-circle"></i> Cảnh báo Tồn kho</h6>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="p" items="${lowStockProducts}">
                            <div class="d-flex justify-content-between align-items-center pb-3 border-bottom border-light">
                                <div class="flex-grow-1 pe-3">
                                    <div class="fw-semibold text-dark text-truncate mb-1" style="font-size: 14px;">${p.name}</div>
                                    <span class="badge ${p.stock == 0 ? 'bg-danger' : 'bg-warning text-dark'}" style="font-size: 11px;">Còn ${p.stock} ${p.unit}</span>
                                </div>
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
        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: { labels: trendLabels, datasets: [{ label: 'Doanh thu (₫)', data: revData, backgroundColor: '#10B981', borderRadius: 4 }] },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { border: { dash: [4, 4] } } } }
        });

        new Chart(document.getElementById('ordersChart'), {
            type: 'line',
            data: { labels: trendLabels, datasets: [{ label: 'Số lượng đơn', data: ordData, borderColor: '#3B82F6', backgroundColor: 'rgba(59, 130, 246, 0.1)', borderWidth: 3, fill: true, tension: 0.4 }] },
            options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { grid: { display: false } }, y: { border: { dash: [4, 4] }, ticks: { stepSize: 1 } } } }
        });
    }

    const topProdLabels = [ <c:forEach items="${topProductsBar}" var="p">"${fn:escapeXml(p.name)}",</c:forEach> ];
    const topProdRevs = [ <c:forEach items="${topProductsBar}" var="p">${p.rev},</c:forEach> ];

    if (topProdLabels.length > 0) {
        new Chart(document.getElementById('topProductsChart'), {
            type: 'bar',
            data: { labels: topProdLabels, datasets: [{ label: 'Doanh thu', data: topProdRevs, backgroundColor: '#F59E0B', borderRadius: 4, barThickness: 24 }] },
            options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { grid: { borderDash: [4, 4] } }, y: { grid: { display: false } } } }
        });
    }
</script>
</body>
</html>