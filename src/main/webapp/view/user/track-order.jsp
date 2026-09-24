<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tra cứu đơn hàng | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { background-color: #F9FAFB; font-family: 'Inter', sans-serif; }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .tracking-box { max-width: 600px; margin: 80px auto; background: #fff; padding: 40px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-control { padding: 12px 16px; border-radius: 8px; }
        .form-control:focus { border-color: #10B981; box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
        .btn-track { background: #10B981; color: white; padding: 12px; border-radius: 8px; font-weight: 600; width: 100%; transition: 0.2s; border: none; }
        .btn-track:hover { background: #059669; }

        /* Timeline Styles */
        .timeline { position: relative; padding-left: 30px; margin-top: 30px; }
        .timeline::before { content: ''; position: absolute; left: 7px; top: 0; bottom: 0; width: 2px; background: #E5E7EB; }
        .timeline-item { position: relative; margin-bottom: 24px; }
        .timeline-item::before { content: ''; position: absolute; left: -30px; top: 4px; width: 16px; height: 16px; border-radius: 50%; background: #10B981; border: 3px solid #fff; box-shadow: 0 0 0 1px #10B981; }
        .timeline-item.pending::before { background: #E5E7EB; box-shadow: 0 0 0 1px #D1D5DB; }
    </style>
</head>
<body>
    <div class="container">
        <div class="tracking-box border">
            <!-- Nút quay lại trang chủ -->
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none text-muted fw-medium d-inline-block mb-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Về trang chủ
            </a>

            <div class="text-center mb-4">
                <h2 class="brand-font fw-bold text-dark"><i class="fa-solid fa-box-open text-success me-2"></i>Tra cứu đơn hàng</h2>
                <p class="text-muted">Nhập mã đơn hàng và số điện thoại để kiểm tra tiến độ</p>
            </div>

            <form action="${pageContext.request.contextPath}/track-order" method="POST">
                <div class="mb-3">
                    <label class="form-label fw-medium text-dark">Mã đơn hàng</label>
                    <input type="text" name="orderId" class="form-control" placeholder="Ví dụ: 1024" required value="${param.orderId}">
                </div>
                <div class="mb-4">
                    <label class="form-label fw-medium text-dark">Số điện thoại đặt hàng</label>
                    <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại của người nhận" required value="${param.phone}">
                </div>
                <button type="submit" class="btn-track">TRA CỨU NGAY</button>
            </form>

            <%-- HIỂN THỊ KẾT QUẢ KHI TÌM THẤY ĐƠN --%>
            <c:if test="${not empty order}">
                <div class="mt-5 pt-4 border-top">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold m-0 text-dark">Mã đơn: #${order.id}</h5>
                        <span class="badge ${order.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-success'} px-3 py-2 rounded-pill">${order.orderStatus}</span>
                    </div>

                    <div class="p-3 bg-light rounded-3 mb-4 text-dark" style="font-size: 14px;">
                        <div><strong>Người nhận:</strong> ${order.receiverName}</div>
                        <div><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                    </div>

                    <h6 class="fw-bold text-dark mb-3">Tiến độ giao hàng</h6>
                    <div class="timeline">
                        <c:forEach var="history" items="${orderHistory}">
                            <div class="timeline-item">
                                <div class="fw-bold text-dark">${history.newStatus}</div>
                                <div class="text-muted" style="font-size: 13px;">
                                    <fmt:formatDate value="${history.createdAt}" pattern="dd/MM/yyyy HH:mm"/> - ${history.reason}
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Mặc định có trạng thái khởi tạo nếu chưa có history -->
                        <c:if test="${empty orderHistory}">
                            <div class="timeline-item">
                                <div class="fw-bold text-dark">Đã tiếp nhận đơn hàng</div>
                                <div class="text-muted" style="font-size: 13px;">
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/> - Hệ thống đang chờ xác nhận.
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <%-- HIỂN THỊ THÔNG BÁO LỖI --%>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger mt-4 text-center border-0 bg-danger bg-opacity-10 text-danger fw-medium">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> ${errorMsg}
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>