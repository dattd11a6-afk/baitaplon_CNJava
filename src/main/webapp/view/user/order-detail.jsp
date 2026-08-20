<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #DH${order.id} | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">
    <nav class="navbar border-bottom bg-white py-3 sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand text-success brand-font" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <a href="${pageContext.request.contextPath}/orders" class="text-dark text-decoration-none fw-medium" style="font-size: 14px;"><i class="fa-solid fa-arrow-left-long me-2"></i> Quay lại danh sách</a>
        </div>
    </nav>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="brand-font mb-1">Chi tiết đơn hàng <span class="text-success">#DH${order.id}</span></h2>
                <p class="text-muted mb-0" style="font-size: 14px;">Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
            </div>
            <div>
                <c:choose>
                    <c:when test="${order.orderStatus == 'PENDING'}"><span class="badge bg-warning text-dark px-3 py-2 rounded-pill fs-6">Đang chờ xử lý</span></c:when>
                    <c:when test="${order.orderStatus == 'COMPLETED'}"><span class="badge bg-success text-white px-3 py-2 rounded-pill fs-6">Giao thành công</span></c:when>
                    <c:otherwise><span class="badge bg-secondary text-white px-3 py-2 rounded-pill fs-6">${order.orderStatus}</span></c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row g-4">
            <!-- THÔNG TIN NHẬN HÀNG -->
            <div class="col-lg-4">
                <div class="bg-white rounded-4 border border-light p-4 shadow-sm h-100">
                    <h5 class="brand-font mb-4">Thông tin giao hàng</h5>
                    <div class="mb-3 text-muted" style="font-size: 14px;">
                        <div class="fw-semibold text-dark mb-1"><i class="fa-regular fa-user me-2"></i>${order.receiverName}</div>
                        <div class="mb-1"><i class="fa-solid fa-phone me-2"></i>${order.receiverPhone}</div>
                        <div class="mb-3"><i class="fa-solid fa-location-dot me-2"></i>${order.receiverAddress}</div>

                        <div class="pt-3 border-top">
                            <span class="d-block mb-1">Hình thức thanh toán:</span>
                            <strong class="text-dark">${order.paymentMethod == 'COD' ? 'Thanh toán tiền mặt (COD)' : 'Chuyển khoản ngân hàng'}</strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- DANH SÁCH SẢN PHẨM -->
            <div class="col-lg-8">
                <div class="bg-white rounded-4 border border-light p-4 shadow-sm">
                    <h5 class="brand-font mb-4">Sản phẩm đã mua</h5>

                    <div class="table-responsive border-bottom pb-3 mb-3">
                        <table class="table align-middle text-nowrap mb-0">
                            <thead class="text-muted" style="font-size: 13px;">
                                <tr>
                                    <th>SẢN PHẨM</th>
                                    <th>ĐƠN GIÁ</th>
                                    <th class="text-center">SỐ LƯỢNG</th>
                                    <th class="text-end">THÀNH TIỀN</th>
                                </tr>
                            </thead>
                            <tbody style="border-top: 1px solid var(--border-light);">
                                <c:forEach var="item" items="${details}">
                                    <tr>
                                        <td class="fw-medium text-dark">${item.productName}</td>
                                        <td class="text-muted"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        <td class="text-center fw-medium">x${item.quantity}</td>
                                        <td class="fw-bold text-end"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-2">
                        <span class="fw-bold fs-5">TỔNG CỘNG</span>
                        <span class="fw-bold text-success fs-3"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>