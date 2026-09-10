<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ của tôi | Fruit Farmer</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-main: #F5F5F5; }
        body { background-color: var(--bg-main); font-family: 'Inter', sans-serif; font-size: 14px; color: #333; }
        .hover-primary:hover { color: var(--primary) !important; transition: 0.2s; }
        .navbar-brand { font-family: 'DM Sans', sans-serif; font-weight: 700; font-size: 24px; color: var(--primary) !important; }
        .customer-profile { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #ddd; }
        .customer-avatar { width: 48px; height: 48px; border-radius: 50%; object-fit: cover; }
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 10px 0; color: #555; text-decoration: none; font-weight: 500; transition: 0.2s; }
        .menu-item:hover, .menu-item.active { color: var(--primary); }
        .profile-card { background: #fff; border-radius: 4px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); padding: 32px; min-height: 500px; }
        .btn-shopee-primary { background: var(--primary); color: #fff; border: none; padding: 8px 32px; border-radius: 4px; font-weight: 500; transition: 0.2s; }
        .btn-shopee-primary:hover { background: #245530; color: #fff; }
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
            <div class="dropdown">
                <a href="#" class="text-decoration-none text-dark fw-medium d-flex align-items-center gap-2 hover-primary" data-bs-toggle="dropdown">
                    <i class="ph-fill ph-user-circle fs-4 text-muted"></i> ${sessionScope.user.fullName}
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3">
                    <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="ph ph-sign-out me-2"></i>Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3 d-none d-lg-block">
            <div class="pe-3">
                <div class="customer-profile">
                    <!-- Ảnh đại diện mini ở Sidebar -->
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
                        <span class="text-muted" style="font-size: 12px;"><i class="ph ph-pencil-simple"></i> Sửa hồ sơ</span>
                    </div>
                </div>
                <div class="d-flex flex-column">
                    <a href="${pageContext.request.contextPath}/profile" class="menu-item active"><i class="ph ph-user"></i> Tài khoản của tôi</a>
                    <a href="${pageContext.request.contextPath}/orders/history" class="menu-item"><i class="ph ph-receipt"></i> Đơn mua</a>
                    <a href="${pageContext.request.contextPath}/notifications" class="menu-item"><i class="ph ph-bell"></i> Thông báo</a>
                    <a href="${pageContext.request.contextPath}/vouchers" class="menu-item"><i class="ph ph-ticket"></i> Kho Voucher</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="profile-card">
                <div class="border-bottom pb-3 mb-4">
                    <h5 class="fw-bold m-0">Hồ Sơ Của Tôi</h5>
                    <div class="text-muted mt-1">Quản lý thông tin hồ sơ để bảo mật tài khoản</div>
                </div>

                <div class="row">
                    <!-- Đã fix lỗi enctype="multipart/form-data" -->
                    <form action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data" class="d-flex flex-wrap w-100">
                        <div class="col-md-8 pe-md-5">
                            <div class="row align-items-center mb-4">
                                <div class="col-4 text-end text-muted">Email đăng nhập</div>
                                <div class="col-8 fw-medium">${sessionScope.user.email}</div>
                            </div>
                            <div class="row align-items-center mb-4">
                                <div class="col-4 text-end text-muted">Tên đầy đủ</div>
                                <div class="col-8">
                                    <input type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required>
                                </div>
                            </div>
                            <div class="row align-items-center mb-4">
                                <div class="col-4 text-end text-muted">Số điện thoại</div>
                                <div class="col-8">
                                    <input type="text" name="phone" class="form-control" value="${sessionScope.user.phone}">
                                </div>
                            </div>
                            <div class="row align-items-center mb-4">
                                <div class="col-4 text-end text-muted">Địa chỉ nhận hàng</div>
                                <div class="col-8">
                                    <input type="text" name="address" class="form-control" value="${sessionScope.user.address}">
                                </div>
                            </div>
                            <div class="row mt-5">
                                <div class="col-4"></div>
                                <div class="col-8"><button type="submit" class="btn-shopee-primary">Lưu thay đổi</button></div>
                            </div>
                        </div>

                        <!-- Cột avatar -->
                        <div class="col-md-4 border-start text-center pt-4">
                            <!-- Logic nạp ảnh thật nếu có, chưa có thì nạp ảnh chữ cái -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.avatar}">
                                    <img src="${pageContext.request.contextPath}/assets/images/users/${sessionScope.user.avatar}" id="avatarPreview" class="rounded-circle mb-3 border" style="object-fit: cover; width: 120px; height: 120px;">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=2F6B3F&color=fff&size=120" id="avatarPreview" class="rounded-circle mb-3 border" style="object-fit: cover; width: 120px; height: 120px;">
                                </c:otherwise>
                            </c:choose>

                            <!-- Nút chọn ảnh đã được fix JS -->
                            <label class="btn btn-outline-secondary btn-sm d-block mx-auto mt-2" style="width: fit-content; cursor: pointer;">
                                <i class="ph ph-camera me-1"></i> Chọn Ảnh
                                <input type="file" name="avatarFile" accept="image/jpeg, image/png, image/jpg" style="display: none;" onchange="if(this.files[0]) document.getElementById('avatarPreview').src = URL.createObjectURL(this.files[0])">
                            </label>

                            <div class="text-muted mt-3" style="font-size: 12px;">Dung lượng file tối đa 2 MB<br>Định dạng: .JPEG, .PNG</div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>