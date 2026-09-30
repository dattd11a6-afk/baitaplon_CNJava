<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Đơn hàng #${order.id} | Admin Workspace</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #EAEAEC; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* === KẾ THỪA SIDEBAR === */
        .sidebar { width: 260px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 14px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li a:hover i { color: var(--primary); transform: scale(1.1); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }

        /* === CSS RIÊNG TRANG CHI TIẾT === */
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); overflow: hidden; margin-bottom: 24px; }
        .card-header-custom { background: #fff; border-bottom: 1px solid var(--border-color); padding: 16px 20px; font-weight: 700; color: #0F172A; display: flex; align-items: center; gap: 8px; }

        /* Timeline UI */
        .timeline { border-left: 2px solid #E2E8F0; margin: 10px 0 10px 15px; padding-left: 20px; list-style: none; }
        .timeline li { position: relative; margin-bottom: 20px; }
        .timeline li:last-child { margin-bottom: 0; }
        .timeline li::before { content: ''; position: absolute; left: -27px; top: 0; width: 12px; height: 12px; border-radius: 50%; background: var(--surface); border: 2px solid var(--primary); }
        .timeline-date { font-size: 12px; color: var(--text-muted); font-weight: 600; margin-bottom: 4px; }
        .timeline-content { font-size: 13px; color: var(--text-main); }
        .timeline-reason { font-size: 12px; color: #64748B; background: #F8FAFC; padding: 8px; border-radius: 6px; margin-top: 6px; border: 1px solid #E2E8F0; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- === SIDEBAR ĐỒNG BỘ === -->
    <aside class="sidebar">
        <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
            <div class="d-flex align-items-center justify-content-center rounded" style="width: 36px; height: 36px; background: linear-gradient(135deg, var(--primary), #10B981);"><i class="ph-bold ph-leaf text-white fs-5"></i></div>
            <div><div class="fw-bold fs-5 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div><div style="font-size: 10px; color: #10B981; font-weight: 600; letter-spacing: 1px;">ADMIN WORKSPACE</div></div>
        </div>
        <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
            <ul class="sidebar-menu">
                <div class="menu-label mt-2">Phân tích</div>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo kinh doanh</a></li>
                <div class="menu-label">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>
                <div class="menu-label">Kho & Hàng hóa</div>
                <li><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Danh sách Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập kho</a></li>
                <div class="menu-label">Cấu hình & Điều phối</div>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân viên</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/shipper-manage"><i class="ph-fill ph-motorcycle"></i> Trạm điều phối</a></li>
            </ul>
        </div>
        <div class="p-4 border-top" style="border-color: rgba(255,255,255,0.05)!important;">
            <a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center justify-content-center py-2 px-3 text-decoration-none rounded" style="background: rgba(239, 68, 68, 0.1); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.2); transition: 0.2s;"><i class="ph-bold ph-sign-out fs-5 me-2"></i> Đăng xuất</a>
        </div>
    </aside>

    <!-- === MAIN CONTENT === -->
    <main class="flex-grow-1 overflow-auto p-4 px-5" style="height: 100vh;">

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/shipper-manage" class="btn btn-light border text-dark p-2" title="Quay lại"><i class="ph-bold ph-arrow-left"></i></a>
                <div>
                    <h3 class="fw-bold m-0 text-dark brand-font">Đơn hàng #${order.id}</h3>
                    <div class="text-muted mt-1" style="font-size: 13px;">Đặt lúc: <fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div>
                </div>
            </div>
            <div>
                <c:choose>
                    <c:when test="${order.orderStatus == 'PENDING'}"><span class="badge bg-warning text-dark fs-6 px-3 py-2 rounded-3">Chờ xác nhận</span></c:when>
                    <c:when test="${order.orderStatus == 'PROCESSING'}"><span class="badge bg-info text-dark fs-6 px-3 py-2 rounded-3">Đang đóng gói</span></c:when>
                    <c:when test="${order.orderStatus == 'READY'}"><span class="badge bg-primary fs-6 px-3 py-2 rounded-3">Chờ lấy hàng</span></c:when>
                    <c:when test="${order.orderStatus == 'SHIPPING'}"><span class="badge fs-6 px-3 py-2 rounded-3" style="background-color: #8b5cf6;">Đang giao</span></c:when>
                    <c:when test="${order.orderStatus == 'COMPLETED'}"><span class="badge bg-success fs-6 px-3 py-2 rounded-3">Hoàn thành</span></c:when>
                    <c:when test="${order.orderStatus == 'CANCELLED'}"><span class="badge bg-danger fs-6 px-3 py-2 rounded-3">Đã hủy</span></c:when>
                </c:choose>
            </div>
        </div>

        <div class="row g-4">
            <!-- === CỘT TRÁI: THÔNG TIN KHÁCH & SẢN PHẨM === -->
            <div class="col-lg-8">
                <!-- Thông tin giao hàng -->
                <div class="admin-card">
                    <div class="card-header-custom"><i class="ph-fill ph-map-pin text-danger fs-5"></i> Thông tin giao hàng</div>
                    <div class="p-4 row g-3">
                        <div class="col-md-6">
                            <div class="text-muted small fw-semibold text-uppercase mb-1">Khách hàng</div>
                            <div class="fw-bold text-dark fs-6">${order.receiverName}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small fw-semibold text-uppercase mb-1">Số điện thoại</div>
                            <div class="fw-medium text-dark">${order.receiverPhone}</div>
                        </div>
                        <div class="col-12">
                            <div class="text-muted small fw-semibold text-uppercase mb-1">Địa chỉ giao</div>
                            <div class="text-dark">${order.receiverAddress}</div>
                        </div>
                        <c:if test="${not empty order.note}">
                            <div class="col-12">
                                <div class="p-3 bg-warning bg-opacity-10 border border-warning border-opacity-25 rounded-3 text-dark">
                                    <i class="ph-fill ph-chat-circle-text text-warning me-1"></i> <strong>Ghi chú:</strong> ${order.note}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Danh sách sản phẩm -->
                <div class="admin-card">
                    <div class="card-header-custom"><i class="ph-fill ph-package text-success fs-5"></i> Sản phẩm trong đơn</div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0 border-0">
                            <thead class="table-light text-muted" style="font-size: 12px; text-transform: uppercase;">
                                <tr><th class="ps-4">Sản phẩm</th><th>Đơn giá</th><th class="text-center">SL</th><th class="pe-4 text-end">Thành tiền</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${details}">
                                    <tr>
                                        <td class="ps-4 fw-medium text-dark">${item.productName}</td>
                                        <td class="text-muted"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center fw-bold">x${item.quantity}</td>
                                        <td class="pe-4 text-end fw-bold text-dark"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="p-4 bg-light border-top d-flex justify-content-between align-items-center">
                        <div class="text-muted fw-medium">Thanh toán: <strong class="text-dark">${order.paymentMethod}</strong></div>
                        <div class="fs-5 text-dark">Tổng cộng: <span class="fw-bold text-danger fs-4 ms-2"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span></div>
                    </div>
                </div>
            </div>

            <!-- === CỘT PHẢI: ĐIỀU PHỐI & TIMELINE === -->
            <div class="col-lg-4">

                <!-- BỘ NÚT ĐIỀU PHỐI DÀNH CHO STAFF MÀ TUI ĐÃ CODE CHO BÁC Ở BƯỚC TRƯỚC -->
                <div class="admin-card border-primary border-opacity-25" style="background: #F8FAFC;">
                    <div class="card-header-custom bg-transparent"><i class="ph-fill ph-sliders text-primary fs-5"></i> Bảng Điều Phối (Staff)</div>
                    <div class="p-4 text-center">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'PENDING'}">
                                <div class="text-dark fw-medium mb-3 text-start" style="font-size: 13px;">Đơn hàng mới. Hãy gọi khách chốt đơn và bắt đầu đóng gói!</div>
                                <form action="${pageContext.request.contextPath}/admin/order/update-status" method="POST">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <input type="hidden" name="action" value="CONFIRM">
                                    <button type="submit" class="btn btn-warning fw-bold w-100 py-2 text-dark shadow-sm"><i class="ph-bold ph-package me-1"></i> Xác nhận & Đóng gói</button>
                                </form>
                            </c:when>

                            <c:when test="${order.orderStatus == 'PROCESSING'}">
                                <div class="text-dark fw-medium mb-3 text-start" style="font-size: 13px;">Đang đóng gói. Bấm nút dưới đây để tìm Shipper.</div>
                                <form action="${pageContext.request.contextPath}/admin/order/update-status" method="POST">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <input type="hidden" name="action" value="CALL_SHIPPER">
                                    <button type="submit" class="btn btn-primary fw-bold w-100 py-2 shadow-sm"><i class="ph-bold ph-broadcast me-1"></i> Đóng gói xong - Gọi Shipper</button>
                                </form>
                            </c:when>

                            <c:when test="${order.orderStatus == 'READY'}">
                                <div class="alert alert-primary bg-primary bg-opacity-10 border-0 text-primary fw-medium m-0">
                                    <i class="spinner-border spinner-border-sm me-2"></i> Đang chờ Shipper nhận đơn...
                                </div>
                            </c:when>

                            <c:when test="${order.orderStatus == 'SHIPPING'}">
                                <div class="alert alert-info bg-info bg-opacity-10 border-0 text-info-emphasis fw-medium m-0">
                                    <i class="ph-fill ph-motorcycle fs-5 align-middle me-2"></i> Shipper đang giao hàng.
                                </div>
                            </c:when>

                            <c:when test="${order.orderStatus == 'COMPLETED'}">
                                <div class="alert alert-success bg-success bg-opacity-10 border-0 text-success fw-bold m-0"><i class="ph-bold ph-check-circle me-1"></i> Giao dịch thành công!</div>
                            </c:when>

                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                <div class="alert alert-danger bg-danger bg-opacity-10 border-0 text-danger fw-bold mb-2"><i class="ph-bold ph-x-circle me-1"></i> Đơn hàng bị hủy</div>
                                <div class="text-muted text-start" style="font-size: 12px;">Lý do: ${order.cancelReason}</div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>

                <!-- TIMELINE LỊCH SỬ -->
                <div class="admin-card">
                    <div class="card-header-custom"><i class="ph-fill ph-clock-counter-clockwise text-info fs-5"></i> Lịch sử tiến độ</div>
                    <div class="p-4 pt-3">
                        <ul class="timeline m-0">
                            <!-- Nốt Tạo đơn mặc định -->
                            <li>
                                <div class="timeline-date"><fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div>
                                <div class="timeline-content fw-bold text-dark">Khách hàng đặt đơn</div>
                            </li>

                            <!-- Vòng lặp các nốt trạng thái -->
                            <c:forEach var="history" items="${historyList}">
                                <li>
                                    <div class="timeline-date"><fmt:formatDate value="${history.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div>
                                    <div class="timeline-content fw-bold text-dark">
                                        Đổi sang: <span class="text-primary">${history.newStatus}</span>
                                    </div>
                                    <c:if test="${not empty history.reason}">
                                        <div class="timeline-reason">${history.reason}</div>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
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
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center"><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium d-flex align-items-center"><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script> document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show()); }); </script>
</body>
</html>