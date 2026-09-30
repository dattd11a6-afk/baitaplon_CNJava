<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Kho & Nguồn hàng | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #1F9D55; --primary-dark: #167e43; --z-bg: #F4F7F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        .sidebar { width: 250px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 13px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(31, 157, 85, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        .main-wrapper { margin-left: 250px; width: calc(100% - 250px); display: flex; flex-direction: column; min-height: 100vh;}
        .z-topbar { height: 70px; background: var(--z-surface); border-bottom: 1px solid var(--z-border); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; position: sticky; top: 0; z-index: 10; }

        .nav-tabs-custom { border-bottom: 1px solid var(--z-border); display: flex; gap: 32px; margin-bottom: 24px; }
        .nav-tabs-custom .nav-link { color: var(--z-text-muted); font-weight: 600; font-size: 13px; padding: 12px 4px; border: none; border-bottom: 2px solid transparent; background: transparent; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 8px;}
        .nav-tabs-custom .nav-link:hover { color: var(--primary); }
        .nav-tabs-custom .nav-link.active { color: var(--primary); border-bottom-color: var(--primary); }

        .admin-card { background: var(--z-surface); border: 1px solid var(--z-border); border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); padding: 24px; }
        .admin-card-table { padding: 0 !important; }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 20px; color: #9CA3AF; background: var(--z-surface); text-transform: uppercase; font-size: 10px; font-weight: 700; border-bottom: 1px solid var(--z-border); letter-spacing: 0.5px;}
        .admin-table td { padding: 16px 20px; vertical-align: middle; border-bottom: 1px solid #F8FAFC; color: var(--z-text-main); font-size: 13px;}
        .admin-table tbody tr:hover td { background: #F8FAFC; }

        .form-control, .form-select { border-radius: 8px; border-color: var(--z-border); padding: 10px 14px; font-size: 13px; transition: 0.2s;}
        .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1); outline: none;}

        .btn-action { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; font-size: 15px; transition: 0.2s; border: 1px solid var(--z-border); background: #fff; cursor: pointer; color: var(--z-text-muted);}
        .btn-action:hover.edit { background: #EEF2FF; color: #4F46E5; border-color: #C7D2FE; }
        .btn-action:hover.delete { background: #FEF2F2; color: #EF4444; border-color: #FECACA; }
        .btn-add-row { border: 1px dashed var(--primary); color: var(--primary); background: rgba(47, 107, 63, 0.05); font-weight: 600; transition: 0.2s; }
        .btn-add-row:hover { background: rgba(47, 107, 63, 0.1); color: var(--primary); }

        .search-box-white { background: #fff; border: 1px solid var(--z-border); border-radius: 8px; display: flex; align-items: center; padding: 0 16px; width: 300px; transition: 0.2s;}
        .search-box-white:focus-within { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(31,157,85,0.1); }
        .search-box-white i { color: #9CA3AF; font-size: 16px; }
        .search-box-white input { border: none; padding: 10px 12px; width: 100%; outline: none; font-size: 13px; color: var(--z-text-main);}

        .toast-zotech { background-color: var(--primary-dark); color: white; border-radius: 8px; padding: 12px 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; border: none; font-size: 14px; font-weight: 500;}

        /* Filter Button Styling */
        .filter-btn { border-radius: 50px; font-weight: 600; font-size: 12px; padding: 6px 16px; border: 1px solid var(--z-border); background: #fff; color: var(--z-text-muted); cursor: pointer; transition: 0.2s; }
        .filter-btn:hover { background: #F3F4F6; color: var(--z-text-main); }
        .filter-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), #10B981);">
                <i class="ph-bold ph-leaf text-white fs-6"></i>
            </div>
            <div><div class="fw-bold fs-6 brand-font text-white">Fruit Farmer</div></div>
        </div>
        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
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
                <li class="active"><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down text-info"></i> Lập phiếu Nhập</a></li>
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
                <a href="#" class="d-flex align-items-center text-decoration-none text-dark dropdown-toggle" data-bs-toggle="dropdown">
                    <div class="d-flex flex-column text-end me-2">
                        <span class="fw-bold" style="font-size: 13px;">${sessionScope.user.fullName}</span>
                        <span class="text-muted" style="font-size: 11px;">Quản trị viên</span>
                    </div>
                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; font-weight: bold; font-size: 15px;">
                        ${fn:substring(sessionScope.user.fullName, 0, 1)}
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                    <li><a class="dropdown-item py-2 fw-medium text-danger" href="${pageContext.request.contextPath}/logout"><i class="ph-bold ph-sign-out me-2"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="p-4 px-5 pb-5">
            <h2 class="fw-bold mb-4 brand-font text-dark" style="font-size: 28px;">Quản lý Kho & Nguồn hàng</h2>

            <ul class="nav nav-tabs-custom" id="inventoryTabs" role="tablist">
                <li class="nav-item"><button class="nav-link active" id="receipt-form-tab" data-bs-toggle="tab" data-bs-target="#receipt-form"><i class="ph-bold ph-file-plus"></i> Lập Phiếu Nhập</button></li>
                <li class="nav-item"><button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history"><i class="ph-bold ph-clock-counter-clockwise"></i> Lịch Sử Nhập Kho</button></li>
                <li class="nav-item"><button class="nav-link" id="supplier-tab" data-bs-toggle="tab" data-bs-target="#supplier"><i class="ph-bold ph-truck"></i> Nhà Cung Cấp</button></li>
            </ul>

            <div class="tab-content" id="inventoryTabsContent">

                <!-- TAB 1: FORM LẬP PHIẾU NHẬP -->
                <div class="tab-pane fade show active" id="receipt-form" role="tabpanel">
                    <form action="${pageContext.request.contextPath}/admin/inventory" method="POST" id="inventoryForm">
                        <div class="admin-card mb-4">
                            <h6 class="fw-bold brand-font mb-4"><i class="ph-fill ph-info text-primary me-2"></i>Thông tin chứng từ</h6>
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-dark">Nhà cung cấp <span class="text-danger">*</span></label>
                                    <select name="supplierId" class="form-select" required>
                                        <option value="">-- Chọn Nhà cung cấp --</option>
                                        <c:forEach var="sup" items="${suppliers}">
                                            <!-- CHỈ HIỆN ACTIVE TRONG FORM NHẬP -->
                                            <c:if test="${sup.status == 'ACTIVE'}">
                                                <option value="${sup.id}">${sup.name} - ${sup.phone}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold text-dark">Ghi chú phiếu nhập</label>
                                    <input type="text" name="note" class="form-control" placeholder="Tùy chọn ghi chú...">
                                </div>
                            </div>
                        </div>

                        <div class="admin-card mb-4" style="padding: 0;">
                            <div class="p-4 border-bottom d-flex justify-content-between align-items-center bg-light">
                                <h6 class="fw-bold brand-font m-0"><i class="ph-fill ph-package text-success me-2"></i>Chi tiết sản phẩm nhập</h6>
                                <button type="button" class="btn btn-add-row btn-sm px-3 py-2" onclick="addRow()"><i class="ph-bold ph-plus me-1"></i> Thêm dòng</button>
                            </div>
                            <table class="table admin-table m-0" id="inventoryTable">
                                <thead>
                                    <tr>
                                        <th style="width: 40%; background: #F8FAFC;">Sản phẩm *</th>
                                        <th style="width: 15%; background: #F8FAFC;">Số lượng *</th>
                                        <th style="width: 20%; background: #F8FAFC;">Giá vốn (VNĐ) *</th>
                                        <th class="text-end" style="width: 20%; background: #F8FAFC;">Thành tiền</th>
                                        <th class="text-center" style="width: 5%; background: #F8FAFC;">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody id="inventoryBody">
                                    <tr class="item-row">
                                        <td>
                                            <select name="productIds[]" class="form-select" required onchange="calculateTotal()">
                                                <option value="">-- Chọn sản phẩm --</option>
                                                <c:forEach var="p" items="${products}">
                                                    <option value="${p.id}">${p.name} (Tồn: ${p.stock})</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="number" name="quantities[]" class="form-control text-center row-qty" min="1" value="1" required oninput="calculateTotal()"></td>
                                        <td><input type="number" name="importPrices[]" class="form-control row-price" min="0" value="0" required oninput="calculateTotal()"></td>
                                        <td class="text-end fw-bold text-success row-subtotal align-middle">0 ₫</td>
                                        <td class="text-center align-middle"><button type="button" class="btn-action delete opacity-50" disabled style="cursor: not-allowed;"><i class="ph-bold ph-trash"></i></button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-flex justify-content-between align-items-center bg-white p-4 border rounded-3 shadow-sm mb-5">
                            <div class="d-flex align-items-center gap-4">
                                <span class="text-muted fw-medium">Tổng SL: <span id="grandQty" class="text-dark fw-bold fs-5 ms-1">1</span></span>
                                <div class="vr"></div>
                                <span class="text-muted fw-medium">Tổng tiền: <span id="grandTotal" class="text-danger fw-bold fs-3 ms-2">0 ₫</span></span>
                            </div>
                            <button type="submit" class="btn btn-success px-4 fw-bold py-2"><i class="ph-fill ph-check-circle me-1"></i> Nhập kho ngay</button>
                        </div>
                    </form>
                </div>

                <!-- TAB 2: LỊCH SỬ NHẬP KHO -->
                <div class="tab-pane fade" id="history" role="tabpanel">
                    <div class="admin-card p-0">
                        <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                            <h6 class="fw-bold m-0 text-dark">Tra cứu lịch sử</h6>
                            <div class="search-box-white">
                                <i class="ph-bold ph-magnifying-glass"></i>
                                <input type="text" id="searchHistory" onkeyup="quickSearch('searchHistory', 'historyTable')" placeholder="Tìm kiếm mã phiếu, tên NCC...">
                            </div>
                        </div>

                        <table class="admin-table" id="historyTable">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">Mã PN</th><th>Ngày nhập</th><th>Nhà cung cấp</th><th>Người lập</th><th class="text-end">Tổng tiền (VNĐ)</th><th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${receipts}">
                                    <tr>
                                        <td><span class="badge bg-light text-dark border border-secondary border-opacity-25 px-2 py-1">#PN${r.id}</span></td>
                                        <td class="fw-medium text-dark"><fmt:formatDate value="${r.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></td>
                                        <td><div class="d-flex align-items-center"><i class="ph-fill ph-truck text-primary me-2 fs-5"></i><span class="fw-bold text-dark text-truncate" style="max-width: 200px;" title="${r.supplierName}">${r.supplierName}</span></div></td>
                                        <td class="text-muted">${r.userName}</td>
                                        <td class="text-end fw-bold text-danger fs-6"><fmt:formatNumber value="${r.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <button type="button" class="btn-action edit" onclick="viewReceiptDetails(${r.id})" title="Xem chi tiết phiếu nhập"><i class="ph-bold ph-eye"></i></button>
                                                <button type="button" class="btn-action delete" onclick="confirmDeleteReceipt(${r.id})" title="Xóa Phiếu"><i class="ph-bold ph-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <c:if test="${empty receipts}"><div class="text-center py-5 text-muted">Chưa có phiếu nhập kho nào.</div></c:if>
                    </div>
                </div>

                <!-- TAB 3: NHÀ CUNG CẤP -->
                <div class="tab-pane fade" id="supplier" role="tabpanel">
                    <div class="admin-card p-0">
                        <!-- HEADER CỦA BẢNG KÈM BỘ LỌC CHIPS -->
                        <div class="d-flex justify-content-between align-items-center p-3 border-bottom bg-light">
                            <div class="d-flex align-items-center gap-2">
                                <h6 class="fw-bold m-0 text-dark me-3">Danh sách Nhà cung cấp</h6>
                                <button type="button" class="filter-btn sup-filter-btn active" onclick="filterSuppliers('ALL', this)">Tất cả</button>
                                <button type="button" class="filter-btn sup-filter-btn" onclick="filterSuppliers('ACTIVE', this)">Đang hoạt động</button>
                                <button type="button" class="filter-btn sup-filter-btn" onclick="filterSuppliers('INACTIVE', this)">Ngừng hợp tác</button>
                            </div>
                            <div class="d-flex gap-3">
                                <div class="search-box-white">
                                    <i class="ph-bold ph-magnifying-glass"></i>
                                    <input type="text" id="searchSupplier" onkeyup="quickSearch('searchSupplier', 'supplierTable')" placeholder="Tìm tên, SĐT, Email...">
                                </div>
                                <button class="btn fw-medium text-white px-4" style="background: var(--primary);" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                                    <i class="ph-bold ph-plus me-1"></i> Thêm NCC
                                </button>
                            </div>
                        </div>

                        <table class="admin-table" id="supplierTable">
                            <thead><tr><th>Tên nhà cung cấp</th><th>Số điện thoại</th><th>Email</th><th>Địa chỉ</th><th>Trạng thái</th><th class="text-center">Thao tác</th></tr></thead>
                            <tbody>
                                <c:forEach var="s" items="${suppliers}">
                                    <!-- HIỂN THỊ TẤT CẢ VÀ GẮN DATA-STATUS ĐỂ LỌC -->
                                    <tr class="supplier-row" data-status="${s.status}">
                                        <td class="fw-bold text-dark">${s.name}</td>
                                        <td class="text-muted">${s.phone}</td>
                                        <td class="text-muted">${s.email}</td>
                                        <td class="text-muted text-truncate" style="max-width: 250px;" title="${s.address}">${s.address}</td>
                                        <td>
                                            <!-- HIỂN THỊ CHUẨN XÁC TRẠNG THÁI -->
                                            <c:choose>
                                                <c:when test="${s.status == 'INACTIVE'}">
                                                    <span class="badge border bg-success-subtle text-success border-success-subtle px-2 py-1"><i class="ph-fill ph-check-circle me-1"></i>Ngừng hợp tác</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge border bg-light text-muted px-2 py-1"><i class="ph-fill ph-minus-circle me-1"></i>Đang hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <button type="button" class="btn-action edit" data-bs-toggle="modal" data-bs-target="#editSupplierModal${s.id}"><i class="ph-bold ph-pencil-simple"></i></button>
                                                <button type="button" class="btn-action delete" onclick="confirmDeleteSupplier(${s.id}, '${fn:escapeXml(s.name)}')"><i class="ph-bold ph-trash"></i></button>
                                            </div>
                                        </td>
                                    </tr>

                                    <!-- Modal Sửa NCC -->
                                    <div class="modal fade" id="editSupplierModal${s.id}">
                                        <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 shadow-lg rounded-4">
                                            <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font">Sửa thông tin NCC</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                            <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST">
                                                <div class="modal-body text-start p-4">
                                                    <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${s.id}">

                                                    <div class="mb-3"><label class="form-label fw-semibold">Tên đối tác *</label><input type="text" name="name" class="form-control fw-bold" value="${s.name}" required></div>
                                                    <div class="mb-3"><label class="form-label fw-semibold">Số điện thoại</label><input type="text" name="phone" class="form-control" value="${s.phone}"></div>
                                                    <div class="mb-3"><label class="form-label fw-semibold">Email</label><input type="email" name="email" class="form-control" value="${s.email}"></div>
                                                    <div class="mb-3"><label class="form-label fw-semibold">Địa chỉ</label><textarea name="address" class="form-control" rows="2">${s.address}</textarea></div>

                                                    <div class="mb-2">
                                                        <label class="form-label fw-semibold">Trạng thái hợp tác</label>
                                                        <select name="status" class="form-select fw-medium">
                                                            <option value="ACTIVE" ${s.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động</option>
                                                            <option value="INACTIVE" ${s.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hợp tác</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer bg-light border-0"><button type="submit" class="btn text-white fw-medium px-4 w-100" style="background: var(--primary);">Lưu thay đổi</button></div>
                                            </form>
                                        </div></div>
                                    </div>
                                </c:forEach>
                            </tbody>
                        </table>
                        <c:if test="${empty suppliers}">
                            <div class="text-center py-5 text-muted">Chưa có dữ liệu Nhà cung cấp.</div>
                        </c:if>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<!-- Modal Thêm Nhà Cung Cấp -->
<div class="modal fade" id="addSupplierModal">
    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 shadow-lg rounded-4">
        <div class="modal-header border-bottom-0"><h5 class="fw-bold m-0 brand-font">Thêm NCC Mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST">
            <div class="modal-body text-start p-4">
                <input type="hidden" name="action" value="add">
                <div class="mb-3"><label class="form-label fw-semibold">Tên NCC *</label><input type="text" name="name" class="form-control fw-bold" required></div>
                <div class="mb-3"><label class="form-label fw-semibold">SĐT</label><input type="text" name="phone" class="form-control"></div>
                <div class="mb-3"><label class="form-label fw-semibold">Email</label><input type="email" name="email" class="form-control"></div>
                <div class="mb-3"><label class="form-label fw-semibold">Địa chỉ</label><textarea name="address" class="form-control" rows="2"></textarea></div>
                <div class="mb-2">
                    <label class="form-label fw-semibold">Trạng thái</label>
                    <select name="status" class="form-select fw-medium">
                        <option value="ACTIVE" selected>Đang hoạt động</option>
                        <option value="INACTIVE">Ngừng hợp tác</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer bg-light border-0"><button type="submit" class="btn text-white fw-medium px-4 w-100" style="background: var(--primary);">Khởi tạo NCC</button></div>
        </form>
    </div></div>
</div>

<!-- FORM NGẦM ĐỂ XÓA (JS SẼ GỌI VÀO ĐÂY) -->
<form id="deleteSupplierForm" action="${pageContext.request.contextPath}/admin/suppliers" method="POST" style="display: none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="id" id="deleteSupplierId" value="">
</form>

<form id="deleteReceiptForm" action="${pageContext.request.contextPath}/admin/inventory" method="POST" style="display: none;">
    <input type="hidden" name="action" value="deleteReceipt">
    <input type="hidden" name="receiptId" id="deleteReceiptId" value="">
</form>

<!-- MODAL CHI TIẾT PHIẾU NHẬP -->
<div class="modal fade" id="receiptDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="modal-header border-bottom-0 p-4 pb-3">
                <h5 class="fw-bold text-dark brand-font m-0">Chi tiết Phiếu nhập <span id="modalReceiptId" class="text-primary"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0" style="max-height: 450px; overflow-y: auto;">
                <table class="table table-hover align-middle m-0">
                    <thead class="table-light text-muted sticky-top" style="font-size: 11px; text-transform: uppercase;">
                        <tr><th class="ps-4 py-3">Tên Sản phẩm</th><th class="text-center py-3">Số lượng</th><th class="text-end py-3">Giá nhập (VNĐ)</th><th class="pe-4 text-end py-3">Thành tiền (VNĐ)</th></tr>
                    </thead>
                    <tbody id="receiptDetailBody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<template id="rowTemplate">
    <tr class="item-row">
        <td><select name="productIds[]" class="form-select" required onchange="calculateTotal()"><option value="">-- Chọn sản phẩm --</option><c:forEach var="p" items="${products}"><option value="${p.id}">${p.name} (Tồn:${p.stock})</option></c:forEach></select></td>
        <td><input type="number" name="quantities[]" class="form-control text-center row-qty" min="1" value="1" required oninput="calculateTotal()"></td>
        <td><input type="number" name="importPrices[]" class="form-control row-price" min="0" value="0" required oninput="calculateTotal()"></td>
        <td class="text-end fw-bold text-success row-subtotal align-middle">0 ₫</td>
        <td class="text-center align-middle"><button type="button" class="btn-action delete" onclick="removeRow(this)"><i class="ph-bold ph-trash"></i></button></td>
    </tr>
</template>

<!-- TOAST ZOTECH -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center border-0 toast-zotech" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex w-100 align-items-center justify-content-between">
                <div><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var ts = [].slice.call(document.querySelectorAll('.toast'));
        ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());

        var triggerTabList = [].slice.call(document.querySelectorAll('#inventoryTabs button[data-bs-toggle="tab"]'))
        triggerTabList.forEach(function (triggerEl) {
            triggerEl.addEventListener('shown.bs.tab', function (event) { localStorage.setItem('activeInventoryTab', event.target.id); });
        });
        var activeTabId = localStorage.getItem('activeInventoryTab');
        if (activeTabId) { var tabToActivate = new bootstrap.Tab(document.getElementById(activeTabId)); tabToActivate.show(); }
    });

    const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
    function addRow() { document.getElementById('inventoryBody').appendChild(document.getElementById('rowTemplate').content.cloneNode(true)); calculateTotal(); }
    function removeRow(btn) { btn.closest('tr').remove(); calculateTotal(); }
    function calculateTotal() {
        let total = 0, qty = 0;
        document.querySelectorAll('#inventoryBody .item-row').forEach(row => {
            const q = parseFloat(row.querySelector('.row-qty').value) || 0;
            const p = parseFloat(row.querySelector('.row-price').value) || 0;
            row.querySelector('.row-subtotal').innerText = formatter.format(q * p);
            total += (q * p); qty += q;
        });
        document.getElementById('grandTotal').innerText = formatter.format(total); document.getElementById('grandQty').innerText = qty;
    }

    function viewReceiptDetails(receiptId) {
        document.getElementById('modalReceiptId').innerText = '#PN' + receiptId;
        const tbody = document.getElementById('receiptDetailBody');
        tbody.innerHTML = `<tr><td colspan="4" class="text-center py-5"><div class="spinner-border text-success" role="status"></div></td></tr>`;
        new bootstrap.Modal(document.getElementById('receiptDetailModal')).show();

        fetch('${pageContext.request.contextPath}/admin/inventory?action=getDetails&id=' + receiptId)
            .then(response => response.json())
            .then(data => {
                let html = '';
                if (data.length === 0) html = '<tr><td colspan="4" class="text-center py-4 text-muted">Không có dữ liệu</td></tr>';
                else data.forEach(item => {
                    html += `<tr><td class="ps-4 fw-bold">\${item.productName}</td><td class="text-center"><span class="text-success">+\${item.quantity}</span></td><td class="text-end text-muted">\${formatter.format(item.importPrice)}</td><td class="pe-4 text-end fw-bold text-danger">\${formatter.format(item.subtotal)}</td></tr>`;
                });
                tbody.innerHTML = html;
            });
    }

    function quickSearch(inputId, tableId) {
        let input = document.getElementById(inputId).value.toLowerCase();
        let tr = document.getElementById(tableId).getElementsByTagName("tr");
        for (let i = 1; i < tr.length; i++) {
            let rowContent = tr[i].textContent || tr[i].innerText;
            tr[i].style.display = rowContent.toLowerCase().indexOf(input) > -1 ? "" : "none";
        }
    }

    // JAVASCRIPT HỎI CONFIRM
    function confirmDeleteSupplier(id, name) {
        if(confirm('Cảnh báo: Bạn có chắc chắn muốn Ngừng hợp tác với [' + name + '] không? \nNhà cung cấp này sẽ bị ẩn đi khi bạn Lập phiếu nhập kho mới.')) {
            document.getElementById('deleteSupplierId').value = id;
            document.getElementById('deleteSupplierForm').submit();
        }
    }

    function confirmDeleteReceipt(id) {
        if(confirm('CẢNH BÁO: Xóa phiếu nhập này sẽ tự động TRỪ LẠI số lượng tồn kho của các sản phẩm bên trong. Bạn có chắc chắn xóa?')) {
            document.getElementById('deleteReceiptId').value = id;
            document.getElementById('deleteReceiptForm').submit();
        }
    }

    // JAVASCRIPT LỌC TAB NHÀ CUNG CẤP
    function filterSuppliers(status, btn) {
        // Cập nhật nút Active
        document.querySelectorAll('.sup-filter-btn').forEach(b => {
            b.classList.remove('active');
            b.classList.replace('text-white', 'text-muted');
        });
        btn.classList.add('active');
        btn.classList.replace('text-muted', 'text-white');

        // Lọc Row dữ liệu
        const rows = document.querySelectorAll('.supplier-row');
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