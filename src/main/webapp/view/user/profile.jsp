<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tài khoản của tôi | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { background-color: #F3F4F6; font-family: 'Inter', sans-serif; color: #1F2937; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* Card & Form Styles */
        .profile-card { background: #fff; border-radius: 16px; border: none; padding: 32px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); }
        .form-control, .form-select { border-radius: 8px; padding: 12px 16px; border-color: #E5E7EB; background-color: #F9FAFB; font-size: 14px; }
        .form-control:focus, .form-select:focus { border-color: #2F6B3F; box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1); background-color: #fff; }
        .btn-success-custom { background-color: #2F6B3F; color: #fff; font-weight: 600; padding: 12px 24px; border-radius: 8px; border: none; transition: 0.2s; }
        .btn-success-custom:hover { background-color: #245530; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(47, 107, 63, 0.2); }
        .btn-upload-avt { background: #F3F4F6; border: 1px solid #E5E7EB; padding: 6px 16px; border-radius: 99px; font-size: 13px; color: #4B5563; font-weight: 500; transition: 0.2s; display: inline-block; }
        .btn-upload-avt:hover { background: #E5E7EB; color: #1F2937; }

        /* ================= BASE THẺ THÀNH VIÊN ================= */
        .membership-card {
            border-radius: 16px; padding: 24px; position: relative; overflow: hidden;
            transition: all 0.2s ease; color: white; cursor: pointer; border: 2px solid transparent;
        }
        .membership-card:hover { transform: translateY(-3px); border-color: rgba(255,255,255,0.5); }
        .membership-card::before {
            font-family: "Font Awesome 6 Free"; font-weight: 900; position: absolute;
            right: -20px; bottom: -30px; font-size: 140px; opacity: 0.15; transform: rotate(-15deg);
        }

        /* ================= 4 HẠNG THÀNH VIÊN ================= */
        .card-bronze { background: linear-gradient(135deg, #A86539, #CD853F); box-shadow: 0 10px 20px rgba(176, 106, 59, 0.3); --tier-color: #CD853F;}
        .card-bronze::before { content: "\f005"; }

        .card-silver { background: linear-gradient(135deg, #7F8C8D, #BDC3C7); box-shadow: 0 10px 20px rgba(127, 140, 141, 0.3); color: #1F2937; --tier-color: #7F8C8D;}
        .card-silver::before { content: "\f5a2"; opacity: 0.1; }

        .card-gold { background: linear-gradient(135deg, #D4AF37, #F3E5AB); box-shadow: 0 10px 20px rgba(212, 175, 55, 0.4); color: #5C4033; --tier-color: #D4AF37;}
        .card-gold::before { content: "\f521"; opacity: 0.15; }

        .card-diamond { background: linear-gradient(135deg, #1E3A8A, #3B82F6); box-shadow: 0 10px 25px rgba(59, 130, 246, 0.4); --tier-color: #3B82F6;}
        .card-diamond::before { content: "\f219"; }

        /* ================= LIGHT MODAL (NEW) ================= */
        .tier-row { transition: 0.2s; border-bottom: 1px solid #E5E7EB; }
        .tier-row:last-child { border-bottom: none; }
        .tier-row:hover { background-color: #F9FAFB; }
        .tier-row.active-tier { background-color: #ECFDF5; position: relative; } /* Xanh lá nhạt */
        .tier-row.active-tier::before {
            content: ""; position: absolute; left: 0; top: 0; bottom: 0; width: 4px; background-color: #10B981; border-top-right-radius: 4px; border-bottom-right-radius: 4px;
        }
    </style>
</head>
<body>
    <%-- LẤY DỮ LIỆU THẬT TỪ SERVLET TRUYỀN SANG --%>
    <c:set var="spend" value="${totalSpend != null ? totalSpend : 0}" />

    <%-- LOGIC CHIA HẠNG & TÍNH TIẾN ĐỘ --%>
    <c:choose>
        <c:when test="${spend >= 50000000}">
            <c:set var="tierLevel" value="4" />
            <c:set var="tierName" value="Thành viên Diamond" />
            <c:set var="tierClass" value="card-diamond" />
            <c:set var="nextTierSpend" value="0" />
        </c:when>
        <c:when test="${spend >= 30000000}">
            <c:set var="tierLevel" value="3" />
            <c:set var="tierName" value="Thành viên Gold" />
            <c:set var="tierClass" value="card-gold" />
            <c:set var="nextTierSpend" value="50000000" />
        </c:when>
        <c:when test="${spend >= 10000000}">
            <c:set var="tierLevel" value="2" />
            <c:set var="tierName" value="Thành viên Silver" />
            <c:set var="tierClass" value="card-silver" />
            <c:set var="nextTierSpend" value="30000000" />
        </c:when>
        <c:otherwise>
            <c:set var="tierLevel" value="1" />
            <c:set var="tierName" value="Thành viên Bronze" />
            <c:set var="tierClass" value="card-bronze" />
            <c:set var="nextTierSpend" value="10000000" />
        </c:otherwise>
    </c:choose>

    <%-- Tính % progress bar (Tối đa 100%) --%>
    <c:set var="progressPercent" value="${nextTierSpend > 0 ? (spend / nextTierSpend) * 100 : 100}" />
    <c:if test="${progressPercent > 100}"><c:set var="progressPercent" value="100" /></c:if>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg border-bottom bg-white sticky-top shadow-sm">
        <div class="container py-1">
            <a class="navbar-brand text-success brand-font fw-bold fs-4" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-leaf"></i> Fruit Farmer.</a>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none fw-medium"><i class="fa-solid fa-arrow-left me-1"></i> Quay lại Cửa hàng</a>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row g-4">
            <!-- CỘT TRÁI: AVATAR & THẺ THÀNH VIÊN -->
            <div class="col-lg-4">
                <div class="profile-card p-4 mb-4 text-center" style="background: transparent; box-shadow: none;">

                    <!-- Avatar & Info -->
                    <div class="mb-4">
                        <div class="position-relative d-inline-block mb-3">
                            <img src="${sessionScope.user.avatar != null ? pageContext.request.contextPath.concat('/assets/images/users/').concat(sessionScope.user.avatar) : 'https://ui-avatars.com/api/?name='.concat(sessionScope.user.fullName != null ? sessionScope.user.fullName : 'U').concat('&background=random')}"
                                 class="rounded-circle shadow-sm object-fit-cover"
                                 style="width: 110px; height: 110px; border: 4px solid var(--tier-color); background: #fff;" alt="Avatar">
                        </div>
                        <div>
                            <a href="#" class="btn-upload-avt text-decoration-none shadow-sm"><i class="fa-solid fa-camera me-1"></i> Đổi ảnh</a>
                        </div>
                        <h4 class="fw-bold mt-4 mb-1 brand-font text-dark">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Thành viên mới'}</h4>
                        <div class="text-muted" style="font-size: 14px;">${sessionScope.user.email}</div>
                    </div>

                    <!-- Thẻ Thành Viên (Clickable) -->
                    <div class="membership-card ${tierClass} text-start shadow" data-bs-toggle="modal" data-bs-target="#rankModal">
                        <div class="text-uppercase fw-bold mb-4" style="font-size: 11px; letter-spacing: 1px; opacity: 0.9;">
                            ${tierName}
                        </div>
                        <h4 class="brand-font fw-bold text-uppercase m-0 pb-2">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'NEW MEMBER'}</h4>
                        <div class="mt-2 pt-2 border-top border-light border-opacity-25 d-flex justify-content-between align-items-center" style="font-size: 13px;">
                            <span>Đã chi: <fmt:formatNumber value="${spend}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            <span class="fw-medium bg-white bg-opacity-25 px-2 py-1 rounded-pill" style="font-size: 11px;">Xem hạng <i class="fa-solid fa-chevron-right ms-1" style="font-size: 10px;"></i></span>
                        </div>
                    </div>
                </div>

                <div class="profile-card p-3">
                    <div class="list-group list-group-flush">
                        <a href="#" class="list-group-item list-group-item-action border-0 fw-semibold text-success bg-success-subtle rounded"><i class="fa-regular fa-user me-2"></i> Hồ sơ cá nhân</a>
                        <a href="${pageContext.request.contextPath}/orders/history" class="list-group-item list-group-item-action border-0 text-muted"><i class="fa-solid fa-clipboard-list me-2"></i> Lịch sử đơn hàng</a>
                        <a href="${pageContext.request.contextPath}/logout" class="list-group-item list-group-item-action border-0 text-danger mt-3"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Đăng xuất</a>
                    </div>
                </div>
            </div>

            <!-- CỘT PHẢI: FORM CẬP NHẬT -->
            <div class="col-lg-8">
                <div class="profile-card">
                    <h4 class="brand-font fw-bold mb-1">Hồ Sơ Của Tôi</h4>
                    <p class="text-muted mb-4 pb-3 border-bottom" style="font-size: 14px;">Quản lý thông tin hồ sơ để bảo mật tài khoản và giao hàng chính xác.</p>

                    <form action="${pageContext.request.contextPath}/profile" method="POST" id="profileForm">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="row mb-3 align-items-center">
                            <div class="col-md-3 text-md-end text-muted fw-medium" style="font-size: 14px;">Email đăng nhập</div>
                            <div class="col-md-9"><input type="text" class="form-control text-muted" value="${sessionScope.user.email}" readonly disabled></div>
                        </div>

                        <div class="row mb-3 align-items-center">
                            <div class="col-md-3 text-md-end text-muted fw-medium" style="font-size: 14px;">Họ và tên</div>
                            <div class="col-md-9"><input type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required></div>
                        </div>

                        <div class="row mb-4 align-items-center">
                            <div class="col-md-3 text-md-end text-muted fw-medium" style="font-size: 14px;">Số điện thoại</div>
                            <div class="col-md-9"><input type="text" name="phone" class="form-control" value="${sessionScope.user.phone}" required pattern="[0-9]{10,11}"></div>
                        </div>

                        <!-- KHU VỰC ĐỊA CHỈ ĐỘNG - JSON -->
                        <h6 class="fw-bold mb-3 mt-4 pt-4 border-top"><i class="fa-solid fa-location-dot text-danger me-2"></i>Sổ địa chỉ Giao hàng</h6>
                        <input type="hidden" id="fullAddress" name="address" value="${sessionScope.user.address}">

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="form-label text-muted" style="font-size: 12px;">Tỉnh / Thành phố</label>
                                <select class="form-select" id="tinh" required><option value="">-- Chọn Tỉnh/Thành phố --</option></select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted" style="font-size: 12px;">Quận / Huyện</label>
                                <select class="form-select" id="quan" required disabled><option value="">-- Chọn Quận/Huyện --</option></select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-muted" style="font-size: 12px;">Phường / Xã</label>
                                <select class="form-select" id="phuong" required disabled><option value="">-- Chọn Phường/Xã --</option></select>
                            </div>
                        </div>

                        <div class="row mb-4">
                            <div class="col-12">
                                <label class="form-label text-muted" style="font-size: 12px;">Địa chỉ cụ thể (Số nhà, Tên đường)</label>
                                <input type="text" class="form-control" id="sonha" placeholder="VD: Số 89, Ngõ 12 Lê Đức Thọ" required>
                            </div>
                        </div>

                        <div class="row mt-4">
                            <div class="col-md-9 offset-md-3">
                                <button type="button" class="btn-success-custom w-100" onclick="submitProfileForm()">Lưu Cập Nhật</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== MODAL ĐẶC QUYỀN HẠNG (LIGHT MODE + UX) ==================== -->
    <div class="modal fade" id="rankModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header border-bottom p-4 pb-3">
                    <h5 class="modal-title fw-bold text-dark brand-font"><i class="fa-solid fa-ranking-star text-warning me-2"></i>Đặc quyền & Hạng thành viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 bg-light rounded-bottom-4">

                    <!-- Progress Bar Nâng Cấp UX -->
                    <div class="bg-white p-4 rounded-3 shadow-sm mb-4 border border-light">
                        <div class="d-flex justify-content-between align-items-end mb-2">
                            <div>
                                <div class="text-muted fw-medium mb-1" style="font-size: 12px;">CHI TIÊU TÍCH LŨY</div>
                                <h4 class="fw-bold text-dark m-0"><fmt:formatNumber value="${spend}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h4>
                            </div>
                            <c:if test="${tierLevel < 4}">
                                <div class="text-end">
                                    <div class="text-muted fw-medium mb-1" style="font-size: 12px;">MỤC TIÊU LÊN HẠNG</div>
                                    <div class="text-dark" style="font-size: 13px;">Cần thêm <strong class="text-success"><fmt:formatNumber value="${nextTierSpend - spend}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong></div>
                                </div>
                            </c:if>
                            <c:if test="${tierLevel == 4}">
                                <div class="badge bg-primary px-3 py-2 rounded-pill">Bạn đã đạt hạng cao nhất!</div>
                            </c:if>
                        </div>
                        <div class="progress mt-3" style="height: 8px; background-color: #E5E7EB;">
                            <div class="progress-bar bg-success rounded-pill" role="progressbar" style="width: ${progressPercent}%;"></div>
                        </div>
                    </div>

                    <!-- Bảng Hạng (Sáng sủa, sạch sẽ) -->
                    <div class="bg-white rounded-3 shadow-sm border border-light overflow-hidden">
                        <div class="row text-muted fw-bold py-3 px-4 bg-light border-bottom" style="font-size: 11px; letter-spacing: 1px;">
                            <div class="col-3">HẠNG</div>
                            <div class="col-3">ƯU ĐÃI MUA SẮM</div>
                            <div class="col-3">GIẢM TỐI ĐA</div>
                            <div class="col-3">ĐƠN TỐI THIỂU</div>
                        </div>

                        <!-- Hạng Đồng -->
                        <div class="row align-items-center py-3 px-4 tier-row ${tierLevel == 1 ? 'active-tier' : ''}">
                            <div class="col-3">
                                <div class="fw-bold" style="color: #CD853F; font-size: 15px;"><i class="fa-solid fa-star me-1"></i> Đồng</div>
                                <div class="text-muted mt-1" style="font-size: 12px;">Dưới 10 triệu</div>
                            </div>
                            <div class="col-3 fw-bold text-dark">Giảm 2%</div>
                            <div class="col-3 text-muted">0,1 triệu</div>
                            <div class="col-3 d-flex justify-content-between align-items-center text-muted">
                                <span>10 triệu</span>
                                <c:if test="${tierLevel == 1}"><span class="badge bg-success rounded-pill px-2 py-1" style="font-size: 10px;">HẠNG CỦA BẠN</span></c:if>
                            </div>
                        </div>

                        <!-- Hạng Bạc -->
                        <div class="row align-items-center py-3 px-4 tier-row ${tierLevel == 2 ? 'active-tier' : ''}">
                            <div class="col-3">
                                <div class="fw-bold" style="color: #7F8C8D; font-size: 15px;"><i class="fa-solid fa-medal me-1"></i> Bạc</div>
                                <div class="text-muted mt-1" style="font-size: 12px;">Từ 10 triệu</div>
                            </div>
                            <div class="col-3 fw-bold text-dark">Giảm 6%</div>
                            <div class="col-3 text-muted">1,5 triệu</div>
                            <div class="col-3 d-flex justify-content-between align-items-center text-muted">
                                <span>20 triệu</span>
                                <c:if test="${tierLevel == 2}"><span class="badge bg-success rounded-pill px-2 py-1" style="font-size: 10px;">HẠNG CỦA BẠN</span></c:if>
                            </div>
                        </div>

                        <!-- Hạng Vàng -->
                        <div class="row align-items-center py-3 px-4 tier-row ${tierLevel == 3 ? 'active-tier' : ''}">
                            <div class="col-3">
                                <div class="fw-bold" style="color: #D4AF37; font-size: 15px;"><i class="fa-solid fa-crown me-1"></i> Vàng</div>
                                <div class="text-muted mt-1" style="font-size: 12px;">Từ 30 triệu</div>
                            </div>
                            <div class="col-3 fw-bold text-dark">Giảm 8%</div>
                            <div class="col-3 text-muted">2,5 triệu</div>
                            <div class="col-3 d-flex justify-content-between align-items-center text-muted">
                                <span>30 triệu</span>
                                <c:if test="${tierLevel == 3}"><span class="badge bg-success rounded-pill px-2 py-1" style="font-size: 10px;">HẠNG CỦA BẠN</span></c:if>
                            </div>
                        </div>

                        <!-- Hạng Kim Cương -->
                        <div class="row align-items-center py-3 px-4 tier-row ${tierLevel == 4 ? 'active-tier' : ''}">
                            <div class="col-3">
                                <div class="fw-bold" style="color: #3B82F6; font-size: 15px;"><i class="fa-regular fa-gem me-1"></i> Kim cương</div>
                                <div class="text-muted mt-1" style="font-size: 12px;">Từ 50 triệu</div>
                            </div>
                            <div class="col-3 fw-bold text-dark">Giảm 15%</div>
                            <div class="col-3 text-muted">3,5 triệu</div>
                            <div class="col-3 d-flex justify-content-between align-items-center text-muted">
                                <span>50 triệu</span>
                                <c:if test="${tierLevel == 4}"><span class="badge bg-success rounded-pill px-2 py-1" style="font-size: 10px;">HẠNG CỦA BẠN</span></c:if>
                            </div>
                        </div>
                    </div>

                    <div class="text-center text-muted mt-4" style="font-size: 12px;">
                        <i class="fa-solid fa-circle-info me-1"></i> Ưu đãi được áp dụng tự động lúc thanh toán dựa trên chi tiêu tích lũy của tài khoản.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST THÔNG BÁO -->
    <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100;">
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast align-items-center text-bg-success border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;">
                        <i class="fa-solid fa-circle-check me-2 fs-5"></i> ${sessionScope.successMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast align-items-center text-bg-danger border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body fw-medium d-flex align-items-center" style="font-size: 14px; padding: 12px 16px;">
                        <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i> ${sessionScope.errorMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-3 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Kích hoạt Toast
        document.addEventListener("DOMContentLoaded", function() {
            var ts = [].slice.call(document.querySelectorAll('.toast'));
            ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3500 }); }).forEach(t => t.show());
        });

        // LOAD DATA ĐỊA CHỈ TỪ JSON
        fetch("https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json")
            .then(response => response.json())
            .then(data => {
                let tinhSelect = document.getElementById("tinh");
                let quanSelect = document.getElementById("quan");
                let phuongSelect = document.getElementById("phuong");

                data.forEach(tinh => { tinhSelect.options.add(new Option(tinh.Name, tinh.Id)); });

                tinhSelect.addEventListener("change", function() {
                    quanSelect.options.length = 1; phuongSelect.options.length = 1; quanSelect.disabled = false;
                    if (this.value !== "") {
                        const selectedTinh = data.find(n => n.Id === this.value);
                        selectedTinh.Districts.forEach(quan => { quanSelect.options.add(new Option(quan.Name, quan.Id)); });
                    } else { quanSelect.disabled = true; phuongSelect.disabled = true; }
                });

                quanSelect.addEventListener("change", function() {
                    phuongSelect.options.length = 1; phuongSelect.disabled = false;
                    if (this.value !== "") {
                        const selectedTinh = data.find(n => n.Id === tinhSelect.value);
                        const selectedQuan = selectedTinh.Districts.find(n => n.Id === this.value);
                        selectedQuan.Wards.forEach(phuong => { phuongSelect.options.add(new Option(phuong.Name, phuong.Id)); });
                    } else { phuongSelect.disabled = true; }
                });
            })
            .catch(error => console.error("Lỗi tải dữ liệu địa chỉ:", error));

        function submitProfileForm() {
            const tinh = document.getElementById("tinh");
            const quan = document.getElementById("quan");
            const phuong = document.getElementById("phuong");
            const sonha = document.getElementById("sonha").value.trim();

            if(!tinh.value || !quan.value || !phuong.value || !sonha) {
                alert("Vui lòng chọn đầy đủ Tỉnh, Quận, Phường và nhập số nhà cụ thể nhé!"); return;
            }
            const tenTinh = tinh.options[tinh.selectedIndex].text;
            const tenQuan = quan.options[quan.selectedIndex].text;
            const tenPhuong = phuong.options[phuong.selectedIndex].text;

            document.getElementById("fullAddress").value = sonha + ", " + tenPhuong + ", " + tenQuan + ", " + tenTinh;
            document.getElementById("profileForm").submit();
        }
    </script>
</body>
</html>