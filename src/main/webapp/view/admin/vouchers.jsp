<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Khuyến mãi | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* ZOTECH CORE UI */
        :root {
            --primary: #2F6B3F;
            --primary-dark: #167e43;
            --z-bg: #F8FAFC;
            --z-surface: #FFFFFF;
            --z-text-main: #0F172A;
            --z-text-muted: #64748B;
            --z-border: #E2E8F0;
        }

        body {
            background-color: var(--z-bg);
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--z-text-main);
        }

        .brand-font {
            font-family: 'DM Sans', sans-serif;
        }

        /* ZOTECH SIDEBAR ĐỒNG BỘ */
        .sidebar {
            width: 250px;
            background-color: #111827;
            color: #fff;
            height: 100vh;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 100;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .menu-label {
            padding: 24px 24px 8px;
            font-size: 11px;
            font-weight: 700;
            color: #6B7280;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 10px 24px;
            color: #9CA3AF;
            text-decoration: none;
            font-weight: 500;
            font-size: 13px;
            transition: all 0.2s ease;
            border-left: 3px solid transparent;
        }

        .sidebar-menu li a i {
            font-size: 18px;
            margin-right: 12px;
            transition: 0.2s;
        }

        .sidebar-menu li a:hover {
            color: #fff;
            background-color: rgba(255,255,255,0.03);
        }

        .sidebar-menu li.active a {
            color: #fff;
            background-color: rgba(47, 107, 63, 0.15);
            border-left-color: var(--primary);
            font-weight: 600;
        }

        .sidebar-menu li.active a i {
            color: var(--primary);
        }

        .custom-scrollbar::-webkit-scrollbar {
            width: 4px;
            height: 4px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
        }

        /* ZOTECH MAIN & HEADER */
        .main-wrapper {
            margin-left: 250px;
            width: calc(100% - 250px);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .z-topbar {
            height: 70px;
            background: var(--z-surface);
            border-bottom: 1px solid var(--z-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        /* TABLE CSS - ĐÃ FIX CHỐNG BÓP MÉO */
        .admin-card {
            background: var(--z-surface);
            border: 1px solid var(--z-border);
            border-radius: 14px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            overflow: hidden;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px; /* FIX: Đảm bảo bảng không bao giờ bị bóp nhỏ hơn 1000px */
        }

        .admin-table th {
            padding: 16px 20px;
            color: var(--z-text-muted);
            background: #F8FAFC;
            text-transform: uppercase;
            font-size: 11px;
            font-weight: 600;
            border-bottom: 1px solid var(--z-border);
            text-align: left;
        }

        .admin-table td {
            padding: 16px 20px;
            vertical-align: middle;
            border-bottom: 1px solid #F1F5F9;
            color: var(--z-text-main);
            text-align: left;
        }

        .admin-table tbody tr:hover td {
            background: #F8FAFC;
        }

        .col-number {
            text-align: right !important;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
        }

        /* NÚT THAO TÁC */
        .action-btns {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            align-items: center;
            flex-wrap: nowrap;
            width: max-content;
            margin-left: auto;
        }

        .btn-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--z-border);
            background: var(--z-surface);
            color: #6B7280;
            transition: 0.2s;
            cursor: pointer;
            padding: 0;
            outline: none;
        }

        .btn-icon:hover.edit {
            background: #EFF6FF;
            color: #2563EB;
            border-color: #BFDBFE;
        }

        .btn-icon:hover.delete {
            background: #FEF2F2;
            color: #DC2626;
            border-color: #FECACA;
        }

        /* THANH TÌM KIẾM */
        .search-box-white {
            background: #fff;
            border: 1px solid var(--z-border);
            border-radius: 8px;
            display: flex;
            align-items: center;
            padding: 0 14px;
            width: 280px;
            transition: 0.2s;
        }

        .search-box-white:focus-within {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(31,157,85,0.1);
        }

        .search-box-white i {
            color: #9CA3AF;
            font-size: 16px;
        }

        .search-box-white input {
            border: none;
            padding: 9px 10px;
            width: 100%;
            outline: none;
            font-size: 13px;
            color: var(--z-text-main);
        }

        /* NÚT LỌC TRẠNG THÁI CHIPS */
        .filter-btn {
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            padding: 6px 16px;
            border: 1px solid var(--z-border);
            background: #fff;
            color: var(--z-text-muted);
            cursor: pointer;
            transition: 0.2s;
            white-space: nowrap;
            flex-shrink: 0;
        }

        .filter-btn:hover {
            background: #F1F5F9;
            color: var(--z-text-main);
        }

        .filter-btn.active {
            background: var(--primary);
            color: #fff;
            border-color: var(--primary);
        }

        /* STATUS PILL */
        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
            line-height: 1.5;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pill.active {
            background: #ECFDF5;
            color: #059669;
            border: 1px solid #A7F3D0;
        }

        .status-pill.inactive {
            background: #F1F5F9;
            color: #64748B;
            border: 1px solid #CBD5E1;
        }

        .status-pill.expired {
            background: #FEF2F2;
            color: #DC2626;
            border: 1px solid #FECACA;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            display: inline-block;
        }

        .status-pill.active .status-dot { background-color: #10B981; }
        .status-pill.inactive .status-dot { background-color: #94A3B8; }
        .status-pill.expired .status-dot { background-color: #EF4444; }

        /* TÙY CHỈNH FORM */
        .form-control, .form-select {
            border-radius: 8px;
            border-color: var(--z-border);
            padding: 10px 14px;
            font-size: 13px;
            transition: 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1);
            outline: none;
        }

        /* TOAST ZOTECH STYLE ĐỒNG BỘ VỚI ADMIN */
        .toast-zotech { background-color: var(--primary-dark); color: white; border-radius: 8px; padding: 12px 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; border: none; font-size: 14px; font-weight: 500;}
        .toast-zotech-danger { background-color: #DC2626; color: white; border-radius: 8px; padding: 12px 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; border: none; font-size: 14px; font-weight: 500;}
    </style>
</head>
<body>

<!-- KHAI BÁO THỜI GIAN HIỆN TẠI ĐỂ TÍNH TOÁN VOUCHER HẾT HẠN TẠI ADMIN -->
<jsp:useBean id="now" class="java.util.Date" />

<div class="d-flex">
    <!-- ZOTECH SIDEBAR ĐỒNG BỘ -->
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
                <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo</a></li>

                <div class="menu-label">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>

                <div class="menu-label">Kho & Vận hành</div>
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

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

        <div class="p-4 px-5 pb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold mb-2 brand-font text-dark" style="font-size: 28px;">Quản lý Khuyến Mãi</h2>
                </div>
            </div>

            <div class="admin-card p-0">
                <div class="d-flex justify-content-between align-items-center p-3 border-bottom bg-white">
                    <div class="d-flex align-items-center gap-2 overflow-x-auto custom-scrollbar pb-1">
                        <button type="button" class="filter-btn v-filter-btn active" onclick="filterVouchers('ALL', this)">Tất cả mã</button>
                        <button type="button" class="filter-btn v-filter-btn" onclick="filterVouchers('ACTIVE', this)">Đang phát hành</button>
                        <button type="button" class="filter-btn v-filter-btn" onclick="filterVouchers('INACTIVE', this)">Hết hạn / Khóa</button>
                    </div>
                    <div class="d-flex gap-3 flex-shrink-0">
                        <div class="search-box-white">
                            <i class="ph-bold ph-magnifying-glass"></i>
                            <input type="text" id="searchVoucher" onkeyup="quickSearch('searchVoucher', 'voucherTable')" placeholder="Tìm mã code...">
                        </div>
                        <button class="btn btn-success fw-medium px-4" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                            <i class="ph-bold ph-plus me-1"></i> Thêm Voucher mới
                        </button>
                    </div>
                </div>

                <!-- TABLE RESPONSIVE WRAPPER ĐỂ XUẤT HIỆN THANH CUỘN KHI NHỎ -->
                <div class="table-responsive custom-scrollbar">
                    <table class="admin-table mb-0" id="voucherTable">
                        <thead>
                            <tr>
                                <th>Mã Code</th>
                                <th>Loại</th>
                                <th class="col-number">Mức giảm</th>
                                <th class="col-number">Đơn tối thiểu</th>
                                <th class="text-center">Số lượng</th>
                                <th>Ngày hết hạn</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end" style="width: 120px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="v" items="${vouchers}">
                                <!-- LOGIC TÍNH TOÁN XEM ĐÃ HẾT HẠN CHƯA ĐỂ GÁN DATA-STATUS CHO BỘ LỌC -->
                                <c:set var="isExpired" value="${v.expiryDate != null && v.expiryDate.time < now.time}" />
                                <c:set var="filterStatus" value="${(v.status == 'ACTIVE' && !isExpired) ? 'ACTIVE' : 'INACTIVE'}" />

                                <tr class="voucher-row" data-status="${filterStatus}">
                                    <td class="text-nowrap">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded bg-success bg-opacity-10 text-success d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; flex-shrink: 0;"><i class="ph-fill ph-ticket fs-5"></i></div>
                                            <span class="fw-bold text-dark fs-6">${v.code}</span>
                                        </div>
                                    </td>
                                    <td class="text-nowrap">
                                        <c:choose>
                                            <c:when test="${v.type == 'PERCENT'}"><span class="badge bg-info text-dark rounded-pill px-2 py-1">Giảm %</span></c:when>
                                            <c:when test="${v.type == 'AMOUNT'}"><span class="badge bg-warning text-dark rounded-pill px-2 py-1">Giảm tiền</span></c:when>
                                            <c:when test="${v.type == 'FREE_SHIP'}"><span class="badge bg-primary rounded-pill px-2 py-1">Freeship</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td class="col-number text-danger fw-bold text-nowrap">
                                        <c:choose>
                                            <c:when test="${v.type == 'PERCENT'}">- ${fn:replace(v.discountValue, ".00", "")} %</c:when>
                                            <c:otherwise>- <fmt:formatNumber value="${v.discountValue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="col-number text-muted text-nowrap"><fmt:formatNumber value="${v.minOrderAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td class="text-center fw-bold text-nowrap ${v.usageLimit == 0 ? 'text-danger' : 'text-dark'}">${v.usedCount} / ${v.usageLimit > 0 ? v.usageLimit : '∞'}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty v.expiryDate}">
                                                <div class="text-muted fw-medium text-nowrap ${isExpired ? 'text-danger' : ''}">
                                                    <fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </c:when>
                                            <c:otherwise><div class="text-muted fw-medium text-nowrap">Không thời hạn</div></c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${v.status == 'INACTIVE'}">
                                                <span class="status-pill inactive"><span class="status-dot"></span> Đã khóa</span>
                                            </c:when>
                                            <c:when test="${isExpired}">
                                                <span class="status-pill expired"><span class="status-dot"></span> Đã hết hạn</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-pill active"><span class="status-dot"></span> Đang phát hành</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-end">
                                        <div class="action-btns">
                                            <button type="button" class="btn-icon edit" data-bs-toggle="modal" data-bs-target="#editVoucherModal${v.id}" title="Sửa"><i class="ph-bold ph-pencil-simple"></i></button>
                                            <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST" class="m-0 p-0" style="display: inline-block;" onsubmit="return confirm('Bạn có chắc muốn ngừng kích hoạt / xóa mã giảm giá này?');">
                                                <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${v.id}">
                                                <button type="submit" class="btn-icon delete" title="Khóa/Xóa"><i class="ph-bold ph-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>

                                <!-- MODAL SỬA VOUCHER -->
                                <div class="modal fade" id="editVoucherModal${v.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 shadow-lg rounded-4">
                                        <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font fs-4">Sửa Voucher</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                        <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST">
                                            <div class="modal-body text-start">
                                                <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${v.id}">
                                                <div class="mb-3"><label class="form-label fw-semibold">Mã Code</label><input type="text" name="code" class="form-control text-uppercase fw-bold text-success" value="${v.code}" required></div>
                                                <div class="row">
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Loại Voucher</label>
                                                        <select name="type" class="form-select fw-medium">
                                                            <option value="AMOUNT" ${v.type == 'AMOUNT' ? 'selected' : ''}>Giảm số tiền</option>
                                                            <option value="PERCENT" ${v.type == 'PERCENT' ? 'selected' : ''}>Giảm phần trăm (%)</option>
                                                            <option value="FREE_SHIP" ${v.type == 'FREE_SHIP' ? 'selected' : ''}>Miễn phí vận chuyển</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Giá trị giảm</label><input type="number" name="discountValue" class="form-control" value="${v.discountValue}" min="0" required></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Đơn tối thiểu (VNĐ)</label><input type="number" name="minOrderAmount" class="form-control" value="${v.minOrderAmount}" min="0"></div>
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Giảm tối đa (VNĐ)</label><input type="number" name="maxDiscountAmount" class="form-control" value="${v.maxDiscountAmount}" min="0"></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Lượt dùng tối đa</label><input type="number" name="usageLimit" class="form-control" value="${v.usageLimit}" placeholder="Bỏ trống nếu không giới hạn"></div>
                                                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Ngày hết hạn</label><input type="date" name="expiryDate" class="form-control" value="${fn:substring(v.expiryDate, 0, 10)}"></div>
                                                </div>
                                                <div class="mb-2"><label class="form-label fw-semibold">Trạng thái</label><select name="status" class="form-select fw-medium"><option value="ACTIVE" ${v.status == 'ACTIVE' ? 'selected' : ''}>Kích hoạt</option><option value="INACTIVE" ${v.status == 'INACTIVE' ? 'selected' : ''}>Tạm khóa</option></select></div>
                                            </div>
                                            <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium w-100">Lưu thay đổi</button></div>
                                        </form>
                                    </div></div>
                                </div>
                            </c:forEach>
                        <c:if test="${empty vouchers}">
                            <tr><td colspan="8" class="text-center py-5 text-muted"><i class="ph-light ph-ticket fs-1 mb-2"></i><br>Chưa có mã giảm giá nào</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM VOUCHER -->
<div class="modal fade" id="addVoucherModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow-lg">
        <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font fs-4">Tạo Voucher Mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <form action="${pageContext.request.contextPath}/admin/vouchers" method="POST">
            <div class="modal-body text-start">
                <input type="hidden" name="action" value="add">
                <div class="mb-3"><label class="form-label fw-semibold">Mã Code (Tự tạo) *</label><input type="text" name="code" class="form-control text-uppercase fw-bold text-success" placeholder="VD: FREESHIP50" required></div>
                <div class="row">
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Loại Voucher</label>
                        <select name="type" class="form-select fw-medium">
                            <option value="AMOUNT" selected>Giảm số tiền</option><option value="PERCENT">Giảm phần trăm (%)</option><option value="FREE_SHIP">Miễn phí vận chuyển</option>
                        </select>
                    </div>
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Giá trị giảm *</label><input type="number" name="discountValue" class="form-control" min="0" required></div>
                </div>
                <div class="row">
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Đơn tối thiểu (VNĐ)</label><input type="number" name="minOrderAmount" class="form-control" value="0" min="0"></div>
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Giảm tối đa (VNĐ)</label><input type="number" name="maxDiscountAmount" class="form-control" value="0" min="0"></div>
                </div>
                <div class="row">
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Số lượng mã (Giới hạn) *</label><input type="number" name="usageLimit" class="form-control" min="1" value="100" required></div>
                    <div class="col-6 mb-3"><label class="form-label fw-semibold">Ngày hết hạn *</label><input type="date" name="expiryDate" class="form-control" required></div>
                </div>
                <div class="mb-2"><label class="form-label fw-semibold">Trạng thái ban đầu</label><select name="status" class="form-select fw-medium"><option value="ACTIVE" selected>Phát hành Voucher</option><option value="INACTIVE">Ngừng phát hành Voucher</option></select></div>
            </div>
            <div class="modal-footer bg-light border-0"><button type="submit" class="btn btn-primary fw-medium w-100">Xác nhận tạo Voucher</button></div>
        </form>
    </div></div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); });

    // TÌM KIẾM
    function quickSearch(inputId, tableId) {
        let input = document.getElementById(inputId).value.toLowerCase();
        let tr = document.getElementById(tableId).getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) {
            let rowContent = tr[i].textContent || tr[i].innerText;
            tr[i].style.display = rowContent.toLowerCase().indexOf(input) > -1 ? "" : "none";
        }
    }

    // LỌC VOUCHER THEO CHIPS JAVASCRIPT
    function filterVouchers(status, btn) {
        document.querySelectorAll('.v-filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const rows = document.querySelectorAll('.voucher-row');
        rows.forEach(row => {
            if (status === 'ALL' || row.getAttribute('data-status') === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>