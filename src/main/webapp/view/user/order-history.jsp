<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi | Fruit Farmer</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-main: #F5F5F5; --border: #EAEAEC; }
        body { background-color: var(--bg-main); font-family: 'Inter', sans-serif; font-size: 14px; color: #333; }
        .hover-primary:hover { color: var(--primary) !important; transition: 0.2s; }
        .navbar-brand { font-family: 'DM Sans', sans-serif; font-weight: 700; font-size: 24px; color: var(--primary) !important; }
        .customer-sidebar { background: transparent; }
        .customer-profile { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd; }
        .customer-avatar { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; }
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 10px 0; color: #555; text-decoration: none; font-weight: 500; transition: 0.2s; }
        .menu-item:hover, .menu-item.active { color: var(--primary); }
        .order-tabs { display: flex; background: #fff; border-radius: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 16px;}
        .order-tabs .tab-item { flex: 1; text-align: center; padding: 16px 0; color: #555; cursor: pointer; border-bottom: 2px solid transparent; font-weight: 500; transition: 0.2s; }
        .order-tabs .tab-item:hover, .order-tabs .tab-item.active { color: var(--primary); border-bottom-color: var(--primary); }
        .order-card { background: #fff; border-radius: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 16px; display: block; }
        .order-header { padding: 16px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
        .order-body { padding: 16px 24px; border-bottom: 1px solid var(--border); }
        .order-footer { padding: 16px 24px; background: #FFFAFA; text-align: right; }
        .product-item { display: flex; gap: 16px; margin-bottom: 16px; }
        .product-img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid var(--border); }
        .product-info { flex-grow: 1; text-align: left; }
        .btn-shopee-primary { background: var(--primary); color: #fff; border: none; padding: 8px 24px; border-radius: 4px; font-weight: 500; min-width: 130px; transition: 0.2s; }
        .btn-shopee-primary:hover { background: #245530; color: #fff; }
        .btn-shopee-outline { background: #fff; color: #555; border: 1px solid #ccc; padding: 8px 24px; border-radius: 4px; font-weight: 500; min-width: 130px; transition: 0.2s; }
        .btn-shopee-outline:hover { background: #f8f9fa; color: #333; }
        .tracking-timeline { border-left: 2px solid var(--primary); margin-left: 10px; padding-left: 24px; }
        .tracking-item { margin-bottom: 20px; position: relative; }
        .tracking-item::before { content: ''; position: absolute; left: -31px; top: 0; width: 12px; height: 12px; border-radius: 50%; background: var(--primary); border: 2px solid #fff; }
        .tracking-item.text-muted::before { background: #ccc; border-color: #fff; }
        .tracking-item.text-muted { border-left-color: #ccc; }

        /* CSS CHUẨN CHO ĐÁNH GIÁ SAO TƯƠNG TÁC */
        .rating-stars { display: flex; gap: 8px; flex-direction: row-reverse; justify-content: center; }
        .rating-stars input { display: none; }
        .rating-stars label { font-size: 32px; color: #E5E7EB; cursor: pointer; transition: color 0.2s ease; }
        .rating-stars input:checked ~ label,
        .rating-stars label:hover,
        .rating-stars label:hover ~ label { color: #F59E0B; }
        #ratingText { font-weight: 600; color: #F59E0B; margin-top: 8px; text-align: center;}
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white py-3 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <a class="navbar-brand text-decoration-none" href="${pageContext.request.contextPath}/"><i class="ph-fill ph-leaf"></i> Fruit Farmer.</a>
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/orders/history" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary"><i class="ph ph-receipt fs-5"></i> Đơn mua</a>
            <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary position-relative">
                <i class="ph ph-shopping-cart fs-5"></i> Giỏ hàng
                <c:if test="${not empty sessionScope.cart}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">${sessionScope.cart.size()}</span>
                </c:if>
            </a>
            <c:if test="${not empty sessionScope.user}">
                <div class="vr mx-2 text-muted"></div>
                <div class="dropdown">
                    <a href="#" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-2 hover-primary" data-bs-toggle="dropdown">
                        <i class="ph-fill ph-user-circle fs-4 text-muted"></i> ${sessionScope.user.fullName}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="ph ph-user me-2"></i>Tài khoản của tôi</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders/history"><i class="ph ph-receipt me-2"></i>Đơn mua</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="ph ph-sign-out me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="row">
        <div class="col-lg-3 d-none d-lg-block">
            <div class="customer-sidebar pe-3">
                <div class="customer-profile">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.avatar}">
                            <img src="${pageContext.request.contextPath}/assets/images/users/${sessionScope.user.avatar}" class="customer-avatar">
                        </c:when>
                        <c:otherwise>
                            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=2F6B3F&color=fff" class="customer-avatar">
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <div class="fw-bold fs-6">${sessionScope.user.fullName}</div>
                        <a href="${pageContext.request.contextPath}/profile" class="text-muted text-decoration-none" style="font-size: 12px;"><i class="ph ph-pencil-simple"></i> Sửa hồ sơ</a>
                    </div>
                </div>
                <div class="d-flex flex-column">
                    <a href="${pageContext.request.contextPath}/profile" class="menu-item"><i class="ph ph-user"></i> Tài khoản của tôi</a>
                    <a href="${pageContext.request.contextPath}/orders/history" class="menu-item active"><i class="ph ph-receipt"></i> Đơn mua</a>
                    <a href="${pageContext.request.contextPath}/notifications" class="menu-item"><i class="ph ph-bell"></i> Thông báo</a>
                    <a href="${pageContext.request.contextPath}/vouchers" class="menu-item"><i class="ph ph-ticket"></i> Kho Voucher</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="order-tabs">
                <div class="tab-item active" data-filter="ALL">Tất cả</div>
                <div class="tab-item" data-filter="PENDING,CONFIRMED,PREPARING">Chờ xử lý</div>
                <div class="tab-item" data-filter="SHIPPING">Đang giao</div>
                <div class="tab-item" data-filter="COMPLETED">Hoàn thành</div>
                <div class="tab-item" data-filter="CANCELLED">Đã hủy</div>
            </div>

            <c:forEach var="o" items="${myOrders}">
                <div class="order-card" data-status="${o.orderStatus}">
                    <div class="order-header">
                        <div class="fw-bold"><i class="ph-fill ph-storefront text-success me-2"></i> Fruit Farmer Official</div>
                        <div class="fw-medium">
                            <c:choose>
                                <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="text-primary"><i class="ph ph-truck"></i> ĐANG GIAO HÀNG</span></c:when>
                                <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="text-success"><i class="ph ph-check-circle"></i> ĐÃ HOÀN THÀNH</span></c:when>
                                <c:when test="${o.orderStatus == 'CANCELLED'}"><span class="text-danger"><i class="ph ph-x-circle"></i> ĐÃ HỦY</span></c:when>
                                <c:otherwise><span class="text-warning text-dark"><i class="ph ph-clock"></i> CHỜ XỬ LÝ</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="order-body">
                        <!-- ĐỔ DỮ LIỆU SẢN PHẨM THẬT -->
                        <c:forEach var="item" items="${orderItemsMap[o.id]}">
                            <div class="product-item pb-3 mb-3 border-bottom border-light">
                                <c:choose>
                                    <c:when test="${not empty item.product.image && fn:startsWith(item.product.image, 'http')}">
                                        <img src="${item.product.image}" class="product-img">
                                    </c:when>
                                    <c:when test="${not empty item.product.image}">
                                        <img src="${pageContext.request.contextPath}/assets/images/products/${item.product.image}" class="product-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=200" class="product-img">
                                    </c:otherwise>
                                </c:choose>
                                <div class="product-info">
                                    <div class="fw-semibold text-dark fs-6">${item.product.name}</div>
                                    <div class="text-muted mt-1" style="font-size: 13px;">Phân loại: Tiêu chuẩn | Số lượng: x${item.quantity}</div>
                                </div>
                                <div class="fw-bold text-dark fs-6 d-flex align-items-center"><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                            </div>
                        </c:forEach>
                        <div class="text-end text-muted mt-2" style="font-size: 12px;">Ngày đặt: <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>

                    <div class="order-footer">
                        <div class="d-flex justify-content-end align-items-center mb-4 gap-3">
                            <span class="text-muted" style="font-size: 13px;">Mã đơn: #DH${o.id}</span>
                            <div class="fs-6">Thành tiền: <span class="fw-bold text-success fs-4 ms-2"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span></div>
                        </div>

                        <!-- CÁC NÚT THAO TÁC CỦA ĐƠN HÀNG -->
                        <div class="d-flex justify-content-end gap-3 align-items-center">
                            <c:choose>
                                <c:when test="${o.orderStatus == 'SHIPPING'}">
                                    <button class="btn-shopee-outline btn-track" data-id="${o.id}" data-status="${o.orderStatus}" data-bs-toggle="modal" data-bs-target="#trackingModal">Theo dõi đơn</button>
                                    <form action="${pageContext.request.contextPath}/orders/history" method="POST" class="m-0">
                                        <input type="hidden" name="action" value="confirm_received">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <button type="submit" class="btn-shopee-primary">Đã nhận được hàng</button>
                                    </form>
                                </c:when>

                                <c:when test="${o.orderStatus == 'COMPLETED'}">
                                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                        <input type="hidden" name="action" value="repurchase">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <button type="submit" class="btn-shopee-outline">Mua lại</button>
                                    </form>
                                    <!-- Nút Đánh giá giờ đã truyền thêm data-product để lấy đúng ID sản phẩm đầu tiên của đơn hàng -->
                                    <button class="btn-shopee-primary btn-rate" data-order="${o.id}" data-product="${orderItemsMap[o.id][0].product.id}" data-bs-toggle="modal" data-bs-target="#ratingModal">Đánh giá</button>
                                </c:when>

                                <c:when test="${o.orderStatus == 'CANCELLED'}">
                                    <div class="text-danger me-auto fw-medium" style="font-size: 13px;">
                                        <i class="ph-fill ph-warning-circle"></i> Lý do hủy: ${o.cancelReason}
                                    </div>
                                    <button class="btn-shopee-primary w-auto bg-secondary" disabled>Đơn đã hủy</button>
                                </c:when>

                                <c:otherwise>
                                    <button class="btn-shopee-outline btn-track" data-id="${o.id}" data-status="${o.orderStatus}" data-bs-toggle="modal" data-bs-target="#trackingModal">Tiến độ</button>
                                    <button class="btn btn-outline-danger btn-sm fw-medium px-4 py-2" data-bs-toggle="modal" data-bs-target="#cancelOrderModal${o.id}">Hủy đơn</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- MODAL HỦY ĐƠN (Giữ nguyên) -->
                <div class="modal fade" id="cancelOrderModal${o.id}" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 rounded-4">
                            <form action="${pageContext.request.contextPath}/orders/history" method="POST">
                                <div class="modal-header border-bottom-0 pb-0">
                                    <h5 class="modal-title fw-bold text-dark">Lý do hủy đơn hàng #${o.id}</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <input type="hidden" name="action" value="cancel_order">
                                    <input type="hidden" name="orderId" value="${o.id}">

                                    <div class="alert alert-warning border-0 bg-warning-subtle text-warning-emphasis" style="font-size: 13px;">
                                        <i class="ph-fill ph-warning-circle me-1"></i> Vui lòng chọn lý do hủy. Thao tác này không thể hoàn tác.
                                    </div>

                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio" name="reasonType" value="Muốn thay đổi địa chỉ giao hàng" id="r1_${o.id}" required>
                                        <label class="form-check-label fw-medium text-dark" for="r1_${o.id}">Muốn thay đổi địa chỉ giao hàng</label>
                                    </div>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio" name="reasonType" value="Muốn nhập/thay đổi mã Voucher" id="r2_${o.id}">
                                        <label class="form-check-label fw-medium text-dark" for="r2_${o.id}">Muốn thay đổi mã Voucher</label>
                                    </div>
                                    <div class="form-check mb-3">
                                        <input class="form-check-input" type="radio" name="reasonType" value="Đổi ý, không muốn mua nữa" id="r3_${o.id}">
                                        <label class="form-check-label fw-medium text-dark" for="r3_${o.id}">Đổi ý, không muốn mua nữa</label>
                                    </div>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="reasonType" value="Khác" id="r4_${o.id}">
                                        <label class="form-check-label fw-medium text-dark" for="r4_${o.id}">Lý do khác</label>
                                    </div>
                                    <textarea class="form-control mt-2 d-none" id="otherReason${o.id}" name="reasonOther" rows="2" placeholder="Nhập lý do của bạn (bắt buộc)..."></textarea>
                                </div>
                                <div class="modal-footer border-top-0 pt-0">
                                    <button type="button" class="btn btn-light fw-medium" data-bs-dismiss="modal">Không</button>
                                    <button type="submit" class="btn btn-danger fw-bold px-4">Xác nhận Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Modal Tracking -->
<div class="modal fade" id="trackingModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom">
                <h5 class="fw-bold m-0">Chi tiết vận chuyển <span id="modalOrderId" class="text-success"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4" id="modalTrackingBody"></div>
        </div>
    </div>
</div>

<!-- MODAL ĐÁNH GIÁ ĐÃ FIX: CHUẨN ENCTYPE & SAO TƯƠNG TÁC CSS -->
<div class="modal fade" id="ratingModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-bottom-0 pb-0 mt-2 mx-2">
                <h5 class="fw-bold m-0 brand-font">Đánh giá đơn hàng <span id="rateModalOrderTitle" class="text-success"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <!-- Đã thêm enctype="multipart/form-data" -->
            <form action="${pageContext.request.contextPath}/review" method="POST" enctype="multipart/form-data">
                <div class="modal-body p-4 pt-2">
                    <input type="hidden" name="orderId" id="ratingOrderId" value="">
                    <!-- Nhận đúng Product ID từ JS -->
                    <input type="hidden" name="productId" id="ratingProductId" value="">

                    <p class="text-center fw-medium mb-3 text-dark">Trải nghiệm mua sắm của bạn thế nào?</p>

                    <!-- HTML SAO TƯƠNG TÁC -->
                    <div class="rating-stars mb-1">
                        <input type="radio" name="rating" id="star5" value="5" required checked><label for="star5" class="ph-fill ph-star"></label>
                        <input type="radio" name="rating" id="star4" value="4"><label for="star4" class="ph-fill ph-star"></label>
                        <input type="radio" name="rating" id="star3" value="3"><label for="star3" class="ph-fill ph-star"></label>
                        <input type="radio" name="rating" id="star2" value="2"><label for="star2" class="ph-fill ph-star"></label>
                        <input type="radio" name="rating" id="star1" value="1"><label for="star1" class="ph-fill ph-star"></label>
                    </div>
                    <div id="ratingText">Tuyệt vời</div>

                    <div class="mt-4 mb-3">
                        <textarea name="comment" class="form-control rounded-3" rows="4" placeholder="Sản phẩm tươi ngon chứ? Bạn có hài lòng không?" required></textarea>
                    </div>

                    <!-- Ô Đính Kèm File Ảnh/Video -->
                    <div class="mb-4">
                        <label class="form-label fw-medium text-muted" style="font-size: 13px;"><i class="ph-bold ph-camera me-1"></i> Thêm Ảnh/Video (Tùy chọn)</label>
                        <input type="file" name="mediaFile" class="form-control" accept="image/*,video/mp4,video/quicktime">
                    </div>
                </div>

                <div class="modal-footer border-0 p-3 bg-light rounded-bottom-4">
                    <button type="button" class="btn btn-light border fw-medium px-4" data-bs-dismiss="modal">Trở lại</button>
                    <button type="submit" class="btn btn-success fw-bold px-4" style="background-color: var(--primary);">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- TOAST THÔNG BÁO -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body"><i class="ph-fill ph-check-circle me-2"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body"><i class="ph-fill ph-warning-circle me-2"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // 1. TABS
    const tabs = document.querySelectorAll('.tab-item');
    const cards = document.querySelectorAll('.order-card');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            const filterStr = tab.getAttribute('data-filter');
            const filters = filterStr.split(',');
            cards.forEach(card => {
                const status = card.getAttribute('data-status');
                card.style.display = (filterStr === 'ALL' || filters.includes(status)) ? 'block' : 'none';
            });
        });
    });

    // 2. TRACKING MODAL
    document.getElementById('trackingModal').addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        document.getElementById('modalOrderId').innerText = '#DH' + button.getAttribute('data-id');
        const status = button.getAttribute('data-status');
        let html = '<div class="tracking-timeline">';
        if(status === 'SHIPPING') {
            html += `<div class="tracking-item"><div class="fw-bold text-success">Đang giao hàng</div><div class="mt-1" style="font-size: 13px;">Shipper đang giao hàng cho bạn.</div></div><div class="tracking-item text-muted"><div class="fw-bold">Đã xuất kho</div></div>`;
        } else {
            html += `<div class="tracking-item text-muted"><div class="fw-bold">Đang chuẩn bị hàng</div></div><div class="tracking-item text-muted"><div class="fw-bold">Đơn hàng đã ghi nhận</div></div>`;
        }
        html += '</div>';
        document.getElementById('modalTrackingBody').innerHTML = html;
    });

    // 3. RATING MODAL (Nạp đúng OrderID và ProductID)
    document.getElementById('ratingModal').addEventListener('show.bs.modal', function (event) {
        const button = event.relatedTarget;
        const orderId = button.getAttribute('data-order');
        const productId = button.getAttribute('data-product');

        document.getElementById('ratingOrderId').value = orderId;
        document.getElementById('ratingProductId').value = productId;
        document.getElementById('rateModalOrderTitle').innerText = '#DH' + orderId;
    });

    // 4. JS TEXT RATING SAO TƯƠNG TÁC
    const texts = { 1: "Rất tệ", 2: "Kém", 3: "Bình thường", 4: "Tốt", 5: "Tuyệt vời" };
    const ratingTextStatus = document.getElementById('ratingText');

    document.querySelectorAll('.rating-stars label').forEach(label => {
        label.addEventListener('mouseover', function() {
            let val = this.previousElementSibling.value;
            ratingTextStatus.innerText = texts[val];
        });
        label.addEventListener('mouseleave', function() {
            let checkedVal = document.querySelector('.rating-stars input:checked').value;
            ratingTextStatus.innerText = texts[checkedVal];
        });
        label.addEventListener('click', function() {
            let val = this.previousElementSibling.value;
            ratingTextStatus.innerText = texts[val];
        });
    });

    // 5. LÝ DO HỦY ĐƠN KHÁC
    document.addEventListener('change', function(e) {
        if (e.target.name === 'reasonType') {
            const orderId = e.target.id.split('_')[1];
            const otherTextarea = document.getElementById('otherReason' + orderId);
            if (e.target.value === 'Khác') {
                otherTextarea.classList.remove('d-none');
                otherTextarea.required = true;
            } else {
                otherTextarea.classList.add('d-none');
                otherTextarea.required = false;
            }
        }
    });

    // TOAST INITIALIZE
    var toastList = [].slice.call(document.querySelectorAll('.toast')).map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 3000 }); });
    toastList.forEach(toast => toast.show());
});
</script>
</body>
</html>