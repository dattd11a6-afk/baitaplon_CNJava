<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách đơn hàng | Shipper</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --ship-primary: #F59E0B; --ship-sidebar: #111827; --ship-bg: #F9FAFB; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E2E8F0; }
        body { background-color: var(--ship-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        .sidebar { width: 250px; background-color: var(--ship-sidebar); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--ship-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff;}
        .sidebar-menu { list-style: none; padding: 0; margin: 24px 0 0 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 14px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: var(--ship-primary); background-color: rgba(245, 158, 11, 0.1); border-left-color: var(--ship-primary); font-weight: 600; }

        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }
        .ship-header { height: 72px; background: #fff; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .page-body { padding: 32px; flex-grow: 1; }

        .nav-pills .nav-link { color: #4B5563; border-radius: 50px; font-size: 13px; font-weight: 600; padding: 8px 24px; border: 1px solid #D1D5DB; margin-right: 16px; background: #fff; transition: 0.2s;}
        .nav-pills .nav-link:hover { border-color: var(--ship-primary); color: var(--ship-primary); }
        .nav-pills .nav-link.active { background-color: var(--ship-primary); color: #fff; border-color: var(--ship-primary); box-shadow: 0 4px 12px rgba(245, 158, 11, 0.25);}

        .order-card { background: #fff; border-radius: 16px; border: 1px solid var(--border-color); padding: 24px; transition: 0.2s; height: 100%; display: flex; flex-direction: column;}
        .order-card:hover { border-color: var(--ship-primary); box-shadow: 0 8px 24px rgba(0,0,0,0.04); transform: translateY(-2px);}
        .card-footer-action { margin-top: auto; padding-top: 16px; border-top: 1px dashed var(--border-color); display: flex; justify-content: space-between; align-items: center;}

        .user-chip { display: flex; align-items: center; gap: 12px; background: #F3F4F6; padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #E5E7EB; }
        .user-avatar { width: 32px; height: 32px; background: var(--ship-primary); color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        .filter-wrapper { background: #fff; border: 1px solid var(--border-color); border-radius: 50px; padding: 4px 16px; display: flex; align-items: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);}
        .filter-wrapper select { border: none; outline: none; font-size: 13px; font-weight: 600; color: #1F2937; cursor: pointer; background: transparent;}
    </style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="ph-bold ph-moped"></i></div>
            <div>
                <div class="fw-bold brand-font text-white" style="font-size: 16px;">Delivery App</div>
                <div style="font-size: 10px; color: var(--ship-primary); font-weight: 700; letter-spacing: 1px;">SHIPPER PORTAL</div>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/shipper/home"><i class="ph-fill ph-house"></i> Tổng quan</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/shipper/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng của tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/shipper/profile"><i class="ph-fill ph-user-circle"></i> Tài khoản cá nhân</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="ship-header">
            <h5 class="fw-bold m-0 brand-font">Quản lý Đơn hàng</h5>
            <div class="dropdown">
                <div class="user-chip dropdown-toggle" data-bs-toggle="dropdown">
                    <div class="user-avatar">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                    <div class="user-info d-flex flex-column text-start">
                        <span class="fw-bold" style="font-size: 13px; line-height: 1;">${sessionScope.user.fullName}</span>
                        <span class="text-muted" style="font-size: 11px;">Tài xế giao hàng</span>
                    </div>
                </div>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                    <li><a class="dropdown-item py-2 fw-medium" href="${pageContext.request.contextPath}/shipper/profile">Hồ sơ cá nhân</a></li>
                    <li><hr class="dropdown-divider my-1"></li>
                    <li><a class="dropdown-item py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="page-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <ul class="nav nav-pills m-0" id="pills-tab" role="tablist">
                    <li class="nav-item"><button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-wait">Chờ lấy hàng</button></li>
                    <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-shipping">Đang giao</button></li>
                    <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-done">Đã giao</button></li>
                    <li class="nav-item"><button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-cancel">Thất bại / Bị hủy</button></li>
                </ul>

                <div class="filter-wrapper">
                    <i class="ph-bold ph-funnel text-muted"></i>
                    <select id="deliveryFilter" onchange="applyDeliveryFilter()">
                        <option value="EXPRESS" selected>Giao nhanh 2H (Ưu tiên)</option>
                        <option value="STANDARD">Giao tiêu chuẩn</option>
                        <option value="ALL">Tất cả đơn hàng</option>
                    </select>
                </div>
            </div>

            <div class="tab-content" id="pills-tabContent">
                <!-- 1. CHỜ LẤY HÀNG -->
                <div class="tab-pane fade show active" id="tab-wait">
                    <div class="row g-4" id="wait-container">
                        <c:set var="hasWait" value="false" />
                        <c:forEach var="o" items="${myOrders}">
                            <c:if test="${o.orderStatus == 'PREPARING'}">
                                <c:set var="hasWait" value="true" />
                                <c:set var="isExpress" value="${o.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(o.note), 'HỎA TỐC')}" />

                                <div class="col-xl-4 col-lg-6 col-md-6 order-wrapper" data-type="${isExpress ? 'EXPRESS' : 'STANDARD'}">
                                    <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/shipper/order-detail?id=${o.id}'">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold fs-5 text-dark">#DH${o.id}</span>
                                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">CHỜ LẤY HÀNG</span>
                                        </div>
                                        <div class="mb-4">
                                            <c:if test="${isExpress}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1"><i class="ph-bold ph-lightning"></i> GIAO HỎA TỐC 2H</span></c:if>
                                            <c:if test="${!isExpress}"><span class="badge bg-light text-dark border px-2 py-1"><i class="ph-bold ph-truck"></i> TIÊU CHUẨN</span></c:if>
                                        </div>

                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="ph-fill ph-user-circle text-muted fs-5"></i>
                                            <span class="fw-bold text-dark fs-6">${o.receiverName}</span>
                                            <span class="text-muted ms-auto"><fmt:formatDate value="${o.createdAt}" pattern="HH:mm - dd/MM"/></span>
                                        </div>
                                        <div class="d-flex align-items-start gap-2 mb-4">
                                            <i class="ph-fill ph-map-pin text-danger fs-5 mt-1"></i>
                                            <span class="text-muted lh-base" style="font-size: 13px;">${o.receiverAddress}</span>
                                        </div>

                                        <div class="card-footer-action">
                                            <div>
                                                <div class="text-muted fw-bold" style="font-size: 11px; text-transform: uppercase;">Thu hộ (COD)</div>
                                                <div class="badge ${o.paymentMethod == 'COD' ? 'bg-success' : 'bg-primary'} mt-1 px-2 py-1">${o.paymentMethod == 'COD' ? 'Tiền mặt' : 'Đã thanh toán'}</div>
                                            </div>
                                            <div class="fw-bold text-danger fs-4 text-end">
                                                <c:choose>
                                                    <c:when test="${o.paymentMethod == 'COD'}"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</c:when>
                                                    <c:otherwise>0 đ</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <div id="no-wait-msg" class="col-12 text-center py-5 text-muted fs-5" style="display: ${hasWait ? 'none' : 'block'};">Không có đơn chờ lấy phù hợp.</div>
                    </div>
                </div>

                <!-- 2. ĐANG GIAO -->
                <div class="tab-pane fade" id="tab-shipping">
                    <div class="row g-4" id="shipping-container">
                        <c:set var="hasShipping" value="false" />
                        <c:forEach var="o" items="${myOrders}">
                            <c:if test="${o.orderStatus == 'SHIPPING'}">
                                <c:set var="hasShipping" value="true" />
                                <c:set var="isExpress" value="${o.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(o.note), 'HỎA TỐC')}" />

                                <div class="col-xl-4 col-lg-6 col-md-6 order-wrapper" data-type="${isExpress ? 'EXPRESS' : 'STANDARD'}">
                                    <div class="order-card" style="border: 2px solid var(--ship-primary);" onclick="window.location.href='${pageContext.request.contextPath}/shipper/order-detail?id=${o.id}'">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold fs-5 text-dark">#DH${o.id}</span>
                                            <span class="badge text-dark px-3 py-2 rounded-pill" style="background: var(--ship-primary);">ĐANG GIAO</span>
                                        </div>
                                        <div class="mb-4">
                                            <c:if test="${isExpress}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1"><i class="ph-bold ph-lightning"></i> GIAO HỎA TỐC 2H</span></c:if>
                                            <c:if test="${!isExpress}"><span class="badge bg-light text-dark border px-2 py-1"><i class="ph-bold ph-truck"></i> TIÊU CHUẨN</span></c:if>
                                        </div>

                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="ph-fill ph-user-circle text-muted fs-5"></i>
                                            <span class="fw-bold text-dark fs-6">${o.receiverName}</span>
                                            <span class="text-muted ms-auto">Nhận lúc: <fmt:formatDate value="${o.createdAt}" pattern="HH:mm"/></span>
                                        </div>
                                        <div class="d-flex align-items-start gap-2 mb-4">
                                            <i class="ph-fill ph-map-pin text-danger fs-5 mt-1"></i>
                                            <span class="text-muted lh-base" style="font-size: 13px;">${o.receiverAddress}</span>
                                        </div>

                                        <div class="card-footer-action">
                                            <div>
                                                <div class="text-muted fw-bold" style="font-size: 11px; text-transform: uppercase;">Cần thu (COD)</div>
                                                <div class="badge ${o.paymentMethod == 'COD' ? 'bg-success' : 'bg-primary'} mt-1 px-2 py-1">${o.paymentMethod == 'COD' ? 'Tiền mặt' : 'Đã thanh toán'}</div>
                                            </div>
                                            <div class="fw-bold text-danger fs-4 text-end">
                                                <c:choose>
                                                    <c:when test="${o.paymentMethod == 'COD'}"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</c:when>
                                                    <c:otherwise>0 đ</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <div id="no-shipping-msg" class="col-12 text-center py-5 text-muted fs-5" style="display: ${hasShipping ? 'none' : 'block'};">Chưa có đơn đang giao phù hợp.</div>
                    </div>
                </div>

                <!-- 3. ĐÃ GIAO & 4. THẤT BẠI (Bỏ qua filter, hiện tất cả) -->
                <div class="tab-pane fade" id="tab-done">
                    <div class="row g-4">
                        <c:forEach var="o" items="${myOrders}">
                            <c:if test="${o.orderStatus == 'COMPLETED'}">
                                <div class="col-xl-3 col-lg-4 col-md-6">
                                    <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/shipper/order-detail?id=${o.id}'" style="opacity: 0.8; padding: 16px;">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold fs-6 text-muted">#DH${o.id}</span>
                                            <span class="badge bg-success text-white px-2 py-1 rounded">GIAO THÀNH CÔNG</span>
                                        </div>
                                        <div class="fw-bold text-muted mb-2">${o.receiverName}</div>
                                        <div class="text-muted text-truncate mb-3">${o.receiverAddress}</div>
                                        <div class="card-footer-action pt-3 mt-auto">
                                            <span class="text-muted fw-medium"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/></span>
                                            <span class="fw-bold text-muted fs-6"><c:choose><c:when test="${o.paymentMethod == 'COD'}"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</c:when><c:otherwise>0 đ (Đã TT)</c:otherwise></c:choose></span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <div class="tab-pane fade" id="tab-cancel">
                    <div class="row g-4">
                        <c:forEach var="o" items="${myOrders}">
                            <c:if test="${o.orderStatus == 'CANCELLED'}">
                                <div class="col-xl-3 col-lg-4 col-md-6">
                                    <div class="order-card" onclick="window.location.href='${pageContext.request.contextPath}/shipper/order-detail?id=${o.id}'" style="opacity: 0.85; padding: 16px;">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold fs-6 text-muted">#DH${o.id}</span>
                                            <span class="badge bg-danger text-white px-2 py-1 rounded">THẤT BẠI / HỦY</span>
                                        </div>
                                        <div class="fw-bold text-dark mb-2">${o.receiverName}</div>
                                        <div class="bg-danger bg-opacity-10 p-2 rounded-3 text-danger mb-3 border border-danger border-opacity-25" style="font-size: 12px; font-weight: 500;">
                                            Lý do: ${not empty o.cancelReason ? o.cancelReason : 'Không xác định'}
                                        </div>
                                        <div class="card-footer-action pt-3 mt-auto">
                                            <span class="text-muted fw-medium"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/></span>
                                            <span class="fw-bold text-muted fs-6"><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> đ</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        applyDeliveryFilter(); // Chạy ngay lập tức khi load trang để mặc định lọc EXPRESS
    });

    function applyDeliveryFilter() {
        const filterVal = document.getElementById('deliveryFilter').value;
        const containers = ['wait-container', 'shipping-container'];

        containers.forEach(containerId => {
            const container = document.getElementById(containerId);
            if (!container) return;

            let visibleCount = 0;
            const items = container.querySelectorAll('.order-wrapper');

            items.forEach(item => {
                const type = item.getAttribute('data-type');
                if (filterVal === 'ALL' || type === filterVal) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            const msgDiv = document.getElementById('no-' + containerId.split('-')[0] + '-msg');
            if (msgDiv) msgDiv.style.display = visibleCount === 0 ? 'block' : 'none';
        });
    }
</script>
</body>
</html>