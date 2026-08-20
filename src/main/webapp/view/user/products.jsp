<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa hàng | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-main">

    <!-- NAVBAR TỐI GIẢN (Giữ nguyên cấu trúc của trang chủ) -->
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

    <!-- SHOPPING SECTION -->
    <div class="container py-5">
        <!-- BREADCRUMB & HEADER -->
        <div class="mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb" style="font-size: 13px;">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
                    <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">Tất cả trái cây</li>
                </ol>
            </nav>
            <h1 class="brand-font fs-2">Tất cả trái cây</h1>
        </div>

        <div class="row">
            <!-- SIDEBAR BỘ LỌC (Cột Trái) -->
            <div class="col-lg-3 mb-4 mb-lg-0 pe-lg-4">
                <form id="filterForm" action="${pageContext.request.contextPath}/products" method="GET">
                    <!-- Giữ lại số trang hiện tại để form truyền đi -->
                    <input type="hidden" name="page" id="pageInput" value="${currentPage}">

                    <!-- TÌM KIẾM -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Tìm kiếm</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="VD: Táo, Cam..." style="font-size: 14px; border-radius: 6px 0 0 6px;">
                            <button class="btn btn-outline-success" type="submit" style="border-radius: 0 6px 6px 0;"><i class="fa-solid fa-magnifying-glass"></i></button>
                        </div>
                    </div>

                    <!-- DANH MỤC -->
                    <div class="mb-4 border-bottom pb-4">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Danh mục</label>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="category" value="" id="cat_all" onchange="submitFilter()" ${empty selectedCategory ? 'checked' : ''}>
                            <label class="form-check-label text-muted" for="cat_all" style="font-size: 14px;">Tất cả trái cây</label>
                        </div>
                        <c:forEach var="cat" items="${categories}">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="category" value="${cat.id}" id="cat_${cat.id}" onchange="submitFilter()" ${selectedCategory == cat.id ? 'checked' : ''}>
                                <label class="form-check-label text-muted" for="cat_${cat.id}" style="font-size: 14px;">${cat.name}</label>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- LỌC GIÁ -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold" style="font-size: 14px;">Khoảng giá</label>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <input type="number" class="form-control text-center" name="minPrice" value="${minPrice}" placeholder="Từ" style="font-size: 13px;">
                            <span class="text-muted">-</span>
                            <input type="number" class="form-control text-center" name="maxPrice" value="${maxPrice}" placeholder="Đến" style="font-size: 13px;">
                        </div>
                        <button type="submit" class="btn btn-outline-dark w-100 py-1 mt-2" style="font-size: 13px; font-weight: 500;">Áp dụng giá</button>
                    </div>

                    <!-- SẮP XẾP SẼ NẰM BÊN PHẢI NHƯNG THUỘC FORM NÀY -->

            </div>

            <!-- GRID SẢN PHẨM (Cột Phải) -->
            <div class="col-lg-9">
                <!-- TOP BAR (Số lượng + Sắp xếp) -->
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <span class="text-muted" style="font-size: 14px;">Tìm thấy <strong>${totalProducts}</strong> sản phẩm</span>

                    <div class="d-flex align-items-center gap-2">
                        <span class="text-muted" style="font-size: 13px;">Sắp xếp:</span>
                        <select class="form-select form-select-sm" name="sort" onchange="submitFilter()" style="width: auto; font-size: 13px; cursor: pointer;">
                            <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá: Thấp đến Cao</option>
                            <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá: Cao đến Thấp</option>
                            <option value="name_asc" ${sort == 'name_asc' ? 'selected' : ''}>Tên: A - Z</option>
                        </select>
                    </div>
                </div>
                </form> <!-- Đóng Form Bộ Lọc ở đây -->

                <!-- TRẠNG THÁI TRỐNG (Empty State) -->
                <c:if test="${empty products}">
                    <div class="text-center py-5">
                        <i class="fa-solid fa-basket-shopping text-muted mb-3" style="font-size: 48px; opacity: 0.3;"></i>
                        <h4 class="brand-font">Không tìm thấy sản phẩm nào!</h4>
                        <p class="text-muted">Vui lòng thử lại với từ khóa hoặc bộ lọc khác.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom mt-2">Xóa bộ lọc</a>
                    </div>
                </c:if>

                <!-- LƯỚI SẢN PHẨM -->
                <div class="row g-4 mb-5">
                    <c:forEach var="p" items="${products}">
                        <div class="col-xl-4 col-sm-6">
                            <div class="product-card">
                                <div class="product-img-wrapper">
                                    <c:choose>
                                        <c:when test="${p.stock == 0}">
                                            <span class="position-absolute top-0 start-0 m-2 bg-secondary text-white px-2 py-1 rounded" style="font-size: 10px; font-weight: 600;">Hết hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="position-absolute top-0 start-0 m-2 bg-white px-2 py-1 rounded shadow-sm text-success" style="font-size: 10px; font-weight: 600; border: 1px solid var(--border-light);">${p.categoryName}</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                        <c:choose>
                                            <c:when test="${not empty p.image}">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${p.image}" alt="${p.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Ảnh mặc định nếu chưa up ảnh -->
                                                <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=400&auto=format&fit=crop" alt="Default">
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </div>

                                <div class="product-origin">${p.origin}</div>
                                <h3 class="product-title"><a href="${pageContext.request.contextPath}/product?id=${p.id}" class="text-decoration-none text-dark">${p.name}</a></h3>

                                <div class="product-price-row mt-2">
                                    <div class="product-price">
                                        <!-- Format tiền tệ chuẩn VNĐ -->
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        <span class="fw-normal text-muted" style="font-size: 13px;">/ ${p.unit}</span>
                                    </div>
                                    <c:if test="${p.stock > 0}">
                                        <button class="btn-add-text">Thêm</button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- PHÂN TRANG (Pagination) -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <!-- Nút Previous -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link text-success" href="javascript:void(0)" onclick="gotoPage(${currentPage - 1})">Trang trước</a>
                            </li>

                            <!-- Các số trang -->
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link ${currentPage == i ? 'bg-success border-success' : 'text-success'}" href="javascript:void(0)" onclick="gotoPage(${i})">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Nút Next -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link text-success" href="javascript:void(0)" onclick="gotoPage(${currentPage + 1})">Trang sau</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

            </div>
        </div>
    </div>

    <script>
        // Tự động submit form khi đổi danh mục hoặc đổi kiểu sắp xếp
        function submitFilter() {
            document.getElementById('pageInput').value = 1; // Reset về trang 1 khi đổi bộ lọc
            document.getElementById('filterForm').submit();
        }

        // Chuyển trang nhưng vẫn giữ nguyên bộ lọc
        function gotoPage(pageNumber) {
            document.getElementById('pageInput').value = pageNumber;
            document.getElementById('filterForm').submit();
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