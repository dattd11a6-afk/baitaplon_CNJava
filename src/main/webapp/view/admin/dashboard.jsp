<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --admin-bg: #f4f6f9;
            --sidebar-bg: #212529;
            --sidebar-hover: #343a40;
            --primary: #2e7d32;
        }
        body { background-color: var(--admin-bg); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        /* Bố cục Admin */
        .admin-layout { display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); color: #fff; transition: all 0.3s; flex-shrink: 0; }
        .sidebar .brand { padding: 20px; font-size: 22px; font-weight: bold; border-bottom: 1px solid rgba(255,255,255,0.1); color: #4caf50; letter-spacing: 1px; }
        .sidebar-menu { padding: 15px 0; list-style: none; margin: 0; }
        .sidebar-menu li a { display: block; padding: 12px 20px; color: #ced4da; text-decoration: none; transition: 0.2s; font-size: 15px; }
        .sidebar-menu li a:hover, .sidebar-menu li.active a { background-color: var(--sidebar-hover); color: #fff; border-left: 4px solid var(--primary); }
        .sidebar-menu li a i { width: 25px; text-align: center; margin-right: 10px; }

        /* Main Content */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; }

        /* Topbar */
        .topbar { height: 70px; background: #fff; display: flex; align-items: center; justify-content: space-between; padding: 0 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .topbar-right { display: flex; align-items: center; gap: 20px; }

        /* Stat Cards */
        .stat-card { background: #fff; border-radius: 10px; padding: 20px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.03); display: flex; align-items: center; justify-content: space-between; }
        .stat-icon { width: 60px; height: 60px; border-radius: 15px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .stat-info h3 { font-size: 24px; font-weight: 700; margin: 0; color: #2b2b2b; }
        .stat-info p { margin: 0; font-size: 14px; color: #6c757d; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }
    </style>
</head>
<body>

<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="brand">
            <i class="fa-solid fa-leaf me-2"></i>Fruit Admin.
        </div>
        <ul class="sidebar-menu">
            <li class="active"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge-high"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="fa-solid fa-cart-shopping"></i> Quản lý đơn hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products"><i class="fa-solid fa-box-open"></i> Quản lý sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="fa-solid fa-tags"></i> Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="fa-solid fa-users"></i> Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fa-solid fa-user-tie"></i> Nhân viên</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-line"></i> Báo cáo doanh thu</a></li>
            <li class="mt-4 border-top border-secondary pt-3"><a href="${pageContext.request.contextPath}/logout" class="text-danger"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a></li>
        </ul>
    </aside>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <!-- TOPBAR -->
        <header class="topbar">
            <div>
                <h5 class="m-0 fw-bold text-dark">Dashboard</h5>
            </div>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/" target="_blank" class="btn btn-outline-success btn-sm rounded-pill px-3"><i class="fa-solid fa-globe me-1"></i> Xem Website</a>
                <div class="d-flex align-items-center gap-2">
                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 35px; height: 35px; font-weight: bold;">
                        ${sessionScope.user.fullName.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <div class="fw-bold text-dark" style="font-size: 14px;">${sessionScope.user.fullName}</div>
                        <div class="text-muted" style="font-size: 12px;">Quản trị viên</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- CONTENT BÊN TRONG -->
        <div class="p-4 overflow-auto">
            <h4 class="mb-4 text-dark fw-bold">Xin chào, ${sessionScope.user.fullName}! 👋</h4>

            <!-- THỐNG KÊ TỔNG QUAN -->
            <div class="row g-4 mb-5">
                <!-- Thẻ Doanh thu -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <p>Tổng doanh thu</p>
                            <h3 class="text-success"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h3>
                        </div>
                        <div class="stat-icon bg-success-subtle text-success">
                            <i class="fa-solid fa-wallet"></i>
                        </div>
                    </div>
                </div>
                <!-- Thẻ Đơn hàng -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <p>Tổng đơn hàng</p>
                            <h3>${totalOrders}</h3>
                        </div>
                        <div class="stat-icon bg-primary-subtle text-primary">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                    </div>
                </div>
                <!-- Thẻ Sản phẩm -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <p>Sản phẩm (Đang bán)</p>
                            <h3>${totalProducts}</h3>
                        </div>
                        <div class="stat-icon bg-warning-subtle text-warning text-dark">
                            <i class="fa-solid fa-apple-whole"></i>
                        </div>
                    </div>
                </div>
                <!-- Thẻ Khách hàng -->
                <div class="col-xl-3 col-md-6">
                    <div class="stat-card">
                        <div class="stat-info">
                            <p>Khách hàng (User)</p>
                            <h3>${totalCustomers}</h3>
                        </div>
                        <div class="stat-icon bg-info-subtle text-info text-dark">
                            <i class="fa-solid fa-users"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ở đây sau này có thể thêm Chart.js vẽ biểu đồ doanh thu hoặc Bảng Đơn hàng mới nhất -->
            <div class="bg-white rounded-4 p-4 shadow-sm">
                <h5 class="fw-bold mb-3"><i class="fa-solid fa-chart-simple me-2 text-primary"></i>Hoạt động hệ thống</h5>
                <p class="text-muted">Các biểu đồ chi tiết sẽ được cập nhật ở phân hệ Reports.</p>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>