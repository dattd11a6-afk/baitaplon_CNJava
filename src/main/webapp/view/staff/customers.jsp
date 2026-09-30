<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Tra cứu Khách hàng | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --staff-primary: #1C8D50; --staff-sidebar-bg: #102C1F; --staff-bg-light: #F9FAFB;
            --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E5E9E3;
        }
        body { background-color: var(--staff-bg-light); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; padding: 0;}
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* 1. SIDEBAR (KHÔNG CÓ NÚT ĐĂNG XUẤT) */
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

        /* 1. HEADER CÓ DROPDOWN */
        .staff-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .btn-pos { background-color: var(--staff-primary); color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.2s; box-shadow: 0 2px 6px rgba(28,141,80,0.2); }
        .btn-pos:hover { background-color: #156d3e; color: #fff; transform: translateY(-1px); }
        .user-chip { display: flex; align-items: center; gap: 10px; background: var(--staff-bg-light); padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #f3f4f6; }
        .user-avatar { width: 32px; height: 32px; background: #3B82F6; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        .page-body { padding: 30px; flex-grow: 1; }
        .op-card { background: #fff; border: 1px solid var(--border-color); border-radius: 12px; padding: 0; box-shadow: 0 1px 3px rgba(0,0,0,0.02); overflow: hidden; }

        /* 2. TÌM KIẾM NHANH BẰNG JAVASCRIPT */
        .search-box-wrapper { padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; background: #fff;}
        .search-input-group { border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; display: flex; align-items: center; transition: 0.2s; background: #fff; width: 350px;}
        .search-input-group:focus-within { border-color: var(--staff-primary); box-shadow: 0 0 0 3px rgba(28, 141, 80, 0.1); }
        .search-input-group i { padding: 0 14px; color: #9CA3AF; font-size: 16px; }
        .search-input-group input { border: none; padding: 10px 0; width: 100%; font-size: 13px; outline: none; background: transparent; }

        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 24px; background: #F9FAFB; color: var(--text-muted); font-size: 11px; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        .admin-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; }
        .admin-table tbody tr:hover td { background: #F9FAFB; }

        /* CSS HẠNG KHÁCH HÀNG */
        .tier-badge { font-size: 11px; padding: 4px 10px; border-radius: 20px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .tier-diamond { background: linear-gradient(135deg, #00c6ff, #0072ff); color: white; }
        .tier-gold { background: linear-gradient(135deg, #F59E0B, #D97706); color: white; }
        .tier-silver { background: linear-gradient(135deg, #94A3B8, #64748B); color: white; }
        .tier-bronze { background: linear-gradient(135deg, #D97706, #92400E); color: white; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- 1. SIDEBAR -->
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
                <li class="active"><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph-fill ph-users"></i> Tìm khách hàng</a></li>
                <div class="menu-label">Nhân sự</div>
                <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph-fill ph-clock-user"></i> Ca làm & Chấm công</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <!-- 1. HEADER CÓ DROPDOWN -->
        <header class="staff-header">
            <div class="header-date">
                <i class="ph-light ph-users fs-4 me-2 text-primary"></i>
                <span class="fw-bold text-dark fs-5 brand-font">Quản lý Khách hàng</span>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/staff/pos" class="btn-pos">
                    <i class="ph-bold ph-shopping-cart"></i> Tạo đơn tại quầy
                </a>
                <div class="dropdown ms-2">
                    <div class="user-chip dropdown-toggle d-flex align-items-center gap-2 px-2 py-1 rounded"
                         data-bs-toggle="dropdown" aria-expanded="false">
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
            <div class="op-card">

                <!-- 2. THANH TÌM KIẾM NHANH TRÊN ĐẦU BẢNG -->
                <div class="search-box-wrapper">
                    <h6 class="m-0 fw-bold text-dark fs-5 brand-font">Thông tin liên hệ Khách</h6>
                    <div class="search-input-group">
                        <i class="ph ph-magnifying-glass"></i>
                        <input type="text" id="searchCustomer" onkeyup="quickSearch('searchCustomer', 'customerTable')" placeholder="Tìm kiếm theo Tên, SĐT, Email...">
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table admin-table mb-0" id="customerTable">
                        <thead>
                            <tr>
                                <th>Mã KH</th>
                                <th>Tên khách hàng</th>
                                <!-- 3. THÊM 1 CỘT HẠNG -->
                                <th>Hạng</th>
                                <th>Số điện thoại</th>
                                <th>Email</th>
                                <th>Địa chỉ nhận hàng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- LOOP THEO ĐÚNG DỮ LIỆU CŨ CỦA ANH -->
                            <c:forEach var="c" items="${customers}">
                                <tr>
                                    <td class="text-muted fw-semibold">#KH${c.id}</td>
                                    <td class="fw-bold text-dark"><i class="ph-fill ph-user-circle fs-4 text-primary me-2 align-middle"></i>${c.fullName}</td>

                                    <!-- 3. CỘT HẠNG (Bọc try-catch chống sập bảng) -->
                                    <td>
                                        <c:catch var="tierException">
                                            <c:set var="safeTier" value="${c.tier}" />
                                        </c:catch>

                                        <c:choose>
                                            <c:when test="${not empty tierException or empty safeTier}">
                                                <span class="badge bg-light text-dark border px-2 py-1" style="font-size: 10px;">Thành viên</span>
                                            </c:when>
                                            <c:when test="${safeTier == 'Kim Cương'}">
                                                <span class="tier-badge tier-diamond"><i class="ph-fill ph-sketch-logo"></i> Kim Cương</span>
                                            </c:when>
                                            <c:when test="${safeTier == 'Vàng'}">
                                                <span class="tier-badge tier-gold"><i class="ph-fill ph-crown"></i> Vàng</span>
                                            </c:when>
                                            <c:when test="${safeTier == 'Bạc'}">
                                                <span class="tier-badge tier-silver"><i class="ph-fill ph-medal"></i> Bạc</span>
                                            </c:when>
                                            <c:when test="${safeTier == 'Đồng'}">
                                                <span class="tier-badge tier-bronze"><i class="ph-fill ph-medal"></i> Đồng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-dark border px-2 py-1" style="font-size: 10px;">${safeTier}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- GIỮ NGUYÊN CÁC CỘT CÒN LẠI -->
                                    <td>${c.phone != null ? c.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</td>
                                    <td>${c.email}</td>
                                    <td><span class="text-truncate d-inline-block" style="max-width: 250px;">${c.address != null ? c.address : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 2. TÌM KIẾM NHANH BẰNG JAVASCRIPT
    function quickSearch(inputId, tableId) {
        let input = document.getElementById(inputId).value.toLowerCase();
        let table = document.getElementById(tableId);
        let tr = table.getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) {
            let rowContent = tr[i].textContent || tr[i].innerText;
            tr[i].style.display = rowContent.toLowerCase().indexOf(input) > -1 ? "" : "none";
        }
    }
</script>
</body>
</html>