<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--bg-main);
            padding: 24px;
        }
        .auth-card {
            background: var(--bg-surface);
            width: 100%;
            max-width: 560px; /* Rộng hơn form login một chút */
            padding: 40px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-subtle);
        }
        .form-control {
            border-radius: var(--radius-sm);
            padding: 10px 16px;
            border: 1px solid var(--border-light);
            font-size: 14px;
        }
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: none;
        }
    </style>
</head>
<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="text-center mb-4">
                <a href="${pageContext.request.contextPath}/" class="text-decoration-none brand-font text-success" style="font-size: 24px;">Fruit Farmer.</a>
                <p class="text-muted mt-2" style="font-size: 14px;">Bắt đầu hành trình sống khỏe mỗi ngày.</p>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2" style="font-size: 13px; border-radius: var(--radius-sm);">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold" style="font-size: 13px;">Họ và tên</label>
                        <input type="text" class="form-control" name="fullName" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold" style="font-size: 13px;">Số điện thoại</label>
                        <input type="tel" class="form-control" name="phone" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold" style="font-size: 13px;">Email</label>
                    <input type="email" class="form-control" name="email" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-4">
                        <label class="form-label fw-semibold" style="font-size: 13px;">Mật khẩu</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="col-md-6 mb-4">
                        <label class="form-label fw-semibold" style="font-size: 13px;">Xác nhận mật khẩu</label>
                        <input type="password" class="form-control" name="confirmPassword" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 mb-3">Tạo tài khoản</button>
            </form>

            <div class="text-center" style="font-size: 13px;">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-dark fw-semibold text-decoration-none border-bottom border-dark">Đăng nhập</a>
            </div>
        </div>
    </div>

</body>
</html>