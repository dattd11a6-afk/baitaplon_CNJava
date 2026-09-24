<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tùy chọn Thanh toán | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F9F8F4; color: #1F2937; }
        .checkout-box { background: #fff; border-radius: 12px; border: 1px solid #E5E7EB; padding: 40px; height: 100%; display: flex; flex-direction: column; transition: 0.3s; }
        .checkout-box:hover { box-shadow: 0 10px 30px rgba(0,0,0,0.05); border-color: #1F9D55; }
        .btn-google { background: #fff; border: 1px solid #E5E7EB; color: #374151; font-weight: 600; padding: 12px; border-radius: 8px; display: flex; align-items: center; justify-content: center; gap: 10px; transition: 0.2s; text-decoration: none; }
        .btn-google:hover { background: #F3F4F6; }
        .btn-guest { background: #1F9D55; color: #fff; font-weight: 600; padding: 12px; border-radius: 8px; display: block; text-align: center; transition: 0.2s; text-decoration: none; }
        .btn-guest:hover { background: #163D2A; color: #fff; }
        .badge-gift { background: #FEF2F2; color: #DC2626; font-size: 12px; font-weight: 600; padding: 4px 8px; border-radius: 4px; border: 1px dashed #F87171; }
    </style>
</head>
<body>
    <div class="container py-5 mt-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-dark mb-2">Bạn muốn thanh toán thế nào?</h2>
            <p class="text-muted">Chọn phương thức phù hợp để hoàn tất đơn hàng của bạn.</p>
        </div>

        <div class="row justify-content-center g-4 max-w-4xl mx-auto" style="max-width: 900px;">
            <!-- CỘT 1: MỒI NHỬ KHÁCH VIP (GOOGLE LOGIN) -->
            <div class="col-md-6">
                <div class="checkout-box position-relative">
                    <div class="position-absolute top-0 start-50 translate-middle badge bg-danger rounded-pill px-3 py-2 fs-6 shadow-sm">Khuyên dùng</div>
                    <div class="text-center mb-4 mt-2">
                        <i class="ph-fill ph-user-circle text-primary" style="font-size: 48px;"></i>
                        <h4 class="fw-bold mt-2">Khách hàng thành viên</h4>
                        <p class="text-muted" style="font-size: 14px;">Đăng nhập để tích điểm và theo dõi đơn hàng</p>
                    </div>

                    <a href="#" onclick="alert('Tính năng đang chờ Google xét duyệt quyền truy cập API!')" class="btn-google mb-3 w-100">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg" width="20" alt="Google">
                        Đăng nhập nhanh với Google
                    </a>
                    <div class="text-center mb-4">
                        <span class="badge-gift"><i class="ph-fill ph-gift"></i> Tặng ngay Voucher 10% khi liên kết Gmail</span>
                    </div>

                    <div class="text-center text-muted mb-3" style="font-size: 12px;">hoặc đăng nhập bằng mật khẩu</div>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary w-100 fw-medium">Đăng nhập tài khoản thường</a>
                </div>
            </div>

            <!-- CỘT 2: KHÁCH VÃNG LAI (MUA NHANH) -->
            <div class="col-md-6">
                <div class="checkout-box bg-light">
                    <div class="text-center mb-4 mt-2">
                        <i class="ph-fill ph-shopping-bag text-success" style="font-size: 48px;"></i>
                        <h4 class="fw-bold mt-2">Khách vãng lai</h4>
                        <p class="text-muted" style="font-size: 14px;">Mua hàng nhanh không cần tạo tài khoản</p>
                    </div>

                    <ul class="list-unstyled text-muted mb-4 mt-2 px-3" style="font-size: 14px;">
                        <li class="mb-3"><i class="ph-fill ph-check-circle text-success me-2"></i>Thanh toán siêu tốc trong 30 giây</li>
                        <li class="mb-3"><i class="ph-fill ph-check-circle text-success me-2"></i>Chỉ cần nhập thông tin giao hàng</li>
                        <li class="mb-3 text-secondary"><i class="ph-fill ph-x-circle me-2"></i>Không lưu lịch sử đơn hàng</li>
                        <li class="text-secondary"><i class="ph-fill ph-x-circle me-2"></i>Không được tích điểm hạng thành viên</li>
                    </ul>

                    <div class="mt-auto">
                        <!-- Nút này sẽ bắn tham số ?type=guest lên URL -->
                        <a href="${pageContext.request.contextPath}/checkout?type=guest" class="btn-guest">Tiếp tục thanh toán <i class="ph-bold ph-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>