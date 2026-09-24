<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Khôi phục mật khẩu | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { background-color: #F9FAFB; font-family: 'Inter', sans-serif; }
        .auth-card { max-width: 420px; width: 100%; padding: 40px; border-radius: 16px; background: #fff; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid #EAEAEC; }
        .brand-font { font-family: 'DM Sans', sans-serif; font-weight: 700; color: #2F6B3F; }
        .btn-primary-custom { background-color: #2F6B3F; color: #fff; font-weight: 600; padding: 12px; border-radius: 8px; border: none; transition: 0.2s; font-size: 15px; }
        .btn-primary-custom:hover { background-color: #245530; color: #fff; }
        .form-control { padding: 12px 16px; border-radius: 8px; background: #F9FAFB; border: 1px solid #EAEAEC; }
        .form-control:focus { box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1); border-color: #2F6B3F; background: #fff; }
        .otp-input { text-align: center; font-size: 28px; letter-spacing: 12px; font-weight: 700; color: #2F6B3F; }
        .otp-input::placeholder { color: #ccc; font-weight: 400; letter-spacing: normal; font-size: 20px; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

    <div class="auth-card text-center">
        <!-- Logo -->
        <div class="mb-4 pb-2 border-bottom">
            <h2 class="brand-font fs-3 m-0"><i class="fa-solid fa-leaf"></i> Fruit Farmer.</h2>
            <p class="text-muted mt-2 mb-4" style="font-size: 14px;">Khôi phục quyền truy cập tài khoản</p>
        </div>

        <!-- Thông báo lỗi (Nếu có) -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger py-2 px-3 rounded-3 text-start d-flex align-items-center" style="font-size: 13.5px;">
                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i> ${errorMsg}
            </div>
            <% request.removeAttribute("errorMsg"); %>
        </c:if>

        <c:choose>
            <%-- ================= BƯỚC 1: NHẬP EMAIL ================= --%>
            <c:when test="${empty step || step == 'send_otp'}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="text-start">
                    <input type="hidden" name="action" value="send_otp">

                    <div class="mb-4">
                        <label class="form-label fw-medium text-dark" style="font-size: 14px;">Email đăng ký tài khoản</label>
                        <input type="email" name="email" class="form-control" placeholder="Nhập địa chỉ email của bạn..." required>
                    </div>

                    <button type="submit" class="btn-primary-custom w-100 mb-4">GỬI MÃ XÁC NHẬN</button>

                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/login" class="text-muted text-decoration-none fw-medium" style="font-size: 14px;">
                            <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Đăng nhập
                        </a>
                    </div>
                </form>
            </c:when>

            <%-- ================= BƯỚC 2: NHẬP MÃ OTP ================= --%>
            <c:when test="${step == 'verify_otp'}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="text-start">
                    <input type="hidden" name="action" value="verify_otp">

                    <div class="alert alert-success py-2 rounded-3 text-center mb-4 bg-success-subtle border-0 text-success" style="font-size: 13.5px;">
                        Mã xác nhận (6 số) đã được gửi tới<br><strong class="fs-6">${sessionScope.sessionEmail}</strong>
                    </div>

                    <div class="mb-4">
                        <input type="text" name="otp" class="form-control otp-input" placeholder="------" maxlength="6" required autocomplete="off">
                        <div class="text-center mt-3">
                            <span class="text-muted" style="font-size: 13px;"><i class="fa-regular fa-clock me-1"></i> Mã có hiệu lực trong 5 phút.</span>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary-custom w-100 mb-3">XÁC NHẬN MÃ</button>

                    <div class="text-center mt-2">
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-muted text-decoration-none" style="font-size: 13px; text-decoration: underline !important;">Thử địa chỉ Email khác</a>
                    </div>
                </form>
            </c:when>

            <%-- ================= BƯỚC 3: ĐỔI MẬT KHẨU MỚI ================= --%>
            <c:when test="${step == 'reset_password'}">
                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="text-start">
                    <input type="hidden" name="action" value="reset_password">

                    <div class="mb-3">
                        <label class="form-label fw-medium text-dark" style="font-size: 14px;">Mật khẩu mới</label>
                        <input type="password" name="newPassword" class="form-control" placeholder="Tối thiểu 6 ký tự" minlength="6" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-medium text-dark" style="font-size: 14px;">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
                    </div>

                    <button type="submit" class="btn-primary-custom w-100">ĐỔI MẬT KHẨU VÀ ĐĂNG NHẬP</button>
                </form>
            </c:when>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>