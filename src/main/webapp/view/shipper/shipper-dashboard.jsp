<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Tài xế giao hàng | Fruit Farmer</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F3F4F6; color: #1F2937; padding-bottom: 80px; }
        .shipper-header { background: #1F9D55; color: white; padding: 16px; position: sticky; top: 0; z-index: 1000; }
        .nav-tabs-custom { display: flex; background: white; border-bottom: 1px solid #E5E7EB; position: sticky; top: 68px; z-index: 999; }
        .nav-tabs-custom .nav-link { flex: 1; text-align: center; color: #6B7280; font-weight: 600; padding: 12px 0; border: none; border-bottom: 3px solid transparent; text-decoration: none; font-size: 14px; }
        .nav-tabs-custom .nav-link.active { color: #1F9D55; border-bottom-color: #1F9D55; }
        .order-card { background: white; border-radius: 12px; margin: 16px; padding: 16px; border: 1px solid #E5E7EB; }
        .btn-call { background: #E0F2FE; color: #0284C7; font-weight: 600; padding: 10px; border-radius: 8px; width: 100%; display: flex; align-items: center; justify-content: center; text-decoration: none; font-size: 13px; }
        .btn-map { background: #FEF3C7; color: #D97706; font-weight: 600; padding: 10px; border-radius: 8px; width: 100%; display: flex; align-items: center; justify-content: center; text-decoration: none; font-size: 13px; }
        .btn-qr { background: #EEF2FF; color: #4F46E5; font-weight: 600; padding: 10px; border-radius: 8px; width: 100%; border: none; font-size: 13px; }
        .btn-update { background: #1F9D55; color: white; font-weight: 600; padding: 10px; border-radius: 8px; width: 100%; border: none; font-size: 13px; }
    </style>
</head>
<body>

    <header class="shipper-header d-flex justify-content-between align-items-center">
        <div>
            <div class="fw-bold fs-5">Lái xe Fruit Farmer</div>
            <div class="small text-white-50"><i class="ph-fill ph-check-circle text-white me-1"></i> Trực tuyến</div>
        </div>
        <div class="rounded-circle bg-white text-success d-flex align-items-center justify-content-center fw-bold" style="width: 38px; height: 38px;">
            <i class="ph ph-motorcycle fs-5"></i>
        </div>
    </header>

    <div class="nav-tabs-custom">
        <a href="${pageContext.request.contextPath}/shipper?tab=shipping" class="nav-link ${currentTab == 'shipping' ? 'active' : ''}">Đang giao (${fn:length(orders)})</a>
        <a href="${pageContext.request.contextPath}/shipper?tab=completed" class="nav-link ${currentTab == 'completed' ? 'active' : ''}">Lịch sử giao</a>
    </div>

    <div class="orders-container">
        <c:forEach var="order" items="${orders}">
            <div class="order-card shadow-sm">
                <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                    <span class="fw-bold fs-6">Đơn hàng #${order.id}</span>
                    <span class="badge ${order.orderStatus == 'SHIPPING' ? 'bg-warning text-dark' : 'bg-success'}">${order.orderStatus}</span>
                </div>

                <div class="mb-3">
                    <div class="fw-bold text-dark fs-6">${order.receiverName} - <span class="text-primary">${order.receiverPhone}</span></div>
                    <div class="text-muted small mt-1"><i class="ph-fill ph-map-pin text-danger me-1"></i>${order.receiverAddress}</div>
                    <c:if test="${not empty order.note}">
                        <div class="small bg-light p-2 rounded mt-2 border text-muted"><strong>Ghi chú:</strong> ${order.note}</div>
                    </c:if>
                </div>

                <div class="d-flex justify-content-between align-items-center bg-light rounded p-3 mb-3 border">
                    <div>
                        <div class="small text-muted">Phương thức: <strong>${order.paymentMethod}</strong></div>
                        <div class="fw-bold text-success fs-5">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                    </div>
                    <c:if test="${order.paymentStatus != 'PAID'}">
                        <span class="badge bg-danger">Chưa thu tiền</span>
                    </c:if>
                    <c:if test="${order.paymentStatus == 'PAID'}">
                        <span class="badge bg-success">Đã thanh toán</span>
                    </c:if>
                </div>

                <!-- CÁC NÚT ĐIỀU HƯỚNG TIỆN ÍCH -->
                <div class="row g-2 mb-2">
                    <div class="col-6">
                        <a href="tel:${order.receiverPhone}" class="btn-call">
                            <i class="ph-bold ph-phone-call me-1"></i> Gọi khách
                        </a>
                    </div>
                    <div class="col-6">
                        <!-- TÍCH HỢP 1: BẤM LÀ NHẢY SANG GOOGLE MAPS -->
                        <a href="https://www.google.com/maps/dir/?api=1&destination=${fn:escapeXml(order.receiverAddress)}" target="_blank" class="btn-map">
                            <i class="ph-bold ph-navigation-arrow me-1"></i> Chỉ đường
                        </a>
                    </div>
                </div>

                <c:if test="${order.orderStatus == 'SHIPPING'}">
                    <div class="row g-2">
                        <div class="col-6">
                            <!-- TÍCH HỢP 2: BẬT MODAL VIETQR THU TIỀN -->
                            <button type="button" class="btn-qr" onclick="openVietQR('${order.id}', '${order.totalAmount}')">
                                <i class="ph-bold ph-qr-code me-1"></i> Mã VietQR
                            </button>
                        </div>
                        <div class="col-6">
                            <form action="${pageContext.request.contextPath}/shipper/update" method="POST" onsubmit="return confirm('Xác nhận đã giao thành công và thu đủ tiền?');">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <input type="hidden" name="status" value="COMPLETED">
                                <button type="submit" class="btn-update">
                                    <i class="ph-bold ph-check me-1"></i> Đã giao
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:forEach>

        <c:if test="${empty orders}">
            <div class="text-center py-5 text-muted">
                <i class="ph ph-package fs-1 d-block mb-2"></i>
                Hiện không có đơn hàng nào trong mục này.
            </div>
        </c:if>
    </div>

    <!-- MODAL HIỂN THỊ MÃ VIETQR -->
    <div class="modal fade" id="vietQrModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center p-3 rounded-4 border-0 shadow">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold m-0" id="qrModalTitle">Quét mã thanh toán</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="qrImageContainer" class="py-2">
                        <div class="spinner-border text-success" role="status"></div>
                    </div>
                    <p class="small text-muted mb-0">Quét bằng bất kỳ ứng dụng Ngân hàng hoặc Ví MoMo/ZaloPay</p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openVietQR(orderId, amount) {
            const modal = new bootstrap.Modal(document.getElementById('vietQrModal'));
            document.getElementById('qrModalTitle').innerText = 'Thu tiền đơn #' + orderId;
            document.getElementById('qrImageContainer').innerHTML = '<div class="spinner-border text-success py-2"></div>';
            modal.show();

            // Gọi API backend VietQRServlet
            fetch('${pageContext.request.contextPath}/api/vietqr?orderId=' + orderId + '&amount=' + amount)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('qrImageContainer').innerHTML =
                        '<img src="' + data.qrUrl + '" class="img-fluid rounded border shadow-sm" style="max-height: 350px;" alt="VietQR">';
                })
                .catch(err => {
                    document.getElementById('qrImageContainer').innerHTML = '<span class="text-danger small">Không thể tạo mã QR vào lúc này.</span>';
                });
        }
    </script>
</body>
</html>