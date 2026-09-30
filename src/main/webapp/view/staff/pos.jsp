<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>POS Thu Ngân | Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background: #F5F7F5; height: 100vh; overflow: hidden; }
        .pos-grid { height: calc(100vh - 64px); }
        .product-card { background: #fff; border: 1px solid #E5E9E3; border-radius: 12px; padding: 12px; cursor: pointer; transition: 0.2s; text-align: center; }
        .product-card:hover { border-color: #2F6B3F; box-shadow: 0 4px 12px rgba(47,107,63,0.1); transform: translateY(-2px); }
        .product-img { width: 100%; height: 100px; object-fit: cover; border-radius: 8px; margin-bottom: 12px; }

        .cart-panel { background: #fff; border-left: 1px solid #E5E9E3; height: 100%; display: flex; flex-direction: column; }
        .cart-items { flex-grow: 1; overflow-y: auto; padding: 16px; }
        .cart-item { border-bottom: 1px dashed #E5E9E3; padding-bottom: 12px; margin-bottom: 12px; }

        .checkout-panel { background: #FAFAFA; padding: 20px; border-top: 1px solid #E5E9E3; }
        .btn-checkout { background: #2F6B3F; color: #fff; font-size: 16px; font-weight: 600; padding: 14px; border-radius: 8px; width: 100%; border: none; transition: 0.2s;}
        .btn-checkout:hover:not(:disabled) { background: #245530; }
        .btn-checkout:disabled { background: #9CA3AF; cursor: not-allowed; }
        .pos-header { height: 64px; background: #102C1F; color: #fff; display: flex; align-items: center; padding: 0 24px; justify-content: space-between; }

        /* Style cho Combo Box Voucher */
        .voucher-select { font-size: 13px; font-weight: 500; color: #2F6B3F; border: 1px dashed #2F6B3F; background-color: rgba(47, 107, 63, 0.05); cursor: pointer; }
        .voucher-select:focus { border-color: #2F6B3F; box-shadow: none; }
    </style>
</head>
<body>

<!-- Header POS -->
<header class="pos-header">
    <div class="d-flex align-items-center gap-3">
        <a href="${pageContext.request.contextPath}/staff/dashboard" class="text-white text-decoration-none"><i class="ph ph-arrow-left fs-4"></i></a>
        <div class="fw-bold fs-5" style="font-family: 'DM Sans';">FRUIT POS</div>
    </div>
    <div class="d-flex gap-2">
        <form action="${pageContext.request.contextPath}/staff/pos" method="GET" class="d-flex gap-2">
            <input type="text" name="keyword" class="form-control form-control-sm" placeholder="Tìm tên trái cây..." value="${keyword}" style="width: 250px;">
            <button type="submit" class="btn btn-sm btn-success">Tìm</button>
        </form>
    </div>
</header>

<div class="row g-0 pos-grid">
    <!-- CỘT TRÁI: SẢN PHẨM -->
    <div class="col-lg-8 p-4 overflow-auto">
        <div class="row g-3">
            <c:forEach var="p" items="${products}">
                <div class="col-md-3 col-sm-4">
                    <form action="${pageContext.request.contextPath}/staff/pos" method="POST">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${p.id}">
                        <button type="submit" class="product-card w-100 text-start" ${p.stock == 0 ? 'disabled style="opacity:0.5"' : ''}>
                            <c:choose>
                                <c:when test="${not empty p.image && fn:startsWith(p.image, 'http')}"><img src="${p.image}" class="product-img"></c:when>
                                <c:when test="${not empty p.image}"><img src="${pageContext.request.contextPath}/assets/images/products/${p.image}" class="product-img"></c:when>
                                <c:otherwise><img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200&auto=format&fit=crop" class="product-img"></c:otherwise>
                            </c:choose>
                            <div class="fw-semibold text-truncate mb-1" style="font-size: 13px;">${p.name}</div>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-success fw-bold"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                <div class="text-muted" style="font-size: 11px;">Tồn: ${p.stock}</div>
                            </div>
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- CỘT PHẢI: GIỎ HÀNG & THANH TOÁN -->
    <div class="col-lg-4 cart-panel">
        <div class="p-3 border-bottom d-flex justify-content-between align-items-center">
            <h6 class="fw-bold m-0"><i class="ph ph-shopping-cart me-2"></i>Đơn hàng hiện tại</h6>
            <form action="${pageContext.request.contextPath}/staff/pos" method="POST" class="m-0">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn btn-sm btn-outline-danger" style="font-size: 11px;">Xóa tất cả</button>
            </form>
        </div>

        <!-- DANH SÁCH MÓN HÀNG -->
        <div class="cart-items">
            <c:choose>
                <c:when test="${empty sessionScope.posCart}">
                    <div class="text-center text-muted mt-5 pt-5"><i class="ph ph-basket fs-1 mb-2"></i><p>Chưa có sản phẩm nào</p></div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${sessionScope.posCart}">
                        <div class="cart-item d-flex justify-content-between align-items-center">
                            <div style="max-width: 130px;">
                                <div class="fw-semibold text-truncate" style="font-size: 13px;" title="${item.product.name}">${item.product.name}</div>
                                <div class="text-muted" style="font-size: 12px;"><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <form action="${pageContext.request.contextPath}/staff/pos" method="POST" class="m-0">
                                    <input type="hidden" name="action" value="decrease"><input type="hidden" name="productId" value="${item.product.id}">
                                    <button type="submit" class="btn btn-sm btn-light border px-2 py-0 fw-bold">-</button>
                                </form>
                                <span class="fw-semibold mx-1" style="font-size: 13px; width: 16px; text-align: center;">${item.quantity}</span>
                                <form action="${pageContext.request.contextPath}/staff/pos" method="POST" class="m-0">
                                    <input type="hidden" name="action" value="add"><input type="hidden" name="productId" value="${item.product.id}">
                                    <button type="submit" class="btn btn-sm btn-light border px-2 py-0 fw-bold" ${item.quantity >= item.product.stock ? 'disabled' : ''}>+</button>
                                </form>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <div class="fw-bold text-dark" style="font-size: 13px;"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                <form action="${pageContext.request.contextPath}/staff/pos" method="POST" class="m-0">
                                    <input type="hidden" name="action" value="remove"><input type="hidden" name="productId" value="${item.product.id}">
                                    <button type="submit" class="btn btn-sm text-danger p-0" title="Xóa"><i class="ph ph-x-circle fs-5"></i></button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- FORM THANH TOÁN (CÓ VOUCHER) -->
        <div class="checkout-panel">

            <!-- COMBO BOX CHỌN VOUCHER XINH XẮN -->
            <form action="${pageContext.request.contextPath}/staff/pos" method="POST" class="mb-3">
                <input type="hidden" name="action" value="apply_voucher">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-white border-end-0 text-success"><i class="ph-fill ph-ticket"></i></span>
                    <select name="voucherCode" class="form-select border-start-0 voucher-select ps-0" onchange="this.form.submit()" ${empty sessionScope.posCart ? 'disabled' : ''}>
                        <option value="">-- Không áp dụng Khuyến mãi --</option>
                        <c:forEach var="v" items="${availableVouchers}">
                            <!-- Chỉ hiện các voucher Active và Hợp lệ với Tổng tiền hiện tại -->
                            <c:if test="${v.status == 'ACTIVE' && v.usageLimit > 0 && subTotalAmount >= v.minOrderAmount}">
                                <option value="${v.code}" ${sessionScope.posAppliedVoucher != null && sessionScope.posAppliedVoucher.code == v.code ? 'selected' : ''}>
                                    ${v.code} (Giảm <fmt:formatNumber value="${v.discountValue}" maxFractionDigits="0"/>${v.type == 'PERCENT' ? '%' : '₫'})
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
            </form>

            <form action="${pageContext.request.contextPath}/staff/pos" method="POST">
                <input type="hidden" name="action" value="checkout">

                <div class="row g-2 mb-3">
                    <div class="col-6"><input type="text" name="customerName" class="form-control form-control-sm" placeholder="Tên (Bỏ trống = Khách lẻ)"></div>
                    <div class="col-6"><input type="text" name="customerPhone" class="form-control form-control-sm" placeholder="SĐT khách hàng"></div>
                </div>

                <div class="mb-3 d-flex gap-2">
                    <div class="form-check border rounded p-2 flex-grow-1 bg-white">
                        <input class="form-check-input ms-1" type="radio" name="paymentMethod" id="cash" value="CASH" checked>
                        <label class="form-check-label ms-1" for="cash" style="font-size: 13px; font-weight: 500;">Tiền mặt</label>
                    </div>
                    <div class="form-check border rounded p-2 flex-grow-1 bg-white">
                        <input class="form-check-input ms-1" type="radio" name="paymentMethod" id="bank" value="BANKING">
                        <label class="form-check-label ms-1" for="bank" style="font-size: 13px; font-weight: 500;">Chuyển khoản</label>
                    </div>
                </div>

                <!-- TÍNH TOÁN LẠI GIAO DIỆN HIỂN THỊ TIỀN -->
                <c:if test="${not empty sessionScope.posDiscountAmount}">
                    <div class="d-flex justify-content-between text-muted mb-1" style="font-size: 13px;">
                        <span>Tạm tính:</span>
                        <span><fmt:formatNumber value="${subTotalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                    <div class="d-flex justify-content-between text-success fw-bold mb-2 pb-2 border-bottom" style="font-size: 13px;">
                        <span>Giảm giá:</span>
                        <span>- <fmt:formatNumber value="${sessionScope.posDiscountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </div>
                </c:if>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="fs-5 fw-bold text-dark">KHÁCH CẦN TRẢ</span>
                    <span class="fs-3 fw-bold text-success">
                        <c:set var="finalPosTotal" value="${subTotalAmount - (not empty sessionScope.posDiscountAmount ? sessionScope.posDiscountAmount : 0)}" />
                        <c:if test="${finalPosTotal < 0}"><c:set var="finalPosTotal" value="0" /></c:if>
                        <fmt:formatNumber value="${finalPosTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </span>
                </div>

                <button type="submit" class="btn-checkout" ${empty sessionScope.posCart ? 'disabled' : ''}>TẠO ĐƠN & IN HÓA ĐƠN</button>
            </form>
        </div>
    </div>
</div>

<!-- Cảnh báo nếu đổi số lượng thì voucher tự hủy để nhân viên biết -->
<c:if test="${not empty sessionScope.posAppliedVoucher}">
    <script>
        console.log("Voucher ${sessionScope.posAppliedVoucher.code} đang áp dụng. Nếu thay đổi số lượng, voucher sẽ tự động gỡ để đảm bảo tính toán an toàn.");
    </script>
</c:if>

</body>
</html>