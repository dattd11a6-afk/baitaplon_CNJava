<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">
    <div class="container py-5 text-center" style="max-width: 600px;">
        <div class="bg-white p-5 rounded-4 border border-light shadow-sm mt-5">

            <i class="fa-solid fa-circle-check text-success mb-3" style="font-size: 64px;"></i>
            <h1 class="brand-font mb-3">Đặt hàng thành công!</h1>
            <p class="text-muted mb-4">Cảm ơn bạn đã tin tưởng Fruit Farmer Market. Mã đơn hàng của bạn là <strong>#DH${sessionScope.lastOrder.id}</strong>.</p>

            <!-- NẾU KHÁCH CHỌN CHUYỂN KHOẢN, HIỆN MÃ VIETQR -->
            <c:if test="${sessionScope.lastOrder.paymentMethod == 'TRANSFER_QR'}">
                <div class="bg-main p-4 rounded-4 mb-4 border border-success-subtle mx-auto" style="max-width: 400px;">
                    <h5 class="brand-font text-success mb-3">Quét mã để thanh toán</h5>

                    <!--
                       CẤU TRÚC URL VIETQR:
                       Thay thế "MB" bằng mã ngân hàng của bạn (VD: VCB, TCB, BIDV, ICB...)
                       Thay thế "0123456789" bằng số tài khoản thật của bạn.
                       Tên viết HOA KHÔNG DẤU: DO PHAT DAT
                    -->
                    <img src="${pageContext.request.contextPath}/assets/images/qr-thanh-toan.png"
                         alt="Mã thanh toán VietQR"
                         class="img-fluid rounded border shadow-sm mb-3"
                         style="width: 250px; height: 250px; object-fit: contain; background: #fff;">

                    <div class="text-start text-muted mx-auto" style="font-size: 14px;">
                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom">
                            <span>Chủ tài khoản:</span>
                            <strong class="text-dark">DO PHAT DAT</strong>
                        </div>
                        <div class="d-flex justify-content-between mb-2 pb-2 border-bottom">
                            <span>Số tiền:</span>
                            <strong class="text-success fs-5"><fmt:formatNumber value="${sessionScope.lastOrder.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>Nội dung CK:</span>
                            <strong class="text-dark">DH${sessionScope.lastOrder.id}</strong>
                        </div>
                    </div>
                </div>
            </c:if>

            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-success px-4 me-2">Tiếp tục mua sắm</a>
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary-custom px-4">Xem đơn hàng</a>
        </div>
    </div>
</body>
</html>