<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>
    <style>
        body { background-color: #F8F9FA; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .checkout-box { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); margin-bottom: 20px; border: 1px solid #eee; }
        .form-control, .form-select { border-radius: 8px; padding: 10px 15px; }
        .form-control:focus, .form-select:focus { border-color: #198754; box-shadow: 0 0 0 0.25rem rgba(25, 135, 84, 0.25); }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px; }
        .summary-item.total { font-size: 20px; font-weight: bold; border-top: 1px solid #eee; padding-top: 16px; margin-top: 16px; }
    </style>
</head>
<body>
    <div class="container py-5" style="max-width: 1000px;">
        <h3 class="fw-bold mb-4 text-center text-success"><i class="fa-solid fa-leaf"></i> Hoàn Tất Đơn Hàng</h3>

        <form action="${pageContext.request.contextPath}/checkout" method="POST" id="checkoutForm">
            <div class="row g-4">
                <!-- CỘT TRÁI: THÔNG TIN GIAO HÀNG -->
                <div class="col-lg-7">

                    <div class="checkout-box">
                        <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="fa-solid fa-location-dot text-danger me-2"></i>Thông tin nhận hàng</h5>
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Họ tên người nhận</label>
                                <input type="text" name="receiverName" class="form-control" value="${sessionScope.user != null ? sessionScope.user.fullName : ''}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Số điện thoại</label>
                                <input type="text" name="receiverPhone" class="form-control" value="${sessionScope.user != null ? sessionScope.user.phone : ''}" required>
                            </div>
                        </div>

                        <!-- Dropdown Sổ Địa Chỉ -->
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">Sổ địa chỉ</label>
                            <select class="form-select" id="addressBook" onchange="toggleAddressForm()">
                                <c:if test="${not empty sessionScope.user.address}">
                                    <option value="DEFAULT">Địa chỉ mặc định: ${sessionScope.user.address}</option>
                                </c:if>
                                <option value="NEW" ${empty sessionScope.user.address ? 'selected' : ''}>+ Giao đến địa chỉ mới</option>
                            </select>
                        </div>

                        <!-- Form địa chỉ mới -->
                        <div id="newAddressForm" class="bg-light p-3 rounded" style="${not empty sessionScope.user.address ? 'display: none;' : ''}">
                            <div class="row g-2 mb-2">
                                <div class="col-md-4"><select class="form-select" id="tinh"><option value="">-- Tỉnh/Thành --</option></select></div>
                                <div class="col-md-4"><select class="form-select" id="quan" disabled><option value="">-- Quận/Huyện --</option></select></div>
                                <div class="col-md-4"><select class="form-select" id="phuong" disabled><option value="">-- Phường/Xã --</option></select></div>
                            </div>
                            <input type="text" id="sonha" class="form-control" placeholder="Số nhà, Tên đường (VD: Số 89, Ngõ 12)">
                        </div>

                        <input type="hidden" name="fullAddress" id="fullAddress" value="${not empty sessionScope.user.address ? sessionScope.user.address : ''}">
                        <input type="hidden" name="shippingFee" id="shippingFeeInput" value="0">
                    </div>

                    <!-- GÓI VẬN CHUYỂN DẠNG COMBO BOX (DROPDOWN) - ĐÃ CẬP NHẬT ĐỊNH DẠNG VNĐ -->
                    <div class="checkout-box">
                        <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="fa-solid fa-truck-fast text-warning me-2"></i>Chọn gói Vận chuyển</h5>

                        <label class="form-label text-muted small">Phương thức giao hàng <span class="text-danger">*</span></label>
                        <select class="form-select form-select-lg fw-medium text-dark shadow-sm border-secondary" name="shippingType" id="shippingTypeSelect" onchange="updatePricingUI()" required>
                            <option value="" disabled selected>-- Chọn phương thức giao hàng --</option>
                            <option value="STANDARD">Giao Hàng Tiêu Chuẩn (2-3 ngày) [+<fmt:formatNumber value="${settings['SHIP_STANDARD']}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>]</option>
                            <option value="EXPRESS">Giao Hỏa Tốc 2H [+<fmt:formatNumber value="${settings['SHIP_EXPRESS']}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>]</option>
                        </select>
                    </div>

                    <div class="checkout-box">
                        <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="fa-regular fa-clock text-primary me-2"></i>Thời gian & Thanh toán</h5>
                        <div class="mb-3">
                            <label class="form-label text-muted small">Khung giờ nhận hàng (Tùy chọn)</label>
                            <input type="text" name="deliveryTime" id="deliveryTimePicker" class="form-control bg-white" placeholder="Chọn ngày và giờ giao hàng" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small">Ghi chú</label>
                            <textarea name="note" class="form-control" rows="2" placeholder="VD: Giao giờ hành chính..."></textarea>
                        </div>

                        <label class="form-label text-muted small fw-bold">Phương thức thanh toán</label>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="paymentMethod" value="COD" id="cod" checked>
                            <label class="form-check-label" for="cod"><i class="fa-solid fa-money-bill-wave text-success mx-1"></i> Thanh toán khi nhận hàng (COD)</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="paymentMethod" value="VIETQR" id="qr">
                            <label class="form-check-label" for="qr"><i class="fa-solid fa-qrcode text-primary mx-1"></i> Chuyển khoản VietQR / Momo</label>
                        </div>

                        <input type="hidden" name="usePoints" value="${param.usePoints != null ? param.usePoints : 'false'}">
                    </div>
                </div>

                <!-- CỘT PHẢI: TÓM TẮT ĐƠN HÀNG -->
                <div class="col-lg-5">
                    <div class="checkout-box sticky-top" style="top: 20px; border-top: 4px solid #198754;">
                        <h5 class="fw-bold mb-4 text-center">TÓM TẮT ĐƠN HÀNG</h5>

                        <div class="mb-4 pb-3 border-bottom" style="max-height: 250px; overflow-y: auto;">
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <div class="d-flex justify-content-between mb-2 small">
                                    <span class="text-truncate" style="max-width: 200px;">${item.quantity}x ${item.product.name}</span>
                                    <span class="fw-medium"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                </div>
                            </c:forEach>
                        </div>

                        <c:set var="calcSubtotal" value="0" />
                        <c:forEach var="item" items="${sessionScope.cart}">
                            <c:set var="calcSubtotal" value="${calcSubtotal + item.subtotal}" />
                        </c:forEach>

                        <div class="summary-item text-muted">
                            <span>Tạm tính (Chưa gồm Thuế & Phí)</span>
                            <span><fmt:formatNumber value="${calcSubtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                        </div>

                        <div class="summary-item text-muted">
                            <span>Phí vận chuyển</span>
                            <span id="shippingFeeLabel" class="text-dark fw-bold">Vui lòng chọn...</span>
                        </div>

                        <div class="summary-item text-muted pb-2 border-bottom">
                            <span>Thuế VAT (${settings['TAX_RATE']}%)</span>
                            <span id="taxFeeLabel" class="text-danger fw-bold">...</span>
                        </div>

                        <c:if test="${sessionScope.discountAmount != null && sessionScope.discountAmount > 0}">
                            <div class="summary-item text-success mt-2">
                                <span>Khuyến mãi (${sessionScope.appliedVoucher.code})</span>
                                <span>- <fmt:formatNumber value="${sessionScope.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                            </div>
                        </c:if>

                        <div class="summary-item total">
                            <span>Tổng cộng</span>
                            <span class="text-danger" id="finalTotalLabel" style="font-size: 24px;">...</span>
                        </div>

                        <button type="button" class="btn btn-success w-100 py-3 mt-3 fw-bold fs-5 shadow" onclick="processCheckout()">XÁC NHẬN ĐẶT HÀNG</button>
                        <div class="text-center mt-3"><a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-muted small">Quay lại Giỏ hàng</a></div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        // 1. Dữ liệu từ Server
        const cartTotal = parseFloat('${calcSubtotal}');
        const discountAmount = parseFloat('${sessionScope.discountAmount != null ? sessionScope.discountAmount : 0}');

        // Load cấu hình từ Admin
        const taxRate = parseFloat('${settings["TAX_RATE"]}') || 0;
        const feeStandard = parseFloat('${settings["SHIP_STANDARD"]}') || 0;
        const feeExpress = parseFloat('${settings["SHIP_EXPRESS"]}') || 0;

        // 2. Logic tính tiền tự động
        function updatePricingUI() {
            // Lấy Phương thức Ship từ Combo box
            const shippingSelect = document.getElementById("shippingTypeSelect");
            let selectedShipFee = 0;

            // Format chuẩn VNĐ
            const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

            if (shippingSelect.value === 'STANDARD') {
                selectedShipFee = feeStandard;
                document.getElementById("shippingFeeLabel").innerText = '+ ' + formatter.format(selectedShipFee);
            } else if (shippingSelect.value === 'EXPRESS') {
                selectedShipFee = feeExpress;
                document.getElementById("shippingFeeLabel").innerText = '+ ' + formatter.format(selectedShipFee);
            } else {
                // Chưa chọn phương thức
                document.getElementById("shippingFeeLabel").innerText = 'Vui lòng chọn...';
            }

            // Tiền Thuế = (Tiền Giỏ Hàng) * Thuế suất
            const taxAmount = cartTotal * (taxRate / 100);

            // Gán dữ liệu lên form ẩn
            document.getElementById("shippingFeeInput").value = selectedShipFee;

            // Cập nhật giao diện tiền Thuế
            document.getElementById("taxFeeLabel").innerText = '+ ' + formatter.format(taxAmount);

            // Tổng thanh toán
            let finalTotal = cartTotal + selectedShipFee + taxAmount - discountAmount;
            if(finalTotal < 0) finalTotal = 0;
            document.getElementById("finalTotalLabel").innerText = formatter.format(finalTotal);
        }

        // Chạy lần đầu khi load trang
        updatePricingUI();

        // 3. Flatpickr
        flatpickr("#deliveryTimePicker", {
            enableTime: true, dateFormat: "d/m/Y H:i", minDate: "today",
            minTime: "07:00", maxTime: "20:00", locale: "vn"
        });

        // 4. Logic Địa chỉ
        function toggleAddressForm() {
            const dropdown = document.getElementById("addressBook");
            const newForm = document.getElementById("newAddressForm");
            if (dropdown.value === "NEW") {
                newForm.style.display = "block";
                document.getElementById("fullAddress").value = "";
            } else {
                newForm.style.display = "none";
                document.getElementById("fullAddress").value = "${sessionScope.user.address}";
            }
        }

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
                    } else {
                        quanSelect.disabled = true; phuongSelect.disabled = true;
                    }
                });

                quanSelect.addEventListener("change", function() {
                    phuongSelect.options.length = 1; phuongSelect.disabled = false;
                    if (this.value !== "") {
                        const selectedTinh = data.find(n => n.Id === tinhSelect.value);
                        const selectedQuan = selectedTinh.Districts.find(n => n.Id === this.value);
                        selectedQuan.Wards.forEach(phuong => { phuongSelect.options.add(new Option(phuong.Name, phuong.Id)); });
                    } else { phuongSelect.disabled = true; }
                });
            });

        // 5. Gửi Form Đặt Hàng kèm Validate Combo Box
        function processCheckout() {
            // Validate Phương thức giao hàng
            const shippingSelect = document.getElementById("shippingTypeSelect");
            if(shippingSelect && shippingSelect.value === "") {
                alert("Vui lòng chọn Gói vận chuyển trước khi đặt hàng!");
                shippingSelect.focus();
                return;
            }

            // Validate Địa chỉ mới
            const dropdown = document.getElementById("addressBook");
            if(dropdown && dropdown.value === "NEW") {
                const tinh = document.getElementById("tinh");
                const quan = document.getElementById("quan");
                const phuong = document.getElementById("phuong");
                const sonha = document.getElementById("sonha").value.trim();

                if(!tinh.value || !quan.value || !phuong.value || !sonha) {
                    alert("Vui lòng nhập đầy đủ địa chỉ giao hàng!"); return;
                }
                const tenTinh = tinh.options[tinh.selectedIndex].text;
                const tenQuan = quan.options[quan.selectedIndex].text;
                const tenPhuong = phuong.options[phuong.selectedIndex].text;
                document.getElementById("fullAddress").value = sonha + ", " + tenPhuong + ", " + tenQuan + ", " + tenTinh;
            }

            document.getElementById("checkoutForm").submit();
        }
    </script>
</body>
</html>