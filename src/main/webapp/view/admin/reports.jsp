<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo Thống kê | Fruit Admin</title>
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
        .kpi-title { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .btn-action { border-radius: 6px; font-weight: 500; font-size: 13px; padding: 8px 16px; border: 1px solid var(--border-color); background: var(--surface); color: var(--text-main); transition: 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;}
        .btn-action:hover { background: #F3F4F6; color: var(--text-main); }
        .logout-btn { display: flex; align-items: center; padding: 12px 20px; color: #E5E7EB; background: rgba(255,255,255,0.05); text-decoration: none; border-radius: 6px; margin: 0 10px; transition: 0.2s;}
        .logout-btn:hover { background-color: #DC2626; color: #fff; }
        @media print {
            body { background-color: #fff; }
            .sidebar, .topbar, .btn-action, .toast-container { display: none !important; }
            .main-content { padding: 0 !important; width: 100% !important; margin: 0 !important; height: auto !important; overflow: visible !important;}
            .admin-card { border: none !important; padding: 10px !important; break-inside: avoid; }
            .report-header { text-align: center; margin-bottom: 30px; display: block !important; }
        }
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
            <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph ph-squares-four"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph ph-receipt"></i> Đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph ph-package"></i> Sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph ph-tag"></i> Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph ph-ticket"></i> Khuyến mãi</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph ph-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph ph-identification-badge"></i> Nhân viên</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph ph-chart-line-up"></i> Báo cáo</a></li>
        </ul>
        <div class="mt-auto p-3 border-top" style="border-color: rgba(255,255,255,0.05)!important;"><a href="${pageContext.request.contextPath}/logout" class="logout-btn"><i class="ph ph-sign-out fs-5 me-2"></i> Đăng xuất</a></div>
    </aside>

    <main class="flex-grow-1 overflow-auto main-content" style="height: 100vh;">
        <header class="topbar"><div class="fw-medium text-muted">Hệ thống Quản trị</div></header>

        <div class="p-4 px-5">
            <!-- Header Ẩn: Chỉ hiện khi in ra PDF -->
            <div class="report-header d-none">
                <h2 class="brand-font fw-bold">BÁO CÁO KẾT QUẢ KINH DOANH FRUIT FARMER</h2>
                <p>Ngày tạo: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/></p><hr>
            </div>

            <!-- TIÊU ĐỀ & NÚT EXPORT -->
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h2 class="fw-bold m-0 brand-font text-dark">Báo cáo & Phân tích</h2>
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
    // NHẬN DỮ LIỆU THẬT 100% TỪ BACKEND TRUYỀN XUỐNG
    const revLabels = [ <c:forEach items="${rev7Days}" var="entry">"${entry.key}",</c:forEach> ];
    const revData = [ <c:forEach items="${rev7Days}" var="entry">${entry.value},</c:forEach> ];
    const statusLabels = [ <c:forEach items="${statusDist}" var="entry">"${entry.key}",</c:forEach> ];
    const statusData = [ <c:forEach items="${statusDist}" var="entry">${entry.value},</c:forEach> ];

    // FIX LỖI CỘT QUE CỦI (Sử dụng barPercentage để giới hạn tỷ lệ chiếm chỗ của cột)
    new Chart(document.getElementById('revenueChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: revLabels,
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: revData,
                backgroundColor: '#2F6B3F',
                borderRadius: 4,
                barPercentage: 0.4,       // Cột chỉ chiếm tối đa 40% khoảng trống
                maxBarThickness: 50       // Chống việc 1 cột phóng to khổng lồ
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: { grid: { display: false } },
                y: { beginAtZero: true, border: { dash: [4, 4] } }
            },
            plugins: { legend: { display: false } }
        }
    });

    // DONUT CHART LUXURY
    const bgColors = statusLabels.map(l => l==='COMPLETED' ? '#10B981' : (l==='PENDING' ? '#F59E0B' : (l==='CANCELLED' ? '#EF4444' : '#3B82F6')));
    new Chart(document.getElementById('statusChart').getContext('2d'), {
        type: 'doughnut',
        data: {
            labels: statusLabels,
            datasets: [{ data: statusData, backgroundColor: bgColors, borderWidth: 0, hoverOffset: 4 }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 15, font: { size: 11 } } }
            }
        }
    });
</script>
</body>
</html>