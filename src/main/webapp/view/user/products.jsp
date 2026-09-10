<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa hàng | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Tinh chỉnh UI cho Product Card */
        .product-card { padding: 10px; border-radius: 8px; transition: transform 0.2s ease, box-shadow 0.2s ease; background: #fff; height: 100%; border: 1px solid transparent; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); border-color: #EAEAEC; }
        .product-img-wrapper { position: relative; width: 100%; padding-top: 100%; overflow: hidden; border-radius: 8px; } /* Xóa bg, border ở đây */
        .product-img-wrapper img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: contain; } /* object-fit: contain để ảnh không bị cắt */
        .product-title { font-size: 15px; font-weight: 600; margin: 10px 0 5px; height: 42px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .product-price { font-size: 16px; font-weight: 700; color: #2F6B3F; }
    </style>
</head>
<body class="bg-light">

    <!-- NAVBAR (Giữ nguyên) -->
    <nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white">
        <div class="container">
            <a class="navbar-brand text-success brand-font fw-bold fs-4" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <div class="collapse navbar-collapse justify-content-center">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link fw-bold text-success" href="${pageContext.request.contextPath}/products">Cửa hàng</a></li>
                </ul>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/orders/history" class="text-dark fw-medium text-decoration-none"><i class="fa-regular fa-clipboard me-1"></i> Đơn mua</a>
                <a href="${pageContext.request.contextPath}/cart" class="text-dark position-relative ms-2">
                    <i class="fa-solid fa-bag-shopping fs-5"></i>
                    <c:if test="${not empty sessionScope.cart}"><span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">${sessionScope.cart.size()}</span></c:if>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/profile" class="text-dark text-decoration-none fw-medium"><i class="fa-regular fa-user-circle fs-5 me-1"></i> ${sessionScope.user.fullName}</a>
                    </c:when>
                    <c:otherwise>
                         <a href="${pageContext.request.contextPath}/login" class="text-dark"><i class="fa-regular fa-user fs-5"></i></a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </nav>

    <div class="container py-4">
        <!-- BREADCRUMB (Đã khôi phục) -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb" style="font-size: 13px;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Tất cả trái cây</li>
            </ol>
        </nav>

        <h2 class="brand-font fs-3 fw-bold mb-4">Tất cả trái cây</h2>

        <div class="row">
            <!-- Cột Lọc (Giữ nguyên) -->
            <div class="col-lg-3 mb-4 pe-lg-4">
                <form id="filterForm" action="${pageContext.request.contextPath}/products" method="GET">
                    <input type="hidden" name="page" id="pageInput" value="${currentPage}">

                    <div class="mb-4">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Tìm kiếm</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="VD: Táo..." style="font-size: 14px;">
                            <button class="btn btn-outline-success" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                        </div>
                    </div>

                    <div class="mb-4 pb-4 border-bottom">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Danh mục</label>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="category" value="" id="cat_all" onchange="submitFilter()" ${empty selectedCategory ? 'checked' : ''}>
                            <label class="form-check-label text-muted" for="cat_all">Tất cả trái cây</label>
                        </div>
                        <c:forEach var="cat" items="${categories}">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="category" value="${cat.id}" id="cat_${cat.id}" onchange="submitFilter()" ${selectedCategory == cat.id ? 'checked' : ''}>
                                <label class="form-check-label text-muted" for="cat_${cat.id}">${cat.name}</label>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Khoảng giá</label>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <input type="number" class="form-control text-center" name="minPrice" value="${minPrice}" placeholder="Từ">
                            <span class="text-muted">-</span>
                            <input type="number" class="form-control text-center" name="maxPrice" value="${maxPrice}" placeholder="Đến">
                        </div>
                        <button type="submit" class="btn btn-outline-dark w-100 py-1 mt-2">Áp dụng giá</button>
                    </div>
            </div>

            <!-- Cột Lưới Sản Phẩm -->
            <div class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <span class="text-muted" style="font-size: 14px;">Tìm thấy <strong>${totalProducts}</strong> sản phẩm</span>
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-muted" style="font-size: 13px;">Sắp xếp:</span>
                        <select class="form-select form-select-sm" name="sort" onchange="submitFilter()" style="width: auto; cursor: pointer;">
                            <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                            <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                        </select>
                    </div>
                </div>
                </form>

                <div class="row g-4 mb-5">
                    <c:forEach var="p" items="${products}">
                        <c:set var="imgs" value="${fn:split(p.image, ',')}" />
                        <c:set var="firstImg" value="${fn:trim(imgs[0])}" />

                        <div class="col-xl-4 col-sm-6">
                            <div class="product-card">
                                <div class="product-img-wrapper">
                                    <c:choose>
                                        <c:when test="${p.stock == 0}">
                                            <span class="position-absolute top-0 start-0 m-2 bg-secondary text-white px-2 py-1 rounded" style="font-size: 10px; font-weight: 600; z-index: 2;">Hết hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="position-absolute top-0 start-0 m-2 bg-white px-2 py-1 rounded shadow-sm text-success" style="font-size: 10px; font-weight: 600; z-index: 2; border: 1px solid #EAEAEC;">${p.categoryName}</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                        <c:choose>
                                            <c:when test="${not empty firstImg && fn:startsWith(firstImg, 'http')}">
                                                <img src="${firstImg}" alt="${p.name}">
                                            </c:when>
                                            <c:when test="${not empty firstImg}">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${firstImg}" alt="${p.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=400" alt="Default">
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </div>

                                <div class="product-origin mt-3 text-muted text-uppercase" style="font-size: 10px; font-weight: 600; letter-spacing: 0.5px;">${p.origin}</div>
                                <h3 class="product-title"><a href="${pageContext.request.contextPath}/product?id=${p.id}" class="text-decoration-none text-dark">${p.name}</a></h3>

                                <div class="mt-2 d-flex justify-content-between align-items-center">
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        <span class="fw-normal text-muted" style="font-size: 12px;">/ ${p.unit}</span>
                                    </div>
                                    <c:if test="${p.stock > 0}">
                                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-sm btn-outline-success px-3" style="border-radius: 4px; font-weight: 500;">Thêm</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- KHÔI PHỤC TOAST -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body fw-medium"><i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMsg}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>
    </div>

    <script>
        function submitFilter() { document.getElementById('pageInput').value = 1; document.getElementById('filterForm').submit(); }
        function gotoPage(pageNumber) { document.getElementById('pageInput').value = pageNumber; document.getElementById('filterForm').submit(); }

        // Kích hoạt Toast
        document.addEventListener("DOMContentLoaded", function() {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 3000 }); });
            toastList.forEach(toast => toast.show());
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>