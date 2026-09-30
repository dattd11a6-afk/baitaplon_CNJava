<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân | Shipper App</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=DM+Sans:wght@500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root {
            --ship-primary: #F59E0B; --ship-sidebar: #18181B; --ship-bg: #F4F4F5;
            --text-main: #1F2937; --text-muted: #6B7280;
        }
        body { background-color: var(--ship-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* SIDEBAR */
        .sidebar { width: 250px; background-color: var(--ship-sidebar); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--ship-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff;}
        .sidebar-menu { list-style: none; padding: 0; margin: 20px 0 0 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 20px; color: #A1A1AA; text-decoration: none; font-weight: 500; font-size: 14px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: var(--ship-primary); background-color: rgba(245, 158, 11, 0.1); border-left-color: var(--ship-primary); font-weight: 600; }

        /* MAIN CONTENT & HEADER */
        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }
        .ship-header { height: 70px; background: #fff; padding: 0 30px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #E4E4E7; position: sticky; top: 0; z-index: 10; }
        .page-body { padding: 30px; flex-grow: 1; }

        /* CARDS */
        .op-card { background: #fff; border: 1px solid #E4E4E7; border-radius: 12px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.02); margin-bottom: 24px; }

        .avatar-placeholder { width: 120px; height: 120px; border-radius: 50%; background: #FEF3C7; color: #D97706; display: flex; align-items: center; justify-content: center; font-size: 48px; font-weight: bold; border: 4px solid #fff; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin: 0 auto; }
        .user-chip { display: flex; align-items: center; gap: 10px; background: #FAFAFA; padding: 6px 16px 6px 6px; border-radius: 50px; border: 1px solid #E4E4E7; cursor: pointer; transition: 0.2s;}
        .user-chip:hover { background: #F4F4F5; }
        .user-avatar { width: 32px; height: 32px; background: var(--ship-primary); color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }

        /* TOAST ZOTECH SHIPPER */
        .toast-zotech { background-color: #10B981; color: white; border-radius: 8px; padding: 12px 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; border: none; font-size: 14px; font-weight: 500;}
        .toast-zotech-danger { background-color: #DC2626; color: white; border-radius: 8px; padding: 12px 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 12px; border: none; font-size: 14px; font-weight: 500;}
    </style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="ph-bold ph-moped"></i></div>
            <div>
                <div class="fw-bold brand-font text-white" style="font-size: 16px;">Delivery App</div>
                <div style="font-size: 10px; color: var(--ship-primary); font-weight: 700; letter-spacing: 1px;">SHIPPER PORTAL</div>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/shipper/home"><i class="ph-fill ph-house"></i> Tổng quan</a></li>
            <li><a href="${pageContext.request.contextPath}/shipper/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng của tôi</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/shipper/profile"><i class="ph-fill ph-user-circle"></i> Tài khoản cá nhân</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="ship-header">
            <h5 class="fw-bold m-0 brand-font">Hồ sơ cá nhân</h5>
            <div class="dropdown">
                <div class="user-chip dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                    <div class="user-avatar">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                    <div class="user-info d-flex flex-column text-start">
                        <span class="fw-bold" style="font-size: 13px; line-height: 1;">${sessionScope.user.fullName}</span>
                        <span class="text-muted" style="font-size: 11px;">Tài xế giao hàng</span>
                    </div>
                </div>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2" style="border-radius: 12px; width: 200px;">
                    <li><a class="dropdown-item py-2 fw-medium text-danger" href="${pageContext.request.contextPath}/logout"><i class="ph-bold ph-sign-out me-2"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </header>

        <div class="page-body">
            <!-- Đã gỡ bỏ Alert vuông -->

            <div class="row g-4">
                <!-- CỘT TRÁI: AVATAR -->
                <div class="col-xl-4 col-lg-5">
                    <div class="op-card text-center text-md-start text-lg-center">
                        <h6 class="fw-bold mb-4 brand-font text-dark text-start border-bottom pb-3">Tài khoản</h6>
                        <div class="d-flex flex-column align-items-center mb-4 mt-2">
                            <div class="avatar-placeholder mb-3">${sessionScope.user != null ? fn:substring(sessionScope.user.fullName, 0, 1) : 'S'}</div>
                            <div class="fw-bold text-dark fs-4 mb-1">${sessionScope.user.fullName}</div>
                            <div class="badge px-3 py-1 mt-1 text-dark" style="background: var(--ship-primary); font-size: 12px; border-radius: 20px;">ĐỐI TÁC GIAO HÀNG (SHIPPER)</div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: THÔNG TIN & ĐỔI PASS -->
                <div class="col-xl-8 col-lg-7">
                    <div class="op-card">
                        <h6 class="fw-bold mb-4 brand-font text-dark border-bottom pb-3">Thông tin liên hệ</h6>
                        <div class="row g-4 mb-5">
                            <div class="col-md-6">
                                <label class="fw-semibold text-muted mb-2 fs-6">Họ và tên</label>
                                <input type="text" class="form-control form-control-lg bg-light" value="${sessionScope.user.fullName}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="fw-semibold text-muted mb-2 fs-6">Số điện thoại</label>
                                <input type="text" class="form-control form-control-lg bg-light" value="${sessionScope.user.phone}" readonly>
                            </div>
                            <div class="col-12">
                                <label class="fw-semibold text-muted mb-2 fs-6">Email liên hệ</label>
                                <input type="text" class="form-control form-control-lg bg-light" value="${sessionScope.user.email}" readonly>
                            </div>
                        </div>

                        <h6 class="fw-bold mb-4 brand-font text-dark border-bottom pb-3">Đổi mật khẩu bảo mật</h6>
                        <form action="${pageContext.request.contextPath}/shipper/profile" method="POST" id="profileForm">
                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="fw-semibold text-muted mb-2 fs-6">Mật khẩu mới</label>
                                    <input type="password" class="form-control form-control-lg" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="fw-semibold text-muted mb-2 fs-6">Xác nhận mật khẩu</label>
                                    <input type="password" class="form-control form-control-lg" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận lại" required>
                                </div>
                            </div>
                            <div id="passwordError" class="text-danger mt-3 fw-medium d-none bg-danger bg-opacity-10 p-3 rounded-3 mb-4" style="font-size: 14px;">
                                <i class="ph-fill ph-warning-circle me-1"></i> Mật khẩu xác nhận không khớp!
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn text-dark fw-bold px-5 py-3 fs-6" style="background: var(--ship-primary); border-radius: 8px;">CẬP NHẬT MẬT KHẨU</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- TOAST ZOTECH ĐỒNG BỘ -->
<div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="toast align-items-center border-0 toast-zotech" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex w-100 align-items-center justify-content-between">
                <div><i class="ph-fill ph-check-circle me-2 fs-5"></i> ${sessionScope.successMsg}</div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="toast align-items-center border-0 toast-zotech-danger" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex w-100 align-items-center justify-content-between">
                <div><i class="ph-fill ph-warning-circle me-2 fs-5"></i> ${sessionScope.errorMsg}</div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
        </div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var ts = [].slice.call(document.querySelectorAll('.toast'));
        ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());

        const form = document.getElementById('profileForm');
        const newPw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmPassword');
        const pwError = document.getElementById('passwordError');

        form.addEventListener('submit', function(e) {
            if(newPw.value !== confirmPw.value) {
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