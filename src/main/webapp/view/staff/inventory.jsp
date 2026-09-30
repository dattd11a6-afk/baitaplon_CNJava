<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tra cứu Kho & Nguồn hàng | Staff Panel</title>

    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>

    <style>
        :root {
            --staff-primary: #1C8D50; --staff-sidebar-bg: #102C1F; --staff-bg-light: #F9FAFB;
            --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E5E7EB;
        }
        body { background-color: var(--staff-bg-light); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; padding: 0;}
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR ĐỒNG BỘ */
        .sidebar { width: 250px; background-color: var(--staff-sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--staff-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .menu-label { padding: 20px 20px 8px; font-size: 11px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 20px; color: #D1D5DB; text-decoration: none; font-weight: 500; font-size: 13px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(31, 157, 85, 0.15); border-left-color: var(--staff-primary); font-weight: 600; }

        /* MAIN CONTENT */
        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }

        /* HEADER ĐỒNG BỘ */
        .staff-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .btn-pos { background-color: var(--staff-primary); color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.2s; box-shadow: 0 2px 6px rgba(28,141,80,0.2); }
        .btn-pos:hover { background-color: #156d3e; color: #fff; transform: translateY(-1px); }
        .user-chip { display: flex; align-items: center; gap: 10px; background: var(--staff-bg-light); padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #f3f4f6; }
        .user-avatar { width: 32px; height: 32px; background: #3B82F6; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        /* NỘI DUNG */
        .page-body { padding: 30px; }
        .content-card { background: var(--surface); border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); border: 1px solid var(--border-color); overflow: hidden; }
        .page-title { font-size: 22px; font-weight: 700; color: var(--text-main); margin-bottom: 24px; }

        .nav-tabs-custom { border-bottom: 1px solid var(--border-color); padding: 0 20px; background: #fff; }
        .nav-tabs-custom .nav-link { border: none; color: var(--text-muted); font-weight: 600; padding: 16px 20px; font-size: 14px; position: relative; transition: 0.2s; background: transparent; cursor: pointer; }
        .nav-tabs-custom .nav-link:hover { color: var(--staff-primary); }
        .nav-tabs-custom .nav-link.active { color: var(--staff-primary); background: transparent; }
        .nav-tabs-custom .nav-link.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background: var(--staff-primary); border-radius: 3px 3px 0 0; }

        .search-box-wrapper { background: var(--surface); padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between;}
        .search-input-group { border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; display: flex; align-items: center; transition: 0.2s; background: #fff; width: 350px;}
        .search-input-group:focus-within { border-color: var(--staff-primary); box-shadow: 0 0 0 3px rgba(28, 141, 80, 0.1); }
        .search-input-group i { padding: 0 14px; color: #9CA3AF; font-size: 16px; }
        .search-input-group input { border: none; padding: 10px 0; width: 100%; font-size: 13px; outline: none; background: transparent; }

        .table-responsive { width: 100%; overflow-x: auto; }
        .admin-table { width: 100%; border-collapse: collapse; min-width: 900px; }
        .admin-table th { padding: 16px 20px; background: #F9FAFB; color: var(--text-muted); font-size: 11px; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid var(--border-color); white-space: nowrap; }
        .admin-table td { padding: 16px 20px; vertical-align: middle; border-bottom: 1px solid #F3F4F6; font-size: 13px; color: var(--text-main); white-space: nowrap; }
        .admin-table tbody tr:hover td { background: #F9FAFB; }

        .badge-id { background: #F3F4F6; color: #4B5563; font-weight: 600; padding: 4px 10px; border-radius: 6px; font-size: 12px; }

        .btn-icon { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; font-size: 16px; border: 1px solid transparent; transition: 0.2s; cursor: pointer; background: transparent; }
        .btn-view { color: #4F46E5; background: #EEF2FF; border-color: #C7D2FE; }
        .btn-view:hover { background: #E0E7FF; color: #4338CA; }
    </style>
</head>
<body>

<div class="d-flex">
    <!-- SIDEBAR -->
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
                <li class="active"><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph-fill ph-box-arrow-down"></i> Tra cứu Kho</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph-fill ph-users"></i> Tìm khách hàng</a></li>
                <div class="menu-label">Nhân sự</div>
                <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph-fill ph-clock-user"></i> Ca làm & Chấm công</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <!-- HEADER CÓ DROPDOWN -->
        <header class="staff-header">
            <div class="header-date"><i class="ph-light ph-clock fs-5"></i><span id="currentDateDisplay" class="ms-2 fw-medium text-muted">Hôm nay: Đang cập nhật...</span></div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/staff/pos" class="btn-pos"><i class="ph-bold ph-shopping-cart"></i> Mở Bán Hàng POS</a>
                <div class="dropdown ms-2">
                    <div class="user-chip dropdown-toggle d-flex align-items-center gap-2 px-2 py-1 rounded"
                         data-bs-toggle="dropdown" aria-expanded="false" style="border: 1px solid var(--border-color); background: var(--staff-bg-light);">
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
            <h2 class="page-title brand-font">Tra cứu Kho & Nguồn hàng</h2>

            <div class="content-card">
                <ul class="nav nav-tabs-custom d-flex" role="tablist">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-stock" type="button"><i class="ph-fill ph-package me-1"></i> Tồn Kho Sản Phẩm</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-history" type="button"><i class="ph-fill ph-clock-counter-clockwise me-1"></i> Lịch Sử Nhập Kho</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-supplier" type="button"><i class="ph-fill ph-truck me-1"></i> Nhà Cung Cấp</button>
                    </li>
                </ul>

                <div class="tab-content">

                    <!-- ================= TAB 1: DANH SÁCH SẢN PHẨM & TỒN KHO ================= -->
                    <div class="tab-pane fade show active" id="tab-stock">
                        <div class="search-box-wrapper">
                            <span class="fw-bold text-dark fs-6">Sản phẩm đang kinh doanh</span>
                            <div class="search-input-group">
                                <i class="ph ph-magnifying-glass"></i>
                                <input type="text" id="searchStock" onkeyup="quickSearch('searchStock', 'stockTable')" placeholder="Tìm tên sản phẩm...">
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table align-middle admin-table" id="stockTable">
                                <thead>
                                    <tr>
                                        <th style="width: 10%;">ID</th>
                                        <th style="width: 40%;">Tên Sản Phẩm</th>
                                        <th style="width: 20%;">Phân loại</th>
                                        <th style="width: 15%; text-align: center;">Tồn Kho</th>
                                        <th style="width: 15%; text-align: right;">Giá bán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${productList}">
                                        <tr>
                                            <td><span class="badge-id">#SP${p.id}</span></td>
                                            <td class="fw-bold text-dark">${p.name}</td>
                                            <td class="text-muted">${p.categoryName}</td>
                                            <td class="text-center">
                                                <span class="badge ${p.stock > 10 ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-danger-subtle text-danger border border-danger-subtle'} px-2 py-1 fs-6">${p.stock}${p.unit}</span>
                                            </td>
                                            <td class="fw-bold text-success text-end"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ================= TAB 2: LỊCH SỬ NHẬP KHO (READ-ONLY) ================= -->
                    <div class="tab-pane fade" id="tab-history">
                        <div class="search-box-wrapper">
                            <span class="fw-bold text-dark fs-6">Lịch sử giao dịch</span>
                            <div class="search-input-group">
                                <i class="ph ph-magnifying-glass"></i>
                                <input type="text" id="searchHistory" onkeyup="quickSearch('searchHistory', 'historyTable')" placeholder="Tìm kiếm mã phiếu, NCC, người lập...">
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle admin-table" id="historyTable">
                                <thead>
                                    <tr>
                                        <th style="width: 10%;">Mã PN</th>
                                        <th style="width: 20%;">Ngày Nhập</th>
                                        <th style="width: 30%;">Nhà Cung Cấp</th>
                                        <th style="width: 15%;">Người Lập</th>
                                        <th style="width: 15%; text-align: right;">Tổng Tiền</th>
                                        <th style="width: 10%; text-align: center;">Chi Tiết</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="receipt" items="${receiptList}">
                                        <tr>
                                            <td><span class="badge bg-light text-dark border border-secondary border-opacity-25 px-2 py-1 rounded">#PN${receipt.id}</span></td>
                                            <td><div class="fw-medium text-dark"><fmt:formatDate value="${receipt.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div></td>
                                            <td><div class="text-primary fw-bold"><i class="ph-fill ph-truck me-1"></i> ${receipt.supplierName}</div></td>
                                            <td><div class="fw-medium text-muted">${receipt.userName}</div></td>
                                            <td class="fw-bold text-danger text-end"><fmt:formatNumber value="${receipt.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td class="text-center">
                                                <button type="button" class="btn-icon btn-view" title="Xem chi tiết" onclick="viewReceiptDetail(${receipt.id})"><i class="ph-bold ph-eye"></i></button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty receiptList}">
                                        <tr><td colspan="6" class="text-center py-5 text-muted fw-medium">Chưa có dữ liệu.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ================= TAB 3: NHÀ CUNG CẤP (READ-ONLY) ================= -->
                    <div class="tab-pane fade" id="tab-supplier">
                        <div class="search-box-wrapper">
                            <span class="fw-bold text-dark fs-6">Danh bạ Đối tác</span>
                            <div class="search-input-group">
                                <i class="ph ph-magnifying-glass"></i>
                                <input type="text" id="searchSupplier" onkeyup="quickSearch('searchSupplier', 'supplierTable')" placeholder="Tìm kiếm đối tác...">
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle admin-table" id="supplierTable">
                                <thead>
                                    <tr>
                                        <th style="width: 10%;">ID</th><th style="width: 25%;">Tên Đối Tác</th><th style="width: 20%;">Liên Hệ</th>
                                        <th style="width: 30%;">Địa Chỉ</th><th style="width: 15%; text-align: center;">Trạng Thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sup" items="${supplierList}">
                                        <tr>
                                            <td><span class="badge bg-light text-dark border border-secondary border-opacity-25 px-2 py-1 rounded">#NCC${sup.id}</span></td>
                                            <td class="fw-bold text-dark">${sup.name}</td>
                                            <td>
                                                <div class="text-muted" style="font-size: 12px;"><i class="ph-fill ph-phone text-secondary"></i> ${sup.phone}</div>
                                                <div class="text-muted mt-1" style="font-size: 12px;"><i class="ph-fill ph-envelope-simple text-secondary"></i> ${sup.email}</div>
                                            </td>
                                            <td class="text-muted text-truncate" style="max-width: 250px;" title="${sup.address}">${sup.address}</td>
                                            <td class="text-center"><span class="badge ${sup.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} border px-2 py-1">${sup.status == 'ACTIVE' ? 'Hoạt động' : 'Ngừng GD'}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- MODAL CHI TIẾT PHIẾU NHẬP -->
    <div class="modal fade" id="receiptDetailModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
                <div class="modal-header bg-light border-bottom-0 p-4 pb-3">
                    <div>
                        <h5 class="modal-title fw-bold text-dark brand-font mb-1">Chi tiết Phiếu nhập <span id="modalReceiptId" class="text-success"></span></h5>
                        <div class="text-muted" style="font-size: 12px;">Sản phẩm thực tế đã cộng vào kho</div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0" style="max-height: 450px; overflow-y: auto;">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light text-muted sticky-top" style="font-size: 11px; text-transform: uppercase;">
                            <tr>
                                <th class="ps-4 py-3">Tên Sản phẩm</th>
                                <th class="text-center py-3">Số lượng</th>
                                <th class="text-end py-3">Giá nhập (VNĐ)</th>
                                <th class="pe-4 text-end py-3">Thành tiền (VNĐ)</th>
                            </tr>
                        </thead>
                        <tbody id="receiptDetailBody">
                            <!-- Data JS đẩy vào -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST THÔNG BÁO -->
    <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center"><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
            </div><c:remove var="errorMsg" scope="session" />
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const formatter = new Intl.NumberFormat('vi-VN');

        document.addEventListener("DOMContentLoaded", function() {
            var ts = [].slice.call(document.querySelectorAll('.toast'));
            ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());

            const today = new Date();
            document.getElementById('currentDateDisplay').innerText = 'Hôm nay: ' + String(today.getDate()).padStart(2, '0') + '/' + String(today.getMonth() + 1).padStart(2, '0') + '/' + today.getFullYear();

            var activeTabId = localStorage.getItem('activeInventoryTabStaff');
            if (activeTabId) {
                var tab = new bootstrap.Tab(document.getElementById(activeTabId));
                tab.show();
            }
        });

        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(btn => {
            btn.addEventListener('shown.bs.tab', e => localStorage.setItem('activeInventoryTabStaff', e.target.id));
        });

        // LOGIC XEM CHI TIẾT LỊCH SỬ BẰNG JSON API
        function viewReceiptDetail(receiptId) {
            document.getElementById('modalReceiptId').innerText = '#PN' + receiptId;
            const tbody = document.getElementById('receiptDetailBody');
            tbody.innerHTML = `<tr><td colspan="4" class="text-center py-5"><div class="spinner-border text-success"></div><div class="mt-2 text-muted">Đang tải...</div></td></tr>`;

            new bootstrap.Modal(document.getElementById('receiptDetailModal')).show();

            fetch('${pageContext.request.contextPath}/staff/inventory?action=getDetails&id=' + receiptId)
                .then(response => response.json())
                .then(data => {
                    if (data.length === 0) {
                        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">Không có dữ liệu chi tiết.</td></tr>';
                    } else {
                        let html = '';
                        data.forEach(item => {
                            html += `<tr>
                                        <td class="ps-4 fw-bold text-dark">\${item.productName}</td>
                                        <td class="text-center"><span class="badge bg-light text-dark border px-2 py-1 fs-6">\${item.quantity}</span></td>
                                        <td class="text-end text-muted fw-medium">\${formatter.format(item.importPrice)} ₫</td>
                                        <td class="pe-4 text-end fw-bold text-danger fs-6">\${formatter.format(item.subtotal)} ₫</td>
                                     </tr>`;
                        });
                        tbody.innerHTML = html;
                    }
                })
                .catch(error => {
                    tbody.innerHTML = `<tr><td colspan="4" class="text-center text-danger py-4">Lỗi kết nối máy chủ!</td></tr>`;
                });
        }

        // THUẬT TOÁN TÌM KIẾM NHANH
        function quickSearch(inputId, tableId) {
            let input = document.getElementById(inputId).value.toLowerCase();
            let table = document.getElementById(tableId);
            let tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                let rowContent = tr[i].textContent || tr[i].innerText;
                if (rowContent.toLowerCase().indexOf(input) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>