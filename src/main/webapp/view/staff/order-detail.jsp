<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xử lý Đơn #DH${order.id} | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --primary: #0D6EFD;
            --bg-admin: #F4F7F6;
            --surface: #FFFFFF;
            --text-main: #0F172A;
            --text-muted: #475569;
            --border-color: #E2E8F0;
        }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .table-products td { border-bottom: 1px solid #F1F5F9; vertical-align: middle; padding: 16px 8px; }
        .table-products tr:last-child td { border-bottom: none; }
        .img-thumbnail-product { width: 48px; height: 48px; object-fit: cover; border-radius: 8px; border: 1px solid #E2E8F0; }

        /* CSS cho Badge Hạng Khách Hàng */
        .tier-badge { font-size: 11px; padding: 4px 10px; border-radius: 20px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .tier-diamond { background: linear-gradient(135deg, #00c6ff, #0072ff); color: white; }
        .tier-gold { background: linear-gradient(135deg, #F59E0B, #D97706); color: white; }
        .tier-silver { background: linear-gradient(135deg, #94A3B8, #64748B); color: white; }
        .tier-bronze { background: linear-gradient(135deg, #D97706, #92400E); color: white; }
    </style>
</head>
<body>
    <div class="container py-4" style="max-width: 1050px;">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/staff/orders" class="text-decoration-none text-muted fw-medium d-inline-flex align-items-center mb-3">
                <i class="ph-bold ph-arrow-left me-2"></i> Trở về danh sách
            </a>
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="brand-font fw-bold m-0" style="color: #1E293B;">Đơn hàng #DH${order.id}</h2>
                <c:choose>
                    <c:when test="${order.orderStatus == 'PENDING'}"><span class="badge bg-warning text-dark px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-clock me-1"></i> CHỜ XỬ LÝ</span></c:when>
                    <c:when test="${order.orderStatus == 'CONFIRMED'}"><span class="badge bg-info text-white px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-check-circle me-1"></i> ĐÃ XÁC NHẬN</span></c:when>
                    <c:when test="${order.orderStatus == 'PREPARING'}"><span class="badge bg-primary text-white px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-package me-1"></i> ĐANG SOẠN HÀNG</span></c:when>
                    <c:when test="${order.orderStatus == 'SHIPPING'}"><span class="badge bg-primary text-white px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-truck me-1"></i> ĐANG GIAO HÀNG</span></c:when>
                    <c:when test="${order.orderStatus == 'COMPLETED'}"><span class="badge bg-success text-white px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-check-fat me-1"></i> ĐÃ HOÀN THÀNH</span></c:when>
                    <c:when test="${order.orderStatus == 'CANCELLED'}"><span class="badge bg-danger text-white px-3 py-2 fs-6 rounded-pill"><i class="ph-bold ph-x-circle me-1"></i> ĐÃ HỦY</span></c:when>
                    <c:otherwise><span class="badge bg-secondary px-3 py-2 fs-6 rounded-pill">${order.orderStatus}</span></c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-8">
                <div class="op-card mb-4">
                    <h6 class="fw-bold mb-3 text-uppercase text-muted" style="font-size: 13px; letter-spacing: 1px;">Sản phẩm cần soạn</h6>
                    <c:set var="cartTotal" value="0" />
                    <table class="table table-borderless table-products mb-0">
                        <c:forEach var="item" items="${details}">
                            <c:set var="cartTotal" value="${cartTotal + item.subtotal}" />
                            <tr>
                                <td style="width: 60px; padding-left: 0;">
                                    <img src="${pageContext.request.contextPath}/assets/images/products/${item.productImage}" alt="${item.productName}" class="img-thumbnail-product" onerror="this.src='https://placehold.co/100x100/E2E8F0/475569?text=Trái+cây'">
                                </td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">${item.productName}</div>
                                    <div class="text-muted mt-1" style="font-size: 13px;">Đơn giá: <fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ</div>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-light text-dark border px-2 py-1 fs-6">x <fmt:formatNumber value="${item.quantity}" pattern="#.##"/></span>
                                </td>
                                <td class="text-end fw-bold text-dark fs-6" style="padding-right: 0;">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> đ
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>

                <div class="op-card">
                    <h6 class="fw-bold mb-4 text-uppercase text-muted" style="font-size: 13px; letter-spacing: 1px;">Thông tin Giao hàng</h6>
                    <div class="row g-4">
                        <div class="col-sm-6">
                            <label class="text-muted d-block mb-1 fw-medium" style="font-size:12px;">Tên khách hàng</label>
                            <div class="d-flex align-items-center flex-wrap gap-2">
                                <div class="fw-bold text-dark fs-5">${order.receiverName}</div>

                                <!-- HIỂN THỊ HẠNG KHÁCH HÀNG (SẼ TỰ ẨN NẾU BACKEND CHƯA TRUYỀN BIẾN 'customerTier') -->
                                <c:if test="${not empty customerTier}">
                                    <c:choose>
                                        <c:when test="${fn:containsIgnoreCase(customerTier, 'Kim Cương')}">
                                            <span class="tier-badge tier-diamond"><i class="ph-fill ph-sketch-logo"></i> Kim Cương</span>
                                        </c:when>
                                        <c:when test="${fn:containsIgnoreCase(customerTier, 'Vàng')}">
                                            <span class="tier-badge tier-gold"><i class="ph-fill ph-crown"></i> Vàng</span>
                                        </c:when>
                                        <c:when test="${fn:containsIgnoreCase(customerTier, 'Bạc')}">
                                            <span class="tier-badge tier-silver"><i class="ph-fill ph-medal"></i> Bạc</span>
                                        </c:when>
                                        <c:when test="${fn:containsIgnoreCase(customerTier, 'Đồng')}">
                                            <span class="tier-badge tier-bronze"><i class="ph-fill ph-medal"></i> Đồng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary rounded-pill">${customerTier}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label class="text-muted d-block mb-1 fw-medium" style="font-size:12px;">Số điện thoại</label>
                            <div class="fw-bold text-primary fs-5">${order.receiverPhone}</div>
                        </div>
                        <div class="col-12">
                            <label class="text-muted d-block mb-1 fw-medium" style="font-size:12px;">Địa chỉ nhận hàng</label>
                            <div class="text-dark fs-6" style="line-height: 1.5;">${order.receiverAddress}</div>
                        </div>
                        <div class="col-12">
                            <label class="text-muted d-block mb-2 fw-medium" style="font-size:12px;">Ghi chú của khách</label>
                            <div class="p-3 rounded" style="background-color: #FFFBEB; border-left: 4px solid #F59E0B; color: #92400E; font-size: 13px;">
                                ${empty order.note ? '<i>Không có ghi chú</i>' : order.note}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="op-card mb-4" style="background-color: #F8FAFC;">
                    <h6 class="fw-bold mb-4 text-uppercase text-muted" style="font-size: 13px; letter-spacing: 1px;">Thanh toán</h6>
                    <c:set var="shippingFee" value="${order.totalAmount - cartTotal}" />
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tạm tính:</span><span class="fw-semibold text-dark"><fmt:formatNumber value="${cartTotal}" pattern="#,##0"/> đ</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 pb-3 border-bottom border-secondary border-opacity-25">
                        <span class="text-muted">Phí giao hàng:</span><span class="fw-semibold text-dark"><fmt:formatNumber value="${shippingFee > 0 ? shippingFee : 0}" pattern="#,##0"/> đ</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="fw-bold text-dark fs-6">Tổng tiền:</span>
                        <span class="fw-bold text-danger" style="font-size: 22px;"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center pt-2">
                        <span class="text-muted">Phương thức:</span>
                        <span class="badge bg-light text-dark border px-2 py-1 fs-6">${order.paymentMethod == 'COD' ? 'Tiền mặt (COD)' : 'Chuyển khoản (VietQR)'}</span>
                    </div>
                </div>

                <div class="op-card" style="border: 2px solid var(--primary);">
                    <h6 class="fw-bold mb-3 text-uppercase text-primary" style="font-size: 13px; letter-spacing: 1px;">Thao tác Xử lý</h6>
                    <form action="${pageContext.request.contextPath}/staff/order-detail" method="POST">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="currentStatus" value="${order.orderStatus}">
                        <c:choose>
                            <c:when test="${order.orderStatus == 'PENDING'}">
                                <button type="submit" name="action" value="CONFIRMED" class="btn btn-primary w-100 mb-3 py-2 fs-6 fw-bold">Xác nhận đơn hàng</button>
                                <button type="button" class="btn btn-outline-danger w-100 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#cancelModal">Hủy đơn hàng</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'CONFIRMED'}">
                                <button type="submit" name="action" value="PREPARING" class="btn btn-primary w-100 mb-3 py-2 fs-6 fw-bold">Bắt đầu Soạn hàng</button>
                                <button type="button" class="btn btn-outline-danger w-100 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#cancelModal">Hủy đơn hàng</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'PREPARING'}">
                                <button type="submit" name="action" value="SHIPPING" class="btn btn-primary w-100 py-2 fs-6 fw-bold">Sẵn sàng Giao hàng</button>
                            </c:when>
                            <c:when test="${order.orderStatus == 'SHIPPING'}">
                                <button type="submit" name="action" value="COMPLETED" class="btn btn-success w-100 py-2 fs-6 fw-bold">Hoàn thành (Đã giao)</button>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-secondary text-center m-0 fw-medium">Đơn hàng đã kết thúc luồng xử lý.</div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Hủy đơn -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0">
                <div class="modal-header border-bottom pb-3">
                    <h5 class="fw-bold text-danger m-0">Hủy đơn hàng #DH${order.id}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/staff/order-detail" method="POST">
                    <div class="modal-body py-4">
                        <input type="hidden" name="id" value="${order.id}">
                        <input type="hidden" name="currentStatus" value="${order.orderStatus}">
                        <input type="hidden" name="action" value="CANCELLED">
                        <div class="alert alert-danger bg-opacity-10 border-0" style="font-size: 13px;">
                            <i class="ph-bold ph-warning-circle me-2"></i>Khi hủy đơn, số lượng sản phẩm sẽ tự động được <b>Hoàn lại vào kho</b>.
                        </div>
                        <label class="form-label fw-bold text-dark">Lý do hủy đơn <span class="text-danger">*</span></label>
                        <textarea class="form-control" name="reason" rows="3" required placeholder="VD: Khách đổi ý, Hết hàng..."></textarea>
                    </div>
                    <div class="modal-footer border-0 pt-0 pb-4 px-4">
                        <button type="button" class="btn btn-light fw-medium" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-danger fw-bold px-4">Xác nhận Hủy & Hoàn kho</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>