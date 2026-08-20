<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">

    <!-- NAVBAR (Giữ nguyên cấu trúc) -->
    <nav class="navbar navbar-expand-lg sticky-top border-bottom">
        <div class="container">
            <a class="navbar-brand text-success brand-font" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <div class="collapse navbar-collapse justify-content-center">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link fw-bold text-success" href="${pageContext.request.contextPath}/products">Cửa hàng</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Danh mục</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Câu chuyện</a></li>
                </ul>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/login" class="text-dark"><i class="fa-regular fa-user"></i></a>
                <a href="${pageContext.request.contextPath}/cart" class="text-dark position-relative ms-2">
                    <i class="fa-solid fa-bag-shopping"></i>
                </a>
            </div>
        </div>
    </nav>

    <!-- PRODUCT DETAIL SECTION -->
    <div class="container py-5">

        <!-- BREADCRUMB -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb" style="font-size: 13px;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-muted text-decoration-none">Cửa hàng</a></li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="row g-5 bg-white p-4 p-md-5 rounded-4 border border-light shadow-sm">
            <!-- CỘT TRÁI: HÌNH ẢNH -->
            <div class="col-md-6">
                <div class="bg-main rounded-4 p-4 d-flex align-items-center justify-content-center h-100 border border-light" style="min-height: 400px;">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img src="${pageContext.request.contextPath}/assets/images/products/${product.image}" alt="${product.name}" class="img-fluid rounded" style="mix-blend-mode: multiply;">
                        </c:when>
                        <c:otherwise>
                            <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=600&auto=format&fit=crop" alt="Default" class="img-fluid rounded">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- CỘT PHẢI: THÔNG TIN -->
            <div class="col-md-6">
                <!-- Badges -->
                <div class="d-flex gap-2 mb-3">
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">${product.categoryName}</span>
                    <c:if test="${product.stock > 0 && product.stock <= 10}">
                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-2 rounded-pill">Sắp hết hàng</span>
                    </c:if>
                </div>

                <!-- Tên & Giá -->
                <h1 class="brand-font mb-2">${product.name}</h1>
                <div class="mb-4 text-warning" style="font-size: 14px;">
                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>
                    <span class="text-muted ms-2">(128 Đánh giá)</span>
                </div>

                <div class="brand-font text-dark mb-4" style="font-size: 40px; font-weight: 700;">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    <span class="text-muted fw-normal" style="font-size: 20px;">/ ${product.unit}</span>
                </div>

                <!-- Meta Info -->
                <ul class="list-unstyled mb-4 pb-4 border-bottom">
                    <li class="mb-2"><span class="text-muted d-inline-block" style="width: 100px;">Xuất xứ:</span> <span class="fw-medium">${product.origin}</span></li>
                    <li class="mb-2"><span class="text-muted d-inline-block" style="width: 100px;">Tình trạng:</span>
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="fw-medium text-success"><i class="fa-solid fa-check-circle me-1"></i>Còn hàng (${product.stock} ${product.unit})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="fw-medium text-danger"><i class="fa-solid fa-xmark-circle me-1"></i>Hết hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>

                <!-- FORM THÊM VÀO GIỎ HÀNG -->
                <form action="${pageContext.request.contextPath}/cart" method="POST" class="mb-5">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="${product.id}">

                    <div class="d-flex gap-3 align-items-center">
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <!-- Bộ đếm số lượng -->
                                <div class="qty-input-group">
                                    <button type="button" class="qty-btn" onclick="decreaseQty()">-</button>
                                    <input type="number" class="qty-input" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" readonly>
                                    <button type="button" class="qty-btn" onclick="increaseQty()">+</button>
                                </div>
                                <!-- Nút Submit -->
                                <button type="submit" class="btn btn-primary-custom flex-grow-1" style="height: 48px;">
                                    <i class="fa-solid fa-cart-plus me-2"></i> Thêm vào giỏ
                                </button>
                            </c:when>
                            <c:otherwise>
                                <!-- Vô hiệu hóa nút nếu hết hàng -->
                                <button type="button" class="btn btn-secondary flex-grow-1 opacity-50" style="height: 48px; border-radius: var(--radius-sm);" disabled>
                                    Sản phẩm tạm hết hàng
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>

                <!-- Description -->
                <div>
                    <h5 class="fw-bold mb-3">Mô tả sản phẩm</h5>
                    <p class="text-muted" style="line-height: 1.8;">${product.description}</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Script xử lý tăng/giảm số lượng mượt mà -->
    <script>
        const maxStock = ${product.stock};
        const qtyInput = document.getElementById('quantity');

        function increaseQty() {
            let current = parseInt(qtyInput.value);
            if (current < maxStock) {
                qtyInput.value = current + 1;
            } else {
                alert("Bạn không thể chọn số lượng vượt quá tồn kho hiện tại!");
            }
        }

        function decreaseQty() {
            let current = parseInt(qtyInput.value);
            if (current > 1) {
                qtyInput.value = current - 1;
            }
        }
    </script>

    <!-- ==================== HỆ THỐNG THÔNG BÁO NỔI (TOAST) ==================== -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
        <!-- Thông báo Thành công -->
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" style="font-size: 14px; font-weight: 500;">
                        <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <!-- Thông báo Lỗi -->
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" style="font-size: 14px; font-weight: 500;">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i> ${sessionScope.errorMsg}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>
    </div>

    <!-- CÁC FILE SCRIPT LUÔN PHẢI NẰM TRONG BODY -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl, { delay: 3000 });
            });
            toastList.forEach(toast => toast.show());
        });
    </script>
</body>
</html>