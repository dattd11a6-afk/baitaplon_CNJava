<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">
    <nav class="navbar border-bottom bg-white py-3 sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand text-success brand-font" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/products" class="text-dark text-decoration-none fw-medium" style="font-size: 15px;">Cửa hàng</a>
                <span class="text-muted border-start ps-3" style="font-size: 15px;">Chào, ${sessionScope.user.fullName}</span>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <h2 class="brand-font mb-4">Lịch sử đơn hàng</h2>

        <div class="bg-white rounded-4 border border-light p-4 shadow-sm">
            <c:choose>
                <c:when test="${empty orders}">
                    <div class="text-center py-5">
                        <i class="fa-solid fa-box-open text-muted mb-3" style="font-size: 40px; opacity: 0.3;"></i>
                        <p class="text-muted">Bạn chưa có đơn hàng nào.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom mt-2">Bắt đầu mua sắm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle text-nowrap mb-0">
                            <thead class="text-muted" style="font-size: 13px;">
                                <tr>
                                    <th>MÃ ĐƠN</th>
                                    <th>NGÀY ĐẶT</th>
                                    <th>TỔNG TIỀN</th>
                                    <th>THANH TOÁN</th>
                                    <th>TRẠNG THÁI</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody style="border-top: 1px solid var(--border-light);">
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td class="fw-semibold text-dark">#DH${o.id}</td>
                                        <td class="text-muted"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="fw-bold text-success"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td>
                                            <span class="badge ${o.paymentMethod == 'COD' ? 'bg-secondary' : 'bg-info'} text-white rounded-pill fw-medium px-2 py-1" style="font-size: 11px;">
                                                ${o.paymentMethod == 'COD' ? 'Tiền mặt' : 'Chuyển khoản'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.orderStatus == 'PENDING'}"><span class="badge bg-warning text-dark px-2 py-1 rounded-pill">Đang chờ xử lý</span></c:when>
                                                <c:when test="${o.orderStatus == 'CONFIRMED'}"><span class="badge bg-info text-white px-2 py-1 rounded-pill">Đã xác nhận</span></c:when>
                                                <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge bg-primary text-white px-2 py-1 rounded-pill">Đang giao hàng</span></c:when>
                                                <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="badge bg-success text-white px-2 py-1 rounded-pill">Đã nhận hàng</span></c:when>
                                                <c:when test="${o.orderStatus == 'CANCELLED'}"><span class="badge bg-danger text-white px-2 py-1 rounded-pill">Đã hủy</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/order-detail?id=${o.id}" class="btn btn-outline-dark btn-sm rounded-pill fw-medium" style="font-size: 12px;">Xem chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>