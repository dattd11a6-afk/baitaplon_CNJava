<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | Fruit Farmer</title>

    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .cart-item-img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; background: #F4F7F1; padding: 5px; }
        .qty-input { width: 50px; text-align: center; border: 1px solid var(--border-light); border-radius: 4px; padding: 4px; }
        .qty-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        .hover-primary:hover { color: #2F6B3F !important; transition: 0.2s; }
        .navbar-brand { font-family: 'DM Sans', sans-serif; font-weight: 700; font-size: 24px; color: #2F6B3F !important; }

        /* STYLE VOUCHER CHUẨN E-COMMERCE */
        .voucher-ticket { border: 1px solid #EAEAEC; background: #fff; border-radius: 8px; margin-bottom: 12px; display: flex; align-items: stretch; overflow: hidden; transition: 0.2s;}
        .voucher-ticket:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.05); border-color: #2F6B3F;}
        .voucher-icon-box { width: 80px; background: #2F6B3F; color: white; display: flex; align-items: center; justify-content: center; position: relative; border-right: 1px dashed #fff; }
    </style>
</head>
<body class="bg-main">

    <!-- NAVBAR MỚI ĐƯỢC NÂNG CẤP TÍCH HỢP TÀI KHOẢN & ĐƠN MUA -->
    <nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand text-success brand-font text-decoration-none" href="${pageContext.request.contextPath}/">
                <i class="ph-fill ph-leaf"></i> Fruit Farmer.
            </a>
            <div class="d-flex align-items-center gap-4">
                <a href="${pageContext.request.contextPath}/orders/history" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary">
                    <i class="ph ph-receipt fs-5"></i> Đơn mua
                </a>
                <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary position-relative">
                    <i class="ph ph-shopping-cart fs-5"></i> Giỏ hàng
                    <c:if test="${not empty sessionScope.cart}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">
                            ${sessionScope.cart.size()}
                        </span>
                    </c:if>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="vr mx-2 text-muted"></div>
                        <div class="dropdown">
                            <a href="#" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-2 hover-primary" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="ph-fill ph-user-circle fs-4 text-muted"></i> ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3" style="min-width: 180px;">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="ph ph-user me-2"></i>Tài khoản của tôi</a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders/history"><i class="ph ph-receipt me-2"></i>Đơn mua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="ph ph-sign-out me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="vr mx-2 text-muted"></div>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm px-3 rounded-pill fw-medium">Đăng nhập</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <!-- NỘI DUNG GIỎ HÀNG -->
    <div class="container py-5">


        <c:choose>
            <c:when test="${empty sessionScope.cart}">
                <div class="text-center py-5 bg-white rounded-4 border border-light shadow-sm">
                    <i class="fa-solid fa-basket-shopping text-muted mb-3" style="font-size: 48px; opacity: 0.3;"></i>
                    <h4 class="brand-font">Giỏ hàng của bạn đang trống</h4>
                    <p class="text-muted mb-4">Hãy lấp đầy giỏ hàng bằng những trái cây tươi ngon nhé!</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom px-4">Tiếp tục mua sắm</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="row g-4">
                    <!-- CỘT TRÁI: Danh sách sản phẩm -->
                    <div class="col-lg-8">
                        <div class="bg-white rounded-4 border border-light p-4 shadow-sm">
                            <div class="table-responsive">
                                <table class="table align-middle text-nowrap mb-0">
                                    <thead class="text-muted" style="font-size: 13px;">
                                        <tr>
                                            <th>SẢN PHẨM</th>
                                            <th>ĐƠN GIÁ</th>
                                            <th>SỐ LƯỢNG</th>
                                            <th>TẠM TÍNH</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody style="border-top: 1px solid var(--border-light);">
                                        <c:forEach var="item" items="${sessionScope.cart}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <c:choose>
                                                            <c:when test="${not empty item.product.image && fn:startsWith(item.product.image, 'http')}">
                                                                <img src="${item.product.image}" class="cart-item-img">
                                                            </c:when>
                                                            <c:when test="${not empty item.product.image}">
                                                                <img src="${pageContext.request.contextPath}/assets/images/products/${item.product.image}" class="cart-item-img">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200&auto=format&fit=crop" class="cart-item-img">
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/product?id=${item.product.id}" class="text-dark fw-semibold text-decoration-none d-block">${item.product.name}</a>
                                                            <span class="text-muted" style="font-size: 12px;">Kho: ${item.product.stock}</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="fw-medium text-dark"><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex align-items-center gap-2">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="id" value="${item.product.id}">
                                                        <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stock}" class="qty-input" onchange="this.form.submit()">
                                                    </form>
                                                </td>
                                                <td class="fw-bold text-success"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="id" value="${item.product.id}">
                                                        <button type="submit" class="btn text-danger p-0" title="Xóa"><i class="fa-regular fa-trash-can"></i></button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- tiếp tục mua trái cây kũ -->
                    </div>

                    <!-- CỘT PHẢI: Order Summary -->
                    <div class="col-lg-4">
                        <div class="bg-white rounded-4 border border-light p-4 shadow-sm position-sticky" style="top: 100px;">
                            <h5 class="brand-font mb-4">Tổng đơn hàng</h5>

                            <!-- NÚT GỌI POPUP VOUCHER -->
                            <div class="mb-4">
                                <label class="form-label text-muted fw-bold" style="font-size: 13px;"><i class="ph-fill ph-ticket text-warning fs-5 align-middle me-1"></i> Mã ưu đãi / Voucher</label>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.appliedVoucher}">
                                        <!-- Khối đang áp dụng Voucher -->
                                        <div class="alert alert-success border-0 py-2 px-3 mb-0 d-flex justify-content-between align-items-center" style="font-size: 13px;">
                                            <span><i class="ph-fill ph-check-circle me-1"></i> <b>${sessionScope.appliedVoucher.code}</b></span>
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                                <input type="hidden" name="action" value="remove_voucher">
                                                <button type="submit" class="btn btn-link text-danger p-0 text-decoration-none fw-bold" style="font-size: 12px;">GỠ MÃ</button>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Nút chọn mã -->
                                        <div class="d-grid">
                                            <button class="btn btn-outline-success fw-medium" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                                <i class="ph ph-magnifying-glass me-1"></i> Bấm để chọn Voucher
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="d-flex justify-content-between mb-3 text-muted" style="font-size: 15px;">
                                <span>Tạm tính</span>
                                <span class="fw-medium text-dark"><fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 text-muted" style="font-size: 15px;">
                                <span>Phí giao hàng</span>
                                <span class="text-dark">---</span>
                            </div>

                            <!-- Trừ tiền Voucher -->
                            <div class="d-flex justify-content-between mb-4 ${not empty sessionScope.discountAmount ? 'text-success fw-bold' : 'text-muted'}" style="font-size: 15px;">
                                <span>Giảm giá</span>
                                <span><c:if test="${not empty sessionScope.discountAmount}">- </c:if><fmt:formatNumber value="${not empty sessionScope.discountAmount ? sessionScope.discountAmount : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-4 pt-3 border-top">
                                <span class="fw-bold" style="font-size: 16px;">Tổng thanh toán</span>
                                <span class="fw-bold text-success fs-4">
                                    <fmt:formatNumber value="${cartTotal - (not empty sessionScope.discountAmount ? sessionScope.discountAmount : 0)}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary-custom w-100 py-3" style="font-size: 16px;">
                                Tiến hành thanh toán
                            </a>
                            <!-- tiếp tục mua trái cây giờ đc chuyển xuống đây cho đẹp -->
                            <a href="${pageContext.request.contextPath}/products" class="d-block text-center mt-3 text-muted text-decoration-none" style="font-size: 14px;">
                                Mua thêm trái cây khác
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ==================== MODAL CHỌN VOUCHER (SHOPEE STYLE) ==================== -->
    <div class="modal fade" id="voucherModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom pb-3">
                    <h5 class="modal-title fw-bold text-dark"><i class="ph-fill ph-ticket text-warning me-2"></i>Chọn Voucher khả dụng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body bg-light p-3" style="max-height: 500px;">

                    <!-- Nhập mã tay -->
                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex gap-2 mb-4">
                        <input type="hidden" name="action" value="apply_voucher">
                        <input type="text" name="voucherCode" class="form-control text-uppercase fw-bold border-success" placeholder="Hoặc nhập mã của bạn..." required>
                        <button type="submit" class="btn btn-success fw-bold px-4">Áp dụng</button>
                    </form>

                    <!-- Danh sách đổ từ Database -->
                    <c:choose>
                        <c:when test="${empty availableVouchers}">
                            <div class="text-center text-muted py-4">Hiện không có mã giảm giá nào.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="v" items="${availableVouchers}">
                                <c:if test="${v.status == 'ACTIVE'}">

                                    <!-- Tính toán thanh tiến độ phần trăm % -->
                                    <c:set var="totalLimit" value="${v.usageLimit + v.usedCount}" />
                                    <c:set var="percentUsed" value="${totalLimit > 0 ? (v.usedCount / totalLimit) * 100 : 0}" />

                                    <div class="voucher-ticket shadow-sm">
                                        <!-- Cột Icon -->
                                        <div class="voucher-icon-box">
                                            <i class="ph-fill ph-ticket fs-1"></i>
                                        </div>

                                        <!-- Cột Thông tin -->
                                        <div class="p-3 flex-grow-1 bg-white" style="border-radius: 0 8px 8px 0;">
                                            <div class="d-flex justify-content-between align-items-start mb-1">
                                                <div>
                                                    <div class="fw-bold text-success fs-6">${v.code}</div>
                                                    <div class="text-muted" style="font-size: 12px;">
                                                        <c:choose>
                                                            <c:when test="${v.type == 'PERCENT'}">Giảm <fmt:formatNumber value="${v.discountValue}" maxFractionDigits="0"/>%</c:when>
                                                            <c:otherwise>Giảm <fmt:formatNumber value="${v.discountValue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></c:otherwise>
                                                        </c:choose>
                                                        cho đơn từ <fmt:formatNumber value="${v.minOrderAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-end mt-2">
                                                <!-- Cảnh báo % Đã dùng và Hạn Sử dụng -->
                                                <div style="width: 55%;">
                                                    <div class="progress mb-1" style="height: 4px; background-color: #EAEAEC;">
                                                        <div class="progress-bar bg-danger" style="width: ${percentUsed}%"></div>
                                                    </div>
                                                    <div class="text-danger fw-medium" style="font-size: 10px;">Đã dùng <fmt:formatNumber value="${percentUsed}" maxFractionDigits="0"/>%</div>
                                                    <div class="text-muted mt-1" style="font-size: 10px;"><i class="ph ph-clock"></i> HSD: <fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy"/></div>
                                                </div>

                                                <!-- Nút Dùng Ngay -->
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                                    <input type="hidden" name="action" value="apply_voucher">
                                                    <input type="hidden" name="voucherCode" value="${v.code}">
                                                    <button type="submit" class="btn btn-sm btn-success fw-bold px-3" style="font-size: 12px;" ${v.usageLimit <= 0 ? 'disabled' : ''}>
                                                        ${v.usageLimit <= 0 ? 'HẾT LƯỢT' : 'DÙNG NGAY'}
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
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