<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tự Mix Giỏ Quà | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        body { background-color: #F9F8F4; font-family: 'Inter', sans-serif; color: #1F2937; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        /* Stepper */
        .stepper { display: flex; align-items: center; justify-content: center; gap: 20px; margin-bottom: 40px; padding: 20px 0; border-bottom: 1px solid #E5E7EB; }
        .step-item { display: flex; align-items: center; gap: 10px; font-weight: 600; color: #9CA3AF; transition: 0.3s; }
        .step-item.active { color: #1F9D55; }
        .step-item.completed { color: #1F2937; cursor: pointer; }
        .step-circle { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: #F3F4F6; font-size: 14px; }
        .step-item.active .step-circle { background: #1F9D55; color: #fff; }
        .step-item.completed .step-circle { background: #1F2937; color: #fff; }

        /* Step Content (Ẩn hiện) */
        .step-content { display: none; animation: fadeIn 0.4s ease; }
        .step-content.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Card & UI */
        .bg-white-card { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); border: 1px solid #E5E7EB; }

        /* Nút Tăng/Giảm Số Lượng */
        .qty-controls { display: flex; align-items: center; border: 1px solid #E5E7EB; border-radius: 8px; overflow: hidden; background: #fff; }
        .btn-qty { border: none; background: #F9FAFB; padding: 6px 12px; font-weight: bold; color: #1F2937; cursor: pointer; transition: 0.2s; }
        .btn-qty:hover { background: #E5E7EB; }
        .input-qty { width: 40px; text-align: center; border: none; font-weight: 600; outline: none; }

        /* Radio Card (Giỏ, Trang trí, Đóng gói) */
        .radio-card { border: 2px solid #E5E7EB; border-radius: 12px; padding: 16px; cursor: pointer; transition: 0.2s; display: block; text-align: center; height: 100%; }
        .radio-card input[type="radio"] { display: none; }
        .radio-card:hover { border-color: #1F9D55; }
        .radio-card input[type="radio"]:checked + .radio-content { border-color: transparent; }
        .radio-card:has(input[type="radio"]:checked) { border-color: #1F9D55; background-color: #F0FDF4; box-shadow: 0 4px 12px rgba(31, 157, 85, 0.15); }
        .radio-img { width: 80px; height: 80px; object-fit: contain; margin-bottom: 12px; mix-blend-mode: multiply; }

        /* Summary Panel */
        .summary-panel { position: sticky; top: 100px; border-top: 4px solid #1F9D55; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: #4B5563; }
        .summary-row.total { font-size: 20px; font-weight: 700; color: #1F2937; border-top: 1px dashed #E5E7EB; padding-top: 16px; margin-top: 16px; }

        .btn-next { background: #1F2937; color: #fff; border: none; padding: 14px; border-radius: 8px; font-weight: 600; width: 100%; transition: 0.2s; }
        .btn-next:hover:not(:disabled) { background: #111827; }
        .btn-next:disabled { background: #D1D5DB; cursor: not-allowed; }
    </style>
</head>
<body>

    <!-- NAV BAR (Placeholder) -->
    <nav class="navbar bg-white sticky-top shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand text-success brand-font fw-bold fs-4 m-0" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <span class="fw-bold text-muted brand-font border-start ps-3 border-2">Mix Giỏ Quà Cao Cấp</span>
        </div>
    </nav>

    <div class="container py-4">
        <!-- STEPPER -->
        <div class="stepper">
            <div class="step-item active" id="step-nav-1" onclick="goToStep(1)">
                <div class="step-circle">01</div> Chọn trái cây
            </div>
            <i class="ph-bold ph-caret-right text-muted mx-2"></i>
            <div class="step-item" id="step-nav-2" onclick="goToStep(2)">
                <div class="step-circle">02</div> Chọn giỏ
            </div>
            <i class="ph-bold ph-caret-right text-muted mx-2"></i>
            <div class="step-item" id="step-nav-3" onclick="goToStep(3)">
                <div class="step-circle">03</div> Thiệp & Đóng gói
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/gift-basket" method="POST" id="giftBasketForm">
            <div class="row g-4">

                <!-- CỘT TRÁI: WORKSPACE -->
                <div class="col-lg-8">

                    <!-- ================= BƯỚC 1: CHỌN TRÁI CÂY ================= -->
                    <div class="step-content active" id="step-1">
                        <h4 class="brand-font fw-bold mb-1">Chọn trái cây cho giỏ quà</h4>
                        <p class="text-muted mb-4">Chọn những loại trái cây bạn muốn gửi tặng (ít nhất 1 loại).</p>

                        <div class="row g-3">
                            <c:forEach var="p" items="${fruits}">
                                <div class="col-md-4 col-6">
                                    <div class="bg-white-card text-center p-3 h-100 d-flex flex-column">
                                        <img src="${p.image}" alt="${p.name}" class="img-fluid mb-2" style="height: 120px; object-fit: contain;">
                                        <div class="fw-bold text-dark text-truncate mb-1" style="font-size: 14px;">${p.name}</div>
                                        <div class="text-success fw-bold mb-3" style="font-size: 15px;">
                                            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> <span class="text-muted fw-normal" style="font-size: 12px;">/ ${p.unit}</span>
                                        </div>

                                        <div class="mt-auto d-flex justify-content-center">
                                            <div class="qty-controls">
                                                <button type="button" class="btn-qty" onclick="changeQty(${p.id}, ${p.price}, -1)">-</button>
                                                <!-- Input ẩn báo cho Servlet, input text hiển thị cho User -->
                                                <input type="text" class="input-qty" id="qty_display_${p.id}" value="0" readonly>
                                                <input type="hidden" name="fruit_qty_${p.id}" id="qty_value_${p.id}" value="0">
                                                <button type="button" class="btn-qty" onclick="changeQty(${p.id}, ${p.price}, 1)" ${p.stock <= 0 ? 'disabled' : ''}>+</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- ================= BƯỚC 2: CHỌN GIỎ ================= -->
                    <div class="step-content" id="step-2">
                        <h4 class="brand-font fw-bold mb-1">Chọn chiếc giỏ phù hợp</h4>
                        <p class="text-muted mb-4">Thiết kế giỏ ảnh hưởng rất lớn đến thẩm mỹ của món quà.</p>

                        <div class="row g-3">
                            <c:forEach var="b" items="${baskets}">
                                <div class="col-md-4 col-6">
                                    <label class="radio-card h-100">
                                        <!-- Gọi hàm JS để cập nhật giá tiền -->
                                        <input type="radio" name="basketId" value="${b.id}" data-name="${b.name}" data-price="${b.price}" onchange="updateSummary()" required>
                                        <div class="radio-content">
                                            <img src="${b.image}" alt="${b.name}" class="radio-img">
                                            <div class="fw-bold text-dark" style="font-size: 14px;">${b.name}</div>
                                            <div class="text-muted small mb-2">${b.description}</div>
                                            <div class="fw-bold text-success"><fmt:formatNumber value="${b.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                        </div>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- ================= BƯỚC 3: THIỆP & ĐÓNG GÓI ================= -->
                    <div class="step-content" id="step-3">
                        <h4 class="brand-font fw-bold mb-4">Hoàn thiện giỏ quà</h4>

                        <!-- Thiệp (FREE) -->
                        <div class="bg-white-card mb-4">
                            <h6 class="fw-bold mb-3"><i class="ph-fill ph-envelope-simple text-warning me-2"></i>Gửi một lời nhắn <span class="badge bg-success ms-2">MIỄN PHÍ</span></h6>
                            <textarea name="cardMessage" class="form-control bg-light" rows="3" maxlength="300" placeholder="Nhập lời nhắn gửi người nhận (Tối đa 300 ký tự)..."></textarea>
                        </div>

                        <!-- Trang trí -->
                        <div class="bg-white-card mb-4">
                            <h6 class="fw-bold mb-3"><i class="ph-fill ph-sparkle text-danger me-2"></i>Chọn kiểu trang trí</h6>
                            <div class="row g-3">
                                <c:forEach var="d" items="${decorations}">
                                    <div class="col-md-4 col-6">
                                        <label class="radio-card p-3">
                                            <input type="radio" name="decorationId" value="${d.id}" data-name="${d.name}" data-price="${d.price}" onchange="updateSummary()" required>
                                            <div class="radio-content">
                                                <div class="fw-bold text-dark" style="font-size: 13px;">${d.name}</div>
                                                <div class="text-success fw-bold mt-1"><fmt:formatNumber value="${d.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                            </div>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Đóng gói -->
                        <div class="bg-white-card">
                            <h6 class="fw-bold mb-3"><i class="ph-fill ph-package text-primary me-2"></i>Chọn kiểu đóng gói</h6>
                            <div class="row g-3">
                                <c:forEach var="p" items="${packagings}">
                                    <div class="col-md-4 col-6">
                                        <label class="radio-card p-3">
                                            <input type="radio" name="packagingId" value="${p.id}" data-name="${p.name}" data-price="${p.price}" onchange="updateSummary()" required>
                                            <div class="radio-content">
                                                <div class="fw-bold text-dark" style="font-size: 13px;">${p.name}</div>
                                                <div class="text-success fw-bold mt-1"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                            </div>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- CỘT PHẢI: TÓM TẮT GIỎ QUÀ (LIVE PREVIEW) -->
                <div class="col-lg-4">
                    <div class="bg-white-card summary-panel">
                        <h5 class="fw-bold brand-font text-center mb-4 pb-3 border-bottom">TÓM TẮT GIỎ QUÀ</h5>

                        <div class="summary-row">
                            <span class="fw-medium text-dark">Trái cây đã chọn</span>
                            <span class="fw-bold text-dark" id="sum-fruit">0 ₫</span>
                        </div>
                        <div class="summary-row">
                            <span class="text-muted" id="sum-basket-name">Giỏ (Chưa chọn)</span>
                            <span class="fw-medium text-dark" id="sum-basket-price">0 ₫</span>
                        </div>
                        <div class="summary-row">
                            <span class="text-muted" id="sum-decor-name">Trang trí (Chưa chọn)</span>
                            <span class="fw-medium text-dark" id="sum-decor-price">0 ₫</span>
                        </div>
                        <div class="summary-row">
                            <span class="text-muted" id="sum-pack-name">Đóng gói (Chưa chọn)</span>
                            <span class="fw-medium text-dark" id="sum-pack-price">0 ₫</span>
                        </div>
                        <div class="summary-row text-success fw-medium">
                            <span>Thiệp chúc mừng</span>
                            <span>MIỄN PHÍ</span>
                        </div>

                        <div class="summary-row total">
                            <span>TỔNG CỘNG</span>
                            <span class="text-success brand-font fs-3" id="sum-total">0 ₫</span>
                        </div>

                        <!-- Hệ thống Nút điều hướng -->
                        <div class="mt-4">
                            <button type="button" class="btn btn-outline-secondary w-100 mb-2 fw-bold d-none" id="btnPrev" onclick="prevStep()">← QUAY LẠI</button>
                            <button type="button" class="btn-next" id="btnNext" onclick="nextStep()" disabled>TIẾP TỤC</button>
                            <!-- Nút Submit thực sự bị ẩn đi, chỉ hiện ở Bước 3 -->
                            <button type="submit" class="btn btn-success w-100 fw-bold py-3 fs-5 d-none" id="btnSubmit">THÊM VÀO GIỎ HÀNG</button>
                        </div>
                    </div>
                </div>

            </div>
        </form>
    </div>

    <!-- JAVASCRIPT XỬ LÝ LÔ-GÍC GIAO DIỆN -->
    <script>
        let currentStep = 1;
        let totalFruitPrice = 0;
        let totalFruitQty = 0;

        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

        // --- 1. XỬ LÝ TĂNG GIẢM TRÁI CÂY (STEP 1) ---
        function changeQty(productId, price, change) {
            let inputDisplay = document.getElementById('qty_display_' + productId);
            let inputValue = document.getElementById('qty_value_' + productId);

            let currentVal = parseInt(inputValue.value);
            let newVal = currentVal + change;
            if (newVal < 0) newVal = 0; // Không cho âm

            // Cập nhật giá trị
            inputDisplay.value = newVal;
            inputValue.value = newVal;

            // Tính lại tổng tiền trái cây của nguyên bước 1
            recalcFruitTotal();
            updateSummary();
            validateStep();
        }

        function recalcFruitTotal() {
            totalFruitPrice = 0;
            totalFruitQty = 0;
            // Quét tất cả thẻ input type hidden có id bắt đầu bằng qty_value_
            document.querySelectorAll('input[id^="qty_value_"]').forEach(input => {
                let qty = parseInt(input.value);
                if (qty > 0) {
                    let id = input.id.replace('qty_value_', '');
                    // Tìm thẻ cha chứa nút bấm để móc giá tiền (có thể dùng data-price chuẩn hơn, nhưng demo này dùng regex lấy tạm text hoặc map. Cách chuẩn nhất là gọi lại hàm)
                    // Vì JS thuần, ta truyền luôn price vào hàm onClick để tính toán dễ hơn
                }
            });
            // Cách làm gọn hơn: Cộng trừ trực tiếp biến toàn cục
        }

        // Sửa lại hàm changeQty để cộng dồn chuẩn xác:
        function changeQty(productId, price, change) {
            let inputValue = document.getElementById('qty_value_' + productId);
            let currentVal = parseInt(inputValue.value);
            let newVal = currentVal + change;
            if (newVal < 0) return;

            inputValue.value = newVal;
            document.getElementById('qty_display_' + productId).value = newVal;

            // Cộng/Trừ tiền & số lượng
            totalFruitPrice += (change * price);
            totalFruitQty += change;

            updateSummary();
            validateStep();
        }


        // --- 2. CẬP NHẬT BẢNG TÓM TẮT (LIVE PREVIEW) ---
        function updateSummary() {
            // Giá Trái cây
            document.getElementById('sum-fruit').innerText = formatter.format(totalFruitPrice);

            // Giá Giỏ
            let basketRadio = document.querySelector('input[name="basketId"]:checked');
            let basketPrice = 0;
            if(basketRadio) {
                basketPrice = parseFloat(basketRadio.dataset.price);
                document.getElementById('sum-basket-name').innerText = basketRadio.dataset.name;
                document.getElementById('sum-basket-price').innerText = formatter.format(basketPrice);
            }

            // Giá Trang trí
            let decorRadio = document.querySelector('input[name="decorationId"]:checked');
            let decorPrice = 0;
            if(decorRadio) {
                decorPrice = parseFloat(decorRadio.dataset.price);
                document.getElementById('sum-decor-name').innerText = decorRadio.dataset.name;
                document.getElementById('sum-decor-price').innerText = formatter.format(decorPrice);
            }

            // Giá Đóng gói
            let packRadio = document.querySelector('input[name="packagingId"]:checked');
            let packPrice = 0;
            if(packRadio) {
                packPrice = parseFloat(packRadio.dataset.price);
                document.getElementById('sum-pack-name').innerText = packRadio.dataset.name;
                document.getElementById('sum-pack-price').innerText = formatter.format(packPrice);
            }

            // TỔNG TIỀN CUỐI
            let finalTotal = totalFruitPrice + basketPrice + decorPrice + packPrice;
            document.getElementById('sum-total').innerText = formatter.format(finalTotal);

            validateStep(); // Kích hoạt nút bấm nếu đủ điều kiện
        }


        // --- 3. ĐIỀU HƯỚNG BƯỚC (STEPPER) ---
        function validateStep() {
            let btnNext = document.getElementById('btnNext');

            if (currentStep === 1) {
                btnNext.disabled = (totalFruitQty === 0);
            } else if (currentStep === 2) {
                let basketChecked = document.querySelector('input[name="basketId"]:checked');
                btnNext.disabled = !basketChecked;
            } else if (currentStep === 3) {
                let decorChecked = document.querySelector('input[name="decorationId"]:checked');
                let packChecked = document.querySelector('input[name="packagingId"]:checked');

                let btnSubmit = document.getElementById('btnSubmit');
                btnSubmit.disabled = !(decorChecked && packChecked);
            }
        }

        function nextStep() {
            if (currentStep < 3) {
                currentStep++;
                renderStep();
            }
        }

        function prevStep() {
            if (currentStep > 1) {
                currentStep--;
                renderStep();
            }
        }

        function goToStep(step) {
            // Chỉ cho phép click lùi, không cho nhảy cóc tới trước nếu chưa làm
            if (step < currentStep) {
                currentStep = step;
                renderStep();
            }
        }

        function renderStep() {
            // Ẩn/Hiện Content
            document.querySelectorAll('.step-content').forEach(el => el.classList.remove('active'));
            document.getElementById('step-' + currentStep).classList.add('active');

            // Cập nhật màu Nav Stepper
            for (let i = 1; i <= 3; i++) {
                let navItem = document.getElementById('step-nav-' + i);
                navItem.classList.remove('active', 'completed');

                if (i === currentStep) navItem.classList.add('active');
                else if (i < currentStep) navItem.classList.add('completed');
            }

            // Ẩn/Hiện Buttons
            let btnPrev = document.getElementById('btnPrev');
            let btnNext = document.getElementById('btnNext');
            let btnSubmit = document.getElementById('btnSubmit');

            if (currentStep === 1) {
                btnPrev.classList.add('d-none');
                btnNext.classList.remove('d-none');
                btnSubmit.classList.add('d-none');
            } else if (currentStep === 2) {
                btnPrev.classList.remove('d-none');
                btnNext.classList.remove('d-none');
                btnSubmit.classList.add('d-none');
            } else if (currentStep === 3) {
                btnPrev.classList.remove('d-none');
                btnNext.classList.add('d-none');
                btnSubmit.classList.remove('d-none');
            }

            validateStep();
            window.scrollTo({ top: 0, behavior: 'smooth' }); // Tự cuộn lên đầu nhẹ nhàng
        }
    </script>
</body>
</html>