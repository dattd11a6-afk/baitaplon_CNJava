<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Xử lý Đơn #DH${order.id} | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>:root { --primary: #2F6B3F; --bg-admin: #F5F7F5; --surface: #FFFFFF; --text-main: #17231A; --border-color: #E5E9E3;} body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; } .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; } .brand-font { font-family: 'DM Sans', sans-serif; }</style>
</head>
<body>
    <div class="container py-4" style="max-width: 1000px;">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/staff/orders" class="text-decoration-none text-muted fw-medium d-inline-flex align-items-center mb-2"><i class="ph ph-arrow-left me-1"></i> Trở về danh sách</a>
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="brand-font fw-bold m-0">Đơn hàng #DH${order.id}</h2>
                <span class="badge bg-primary fs-6">${order.orderStatus}</span>
            </div>
        </div>

        <div class="row g-4">
            <!-- CỘT TRÁI: Sản phẩm & Khách hàng -->
            <div class="col-md-8">
                <div class="op-card mb-4">
                    <h6 class="fw-bold mb-3 text-uppercase text-muted" style="font-size: 12px; letter-spacing: 1px;">Sản phẩm cần soạn</h6>
                    <table class="table mb-0 align-middle">
                        <c:forEach var="item" items="${details}">
                            <tr>
                                <td class="fw-semibold">${item.productName}</td>
                                <td class="text-muted"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td class="fw-bold text-primary">x${item.quantity}</td>
                                <td class="text-end fw-bold"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>

                <div class="op-card">
                    <h6 class="fw-bold mb-3 text-uppercase text-muted" style="font-size: 12px; letter-spacing: 1px;">Thông tin Giao hàng</h6>
                    <div class="row g-3">
                        <div class="col-sm-6"><label class="text-muted d-block mb-1" style="font-size:12px;">Khách hàng</label><div class="fw-semibold">${order.receiverName}</div></div>
                        <div class="col-sm-6"><label class="text-muted d-block mb-1" style="font-size:12px;">Số điện thoại</label><div class="fw-semibold">${order.receiverPhone}</div></div>
                        <div class="col-12"><label class="text-muted d-block mb-1" style="font-size:12px;">Địa chỉ</label><div>${order.receiverAddress}</div></div>
                        <div class="col-12"><label class="text-muted d-block mb-1" style="font-size:12px;">Ghi chú</label><div class="fst-italic border-start border-3 border-warning ps-2">${empty order.note ? 'Không có' : order.note}</div></div>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: Bảng điều khiển Trạng thái (Nghiệp vụ) -->
            <div class="col-md-4">
                <div class="op-card mb-4 bg-light">
                    <h6 class="fw-bold mb-3 text-uppercase text-muted" style="font-size: 12px; letter-spacing: 1px;">Thanh toán</h6>
                    <div class="d-flex justify-content-between mb-2"><span>Tổng tiền:</span><span class="fw-bold fs-5 text-success"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span></div>
                    <div class="d-flex justify-content-between"><span>Phương thức:</span><span class="fw-semibold">${order.paymentMethod == 'COD' ? 'Tiền mặt' : 'Chuyển khoản'}</span></div>
                </div>

                <div class="op-card border-primary">
                    <h6 class="fw-bold mb-3 text-uppercase text-primary" style="font-size: 12px; letter-spacing: 1px;">Thao tác Xử lý</h6>
                    <form action="${pageContext.request.contextPath}/staff/order-detail" method="POST">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="currentStatus" value="${order.orderStatus}">

                        <!-- Hiển thị nút Action dựa theo luồng PENDING -> CONFIRMED -> PREPARING -> SHIPPING -> COMPLETED -->
                        <c:choose>
                            <c:when test="${order.orderStatus == 'PENDING'}">
                                <button type="submit" name="action" value="CONFIRMED" class="btn btn-primary w-100 mb-2 py-2 fw-bold">Xác nhận đơn hàng</button>
                                <button type="button" class="btn btn-outline-danger w-100 py-2" data-bs-toggle="modal" data-bs-target="#cancelModal">Hủy đơn</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'CONFIRMED'}">
                                <button type="submit" name="action" value="PREPARING" class="btn btn-info text-white w-100 mb-2 py-2 fw-bold">Bắt đầu Soạn hàng</button>
                                <button type="button" class="btn btn-outline-danger w-100 py-2" data-bs-toggle="modal" data-bs-target="#cancelModal">Hủy đơn</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'PREPARING'}">
                                <button type="submit" name="action" value="SHIPPING" class="btn btn-warning text-dark w-100 py-2 fw-bold">Sẵn sàng Giao hàng</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'SHIPPING'}">
                                <button type="submit" name="action" value="COMPLETED" class="btn btn-success w-100 py-2 fw-bold">Hoàn thành (Đã giao)</button>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-secondary text-center m-0">Đơn hàng đã kết thúc luồng xử lý.</div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Hủy đơn có nhập lý do -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0">
                <div class="modal-header border-0 pb-0"><h5 class="fw-bold text-danger">Hủy đơn hàng #DH${order.id}</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <form action="${pageContext.request.contextPath}/staff/order-detail" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="currentStatus" value="${order.orderStatus}">
                        <input type="hidden" name="action" value="CANCELLED">
                        <div class="alert alert-warning" style="font-size: 13px;"><i class="ph-fill ph-warning me-2"></i>Khi hủy đơn, số lượng sản phẩm sẽ tự động được <b>Hoàn lại vào kho</b>.</div>
                        <label class="form-label fw-medium">Lý do hủy đơn <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="reason" rows="3" required placeholder="VD: Khách đổi ý, Hết hàng..."></textarea>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="submit" class="btn btn-danger w-100">Xác nhận Hủy & Hoàn kho</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>