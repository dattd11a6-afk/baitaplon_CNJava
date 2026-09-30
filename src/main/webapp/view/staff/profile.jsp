<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Hồ sơ cá nhân | Staff Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,500;9..40,600;9..40,700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --staff-primary: #1C8D50; --staff-sidebar-bg: #102C1F; --staff-bg-light: #F9FAFB;
            --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E5E9E3;
        }
        body { background-color: var(--staff-bg-light); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; padding: 0;}
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR ĐỒNG BỘ */
        .sidebar { width: 250px; background-color: var(--staff-sidebar-bg); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--staff-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .menu-label { padding: 20px 20px 8px; font-size: 11px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 20px; color: #D1D5DB; text-decoration: none; font-weight: 500; font-size: 13px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 18px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }

        /* MAIN CONTENT TRÀN VIỀN */
        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }

        /* HEADER CÓ DROPDOWN */
        .staff-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .header-actions { display: flex; align-items: center; gap: 24px; }
        .btn-pos { background-color: var(--staff-primary); color: #fff; border: none; padding: 9px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; display: flex; align-items: center; gap: 8px; text-decoration: none; transition: 0.2s; box-shadow: 0 2px 6px rgba(28,141,80,0.2); }
        .btn-pos:hover { background-color: #156d3e; color: #fff; transform: translateY(-1px); }
        .user-chip { display: flex; align-items: center; gap: 10px; background: var(--staff-bg-light); padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid var(--border-color); cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #f3f4f6; }
        .user-avatar { width: 32px; height: 32px; background: #3B82F6; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        /* PROFILE SPECIFIC */
        .page-body { padding: 30px; flex-grow: 1; }
        .op-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 12px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); margin-bottom: 24px; }

        .avatar-large { width: 140px; height: 140px; border-radius: 50%; object-fit: cover; border: 4px solid #F1F5F9; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .avatar-placeholder { width: 140px; height: 140px; border-radius: 50%; background: #EEF2FF; color: #4F46E5; display: flex; align-items: center; justify-content: center; font-size: 48px; font-weight: bold; border: 4px solid #fff; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        .form-label { font-weight: 600; color: var(--text-main); font-size: 13px; margin-bottom: 8px; }
        .form-control { border-radius: 8px; border: 1px solid var(--border-color); padding: 12px 16px; font-size: 13px; color: var(--text-main); box-shadow: none; transition: 0.2s; }
        .form-control:focus { border-color: var(--staff-primary); box-shadow: 0 0 0 3px rgba(28, 141, 80, 0.1); }

        .btn-save { background: var(--staff-primary); color: #fff; border: none; padding: 14px 28px; border-radius: 8px; font-weight: 600; font-size: 14px; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;}
        .btn-save:hover { background: #156d3e; color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(28, 141, 80, 0.2); }

        .btn-upload { background: #F1F5F9; color: var(--text-main); border: 1px solid var(--border-color); padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; transition: 0.2s; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        .btn-upload:hover { background: #E2E8F0; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="ph-bold ph-storefront text-white"></i></div>
            <div>
                <div class="fw-bold brand-font text-white" style="font-size: 15px;">Fruit Farmer</div>
                <div style="font-size: 10px; color: var(--staff-primary); font-weight: 700; letter-spacing: 1px;">STAFF PANEL</div>
            </div>
        </div>
        <div class="overflow-auto flex-grow-1 py-3">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/staff/dashboard"><i class="ph-fill ph-house"></i> Trang chủ</a></li>
                <div class="menu-label mt-2">Bán hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/pos"><i class="ph-fill ph-desktop"></i> Đơn tại quầy (POS)</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/orders"><i class="ph-fill ph-receipt"></i> Quản lý đơn hàng</a></li>
                <div class="menu-label">Kho & Khách hàng</div>
                <li><a href="${pageContext.request.contextPath}/staff/inventory"><i class="ph-fill ph-box-arrow-down"></i> Tra cứu Kho</a></li>
                <li><a href="${pageContext.request.contextPath}/staff/customers"><i class="ph-fill ph-users"></i> Tìm khách hàng</a></li>
                <div class="menu-label">Nhân sự</div>
                <li><a href="${pageContext.request.contextPath}/staff/attendance"><i class="ph-fill ph-clock-user"></i> Ca làm & Chấm công</a></li>
            </ul>
        </div>
    </aside>

    <main class="main-content">
        <!-- HEADER -->
        <header class="staff-header">
            <div class="header-date">
                <i class="ph-light ph-user-circle fs-4 me-2 text-primary"></i>
                <span class="fw-bold text-dark fs-5 brand-font">Hồ sơ cá nhân</span>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/staff/pos" class="btn-pos">
                    <i class="ph-bold ph-shopping-cart"></i> Tạo đơn tại quầy
                </a>
                <div class="dropdown ms-2">
                    <div class="user-chip dropdown-toggle d-flex align-items-center gap-2 px-2 py-1 rounded"
                         data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                        <div class="user-info d-flex flex-column text-start">
                            <span class="user-name fw-bold" style="font-size: 13px; line-height: 1;">${sessionScope.user != null ? sessionScope.user.fullName : 'Staff Name'}</span>
                            <span class="user-role text-muted" style="font-size: 11px;">Nhân viên bán hàng</span>
                        </div>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2" style="border-radius: 12px; width: 220px; box-shadow: 0 4px 15px rgba(0,0,0,0.05) !important;">
                        <li>
                            <div class="px-3 py-2 border-bottom mb-1 bg-light rounded-top" style="border-radius: 12px 12px 0 0;">
                                <div class="fw-bold text-dark" style="font-size: 13px;">${sessionScope.user != null ? sessionScope.user.fullName : 'Staff'}</div>
                                <div class="text-muted text-truncate" style="font-size: 11px;">${sessionScope.user != null ? sessionScope.user.email : 'Chưa cập nhật email'}</div>
                            </div>
                        </li>
                        <li><a class="dropdown-item py-2 fw-medium d-flex align-items-center" style="font-size: 13px; color: var(--staff-primary); background: rgba(28, 141, 80, 0.05);" href="${pageContext.request.contextPath}/staff/profile"><i class="ph-bold ph-user-circle me-2 fs-5" style="color: var(--staff-primary);"></i> Hồ sơ cá nhân</a></li>
                        <li><hr class="dropdown-divider my-1"></li>
                        <li><a class="dropdown-item py-2 fw-bold text-danger d-flex align-items-center" style="font-size: 13px;" href="${pageContext.request.contextPath}/logout"><i class="ph-bold ph-sign-out me-2 fs-5"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <div class="page-body">

            <!-- FORM CẬP NHẬT -->
            <form action="${pageContext.request.contextPath}/staff/profile" method="POST" enctype="multipart/form-data" id="profileForm">

                <div class="row g-4">
                    <!-- CỘT TRÁI: AVATAR -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="op-card text-center text-md-start text-lg-center">
                            <h6 class="fw-bold mb-4 brand-font text-dark text-start border-bottom pb-3">Ảnh đại diện</h6>

                            <div class="d-flex flex-column align-items-center mb-4 mt-2">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <img src="${pageContext.request.contextPath}/assets/images/users/${sessionScope.user.avatar}" id="avatarPreview" class="avatar-large mb-3">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar-placeholder mb-3" id="avatarPlaceholder">
                                            ${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}
                                        </div>
                                        <img src="" id="avatarPreview" class="avatar-large mb-3 d-none">
                                    </c:otherwise>
                                </c:choose>

                                <div class="fw-bold text-dark fs-4 mb-1">${sessionScope.user.fullName}</div>
                                <div class="badge bg-primary bg-opacity-10 text-primary px-3 py-1 mt-1" style="font-size: 12px;">Nhân viên Bán hàng</div>
                            </div>

                            <div class="d-flex justify-content-center">
                                <label for="avatarUpload" class="btn-upload">
                                    <i class="ph-bold ph-upload-simple"></i> Chọn ảnh mới
                                </label>
                                <input type="file" id="avatarUpload" name="avatar" class="d-none" accept="image/png, image/jpeg, image/jpg">
                            </div>

                            <div class="text-muted text-center mt-3" style="font-size: 12px;">
                                Hỗ trợ: JPG, PNG. Tối đa 2MB.
                            </div>
                        </div>
                    </div>

                    <!-- CỘT PHẢI: THÔNG TIN -->
                    <div class="col-xl-8 col-lg-7">

                        <div class="op-card mb-4">
                            <h6 class="fw-bold mb-4 brand-font text-dark border-bottom pb-3">Thông tin cá nhân</h6>

                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="fullName" value="${sessionScope.user.fullName}" required placeholder="Nhập họ tên đầy đủ">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email liên hệ <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="email" value="${sessionScope.user.email}" required placeholder="example@fruitfarmer.vn">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" value="${sessionScope.user.phone}" placeholder="Nhập số điện thoại...">
                                </div>
                                <!-- Đã xóa trường Ngày sinh (dob) bị lỗi -->
                                <div class="col-md-6">
                                    <!-- Căn layout cho đẹp khi bị khuyết 1 ô -->
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Địa chỉ liên hệ</label>
                                    <input type="text" class="form-control" name="address" value="${sessionScope.user.address}" placeholder="Nhập địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố)...">
                                </div>
                            </div>
                        </div>

                        <div class="op-card mb-4">
                            <div class="border-bottom pb-3 mb-4">
                                <h6 class="fw-bold brand-font text-dark mb-1">Bảo mật tài khoản</h6>
                                <div class="text-muted" style="font-size: 12px;">Để trống các trường dưới đây nếu bạn không muốn đổi mật khẩu.</div>
                            </div>

                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới...">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Xác nhận mật khẩu</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận lại mật khẩu...">
                                </div>
                            </div>

                            <!-- Báo lỗi Pass -->
                            <div id="passwordError" class="text-danger mt-3 fw-medium d-none bg-danger bg-opacity-10 p-2 rounded" style="font-size: 13px;">
                                <i class="ph-fill ph-warning-circle me-1"></i> Mật khẩu xác nhận không khớp, vui lòng kiểm tra lại!
                            </div>
                        </div>

                        <!-- LƯU THAY ĐỔI -->
                        <div class="text-end">
                            <button type="submit" class="btn-save" id="btnSubmitForm">
                                <i class="ph-bold ph-check-circle"></i> Lưu Thay Đổi
                            </button>
                        </div>

                    </div>
                </div>
            </form>

        </div>
    </main>
</div>

<!-- TOAST THÔNG BÁO -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center text-bg-success border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium fs-6"><i class="ph-fill ph-check-circle me-2 fs-5 align-middle"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center text-bg-danger border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body fw-medium fs-6"><i class="ph-fill ph-warning-circle me-2 fs-5 align-middle"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button></div>
        </div><c:remove var="errorMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var ts = [].slice.call(document.querySelectorAll('.toast'));
        ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());

        // CẬP NHẬT ẢNH PREVIEW KHI CHỌN FILE
        const avatarInput = document.getElementById('avatarUpload');
        const avatarPreview = document.getElementById('avatarPreview');
        const avatarPlaceholder = document.getElementById('avatarPlaceholder');

        if(avatarInput) {
            avatarInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(event) {
                        avatarPreview.src = event.target.result;
                        avatarPreview.classList.remove('d-none');
                        if(avatarPlaceholder) avatarPlaceholder.classList.add('d-none');
                    }
                    reader.readAsDataURL(file);
                }
            });
        }

        // CHẶN SUBMIT NẾU 2 MẬT KHẨU KHÔNG KHỚP
        const form = document.getElementById('profileForm');
        const newPw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmPassword');
        const pwError = document.getElementById('passwordError');

        form.addEventListener('submit', function(e) {
            if(newPw.value !== "" && newPw.value !== confirmPw.value) {
                e.preventDefault();
                pwError.classList.remove('d-none');
                confirmPw.focus();
            } else {
                pwError.classList.add('d-none');
            }
        });
    });
</script>
</body>
</html>