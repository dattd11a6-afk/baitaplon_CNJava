<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kho Voucher | Fruit Farmer</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-main: #F5F5F5; }
        body { background-color: var(--bg-main); font-family: 'Inter', sans-serif; font-size: 14px; color: #333; }
        .hover-primary:hover { color: var(--primary) !important; transition: 0.2s; }
        .navbar-brand { font-family: 'DM Sans', sans-serif; font-weight: 700; font-size: 24px; color: var(--primary) !important; }
        .customer-sidebar { background: transparent; }
        .customer-profile { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd; }
        .customer-avatar { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; }
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 10px 0; color: #555; text-decoration: none; font-weight: 500; transition: 0.2s; }
        .menu-item:hover, .menu-item.active { color: var(--primary); }
        .voucher-card { display: flex; height: 118px; background: #fff; border-radius: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); position: relative; overflow: hidden; margin-bottom: 16px; border: 1px solid #eee; }
        .voucher-left { width: 118px; background: #E8F5E9; border-right: 2px dashed #A7F3D0; display: flex; flex-direction: column; justify-content: center; align-items: center; position: relative; }
        .voucher-left::before, .voucher-left::after { content: ''; position: absolute; right: -8px; width: 14px; height: 14px; background: var(--bg-main); border-radius: 50%; border: 1px solid #eee; }
        .voucher-left::before { top: -8px; border-bottom-color: transparent; border-right-color: transparent; transform: rotate(-45deg); }
        .voucher-left::after { bottom: -8px; border-top-color: transparent; border-right-color: transparent; transform: rotate(45deg); }
        .voucher-right { flex: 1; padding: 16px; display: flex; justify-content: space-between; align-items: center; }
        .btn-use { background: var(--primary); color: #fff; padding: 6px 16px; border-radius: 4px; font-weight: 500; text-decoration: none; font-size: 13px; }
        .btn-use:hover { background: #245530; color: #fff; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white py-3 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <a class="navbar-brand text-decoration-none" href="${pageContext.request.contextPath}/"><i class="ph-fill ph-leaf"></i> Fruit Farmer.</a>
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/orders/history" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary"><i class="ph ph-receipt fs-5"></i> Đơn mua</a>
            <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary">
                <i class="ph ph-shopping-cart fs-5"></i> Giỏ hàng
            </a>
            <div class="vr mx-2 text-muted"></div>
            <div class="fw-medium text-dark d-flex align-items-center gap-2"><i class="ph-fill ph-user-circle fs-4 text-muted"></i> ${sessionScope.user.fullName}</div>
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
                    <a href="${pageContext.request.contextPath}/orders/history" class="menu-item"><i class="ph ph-receipt"></i> Đơn mua</a>
                    <a href="${pageContext.request.contextPath}/notifications" class="menu-item"><i class="ph ph-bell"></i> Thông báo</a>
                    <a href="${pageContext.request.contextPath}/vouchers" class="menu-item active"><i class="ph ph-ticket"></i> Kho Voucher</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="bg-white rounded-4 shadow-sm p-4 min-vh-100">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <h5 class="fw-bold m-0">Kho Voucher của tôi</h5>
                    <div class="d-flex gap-2">
                        <input type="text" class="form-control form-control-sm" placeholder="Nhập mã voucher...">
                        <button class="btn btn-dark btn-sm px-3">Lưu</button>
                    </div>
                </div>

                <div class="row">
                    <!-- Nếu chưa có mã giảm giá -->
                    <c:if test="${empty vouchers}">
                        <div class="col-12 text-center py-5">
                            <i class="ph-fill ph-ticket text-muted" style="font-size: 64px; opacity: 0.3;"></i>
                            <h5 class="mt-3 text-muted">Kho Voucher đang trống</h5>
                            <p class="text-muted">Bạn chưa lưu mã giảm giá nào. Hãy sưu tầm thêm nhé!</p>
                        </div>
                    </c:if>

                    <!-- Đổ dữ liệu từ bảng vouchers lên bằng forEach -->
                    <c:forEach var="v" items="${vouchers}">
                        <div class="col-md-6">
                            <div class="voucher-card">
                                <div class="voucher-left ${v.type == 'FREESHIP' ? '' : 'text-success'}"
                                     style="${v.type == 'FREESHIP' ? 'background: #E0F2FE; border-right-color: #BAE6FD; color: #0284C7;' : ''}">
                                    <i class="ph-fill ${v.type == 'FREESHIP' ? 'ph-truck' : 'ph-ticket'} fs-1 mb-1"></i>
                                    <span class="fw-bold" style="font-size: 11px;">${v.type == 'FREESHIP' ? 'FREESHIP' : 'MÃ GIẢM GIÁ'}</span>
                                </div>
                                <div class="voucher-right">
                                    <div>
                                        <div class="fw-bold text-dark" style="font-size: 16px;">
                                            <c:choose>
                                                <c:when test="${v.type == 'PERCENT'}">Giảm <fmt:formatNumber value="${v.discountAmount}" maxFractionDigits="0"/>%</c:when>
                                                <c:when test="${v.type == 'AMOUNT'}">Giảm <fmt:formatNumber value="${v.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></c:when>
                                                <c:otherwise>Miễn phí vận chuyển</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-muted mt-1" style="font-size: 12px;">
                                            Đơn tối thiểu <fmt:formatNumber value="${v.minOrder}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </div>
                                        <div class="text-danger mt-2" style="font-size: 11px;">Hết hạn: <fmt:formatDate value="${v.expirationDate}" pattern="dd/MM/yyyy"/></div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/products" class="btn-use">Dùng ngay</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>