<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">
    <nav class="navbar border-bottom bg-white py-3">
        <div class="container d-flex justify-content-between">
            <a class="navbar-brand text-success brand-font" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <span class="text-muted fw-medium">Thanh toán an toàn</span>
        </div>
    </nav>

    <div class="container py-5">
        <form action="${pageContext.request.contextPath}/checkout" method="POST" class="row g-5">

            <!-- CỘT TRÁI: THÔNG TIN GIAO HÀNG -->
            <div class="col-lg-7">
                <h4 class="brand-font mb-4">Thông tin giao hàng</h4>
                <div class="bg-white p-4 rounded-4 border border-light shadow-sm mb-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" style="font-size: 13px;">Họ và tên người nhận</label>
                            <input type="text" class="form-control" name="receiverName" value="${sessionScope.user.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label" style="font-size: 13px;">Số điện thoại</label>
                            <input type="tel" class="form-control" name="receiverPhone" value="${sessionScope.user.phone}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label" style="font-size: 13px;">Địa chỉ nhận hàng chi tiết</label>
                            <input type="text" class="form-control" name="receiverAddress" value="${sessionScope.user.address}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label" style="font-size: 13px;">Ghi chú (Tùy chọn)</label>
                            <textarea class="form-control" name="note" rows="2" placeholder="Ví dụ: Giao giờ hành chính..."></textarea>
                        </div>
                    </div>
                </div>

                <h4 class="brand-font mb-4">Phương thức thanh toán</h4>
                <div class="bg-white p-4 rounded-4 border border-light shadow-sm">
                    <div class="form-check mb-3 p-3 border rounded-3 border-success bg-success-subtle">
                        <input class="form-check-input ms-1" type="radio" name="paymentMethod" id="cod" value="COD" checked>
                        <label class="form-check-label ms-2 fw-medium" for="cod">Thanh toán tiền mặt khi nhận hàng (COD)</label>
                    </div>
                    <div class="form-check p-3 border rounded-3">
                        <input class="form-check-input ms-1" type="radio" name="paymentMethod" id="qr" value="TRANSFER_QR">
                        <label class="form-check-label ms-2 fw-medium" for="qr">Thanh toán qua mã QR (Chuyển khoản 24/7)</label>
                        <p class="text-muted ms-2 mt-2 mb-0" style="font-size: 13px;">Quét mã QR qua ứng dụng ngân hàng. Nhanh chóng và chính xác.</p>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: TÓM TẮT ĐƠN HÀNG -->
            <div class="col-lg-5">
                <div class="bg-white p-4 rounded-4 border border-light shadow-sm position-sticky" style="top: 30px;">
                    <h5 class="brand-font mb-4">Tóm tắt đơn hàng</h5>
                    <div class="border-bottom pb-3 mb-3" style="max-height: 300px; overflow-y: auto;">
                        <!-- Tính tổng tiền bằng JSTL -->
                        <c:set var="totalCheckout" value="0" />
                        <c:forEach var="item" items="${sessionScope.cart}">
                            <c:set var="totalCheckout" value="${totalCheckout + item.subtotal}" />
                            <div class="d-flex justify-content-between mb-2" style="font-size: 14px;">
                                <span>${item.product.name} <strong>x${item.quantity}</strong></span>
                                <span class="fw-medium"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="d-flex justify-content-between mb-2 text-muted">
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${totalCheckout}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-4 text-muted">
                        <span>Phí giao hàng</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold fs-5">Tổng cộng</span>
                        <span class="fw-bold text-success fs-4"><fmt:formatNumber value="${totalCheckout}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                    <button type="submit" class="btn btn-primary-custom w-100 py-3 fs-6">ĐẶT HÀNG NGAY</button>
                    <a href="${pageContext.request.contextPath}/cart" class="d-block text-center mt-3 text-muted text-decoration-none" style="font-size: 14px;">Quay lại giỏ hàng</a>
                </div>
            </div>
        </form>
    </div>

    <!-- ==================== HỆ THỐNG THÔNG BÁO NỔI (TOAST) ==================== -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
        <!-- Thông báo Thành công -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" style="font-size: 14px; font-weight: 500;">
                        <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <!-- Thông báo Lỗi -->
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" style="font-size: 14px; font-weight: 500;">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>
    </div>

    <!-- CÁC FILE SCRIPT LUÔN PHẢI NẰM TRONG BODY -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl, { delay: 3000 });
            });
            toastList.forEach(toast => toast.show());
        });
    </script>
</body>
</html>