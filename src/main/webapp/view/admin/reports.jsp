<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo Thống kê | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* ZOTECH CORE UI */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* ZOTECH SIDEBAR */
        .sidebar { width: 250px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 13px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        /* ZOTECH MAIN & HEADER */
        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); display: flex; flex-direction: column; min-height: 100vh;}
        .z-topbar { height: 70px; background: var(--z-surface); border-bottom: 1px solid var(--z-border); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; position: sticky; top: 0; z-index: 10; }

        /* REPORTS CSS */
        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 8px; padding: 24px; box-shadow: none; height: 100%; }
        .kpi-title { font-size: 12px; color: var(--z-text-muted); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .btn-action { border-radius: 6px; font-weight: 500; font-size: 13px; padding: 8px 16px; border: 1px solid var(--z-border); background: var(--z-surface); color: var(--z-text-main); transition: 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;}
        .btn-action:hover { background: #F3F4F6; color: var(--z-text-main); }
        @media print {
            body { background-color: #fff; }
            .sidebar, .z-topbar, .btn-action, .toast-container { display: none !important; }
            .main-wrapper { margin-left: 0 !important; width: 100% !important; overflow: visible !important; }
            .admin-card { border: none !important; padding: 10px !important; break-inside: avoid; }
            .report-header { text-align: center; margin-bottom: 30px; display: block !important; }
        }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- ZOTECH SIDEBAR -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), #10B981);">
                <i class="ph-bold ph-leaf text-white fs-6"></i>
            </div>
            <div><div class="fw-bold fs-6 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div></div>
        </div>
        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo</a></li>
                <div class="menu-label">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>
                <div class="menu-label">Kho & Vận hành</div>
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>
            </ul>
        </div>
    </aside>

    <!-- ZOTECH MAIN WAPPER & HEADER -->
    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="z-topbar">
            <div class="d-flex align-items-center gap-3"></div>
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
        </header>

        <div class="p-4 px-5">
            <!-- Header Ẩn: Chỉ hiện khi in ra PDF -->
            <div class="report-header d-none">
                <h2 class="brand-font fw-bold">BÁO CÁO KẾT QUẢ KINH DOANH FRUIT FARMER</h2>
                <p>Ngày tạo: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/></p><hr>
            </div>

            <!-- TIÊU ĐỀ & NÚT EXPORT -->
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h2 class="fw-bold m-0 brand-font text-dark" style="font-size: 28px;">Báo cáo & Phân tích</h2>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/admin/reports?action=exportExcel" class="btn-action text-success">
                        <i class="ph-fill ph-file-csv fs-5"></i> Xuất Excel (CSV)
                    </a>
                    <button onclick="window.print()" class="btn-action">
                        <i class="ph-fill ph-printer fs-5"></i> In PDF
                    </button>
                </div>
            </div>

            <!-- DỮ LIỆU THẬT -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="admin-card" style="border-left: 4px solid var(--primary);">
                        <div class="kpi-title"><i class="ph ph-wallet me-1"></i> Tổng Doanh Thu Giao Dịch</div>
                        <div class="text-success brand-font fw-bold" style="font-size: 32px;"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                        <div class="mt-2 text-muted" style="font-size: 13px;">Chỉ tính các đơn hàng đã giao thành công (COMPLETED)</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="admin-card" style="border-left: 4px solid #3B82F6;">
                        <div class="kpi-title"><i class="ph ph-receipt me-1"></i> Tổng Lượng Đơn Hàng</div>
                        <div class="text-dark brand-font fw-bold" style="font-size: 32px;">${totalOrders} <span class="fs-6 text-muted fw-normal">đơn vị</span></div>
                        <div class="mt-2 text-muted" style="font-size: 13px;">Bao gồm toàn bộ đơn trên hệ thống (Mọi trạng thái)</div>
                    </div>
                </div>
            </div>

            <!-- CHARTS -->
            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="admin-card">
                        <h6 class="fw-bold mb-4 brand-font text-dark">Biểu đồ Doanh thu (7 ngày gần nhất)</h6>
                        <div style="height: 300px;"><canvas id="revenueChart"></canvas></div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="admin-card d-flex flex-column">
                        <h6 class="fw-bold mb-4 brand-font text-dark">Tỉ lệ Trạng thái Đơn hàng</h6>
                        <div style="height: 250px; display: flex; justify-content: center; align-items: center;"><canvas id="statusChart"></canvas></div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- TOAST -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;"><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const revLabels = [ <c:forEach items="${rev7Days}" var="entry">"${entry.key}",</c:forEach> ];
    const revData = [ <c:forEach items="${rev7Days}" var="entry">${entry.value},</c:forEach> ];
    const statusLabels = [ <c:forEach items="${statusDist}" var="entry">"${entry.key}",</c:forEach> ];
    const statusData = [ <c:forEach items="${statusDist}" var="entry">${entry.value},</c:forEach> ];

    new Chart(document.getElementById('revenueChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: revLabels,
            datasets: [{ label: 'Doanh thu (VNĐ)', data: revData, backgroundColor: '#2F6B3F', borderRadius: 4, barPercentage: 0.4, maxBarThickness: 50 }]
        },
        options: { responsive: true, maintainAspectRatio: false, scales: { x: { grid: { display: false } }, y: { beginAtZero: true, border: { dash: [4, 4] } } }, plugins: { legend: { display: false } } }
    });

    const bgColors = statusLabels.map(l => l==='COMPLETED' ? '#10B981' : (l==='PENDING' ? '#F59E0B' : (l==='CANCELLED' ? '#EF4444' : '#3B82F6')));
    new Chart(document.getElementById('statusChart').getContext('2d'), {
        type: 'doughnut',
        data: { labels: statusLabels, datasets: [{ data: statusData, backgroundColor: bgColors, borderWidth: 0, hoverOffset: 4 }] },
        options: { responsive: true, maintainAspectRatio: false, cutout: '70%', plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 15, font: { size: 11 } } } } }
    });
</script>
</body>
</html>