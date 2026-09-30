<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cửa hàng | Fruit Farmer Market</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">

    <style>
        :root { --primary-dark: #163D2A; --primary-green: #1F9D55; --bg-cream: #F9F8F4; --text-main: #1F2937; --border-light: #E5E7EB; }
        body { font-family: 'Inter', sans-serif; color: var(--text-main); background-color: #fff; }
        .serif-font { font-family: 'Playfair Display', serif; }

        /* HEADER (Kế thừa từ index) */
        .header-main { background-color: #fff; border-bottom: 1px solid var(--border-light); padding: 16px 0; position: sticky; top: 0; z-index: 1020; }
        .navbar-brand { font-size: 28px; color: var(--primary-dark) !important; letter-spacing: -0.5px; }
        .nav-link { color: var(--text-main); font-weight: 500; font-size: 15px; padding: 8px 20px !important; transition: 0.2s; }
        .nav-link:hover { color: var(--primary-green); }
        .header-icon { color: var(--text-main); font-size: 24px; text-decoration: none; position: relative; transition: 0.2s; margin-left: 20px; }
        .cart-badge { position: absolute; top: -5px; right: -8px; background: #E87817; color: white; font-size: 10px; font-weight: 700; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; border-radius: 50%; }

        /* BANNER */
        .shop-banner { height: 300px; background: url('https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1920&auto=format&fit=crop') center/cover no-repeat; display: flex; align-items: center; justify-content: center; position: relative; }
        .shop-banner::before { content: ''; position: absolute; inset: 0; background: rgba(22, 61, 42, 0.6); }
        .banner-content { position: relative; z-index: 1; text-align: center; color: white; }

        /* SIDEBAR LỌC (KLEVER FRUIT STYLE) */
        .sidebar-filter { background: #fff; border-right: 1px solid var(--border-light); padding-right: 20px; position: sticky; top: 100px; }
        .filter-group { border-bottom: 1px solid var(--border-light); padding: 20px 0; }
        .filter-title { font-size: 15px; font-weight: 700; color: var(--primary-dark); text-transform: uppercase; margin-bottom: 15px; display: flex; justify-content: space-between; cursor: pointer; }
        .filter-list { list-style: none; padding: 0; margin: 0; }
        .filter-list li { margin-bottom: 12px; font-size: 14px; }
        .filter-list a { color: var(--text-main); text-decoration: none; transition: 0.2s; display: block; }
        .filter-list a:hover, .filter-list a.active { color: var(--primary-green); font-weight: 600; }

        /* Custom Checkbox */
        .custom-check { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .custom-check input { display: none; }
        .checkmark { width: 18px; height: 18px; border: 1px solid #ccc; border-radius: 4px; display: flex; align-items: center; justify-content: center; transition: 0.2s; }
        .custom-check input:checked + .checkmark { background: var(--primary-green); border-color: var(--primary-green); }
        .custom-check input:checked + .checkmark::after { content: '\2714'; color: white; font-size: 12px; }

        /* SẮP XẾP & SẢN PHẨM */
        .sort-bar { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid var(--border-light); margin-bottom: 30px; }
        .sort-select { border: 1px solid var(--border-light); padding: 8px 16px; border-radius: 8px; outline: none; font-size: 14px; color: var(--text-main); cursor: pointer; }

        /* Product Card */
        .product-card { border: 1px solid var(--border-light); border-radius: 12px; background: #fff; transition: 0.3s; height: 100%; display: flex; flex-direction: column; overflow: hidden; }
        .product-card:hover { border-color: var(--primary-green); box-shadow: 0 12px 24px rgba(0,0,0,0.06); transform: translateY(-4px); }
        .product-img-wrap { width: 100%; aspect-ratio: 1/1; background: #F9FAFB; padding: 20px; text-align: center; }
        .product-img { width: 100%; height: 100%; object-fit: contain; mix-blend-mode: multiply; }
        .product-info { padding: 20px; display: flex; flex-direction: column; flex-grow: 1; border-top: 1px solid #f3f4f6; }
        .product-name { font-size: 15px; font-weight: 600; color: var(--text-main); text-decoration: none; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .product-name:hover { color: var(--primary-green); }
        .btn-add-cart { background: transparent; color: var(--primary-dark); border: 1px solid var(--border-light); width: 100%; padding: 10px; border-radius: 8px; font-weight: 600; font-size: 14px; transition: 0.2s; margin-top: auto; }
        .btn-add-cart:hover { background: var(--primary-green); color: white; border-color: var(--primary-green); }
    </style>
</head>
<body>

    <!-- HEADER -->
    <header class="header-main sticky-top">
        <div class="container d-flex justify-content-between align-items-center">
            <a class="navbar-brand serif-font fw-bold text-decoration-none" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>
            <nav class="d-none d-lg-flex">
                <a class="nav-link fw-bold text-success" href="${pageContext.request.contextPath}/products">Sản phẩm</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/products?category=combo">Giỏ Quà</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/vouchers">Khuyến mãi</a>
            </nav>
            <div class="d-flex align-items-center">
                <a href="${pageContext.request.contextPath}/profile" class="header-icon"><i class="ph ph-user"></i></a>
                <a href="${pageContext.request.contextPath}/cart" class="header-icon">
                    <i class="ph ph-shopping-cart"></i>
                    <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                        <span class="cart-badge">${sessionScope.cart.size()}</span>
                    </c:if>
                </a>
            </div>
        </div>
    </header>

    <!-- BANNER -->
    <div class="shop-banner">
        <div class="banner-content">
            <h1 class="serif-font fw-bold mb-3" style="font-size: 48px;">Trái cây tươi hàng ngày</h1>
            <p class="fs-5 fw-light">Chọn lọc từ những nông trại đạt chuẩn VietGAP & GlobalGAP.</p>
        </div>
    </div>

    <!-- MAIN SHOP AREA -->
    <div class="container py-5">
        <div class="row">

            <!-- SIDEBAR LỌC -->
            <div class="col-lg-3 d-none d-lg-block">
                <div class="sidebar-filter pe-4">

                    <!-- Danh mục -->
                    <div class="filter-group pt-0">
                        <div class="filter-title">Danh mục sản phẩm</div>
                        <ul class="filter-list">
                            <li><a href="${pageContext.request.contextPath}/products" class="${empty param.category ? 'active' : ''}">Tất cả sản phẩm</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=muavum" class="${param.category == 'muavum' ? 'active' : ''}">Trái cây đang mùa</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=huuco" class="${param.category == 'huuco' ? 'active' : ''}">Trái cây hữu cơ</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=nhapkhau" class="${param.category == 'nhapkhau' ? 'active' : ''}">Trái cây nhập khẩu</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=vietnam" class="${param.category == 'vietnam' ? 'active' : ''}">Trái cây Việt Nam</a></li>
                            <li><a href="${pageContext.request.contextPath}/products?category=combo" class="${param.category == 'combo' ? 'active' : ''}">Quà tặng & Combo</a></li>
                        </ul>
                    </div>

                    <!-- Xuất xứ -->
                    <div class="filter-group">
                        <div class="filter-title">Xuất xứ</div>
                        <ul class="filter-list">
                            <li><label class="custom-check"><input type="checkbox" name="origin" value="Việt Nam" ${fn:contains(param.origin, 'Việt Nam') ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Việt Nam</label></li>
                            <li><label class="custom-check"><input type="checkbox" name="origin" value="Mỹ" ${fn:contains(param.origin, 'Mỹ') ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Mỹ (USA)</label></li>
                            <li><label class="custom-check"><input type="checkbox" name="origin" value="Úc" ${fn:contains(param.origin, 'Úc') ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Úc (Australia)</label></li>
                            <li><label class="custom-check"><input type="checkbox" name="origin" value="Hàn Quốc" ${fn:contains(param.origin, 'Hàn Quốc') ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Hàn Quốc</label></li>
                        </ul>
                    </div>

                    <!-- Lọc Giá -->
                    <div class="filter-group border-0">
                        <div class="filter-title">Lọc theo giá</div>
                        <ul class="filter-list">
                            <li><label class="custom-check"><input type="radio" name="priceRange" value="under500" ${param.priceRange == 'under500' ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Dưới 500.000₫</label></li>
                            <li><label class="custom-check"><input type="radio" name="priceRange" value="500to1000" ${param.priceRange == '500to1000' ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> 500.000₫ - 1.000.000₫</label></li>
                            <li><label class="custom-check"><input type="radio" name="priceRange" value="over1000" ${param.priceRange == 'over1000' ? 'checked' : ''} onchange="applyFilters()"> <div class="checkmark"></div> Trên 1.000.000₫</label></li>
                        </ul>
                        <button class="btn btn-sm btn-light w-100 mt-3" onclick="clearFilters()">Xóa bộ lọc</button>
                    </div>
                </div>
            </div>

            <!-- PRODUCT GRID -->
            <div class="col-lg-9">
                <!-- Thanh Sắp xếp -->
                <div class="sort-bar">
                    <div class="fw-bold text-dark fs-5 serif-font">
                        ${empty param.category ? 'Tất cả sản phẩm' : (param.category == 'nhapkhau' ? 'Trái cây nhập khẩu' : 'Sản phẩm')}
                        <span class="text-muted fs-6 fw-normal ms-2">(${fn:length(products)} sản phẩm)</span>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-muted fw-medium fs-6"><i class="ph-bold ph-sort-ascending me-1"></i>Sắp xếp:</span>
                        <select id="sortSelect" class="sort-select" onchange="applyFilters()">
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="priceAsc" ${param.sort == 'priceAsc' ? 'selected' : ''}>Giá: Tăng dần</option>
                            <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected' : ''}>Giá: Giảm dần</option>
                            <option value="nameAsc" ${param.sort == 'nameAsc' ? 'selected' : ''}>Tên: A-Z</option>
                        </select>
                    </div>
                </div>

                <!-- Lưới Sản phẩm -->
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty products}">
                            <div class="col-12 text-center py-5">
                                <i class="ph-light ph-magnifying-glass text-muted mb-3" style="font-size: 48px;"></i>
                                <h5 class="fw-bold">Không tìm thấy sản phẩm nào!</h5>
                                <p class="text-muted">Vui lòng thử thay đổi điều kiện lọc.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${products}">
                                <div class="col-xl-4 col-md-6 col-6">
                                    <div class="product-card">
                                        <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="product-img-wrap d-block">
                                            <img src="${not empty p.image && fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/products/').concat(p.image)}" class="product-img">
                                        </a>
                                        <div class="product-info">
                                            <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="product-name">${p.name}</a>
                                            <div class="text-muted small mb-2"><i class="ph-fill ph-map-pin"></i> ${not empty p.origin ? p.origin : 'Fruit Farmer'}</div>
                                            <div class="fw-bold text-success fs-5"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/><span class="fw-normal text-muted fs-6">/${p.unit}</span></div>
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0 mt-3">
                                                <input type="hidden" name="action" value="add"><input type="hidden" name="id" value="${p.id}"><input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn-add-cart" ${p.stock <= 0 ? 'disabled' : ''}>${p.stock <= 0 ? 'Hết hàng' : 'Thêm vào giỏ'}</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- JS XỬ LÝ URL BỘ LỌC MƯỢT MÀ -->
    <script>
        function applyFilters() {
            let url = new URL(window.location.href);

            // 1. Lấy Sort
            let sortVal = document.getElementById('sortSelect').value;
            url.searchParams.set('sort', sortVal);

            // 2. Lấy Xuất xứ (Checkboxes)
            let origins = [];
            document.querySelectorAll('input[name="origin"]:checked').forEach(cb => origins.push(cb.value));
            url.searchParams.delete('origin'); // Xóa cũ
            if(origins.length > 0) {
                origins.forEach(o => url.searchParams.append('origin', o));
            }

            // 3. Lấy Khoảng giá (Radio)
            let priceCheck = document.querySelector('input[name="priceRange"]:checked');
            if(priceCheck) {
                url.searchParams.set('priceRange', priceCheck.value);
            }

            // Reload trang với URL mới để Servlet bắt thông tin
            window.location.href = url.toString();
        }

        function clearFilters() {
            let url = new URL(window.location.href);
            url.searchParams.delete('origin');
            url.searchParams.delete('priceRange');
            window.location.href = url.toString();
        }
    </script>
</body>
</html>