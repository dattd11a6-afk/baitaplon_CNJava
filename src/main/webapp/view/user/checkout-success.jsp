<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        body { background-color: #F4F7F1; font-family: 'Inter', sans-serif; }
        .success-card { background: #fff; border-radius: 16px; padding: 40px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); max-width: 600px; margin: 60px auto; text-align: center; border: 1px solid #EAEAEC; }
        .check-circle { width: 80px; height: 80px; background: #DCFCE7; color: #16A34A; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px; }
        .qr-box { background: #F8FAFC; border: 2px dashed #CBD5E1; border-radius: 12px; padding: 20px; display: inline-block; margin-top: 20px; }
        .btn-custom { padding: 12px 24px; border-radius: 8px; font-weight: 600; font-size: 15px; }
    </style>
</head>
<body>

    <div class="container">
        <div class="success-card">
            <div class="check-circle"><i class="ph-bold ph-check fs-1"></i></div>
            <h2 class="fw-bold text-dark mb-2">Đặt Hàng Thành Công!</h2>
            <p class="text-muted mb-4">Cảm ơn bạn đã mua sắm tại Fruit Farmer. Mã đơn hàng của bạn là <strong class="text-success">#${sessionScope.lastOrderId}</strong></p>

            <div class="bg-light p-3 rounded-3 mb-4 text-start d-flex justify-content-between align-items-center">
                <div>
                    <div class="small text-muted mb-1">Phương thức thanh toán</div>
                    <div class="fw-bold text-dark">${sessionScope.lastPaymentMethod == 'VIETQR' ? 'Chuyển khoản VietQR' : 'Thanh toán khi nhận hàng (COD)'}</div>
                </div>
                <div class="text-end">
                    <div class="small text-muted mb-1">Tổng tiền</div>
                    <div class="fw-bold text-success fs-5"><fmt:formatNumber value="${sessionScope.lastOrderTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                </div>
            </div>

            <!-- KHU VỰC HIỂN THỊ MÃ VIETQR DÀNH RIÊNG CHO PHƯƠNG THỨC CHUYỂN KHOẢN -->
            <c:if test="${sessionScope.lastPaymentMethod == 'VIETQR'}">
                <div class="qr-box w-100 mb-4">
                    <h6 class="fw-bold text-dark mb-3"><i class="ph-bold ph-qr-code text-primary me-2"></i>Quét mã để thanh toán ngay</h6>
                    <div id="qrContainer">
                        <div class="spinner-border text-success my-4" role="status"></div>
                        <div class="small text-muted mt-2">Đang tạo mã QR bảo mật...</div>
                    </div>
                    <div class="small text-muted mt-3 pt-3 border-top"><i class="ph-fill ph-info me-1"></i> Hệ thống sẽ tự động đối soát nội dung chuyển khoản <strong>DH${sessionScope.lastOrderId}</strong>. Vui lòng không sửa nội dung này.</div>
                </div>
            </c:if>

            <div class="d-flex gap-3 justify-content-center mt-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-light border btn-custom text-dark w-50">Về Trang Chủ</a>
                <a href="${pageContext.request.contextPath}/orders/history" class="btn btn-success btn-custom w-50">Xem Đơn Mua</a>
            </div>
        </div>
    </div>

    <!-- SCRIPT GỌI API VIETQR -->
    <c:if test="${sessionScope.lastPaymentMethod == 'VIETQR'}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const orderId = '${sessionScope.lastOrderId}';
                const amount = '${sessionScope.lastOrderTotal}';

                // Gọi tới API VietQRServlet đã xây dựng
                fetch(`${pageContext.request.contextPath}/api/vietqr?orderId=` + orderId + `&amount=` + amount)
                    .then(response => response.json())
                    .then(data => {
                        const qrContainer = document.getElementById('qrContainer');
                        if(data.qrUrl) {
                            qrContainer.innerHTML = `<img src="` + data.qrUrl + `" class="img-fluid rounded shadow-sm" style="max-height: 320px;" alt="VietQR Thanh Toán">`;
                        } else {
                            qrContainer.innerHTML = `<div class="text-danger small fw-medium py-3"><i class="ph-fill ph-warning-circle me-1"></i> Lỗi tạo mã QR. Vui lòng kiểm tra lại.</div>`;
                        }
                    })
                    .catch(error => {
                        document.getElementById('qrContainer').innerHTML = `<div class="text-danger small fw-medium py-3"><i class="ph-fill ph-warning-circle me-1"></i> Lỗi kết nối hệ thống ngân hàng.</div>`;
                        console.error('VietQR API Error:', error);
                    });
            });
        </script>
    </c:if>

    <%-- Xóa session sau khi đã hiển thị để tránh load lại trang bị duplicate --%>
    <%
        session.removeAttribute("lastOrderId");
        session.removeAttribute("lastOrderTotal");
        session.removeAttribute("lastPaymentMethod");
    %>
</body>
</html>