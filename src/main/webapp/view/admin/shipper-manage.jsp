<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trạm điều phối Shipper | Admin Workspace</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        /* === ZOTECH CORE UI === */
        :root { --primary: #2F6B3F; --z-bg: #F3F4F6; --z-surface: #FFFFFF; --z-text-main: #1E293B; --z-text-muted: #64748B; --z-border: #E2E8F0; }
        body { background-color: var(--z-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--z-text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* ZOTECH SIDEBAR (Đồng bộ 100% hệ sinh thái) */
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

        /* TABS TRẠM ĐIỀU PHỐI */
        .nav-tabs-custom { border-bottom: 2px solid var(--z-border); gap: 24px; display: flex; padding-left: 0; margin-bottom: 24px; list-style: none;}
        .nav-tabs-custom li a { display: block; padding: 16px 4px; color: var(--z-text-muted); text-decoration: none; font-weight: 600; font-size: 14px; border-bottom: 3px solid transparent; margin-bottom: -2px; transition: 0.2s;}
        .nav-tabs-custom li a:hover { color: var(--primary); }
        .nav-tabs-custom li a.active { color: var(--primary); border-bottom-color: var(--primary); }

        /* BẢNG ĐIỀU PHỐI */
        .table-custom { border-collapse: separate; border-spacing: 0 12px; width: 100%; }
        .table-custom thead th { color: var(--z-text-muted); font-size: 11px; text-transform: uppercase; letter-spacing: 1px; padding: 0 24px 8px; border: none; font-weight: 600; }
        .order-row { background: var(--z-surface); transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease; border-radius: 12px; cursor: pointer;}
        .order-row td { padding: 16px 24px; vertical-align: middle; border-top: 1px solid var(--z-border); border-bottom: 1px solid var(--z-border); }
        .order-row td:first-child { border-left: 1px solid var(--z-border); border-radius: 12px 0 0 12px; }
        .order-row td:last-child { border-right: 1px solid var(--z-border); border-radius: 0 12px 12px 0; }
        .order-row:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .order-row.active-row { transform: scale(1.02) translateY(-6px); box-shadow: 0 20px 40px rgba(0,0,0,0.12); position: relative; z-index: 10; }
        .order-row.active-row td { border-color: var(--primary); }
        .order-row.active-row td:first-child { border-left: 4px solid var(--primary); }

        /* NÚT THAO TÁC GỌN GÀNG */
        .btn-icon { width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; border: 1px solid var(--z-border); background: var(--z-surface); transition: 0.2s; color: var(--z-text-muted); cursor: pointer;}
        .btn-icon:hover { background: #E0F2FE; color: #0284C7; border-color: #BAE6FD; }

        .btn-assign {
            background: var(--primary); color: #fff; padding: 6px 14px; border-radius: 8px;
            font-size: 12px; font-weight: 600; border: none; transition: 0.2s;
            display: inline-flex; align-items: center; justify-content: center; gap: 6px;
            white-space: nowrap; /* BẮT BUỘC: Ngăn chữ rớt dòng */
        }
        .btn-assign:hover { background: #245530; color: #fff; }

        /* OFFCANVAS */
        .offcanvas-end { width: 450px !important; border-left: none; box-shadow: -10px 0 30px rgba(0,0,0,0.1); }
        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 14px; color: var(--z-text-muted);}
        .receipt-row.total { border-top: 1px dashed var(--z-border); padding-top: 12px; margin-top: 12px; color: var(--z-text-main); font-weight: 700; font-size: 16px;}
    </style>
</head>
<body>
<div class="d-flex">
    <!-- === ZOTECH SIDEBAR ĐỒNG BỘ FULL MENU === -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), #10B981);"><i class="ph-bold ph-leaf text-white fs-6"></i></div>
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
                <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>

                <div class="menu-label">Kho & Vận hành</div>
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân sự</a></li>

                <div class="menu-label">Hệ thống</div>
                <li><a href="${pageContext.request.contextPath}/admin/settings"><i class="ph-fill ph-gear"></i> Cấu hình chung</a></li>
            </ul>
        </div>
    </aside>

    <!-- === ZOTECH MAIN & HEADER === -->
    <main class="main-wrapper overflow-auto" style="height: 100vh;">
        <header class="z-topbar">
            <div class="d-flex align-items-center gap-3"></div>
            <div class="dropdown border-start ps-4">
                <a href="#" class="d-flex align-items-center text-decoration-none text-dark dropdown-toggle" data-bs-toggle="dropdown">
                    <div class="d-flex flex-column text-end me-2">
                        <span class="fw-bold" style="font-size: 13px;">${not empty sessionScope.user ? sessionScope.user.fullName : 'Admin'}</span>
                        <span class="text-muted" style="font-size: 11px;">Quản trị viên</span>
                    </div>
                    <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 36px; height: 36px; font-weight: bold;">
                        ${not empty sessionScope.user ? fn:substring(sessionScope.user.fullName, 0, 1) : 'A'}
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                    <li><a class="dropdown-item py-2 fw-medium" style="font-size: 13px;" href="${pageContext.request.contextPath}/profile"><i class="ph-bold ph-user me-2"></i> Hồ sơ cá nhân</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="p-4 px-5 pb-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <div><h2 class="fw-bold mb-0 brand-font text-dark" style="font-size: 28px;">Trạm điều phối Shipper</h2></div>
                <a href="${pageContext.request.contextPath}/shipper/home" target="_blank" class="btn btn-outline-primary rounded-pill fw-medium d-flex align-items-center gap-2 px-4">
                    <i class="ph-bold ph-app-window"></i> Mở App Shipper
                </a>
            </div>

            <ul class="nav-tabs-custom">
                <li><a href="?status=ALL" class="${currentStatus == 'ALL' ? 'active' : ''}">Tất cả</a></li>
                <li><a href="?status=PENDING" class="${currentStatus == 'PENDING' ? 'active' : ''}">Chờ xác nhận</a></li>
                <li><a href="?status=PROCESSING" class="${currentStatus == 'PROCESSING' || currentStatus == 'CONFIRMED' ? 'active' : ''}">Cần đóng gói</a></li>
                <li><a href="?status=READY" class="${currentStatus == 'READY' || currentStatus == 'PREPARING' ? 'active' : ''}">Đang tìm tài xế</a></li>
                <li><a href="?status=SHIPPING" class="${currentStatus == 'SHIPPING' ? 'active' : ''}">Đang giao</a></li>
                <li><a href="?status=COMPLETED" class="${currentStatus == 'COMPLETED' ? 'active' : ''}">Hoàn thành</a></li>
            </ul>

            <table class="table-custom">
                <thead>
                    <tr>
                        <th width="10%">MÃ ĐH</th><th width="25%">KHÁCH HÀNG</th><th width="15%">TỔNG TIỀN</th><th width="15%">TRẠNG THÁI</th><th width="20%">TÀI XẾ GIAO HÀNG</th><th width="15%" class="text-end pe-4">HÀNH ĐỘNG</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr class="order-row" id="row-${o.id}" onclick="openDetailPanel(${o.id})">
                            <td class="fw-bold text-dark fs-6">#DH${o.id}</td>
                            <td>
                                <div class="fw-bold text-dark mb-1">${o.receiverName}</div>
                                <div class="text-muted" style="font-size: 12px;"><i class="ph-fill ph-phone me-1"></i> ${o.receiverPhone}</div>
                            </td>
                            <td>
                                <div class="fw-bold text-danger fs-6"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</div>
                                <div class="text-muted mt-1" style="font-size: 11px;">${o.paymentMethod == 'COD' ? 'Tiền mặt' : 'Chuyển khoản'}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.orderStatus == 'PENDING'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-2 rounded-pill">Chờ xác nhận</span></c:when>
                                    <c:when test="${o.orderStatus == 'CONFIRMED'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle px-3 py-2 rounded-pill">Đã xác nhận</span></c:when>
                                    <c:when test="${o.orderStatus == 'PROCESSING'}"><span class="badge bg-primary-subtle text-primary-emphasis border border-primary-subtle px-3 py-2 rounded-pill">Đang đóng gói</span></c:when>
                                    <c:when test="${o.orderStatus == 'PREPARING'}"><span class="badge bg-warning text-dark border border-warning px-3 py-2 rounded-pill shadow-sm">Chờ lấy hàng</span></c:when>
                                    <c:when test="${o.orderStatus == 'READY'}"><span class="badge bg-warning text-dark px-3 py-2 rounded-pill shadow-sm">Đang tìm TX</span></c:when>
                                    <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge bg-primary px-3 py-2 rounded-pill shadow-sm"><i class="ph-fill ph-paper-plane-tilt me-1"></i> Đang giao</span></c:when>
                                    <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill"><i class="ph-bold ph-check me-1"></i> Đã giao</span></c:when>
                                    <c:when test="${o.orderStatus == 'CANCELLED'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill">Đã hủy</span></c:when>
                                    <c:otherwise><span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${o.orderStatus}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty o.shipperId && o.shipperId > 0}">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="rounded-circle bg-primary bg-opacity-10 d-flex align-items-center justify-content-center text-primary" style="width: 32px; height: 32px;"><i class="ph-fill ph-moped fs-5"></i></div>
                                            <div>
                                                <div class="fw-bold text-dark" style="font-size: 13px;">${shipperMap[o.shipperId]}</div>
                                                <div class="text-muted" style="font-size: 11px;">Mã TX: #${o.shipperId}</div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise><span class="text-muted fst-italic" style="font-size: 12px;">Chưa có tài xế</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end">
                                <div class="d-flex gap-2 justify-content-end align-items-center">
                                    <button type="button" class="btn-icon" onclick="event.stopPropagation(); openDetailPanel(${o.id})" title="Xem chi tiết">
                                        <i class="ph-bold ph-eye fs-5"></i>
                                    </button>
                                    <c:if test="${o.orderStatus == 'PENDING' || o.orderStatus == 'CONFIRMED' || o.orderStatus == 'PROCESSING' || o.orderStatus == 'PREPARING' || o.orderStatus == 'READY'}">
                                        <!-- ĐÃ FIX: NÚT ĐIỀU PHỐI ĐƯỢC CĂN GIỮA VÀ BÓP KÍCH THƯỚC GỌN GÀNG -->
                                        <button type="button" class="btn-assign shadow-sm" onclick="event.stopPropagation(); openAssignModal(${o.id}, '${o.receiverName}')">
                                            <i class="ph-bold ph-user-plus fs-6"></i> Điều phối TX
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</div>

<!-- ========================================== -->
<!-- MODAL COMBOBOX PHÂN CÔNG SHIPPER -->
<!-- ========================================== -->
<div class="modal fade" id="assignShipperModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/admin/shipper-manage" method="POST" class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="fw-bold brand-font text-dark m-0">Điều phối Tài xế</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body py-4">
                <div class="alert alert-info bg-info bg-opacity-10 border-0 text-info-emphasis mb-4">
                    Đang phân công giao hàng cho đơn: <strong id="assignOrderDisplay" class="text-dark"></strong>
                </div>

                <input type="hidden" name="orderId" id="assignOrderIdInput">

                <label class="form-label fw-bold text-dark">Chọn Tài xế từ danh sách <span class="text-danger">*</span></label>
                <select name="shipperId" class="form-select form-select-lg bg-light" required>
                    <option value="" disabled selected>-- Bấm để chọn tài xế --</option>
                    <c:forEach var="s" items="${shippers}">
                        <option value="${s.id}">${s.fullName} (SĐT: ${s.phone} - Mã TX: #${s.id})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="modal-footer border-top-0 pt-0">
                <button type="submit" class="btn btn-primary fw-bold w-100 py-2 shadow-sm"><i class="ph-bold ph-paper-plane-tilt me-1"></i> XÁC NHẬN PHÂN CÔNG</button>
            </div>
        </form>
    </div>
</div>

<!-- ========================================== -->
<!-- OFFCANVAS: BẢNG TRƯỢT CHI TIẾT -->
<!-- ========================================== -->
<c:forEach var="o" items="${orders}">
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvas-${o.id}" data-bs-scroll="true" data-bs-backdrop="false">
        <div class="offcanvas-header border-bottom bg-light">
            <div>
                <h5 class="offcanvas-title fw-bold brand-font text-dark mb-1">Chi tiết Đơn hàng #DH${o.id}</h5>
                <div class="text-muted" style="font-size: 12px;"><i class="ph-fill ph-clock"></i> <fmt:formatDate value="${o.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" onclick="removeActiveRow(${o.id})"></button>
        </div>

        <div class="offcanvas-body p-0 custom-scrollbar">
            <div class="p-4 border-bottom">
                <div class="fw-bold text-uppercase text-muted mb-3" style="font-size: 11px; letter-spacing: 1px;">Thông tin Người đặt</div>
                <div class="d-flex align-items-start gap-3 mb-3">
                    <div class="rounded-circle bg-primary bg-opacity-10 text-primary d-flex justify-content-center align-items-center mt-1" style="width: 36px; height: 36px;"><i class="ph-fill ph-user fs-5"></i></div>
                    <div>
                        <div class="fw-bold text-dark fs-6">${o.receiverName}</div>
                        <div class="text-muted"><i class="ph-bold ph-phone text-primary me-1"></i> ${o.receiverPhone}</div>
                    </div>
                </div>
                <div class="d-flex align-items-start gap-3 mb-3">
                    <div class="rounded-circle bg-danger bg-opacity-10 text-danger d-flex justify-content-center align-items-center mt-1" style="width: 36px; height: 36px;"><i class="ph-fill ph-map-pin fs-5"></i></div>
                    <div class="text-dark fw-medium mt-1 lh-base">${o.receiverAddress}</div>
                </div>

                <div class="row g-2 mt-2">
                    <div class="col-6">
                        <div class="p-2 bg-light rounded border text-center">
                            <div class="text-muted" style="font-size: 10px; text-transform: uppercase;">Phương thức</div>
                            <div class="fw-bold text-dark" style="font-size: 12px;">
                                <c:choose><c:when test="${o.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(o.note), 'HỎA TỐC')}"><span class="text-danger"><i class="ph-bold ph-lightning"></i> HỎA TỐC 2H</span></c:when><c:otherwise><i class="ph-bold ph-truck text-info"></i> Tiêu chuẩn</c:otherwise></c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="p-2 bg-light rounded border text-center">
                            <div class="text-muted" style="font-size: 10px; text-transform: uppercase;">Thanh toán</div>
                            <div class="fw-bold text-dark" style="font-size: 12px;">${o.paymentMethod == 'COD' ? 'Tiền mặt (COD)' : 'Chuyển khoản'}</div>
                        </div>
                    </div>
                </div>
                <c:if test="${not empty o.note}">
                    <div class="mt-3 p-3 bg-warning bg-opacity-10 border border-warning border-opacity-25 rounded text-dark" style="font-size: 13px;">
                        <i class="ph-fill ph-info text-warning me-1"></i> <strong>Ghi chú:</strong> ${o.note}
                    </div>
                </c:if>
            </div>

            <c:set var="calcSubtotal" value="0" />
            <div class="p-4 border-bottom bg-light bg-opacity-50">
                <div class="fw-bold text-uppercase text-muted mb-3" style="font-size: 11px; letter-spacing: 1px;">Sản phẩm (<span id="count-${o.id}">${fn:length(detailsMap[o.id])}</span> món)</div>
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="item" items="${detailsMap[o.id]}">
                        <c:set var="calcSubtotal" value="${calcSubtotal + item.subtotal}" />
                        <div class="d-flex align-items-center gap-3">
                            <div class="flex-shrink-0">
                                <img src="${not empty item.productImage ? item.productImage : 'https://placehold.co/100x100?text=SP'}" class="rounded border bg-white" style="width: 50px; height: 50px; object-fit: cover;">
                            </div>
                            <div class="flex-grow-1 min-w-0">
                                <div class="fw-bold text-dark text-truncate" style="font-size: 13px;">${item.productName}</div>
                                <div class="text-muted mt-1" style="font-size: 12px;"><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ / ${item.productUnit}</div>
                            </div>
                            <div class="text-end flex-shrink-0">
                                <div class="fw-bold text-dark" style="font-size: 12px;">x${fn:replace(item.quantity, ".0", "")}</div>
                                <div class="fw-bold text-primary mt-1" style="font-size: 13px;"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> đ</div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty detailsMap[o.id]}">
                        <div class="text-center text-muted fst-italic py-3">Đơn hàng không có chi tiết sản phẩm.</div>
                    </c:if>
                </div>
            </div>

            <c:set var="safeShip" value="${o.shippingFee != null ? o.shippingFee : 0}" />
            <c:set var="safeTax" value="${o.taxFee != null ? o.taxFee : 0}" />
            <c:set var="calcVoucher" value="${calcSubtotal + safeShip + safeTax - o.totalAmount}" />
            <c:if test="${calcVoucher < 0}"><c:set var="calcVoucher" value="0" /></c:if>

            <div class="p-4">
                <div class="receipt-row"><span>Tạm tính hàng hóa:</span><span class="text-dark fw-medium"><fmt:formatNumber value="${calcSubtotal}" pattern="#,##0"/> đ</span></div>
                <c:if test="${calcVoucher > 0}"><div class="receipt-row text-success fw-medium"><span>Khuyến mãi (Voucher/Xu):</span><span>- <fmt:formatNumber value="${calcVoucher}" pattern="#,##0"/> đ</span></div></c:if>
                <div class="receipt-row"><span>Phí vận chuyển:</span><span class="text-dark fw-medium">+ <fmt:formatNumber value="${safeShip}" pattern="#,##0"/> đ</span></div>
                <div class="receipt-row"><span>Thuế (VAT):</span><span class="text-dark fw-medium">+ <fmt:formatNumber value="${safeTax}" pattern="#,##0"/> đ</span></div>

                <div class="receipt-row total align-items-center">
                    <span>TỔNG TIỀN CUỐI CÙNG</span>
                    <span class="text-danger fs-3 brand-font"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</span>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<!-- TOAST THÔNG BÁO ĐỒNG BỘ ZOTECH -->
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
    // Khởi tạo Toast
    document.addEventListener("DOMContentLoaded", function() {
        var ts = [].slice.call(document.querySelectorAll('.toast'));
        ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());
    });

    let currentRowId = null;

    function openDetailPanel(orderId) {
        if (currentRowId) removeActiveRow(currentRowId);

        const row = document.getElementById('row-' + orderId);
        if(row) row.classList.add('active-row');
        currentRowId = orderId;

        const targetCanvas = document.getElementById('offcanvas-' + orderId);
        if(targetCanvas) {
            const bsOffcanvas = new bootstrap.Offcanvas(targetCanvas);
            bsOffcanvas.show();
            targetCanvas.addEventListener('hidden.bs.offcanvas', function () {
                removeActiveRow(orderId);
            }, { once: true });
        }
    }

    function removeActiveRow(orderId) {
        const row = document.getElementById('row-' + orderId);
        if(row) row.classList.remove('active-row');
        if(currentRowId === orderId) currentRowId = null;
    }

    // GỌI MODAL COMBOBOX PHÂN CÔNG
    function openAssignModal(orderId, customerName) {
        document.getElementById('assignOrderIdInput').value = orderId;
        document.getElementById('assignOrderDisplay').innerText = "#DH" + orderId + " - Khách: " + customerName;
        new bootstrap.Modal(document.getElementById('assignShipperModal')).show();
    }
</script>
</body>
</html>