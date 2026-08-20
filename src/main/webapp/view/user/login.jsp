<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | Fruit Farmer Market</title>
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
            max-width: 420px;
            padding: 40px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-subtle);
        }
        .form-control {
            border-radius: var(--radius-sm);
            padding: 12px 16px;
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
                <p class="text-muted mt-2" style="font-size: 14px;">Chào mừng bạn quay trở lại.</p>
            </div>

            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2" style="font-size: 13px; border-radius: var(--radius-sm);">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold" style="font-size: 13px;">Email</label>
                    <!-- Tự động điền lại email nếu Cookie Remember Me còn hiệu lực -->
                    <input type="email" class="form-control" id="email" name="email" value="${cookie.rememberedEmail.value}" required>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="password" class="form-label fw-semibold mb-0" style="font-size: 13px;">Mật khẩu</label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none text-muted" style="font-size: 12px;">Quên mật khẩu?</a>
                    </div>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>

                <div class="mb-4 form-check">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember" ${not empty cookie.rememberedEmail ? 'checked' : ''}>
                    <label class="form-check-label text-muted" for="remember" style="font-size: 13px;">Ghi nhớ đăng nhập</label>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 mb-3">Đăng nhập</button>
            </form>

            <div class="text-center" style="font-size: 13px;">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-dark fw-semibold text-decoration-none border-bottom border-dark">Đăng ký ngay</a>
            </div>
        </div>
    </div>

</body>
</html>