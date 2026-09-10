<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông báo | Fruit Farmer</title>
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

        .noti-item { display: flex; gap: 16px; padding: 20px; border-bottom: 1px solid #eee; transition: 0.2s; text-decoration: none; color: inherit; }
        .noti-item:hover { background: #fdfdfd; }
        .noti-unread { background: #F4FBF6; }
        .noti-icon-wrapper { width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .bg-order { background: #E0E7FF; color: #4338CA; }
        .bg-promo { background: #FFEDD5; color: #C2410C; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white py-3 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <a class="navbar-brand text-decoration-none" href="${pageContext.request.contextPath}/"><i class="ph-fill ph-leaf"></i> Fruit Farmer.</a>
        <div class="d-flex align-items-center gap-4">
            <a href="${pageContext.request.contextPath}/orders/history" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary"><i class="ph ph-receipt fs-5"></i> Đơn mua</a>
            <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-1 hover-primary"><i class="ph ph-shopping-cart fs-5"></i> Giỏ hàng</a>
            <div class="vr mx-2 text-muted"></div>
            <div class="fw-medium text-dark d-flex align-items-center gap-2"><i class="ph-fill ph-user-circle fs-4 text-muted"></i> ${sessionScope.user.fullName}</div>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="row">
        <!-- Sidebar Menu -->
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
                    <a href="${pageContext.request.contextPath}/notifications" class="menu-item active"><i class="ph ph-bell"></i> Thông báo</a>
                    <a href="${pageContext.request.contextPath}/vouchers" class="menu-item"><i class="ph ph-ticket"></i> Kho Voucher</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="bg-white rounded-4 shadow-sm min-vh-100 overflow-hidden">
                <div class="d-flex justify-content-between align-items-center p-4 border-bottom">
                    <h5 class="fw-bold m-0">Tất cả thông báo</h5>
                    <a href="#" class="text-success text-decoration-none" style="font-size: 13px;">Đánh dấu Đã đọc tất cả</a>
                </div>

                <div>
                    <!-- Xử lý rỗng -->
                    <c:if test="${empty notifications}">
                        <div class="text-center py-5">
                            <i class="ph-fill ph-bell-ringing text-muted" style="font-size: 64px; opacity: 0.3;"></i>
                            <h5 class="mt-3 text-muted">Bạn chưa có thông báo nào</h5>
                        </div>
                    </c:if>

                    <!-- Vòng lặp in thông báo -->
                    <c:forEach var="n" items="${notifications}">
                        <a href="${n.type == 'PROMO' ? pageContext.request.contextPath.concat('/vouchers') : pageContext.request.contextPath.concat('/orders/history')}"
                           class="noti-item ${n.isRead ? '' : 'noti-unread'}">

                            <div class="noti-icon-wrapper ${n.type == 'PROMO' ? 'bg-promo' : 'bg-order'}">
                                <i class="ph-fill ${n.type == 'PROMO' ? 'ph-ticket' : 'ph-receipt'} fs-4"></i>
                            </div>

                            <div class="flex-grow-1">
                                <div class="fw-bold text-dark mb-1">${n.title}</div>
                                <div class="text-muted" style="font-size: 13px;">${n.message}</div>
                                <div class="text-secondary mt-2" style="font-size: 12px;">
                                    <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>