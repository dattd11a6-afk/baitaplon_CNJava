<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tổng quan | Shipper Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --ship-primary: #F59E0B; --ship-primary-hover: #D97706; --ship-sidebar: #111827; --ship-bg: #F9FAFB; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E2E8F0; }
        body { background-color: var(--ship-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        .sidebar { width: 250px; background-color: var(--ship-sidebar); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--ship-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff;}
        .sidebar-menu { list-style: none; padding: 0; margin: 24px 0 0 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 24px; color: #A1A1AA; text-decoration: none; font-weight: 500; font-size: 14px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: var(--ship-primary); background-color: rgba(245, 158, 11, 0.1); border-left-color: var(--ship-primary); font-weight: 600; }

        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }
        .ship-header { height: 72px; background: #fff; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .page-body { padding: 32px; flex-grow: 1; }

        .op-card { background: #fff; border: 1px solid var(--border-color); border-radius: 16px; padding: 24px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); height: 100%; display: flex; flex-direction: column;}
        .kpi-card { text-align: center; padding: 24px; border-radius: 16px; border: 1px solid var(--border-color); background: #fff; transition: 0.2s; }
        .kpi-card:hover { transform: translateY(-4px); box-shadow: 0 8px 16px rgba(0,0,0,0.04); border-color: var(--ship-primary);}
        .kpi-num { font-size: 32px; font-weight: 700; font-family: 'DM Sans', sans-serif; line-height: 1; margin-bottom: 8px;}
        .kpi-label { font-size: 12px; font-weight: 600; color: var(--text-muted); text-transform: uppercase;}

        .user-chip { display: flex; align-items: center; gap: 12px; background: #F3F4F6; padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #E5E7EB; }
        .user-avatar { width: 32px; height: 32px; background: var(--ship-primary); color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        .filter-wrapper { background: #fff; border: 1px solid var(--border-color); border-radius: 50px; padding: 6px 16px; display: flex; align-items: center; gap: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);}
        .filter-wrapper select { border: none; outline: none; font-size: 13px; font-weight: 600; color: #1F2937; cursor: pointer; background: transparent;}

        .order-card-compact { background: #fff; border-radius: 12px; border: 1px solid var(--border-color); padding: 20px; transition: 0.2s; height: 100%; display: flex; flex-direction: column;}
        .order-card-compact:hover { border-color: var(--ship-primary); box-shadow: 0 4px 12px rgba(0,0,0,0.05); transform: translateY(-2px);}
        .card-footer-action { margin-top: auto; padding-top: 16px; border-top: 1px dashed var(--border-color); display: flex; justify-content: space-between; align-items: center;}

        .ring-animation { animation: ring 1.5s infinite; }
        @keyframes ring { 0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7); } 70% { transform: scale(1.02); box-shadow: 0 0 0 15px rgba(245, 158, 11, 0); } 100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); } }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #D4D4D8; border-radius: 10px; }
        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; }
    </style>
</head>
<body>

<audio id="orderRingtone" loop preload="auto"><source src="https://assets.mixkit.co/active_storage/sfx/1355/1355-preview.mp3" type="audio/mpeg"></audio>

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
            <li class="active"><a href="${pageContext.request.contextPath}/shipper/home"><i class="ph-fill ph-house"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/shipper/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng của tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/shipper/profile"><i class="ph-fill ph-user-circle"></i> Tài khoản cá nhân</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="ship-header">
            <div class="header-date">
                <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill fs-6">
                    <i class="ph-fill ph-check-circle me-1"></i> Đang hoạt động
                </span>
            </div>
            <div class="dropdown">
                <div class="user-chip dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="user-avatar">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                    <div class="user-info d-flex flex-column text-start">
                        <span class="fw-bold" style="font-size: 13px; line-height: 1;">${sessionScope.user.fullName}</span>
                        <span class="text-muted" style="font-size: 11px;">Tài xế giao hàng</span>
                    </div>
                </div>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/shipper/profile">Hồ sơ cá nhân</a></li>
                    <li><a class="dropdown-item py-2 text-danger fw-bold" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="page-body">
            <h3 class="fw-bold brand-font mb-4 text-dark">Thống kê ca làm việc</h3>
            <div class="row g-4 mb-5">
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-num text-info">${countPreparing}</div><div class="kpi-label">Đơn chờ lấy</div></div></div>
                <div class="col-md-3"><div class="kpi-card" style="border-color: var(--ship-primary); background: #FFFBEB;"><div class="kpi-num" style="color: var(--ship-primary);">${countShipping}</div><div class="kpi-label" style="color: #92400E;">Đơn đang giao</div></div></div>
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-num text-success">${countCompleted}</div><div class="kpi-label">Giao thành công</div></div></div>
                <div class="col-md-3"><div class="kpi-card"><div class="kpi-num text-danger">${countFailed}</div><div class="kpi-label">Thất bại / Đã hủy</div></div></div>
            </div>

            <!-- LAYOUT LƯỚI SONG SONG: ĐANG VẬN CHUYỂN & LỘ TRÌNH -->
            <div class="row g-4">
                <div class="col-xl-4 col-lg-5">
                    <h4 class="fw-bold brand-font mb-3 text-dark">Đang vận chuyển</h4>
                    <c:choose>
                        <c:when test="${not empty currentDelivery}">
                            <div class="op-card" style="border-left: 6px solid var(--ship-primary);">
                                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                                    <span class="fw-bold fs-4 text-dark">#DH${currentDelivery.id}</span>
                                    <span class="badge text-dark rounded-pill px-3 py-2 fs-6 shadow-sm" style="background: var(--ship-primary);">ĐANG GIAO</span>
                                </div>
                                <div class="fw-bold text-dark fs-5 mb-2"><i class="ph-fill ph-user-circle me-2 text-muted"></i> ${currentDelivery.receiverName}</div>
                                <div class="text-muted mb-2" style="font-size: 14px;"><i class="ph-fill ph-map-pin me-2 text-danger"></i> ${currentDelivery.receiverAddress}</div>
                                <div class="text-muted mb-4" style="font-size: 14px;"><i class="ph-fill ph-phone me-2 text-primary"></i> ${currentDelivery.receiverPhone}</div>

                                <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded-3 mb-4 border">
                                    <span class="fw-bold text-muted text-uppercase" style="font-size: 11px;">Cần thu (COD)</span>
                                    <span class="fw-bold text-danger fs-3 brand-font">
                                        <c:choose>
                                            <c:when test="${currentDelivery.paymentMethod == 'COD'}"><fmt:formatNumber value="${currentDelivery.totalAmount}" pattern="#,##0"/> đ</c:when>
                                            <c:otherwise>0 đ</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <a href="${pageContext.request.contextPath}/shipper/order-detail?id=${currentDelivery.id}" class="btn w-100 fw-bold py-3 text-dark fs-6 shadow-sm" style="background: var(--ship-primary); border-radius: 12px;">Xem chi tiết & Bản đồ</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="op-card text-center py-5 d-flex flex-column justify-content-center align-items-center h-100" style="min-height: 300px;">
                                <i class="ph-light ph-check-circle text-success mb-3" style="font-size: 56px;"></i>
                                <h6 class="fw-bold text-dark">Thảnh thơi quá!</h6>
                                <div class="text-muted" style="font-size: 13px;">Hiện không có đơn hàng nào đang trong quá trình vận chuyển.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-xl-8 col-lg-7">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="fw-bold brand-font m-0 text-dark">Lộ trình hôm nay</h4>
                        <div class="filter-wrapper">
                            <i class="ph-bold ph-funnel text-muted"></i>
                            <select id="deliveryFilter" onchange="applyDeliveryFilter()">
                                <option value="ALL" selected>Tất cả lộ trình</option>
                                <option value="EXPRESS">Giao Hỏa tốc 2H (Ưu tiên)</option>
                                <option value="STANDARD">Giao Tiêu chuẩn</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3" id="task-container">
                        <c:set var="hasTasks" value="false" />
                        <c:forEach var="o" items="${myOrders}">
                            <!-- ĐIỀU KIỆN CHÍNH GỐC TIẾNG ANH ĐỂ SO SÁNH VỚI DATABASE -->
                            <c:if test="${o.orderStatus == 'PREPARING' || o.orderStatus == 'SHIPPING'}">
                                <c:set var="hasTasks" value="true" />
                                <c:set var="isExpress" value="${o.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(o.note), 'HỎA TỐC')}" />

                                <div class="col-xl-6 col-md-12 order-wrapper" data-type="${isExpress ? 'EXPRESS' : 'STANDARD'}">
                                    <div class="order-card-compact" onclick="window.location.href='${pageContext.request.contextPath}/shipper/order-detail?id=${o.id}'" style="cursor:pointer;">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <span class="fw-bold fs-5 text-dark">#DH${o.id}</span>
                                            <!-- BỘ CHUYỂN ĐỔI NGÔN NGỮ HIỂN THỊ -->
                                            <c:choose>
                                                <c:when test="${o.orderStatus == 'PREPARING'}"><span class="badge bg-warning text-dark px-2 py-1 rounded">CHỜ LẤY HÀNG</span></c:when>
                                                <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge text-dark px-2 py-1 rounded" style="background: var(--ship-primary);">ĐANG GIAO</span></c:when>
                                            </c:choose>
                                        </div>
                                        <div class="mb-4">
                                            <c:if test="${isExpress}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-2 py-1"><i class="ph-bold ph-lightning"></i> GIAO HỎA TỐC 2H</span></c:if>
                                            <c:if test="${!isExpress}"><span class="badge bg-light text-dark border px-2 py-1"><i class="ph-bold ph-truck"></i> TIÊU CHUẨN</span></c:if>
                                        </div>

                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="ph-fill ph-user-circle text-muted fs-5"></i>
                                            <span class="fw-bold text-dark fs-6">${o.receiverName}</span>
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
                        <div id="no-task-msg" class="col-12 text-center py-5 text-muted fs-5" style="display: ${hasTasks ? 'none' : 'block'};">Hiện chưa có đơn hàng nào chờ xử lý.</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- ========================================== -->
<!-- MODAL POPUP YÊU CẦU NHẬN ĐƠN MỚI -->
<!-- ========================================== -->
<c:if test="${not empty pendingOrder}">
    <c:set var="calcSubtotal" value="0" />
    <c:forEach var="item" items="${pendingDetails}">
        <c:set var="calcSubtotal" value="${calcSubtotal + item.subtotal}" />
    </c:forEach>
    <c:set var="safeShip" value="${pendingOrder.shippingFee != null ? pendingOrder.shippingFee : 0}" />
    <c:set var="safeTax" value="${pendingOrder.taxFee != null ? pendingOrder.taxFee : 0}" />
    <c:set var="calcVoucher" value="${calcSubtotal + safeShip + safeTax - pendingOrder.totalAmount}" />
    <c:if test="${calcVoucher < 0}"><c:set var="calcVoucher" value="0" /></c:if>

    <c:set var="isExpress" value="${pendingOrder.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(pendingOrder.note), 'HỎA TỐC')}" />

    <div class="modal fade" id="incomingOrderModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 rounded-4 shadow-lg ring-animation" style="border: 3px solid var(--ship-primary) !important;">
                <div class="modal-header border-bottom d-flex flex-column align-items-center py-4 bg-light rounded-top-4">
                    <div class="rounded-circle d-flex align-items-center justify-content-center mb-2 shadow-sm" style="width: 56px; height: 56px; background: #FEF3C7; color: #D97706;">
                        <i class="ph-fill ph-bell-ringing" style="font-size: 32px;"></i>
                    </div>
                    <h4 class="fw-bold m-0 brand-font text-dark">CÓ ĐƠN HÀNG MỚI!</h4>
                    <span class="badge ${isExpress ? 'bg-danger' : 'bg-dark'} rounded-pill mt-2 px-3 py-2 fs-6 shadow-sm">
                        <i class="ph-bold ${isExpress ? 'ph-lightning' : 'ph-truck'}"></i> ${isExpress ? 'GIAO HỎA TỐC 2H' : 'GIAO TIÊU CHUẨN'}
                    </span>
                </div>

                <div class="modal-body p-0">
                    <div class="p-4 border-bottom">
                        <div class="d-flex justify-content-between mb-2"><span class="text-muted fw-bold">Mã Đơn:</span><span class="fw-bold text-primary fs-5">#DH${pendingOrder.id}</span></div>
                        <div class="d-flex justify-content-between mb-3"><span class="text-muted fw-bold">Dự kiến giao:</span><span class="fw-bold text-success">Càng sớm càng tốt</span></div>

                        <div class="bg-light p-3 rounded-3 border">
                            <div class="fw-bold text-dark fs-6 mb-1"><i class="ph-fill ph-user-circle text-muted me-1"></i> ${pendingOrder.receiverName}</div>
                            <div class="fw-bold text-primary mb-1"><i class="ph-fill ph-phone-call text-muted me-1"></i> ${pendingOrder.receiverPhone}</div>
                            <div class="text-dark lh-base"><i class="ph-fill ph-map-pin text-danger me-1"></i> ${pendingOrder.receiverAddress}</div>
                        </div>
                        <c:if test="${not empty pendingOrder.note}">
                            <div class="alert alert-warning py-2 px-3 mt-3 mb-0 border-warning border-opacity-25" style="font-size: 13px;"><i class="ph-fill ph-info me-1"></i> <span class="fw-bold text-dark">Ghi chú:</span> ${pendingOrder.note}</div>
                        </c:if>
                    </div>

                    <div class="p-4 border-bottom bg-white">
                        <h6 class="fw-bold text-muted mb-3 text-uppercase" style="font-size: 11px; letter-spacing: 1px;">Sản phẩm (${fn:length(pendingDetails)} món)</h6>
                        <div class="custom-scrollbar" style="max-height: 200px; overflow-y: auto;">
                            <c:forEach var="item" items="${pendingDetails}">
                                <div class="d-flex align-items-center mb-3 pb-3 border-bottom border-light">
                                    <div class="flex-shrink-0 me-3"><img src="${not empty item.productImage ? item.productImage : 'https://placehold.co/100x100?text=SP'}" class="rounded border" style="width: 56px; height: 56px; object-fit: cover;"></div>
                                    <div class="flex-grow-1 min-w-0">
                                        <div class="fw-bold text-dark text-truncate fs-6">${item.productName}</div>
                                        <div class="text-muted mt-1"><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ</div>
                                    </div>
                                    <div class="text-end ms-2 flex-shrink-0">
                                        <div class="fw-bold text-dark bg-light px-2 py-1 rounded">x ${fn:replace(item.quantity, ".0", "")}</div>
                                        <div class="fw-bold text-success mt-2"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> đ</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="p-4 bg-light">
                        <div class="receipt-row"><span class="text-muted fw-medium">Tạm tính:</span><span class="fw-bold text-dark"><fmt:formatNumber value="${calcSubtotal}" pattern="#,##0"/> đ</span></div>
                        <c:if test="${calcVoucher > 0}"><div class="receipt-row"><span class="text-muted fw-medium">Khuyến mãi:</span><span class="fw-bold text-success">- <fmt:formatNumber value="${calcVoucher}" pattern="#,##0"/> đ</span></div></c:if>
                        <div class="receipt-row"><span class="text-muted fw-medium">Phí ship:</span><span class="fw-bold text-dark">+ <fmt:formatNumber value="${safeShip}" pattern="#,##0"/> đ</span></div>
                        <div class="receipt-row border-bottom pb-3 mb-3"><span class="text-muted fw-medium">Thuế VAT:</span><span class="fw-bold text-dark">+ <fmt:formatNumber value="${safeTax}" pattern="#,##0"/> đ</span></div>

                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <div class="fw-bold text-dark mb-1 text-uppercase" style="font-size: 11px;">CẦN THU (COD)</div>
                                <div class="badge ${pendingOrder.paymentMethod == 'COD' ? 'bg-danger' : 'bg-primary'} px-2 py-1">${pendingOrder.paymentMethod == 'COD' ? 'THU TIỀN MẶT' : 'ĐÃ CHUYỂN KHOẢN'}</div>
                            </div>
                            <div class="fw-bold text-danger brand-font" style="font-size: 28px;">
                                <c:choose><c:when test="${pendingOrder.paymentMethod == 'COD'}"><fmt:formatNumber value="${pendingOrder.totalAmount}" pattern="#,##0"/> đ</c:when><c:otherwise>0 đ</c:otherwise></c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer p-3 bg-white border-top d-flex gap-2">
                    <form action="${pageContext.request.contextPath}/shipper/home" method="POST" class="m-0 flex-grow-1"><input type="hidden" name="action" value="REJECT"><input type="hidden" name="orderId" value="${pendingOrder.id}"><button type="submit" class="btn btn-light w-100 fw-bold py-3 text-danger border shadow-sm" style="border-radius: 8px;">TỪ CHỐI ĐƠN</button></form>
                    <form action="${pageContext.request.contextPath}/shipper/home" method="POST" class="m-0 flex-grow-1"><input type="hidden" name="action" value="ACCEPT"><input type="hidden" name="orderId" value="${pendingOrder.id}"><button type="submit" class="btn w-100 fw-bold py-3 text-dark shadow-sm" style="background: var(--ship-primary); border-radius: 8px;">NHẬN ĐƠN NGAY</button></form>
                </div>
            </div>
        </div>
    </div>
</c:if>

<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow rounded-3" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex w-100 align-items-center justify-content-between p-3">
                <div class="d-flex align-items-center fw-medium"><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div>
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

        <c:if test="${not empty pendingOrder}">
            var incomingModal = new bootstrap.Modal(document.getElementById('incomingOrderModal'));
            incomingModal.show();
            var ringtone = document.getElementById('orderRingtone');
            if (ringtone) ringtone.play().catch(function(e) { console.log("Trình duyệt chặn autoplay."); });
        </c:if>

        applyDeliveryFilter();
    });

    function applyDeliveryFilter() {
        const filterVal = document.getElementById('deliveryFilter').value;
        let visibleCount = 0;
        const items = document.querySelectorAll('.order-wrapper');

        items.forEach(item => {
            const type = item.getAttribute('data-type');
            if (filterVal === 'ALL' || type === filterVal) {
                item.style.display = 'block';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        const msgDiv = document.getElementById('no-task-msg');
        if (msgDiv) msgDiv.style.display = visibleCount === 0 ? 'block' : 'none';
    }
</script>
</body>
</html>