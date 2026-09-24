<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fruit Farmer Market | Premium Fresh Produce</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>

    <!-- Typography: Inter (Commerce) + Playfair Display (Premium Branding) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-cream: #F9F8F4;
            --primary-dark: #163D2A;
            --primary-green: #1F9D55;
            --accent-orange: #E87817;
            --text-main: #1F2937;
            --text-muted: #6B7280;
            --border-light: #E5E7EB;
            --surface-white: #FFFFFF;
        }

        body { font-family: 'Inter', sans-serif; color: var(--text-main); background-color: var(--surface-white); -webkit-font-smoothing: antialiased; }
        .serif-font { font-family: 'Playfair Display', serif; }

        /* Header & Sticky */
        .header-main { background-color: var(--surface-white); border-bottom: 1px solid var(--border-light); padding: 16px 0; transition: box-shadow 0.3s; }
        .header-main.sticky-top { z-index: 1020; }
        .navbar-brand { font-size: 28px; color: var(--primary-dark) !important; letter-spacing: -0.5px; }

        /* ================= DROPDOWN XƯƠNG CÁ (MEGA MENU) ================= */
        .nav-link { color: var(--text-main); font-weight: 500; font-size: 15px; padding: 8px 20px !important; transition: color 0.2s; position: relative; }
        .nav-link:hover { color: var(--primary-green); }

        .dropdown-hover:hover .mega-menu { opacity: 1; visibility: visible; transform: translateY(0); }
        .mega-menu {
            position: absolute; top: 100%; left: 0; background: #fff; width: 600px; padding: 24px;
            border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border: 1px solid var(--border-light);
            opacity: 0; visibility: hidden; transform: translateY(10px); transition: all 0.3s ease; z-index: 1050;
            display: flex; gap: 30px;
        }
        .mega-menu-col { flex: 1; }
        .mega-menu-title { font-weight: 700; color: var(--primary-dark); border-bottom: 2px solid var(--primary-green); padding-bottom: 8px; margin-bottom: 16px; font-size: 15px; text-transform: uppercase; letter-spacing: 0.5px; }
        .mega-menu-item { display: block; padding: 8px 0; color: var(--text-muted); text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.2s; position: relative; padding-left: 16px; }
        .mega-menu-item::before { content: '→'; position: absolute; left: 0; opacity: 0; transition: 0.2s; color: var(--primary-green); }
        .mega-menu-item:hover { color: var(--primary-green); padding-left: 20px; }
        .mega-menu-item:hover::before { opacity: 1; left: 4px; }
        /* Cấu trúc xương cá con */
        .fishbone-sub { border-left: 1px dashed #ccc; margin-left: 10px; padding-left: 15px; margin-top: 5px; }
        .fishbone-sub a { display: block; font-size: 13px; color: #888; text-decoration: none; padding: 4px 0; transition: 0.2s; }
        .fishbone-sub a:hover { color: var(--primary-green); }

        /* Search & Icons */
        .search-bar { background: var(--bg-cream); border-radius: 8px; padding: 10px 16px; display: flex; align-items: center; width: 300px; border: 1px solid transparent; transition: 0.2s; }
        .search-bar:focus-within { background: var(--surface-white); border-color: var(--primary-green); box-shadow: 0 0 0 3px rgba(31, 157, 85, 0.1); }
        .search-bar input { border: none; background: transparent; outline: none; width: 100%; margin-left: 10px; font-size: 14px; color: var(--text-main); }

        .header-icon { color: var(--text-main); font-size: 24px; text-decoration: none; position: relative; transition: 0.2s; display: flex; align-items: center; gap: 8px; cursor: pointer; }
        .header-icon:hover { color: var(--primary-green); }
        .cart-badge { position: absolute; top: -5px; right: -8px; background: var(--accent-orange); color: white; font-size: 10px; font-weight: 700; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; border-radius: 50%; border: 2px solid white; }

        /* ================= MODULE 3: MIX GIỎ QUÀ ================= */
        .mix-basket-section { background: linear-gradient(135deg, #fdfbf7 0%, #f4f7f6 100%); padding: 80px 0; border-top: 1px solid var(--border-light); }
        .basket-workspace { background: #fff; border-radius: 16px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.05); border: 2px dashed #E5E7EB; min-height: 400px; display: flex; flex-direction: column; }
        .basket-workspace.active { border-color: var(--primary-green); background: #fafffc; }
        .fruit-picker-item { background: #fff; border: 1px solid var(--border-light); border-radius: 12px; padding: 12px; text-align: center; cursor: pointer; transition: 0.2s; user-select: none; }
        .fruit-picker-item:hover { border-color: var(--primary-green); transform: translateY(-3px); box-shadow: 0 5px 15px rgba(31,157,85,0.1); }
        .fruit-picker-item img { width: 60px; height: 60px; object-fit: contain; margin-bottom: 8px; mix-blend-mode: multiply; }
        .added-fruit-chip { background: #fff; border: 1px solid #E5E7EB; padding: 6px 12px; border-radius: 99px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; margin: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .added-fruit-chip i { cursor: pointer; color: #ef4444; }

        /* UI Buttons & Hero */
        .hero-section { background-color: var(--bg-cream); min-height: 60vh; display: flex; align-items: center; padding: 60px 0; }
        .hero-title { font-size: 52px; color: var(--primary-dark); line-height: 1.1; margin-bottom: 20px; letter-spacing: -1px; }
        .btn-primary-custom { background-color: var(--primary-dark); color: #fff; border-radius: 6px; padding: 14px 32px; font-weight: 600; font-size: 15px; border: none; transition: 0.2s; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-primary-custom:hover { background-color: #0f291c; color: #fff; transform: translateY(-2px); }
        .product-card { border: 1px solid var(--border-light); border-radius: 12px; background: var(--surface-white); transition: all 0.3s ease; height: 100%; display: flex; flex-direction: column; overflow: hidden; position: relative; }
        .product-card:hover { border-color: var(--primary-green); box-shadow: 0 12px 24px rgba(0,0,0,0.06); transform: translateY(-4px); z-index: 2; }
        .product-img-wrap { width: 100%; aspect-ratio: 1/1; overflow: hidden; background: #F9FAFB; padding: 20px; position: relative; }
        .product-img { width: 100%; height: 100%; object-fit: contain; transition: transform 0.5s ease; mix-blend-mode: multiply; }
        .product-info { padding: 20px; display: flex; flex-direction: column; flex-grow: 1; border-top: 1px solid #f3f4f6; }
        .product-price { font-size: 18px; font-weight: 700; color: var(--primary-dark); margin-top: auto; }
        .btn-add-cart { background: var(--surface-white); color: var(--primary-dark); border: 1px solid var(--border-light); width: 100%; padding: 12px; border-radius: 8px; font-weight: 600; font-size: 14px; transition: all 0.2s; margin-top: 20px; }
        .btn-add-cart:hover { background: var(--primary-green); color: var(--surface-white); border-color: var(--primary-green); }

        /* Mix Gift Basket Modal */
        .mix-basket-modal .modal-content { border-radius: 16px; border: none; }
        .mix-basket-modal .modal-header { border-bottom: 1px solid var(--border-light); padding: 20px 30px; }
        .mix-basket-modal .modal-body { padding: 30px; }
        .mix-basket-modal .stepper { display: flex; justify-content: space-between; margin-bottom: 30px; }
        .mix-basket-modal .step { flex: 1; text-align: center; font-weight: 600; color: var(--text-muted); position: relative; }
        .mix-basket-modal .step::after { content: ''; position: absolute; top: 12px; left: 50%; width: 100%; height: 2px; background: var(--border-light); z-index: 1; }
        .mix-basket-modal .step:last-child::after { display: none; }
        .mix-basket-modal .step-icon { width: 26px; height: 26px; border-radius: 50%; background: var(--border-light); color: #fff; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; position: relative; z-index: 2; }
        .mix-basket-modal .step.active { color: var(--primary-green); }
        .mix-basket-modal .step.active .step-icon { background: var(--primary-green); }

        .mix-basket-modal .step-content { display: none; }
        .mix-basket-modal .step-content.active { display: block; }

        /* Summary Sidebar in Modal */
        .summary-sidebar { background: var(--bg-cream); border-radius: 12px; padding: 20px; height: 100%; }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
        .summary-total { font-weight: 700; font-size: 18px; color: var(--primary-dark); border-top: 1px solid var(--border-light); padding-top: 15px; margin-top: 15px; }

        .radio-box { border: 1px solid var(--border-light); border-radius: 8px; padding: 15px; cursor: pointer; transition: 0.2s; display: block; text-align: center; }
        .radio-box:hover { border-color: var(--primary-green); }
        .radio-box input[type="radio"] { display: none; }
        .radio-box input[type="radio"]:checked + .radio-content { font-weight: bold; color: var(--primary-green); }
        .radio-box:has(input[type="radio"]:checked) { border-color: var(--primary-green); background-color: #f0fdf4; }
    </style>
</head>
<body>

    <!-- 1. HEADER & MEGA MENU -->
    <header class="header-main sticky-top">
        <div class="container d-flex justify-content-between align-items-center">

            <a class="navbar-brand serif-font fw-bold text-decoration-none" href="${pageContext.request.contextPath}/">Fruit Farmer.</a>

            <nav class="d-none d-lg-flex position-relative">
                <!-- Dropdown Xương cá (Mega Menu) -->
                <div class="dropdown-hover">
                    <a class="nav-link" style="cursor: pointer;">Cửa hàng <i class="ph-bold ph-caret-down" style="font-size: 12px;"></i></a>
                    <div class="mega-menu">
                        <div class="mega-menu-col">
                            <div class="mega-menu-title">Trái cây theo vùng</div>
                            <a href="${pageContext.request.contextPath}/products?category=vietnam" class="mega-menu-item">Trái Cây Việt Nam</a>
                            <div class="fishbone-sub">
                                <a href="#">Đặc sản Miền Tây</a>
                                <a href="#">Trái cây Miền Bắc</a>
                            </div>

                            <a href="${pageContext.request.contextPath}/products?category=nhapkhau" class="mega-menu-item mt-3">Trái Cây Nhập Khẩu</a>
                            <div class="fishbone-sub">
                                <a href="#">Táo, Cherry Mỹ</a>
                                <a href="#">Nho Mẫu Đơn Hàn</a>
                            </div>
                        </div>
                        <div class="mega-menu-col">
                            <div class="mega-menu-title">Quà Tặng & Combo</div>
                            <a href="${pageContext.request.contextPath}/products?category=combo" class="mega-menu-item">Giỏ Quà Biếu Tặng</a>
                            <div class="fishbone-sub">
                                <a href="#">Quà Lễ / Tết</a>
                                <a href="#">Quà Thăm Hỏi</a>
                            </div>

                            <!-- MỞ MODAL MIX GIỎ QUÀ Ở ĐÂY -->
                            <a href="#" class="mega-menu-item mt-3 text-success fw-bold" data-bs-toggle="modal" data-bs-target="#mixBasketModal"><i class="ph-fill ph-magic-wand me-1"></i> Tự Mix Giỏ Quà</a>
                        </div>
                    </div>
                </div>

                <a class="nav-link" href="${pageContext.request.contextPath}/vouchers">Khuyến mãi</a>
                <a class="nav-link" href="#story">Câu chuyện</a>
            </nav>

            <!-- Actions -->
            <div class="d-flex align-items-center gap-4">
                <form action="${pageContext.request.contextPath}/products" method="GET" class="search-bar d-none d-xl-flex m-0">
                    <i class="ph ph-magnifying-glass text-muted fs-5"></i>
                    <input type="text" name="keyword" placeholder="Tìm kiếm trái cây..." required>
                </form>

                <!-- ICON TRA CỨU ĐƠN HÀNG MỚI -->
                <a class="header-icon" data-bs-toggle="modal" data-bs-target="#trackOrderModal" title="Tra cứu đơn hàng">
                    <i class="ph ph-package"></i>
                </a>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <a href="#" class="header-icon" data-bs-toggle="dropdown"><i class="ph ph-user"></i></a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-3" style="border-radius: 8px;">
                                <li><a class="dropdown-item py-2 fw-medium" href="${pageContext.request.contextPath}/profile">Tài khoản</a></li>
                                <li><a class="dropdown-item py-2 fw-medium" href="${pageContext.request.contextPath}/orders/history">Đơn mua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="header-icon" title="Đăng nhập"><i class="ph ph-user"></i></a>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/cart" class="header-icon">
                    <i class="ph ph-shopping-cart"></i>
                    <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                        <span class="cart-badge">${sessionScope.cart.size()}</span>
                    </c:if>
                </a>
            </div>
        </div>
    </header>

    <!-- 2. HERO SECTION -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 pe-lg-5 mb-5 mb-lg-0">
                    <div class="text-uppercase fw-bold mb-3" style="color: var(--primary-green); font-size: 12px; letter-spacing: 1.5px;">Trái cây tươi mỗi ngày</div>
                    <h1 class="hero-title serif-font fw-bold">Chọn trái cây tươi<br>cho một ngày<br>ngon lành.</h1>
                    <p class="text-muted mb-4" style="font-size: 18px;">Trái cây Việt Nam và nhập khẩu cao cấp. Được lựa chọn kỹ lưỡng, đóng gói cẩn thận và giao tận nhà.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-primary-custom">Mua sắm ngay</a>
                    <button class="btn btn-outline-custom ms-3" data-bs-toggle="modal" data-bs-target="#mixBasketModal">Tự mix giỏ quà</button>
                </div>
                <div class="col-lg-6">
                    <img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=1200&auto=format&fit=crop" class="img-fluid rounded-4 shadow-sm" alt="Giỏ trái cây tươi">
                </div>
            </div>
        </div>
    </section>

    <!-- TRUST STRIP -->
    <div class="py-4 border-bottom bg-white d-none d-md-block">
        <div class="container">
            <div class="row text-center">
                <div class="col-3 border-end"><i class="ph ph-plant text-success fs-4 me-2 align-middle"></i> Nguồn gốc rõ ràng</div>
                <div class="col-3 border-end"><i class="ph ph-sun text-success fs-4 me-2 align-middle"></i> Tươi ngon mỗi ngày</div>
                <div class="col-3 border-end"><i class="ph ph-package text-success fs-4 me-2 align-middle"></i> Đóng gói cẩn thận</div>
                <div class="col-3"><i class="ph ph-truck text-success fs-4 me-2 align-middle"></i> Giao hàng tận nơi</div>
            </div>
        </div>
    </div>

    <!-- FEATURED PRODUCTS -->
    <section class="py-5 bg-white">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="serif-font fw-bold m-0" style="color: var(--primary-dark);">Sản phẩm nổi bật</h2>
                    <p class="text-muted m-0 mt-2">Những lựa chọn tươi ngon cho hôm nay.</p>
                </div>
                <a href="${pageContext.request.contextPath}/products" class="text-dark fw-medium text-decoration-none border-bottom border-dark pb-1">Xem tất cả <i class="ph ph-arrow-right"></i></a>
            </div>

            <div class="row g-4">
                <c:forEach var="p" items="${featuredProducts}" end="7">
                    <div class="col-xl-3 col-lg-4 col-md-6 col-12">
                        <div class="product-card">
                            <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="product-img-wrap d-block">
                                <c:choose>
                                    <c:when test="${not empty p.image && fn:startsWith(p.image, 'http')}"><img src="${p.image}" class="product-img"></c:when>
                                    <c:when test="${not empty p.image}"><img src="${pageContext.request.contextPath}/assets/images/products/${p.image}" class="product-img"></c:when>
                                    <c:otherwise><img src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=400&auto=format&fit=crop" class="product-img"></c:otherwise>
                                </c:choose>
                            </a>
                            <div class="product-info">
                                <div class="text-muted fw-bold mb-2" style="font-size: 11px; text-transform: uppercase;">${p.categoryName != null ? p.categoryName : 'Trái cây'}</div>
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}" class="text-dark fw-semibold text-decoration-none mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">${p.name}</a>
                                <div class="text-muted mb-3" style="font-size: 13px;"><i class="ph-fill ph-map-pin"></i> ${p.origin != null ? p.origin : 'Fruit Farmer'}</div>
                                <div class="product-price">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    <span class="fw-normal text-muted" style="font-size: 13px;">/ ${p.unit}</span>
                                </div>
                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="m-0 mt-auto pt-3">
                                    <input type="hidden" name="action" value="add"><input type="hidden" name="id" value="${p.id}"><input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-add-cart" ${p.stock <= 0 ? 'disabled' : ''}>
                                        <i class="ph ${p.stock <= 0 ? 'ph-prohibit' : 'ph-shopping-cart'} fs-5 align-middle me-1"></i> ${p.stock <= 0 ? 'HẾT HÀNG' : 'Thêm vào giỏ'}
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="pt-5 pb-4 bg-light border-top">
        <div class="container">
            <div class="row mb-4">
                <div class="col-lg-4 mb-4 mb-lg-0">
                    <h3 class="serif-font fw-bold mb-3" style="color: var(--primary-dark);">Fruit Farmer.</h3>
                    <p class="text-muted" style="font-size: 14px; max-width: 300px; line-height: 1.6;">Cửa hàng bán lẻ trái cây tươi chuyên nghiệp. Cam kết chất lượng trên từng sản phẩm.</p>
                </div>
                <!-- ...các menu footer... -->
            </div>
            <div class="text-center text-muted border-top pt-4" style="font-size: 13px;">
                &copy; 2026 Fruit Farmer Market. All rights reserved.
            </div>
        </div>
    </footer>

    <!-- ========================================================= -->
    <!-- MODAL 1: TỰ MIX GIỎ QUÀ (HYBRID: LAI GIỮA DB & CODE CỨNG)  -->
    <!-- ========================================================= -->
    <div class="modal fade mix-basket-modal" id="mixBasketModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title serif-font fw-bold text-success"><i class="ph-fill ph-magic-wand me-2"></i>Tự Mix Giỏ Quà</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body bg-light">
                    <div class="row g-4">
                        <!-- CỘT TRÁI: NỘI DUNG CÁC BƯỚC -->
                        <div class="col-lg-8 bg-white p-4 rounded-4 border">
                            <!-- Stepper -->
                            <div class="stepper mb-4 border-bottom pb-3">
                                <div class="step active" id="modal-step-1"><div class="step-icon">1</div><span>Trái Cây</span></div>
                                <div class="step" id="modal-step-2"><div class="step-icon">2</div><span>Giỏ</span></div>
                                <div class="step" id="modal-step-3"><div class="step-icon">3</div><span>Hoàn thiện</span></div>
                            </div>

                            <!-- Step 1: Chọn trái cây -->
                            <div class="step-content active" id="modal-content-1">
                                <h5 class="fw-bold mb-1">1. Chọn trái cây cho giỏ quà</h5>
                                <p class="text-muted small mb-3">Thêm bớt số lượng tùy ý (ít nhất 1 loại).</p>
                                <div class="row g-3">
                                    <c:forEach var="p" items="${featuredProducts}" end="5">
                                        <div class="col-md-4 col-6">
                                            <div class="fruit-picker-item h-100 d-flex flex-column border rounded-3 p-3">
                                                <c:set var="imgUrl" value="${not empty p.image && fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/products/').concat(p.image)}" />
                                                <img src="${imgUrl}" alt="${p.name}" class="img-fluid mb-2 mx-auto" style="height: 80px; object-fit: contain;">
                                                <div class="fw-bold text-dark text-truncate mb-1" style="font-size: 13px;" title="${p.name}">${p.name}</div>
                                                <div class="text-success fw-bold mb-3" style="font-size: 13px;"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>

                                                <!-- BỘ ĐẾM SỐ LƯỢNG RÕ RÀNG -->
                                                <div class="mt-auto d-flex justify-content-center">
                                                    <div class="d-flex align-items-center border rounded bg-light w-100 justify-content-between px-2">
                                                        <button type="button" class="btn btn-sm text-dark border-0 fw-bold fs-5" onclick="changeModalQty('${p.id}', '${fn:escapeXml(p.name)}', ${p.price}, '${imgUrl}', -1)">-</button>
                                                        <input type="text" class="form-control form-control-sm text-center border-0 p-0 fw-bold bg-transparent" id="modal_qty_${p.id}" value="0" readonly style="width: 30px;">
                                                        <button type="button" class="btn btn-sm text-success border-0 fw-bold fs-5" onclick="changeModalQty('${p.id}', '${fn:escapeXml(p.name)}', ${p.price}, '${imgUrl}', 1)">+</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="mt-4 text-end">
                                    <button type="button" class="btn btn-success fw-bold px-4 py-2 rounded-3" onclick="nextModalStep(2)">Tiếp tục <i class="ph-bold ph-arrow-right ms-2"></i></button>
                                </div>
                            </div>

                            <!-- Step 2: Chọn giỏ (Hybrid: Bốc từ DB, nếu DB trống dùng code cứng) -->
                            <div class="step-content" id="modal-content-2">
                                <h5 class="fw-bold mb-3">2. Chọn giỏ phù hợp</h5>
                                <div class="row g-3">
                                    <c:choose>
                                        <c:when test="${not empty baskets}">
                                            <c:forEach var="basket" items="${baskets}" varStatus="status">
                                                <div class="col-md-6">
                                                    <label class="radio-box h-100 p-3">
                                                        <input type="radio" name="basketId" value="${basket.id}" data-name="${basket.name}" data-price="${basket.price}" onchange="updateModalSummary()" ${status.first ? 'checked' : ''}>
                                                        <div class="radio-content">
                                                            <c:choose>
                                                                <c:when test="${not empty basket.image}"><img src="${basket.image}" style="height: 50px; object-fit: contain; margin-bottom: 10px;"></c:when>
                                                                <c:otherwise><i class="ph-light ph-basket fs-1 text-muted mb-2"></i></c:otherwise>
                                                            </c:choose>
                                                            <div class="fw-bold text-dark">${basket.name}</div>
                                                            <div class="text-success fw-bold mt-1"><fmt:formatNumber value="${basket.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="col-md-6">
                                                <label class="radio-box h-100 p-3">
                                                    <input type="radio" name="basketId" value="1" data-name="Giỏ Mây Tiêu Chuẩn" data-price="80000" onchange="updateModalSummary()" checked>
                                                    <div class="radio-content">
                                                        <i class="ph-light ph-basket fs-1 text-muted mb-2"></i>
                                                        <div class="fw-bold text-dark">Giỏ Mây Tiêu Chuẩn</div>
                                                        <div class="text-success fw-bold mt-1">80.000 ₫</div>
                                                    </div>
                                                </label>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="radio-box h-100 p-3">
                                                    <input type="radio" name="basketId" value="2" data-name="Giỏ Gỗ Premium" data-price="120000" onchange="updateModalSummary()">
                                                    <div class="radio-content">
                                                        <i class="ph-light ph-package fs-1 text-muted mb-2"></i>
                                                        <div class="fw-bold text-dark">Giỏ Gỗ Premium</div>
                                                        <div class="text-success fw-bold mt-1">120.000 ₫</div>
                                                    </div>
                                                </label>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mt-4 d-flex justify-content-between">
                                    <button type="button" class="btn btn-outline-secondary fw-bold px-4 py-2 rounded-3" onclick="nextModalStep(1)"><i class="ph-bold ph-arrow-left me-2"></i> Quay lại</button>
                                    <button type="button" class="btn btn-success fw-bold px-4 py-2 rounded-3" onclick="nextModalStep(3)">Tiếp tục <i class="ph-bold ph-arrow-right ms-2"></i></button>
                                </div>
                            </div>

                            <!-- Step 3: Hoàn thiện (Hybrid: Bốc từ DB, nếu DB trống dùng code cứng) -->
                            <div class="step-content" id="modal-content-3">
                                <h5 class="fw-bold mb-4">3. Hoàn thiện giỏ quà</h5>

                                <div class="mb-4">
                                    <label class="fw-bold text-dark mb-2"><i class="ph-fill ph-envelope-simple text-warning me-2"></i>Thiệp chúc mừng (Miễn phí)</label>
                                    <textarea id="cardMessageInput" class="form-control bg-light border-light" rows="2" placeholder="Nhập lời nhắn gửi tặng người thân..."></textarea>
                                </div>

                                <div class="mb-4">
                                    <label class="fw-bold text-dark mb-2"><i class="ph-fill ph-sparkle text-danger me-2"></i>Trang trí</label>
                                    <div class="row g-2">
                                        <c:choose>
                                            <c:when test="${not empty decorations}">
                                                <c:forEach var="decor" items="${decorations}" varStatus="status">
                                                    <div class="col-6">
                                                        <label class="radio-box p-3">
                                                            <input type="radio" name="decorId" value="${decor.id}" data-name="${decor.name}" data-price="${decor.price}" onchange="updateModalSummary()" ${status.first ? 'checked' : ''}>
                                                            <div class="radio-content fw-bold text-dark">
                                                                <c:if test="${not empty decor.image}"><img src="${decor.image}" style="height: 30px; object-fit: contain; margin-bottom: 5px;"><br></c:if>
                                                                ${decor.name} <br><span class="text-success fw-bold small"><fmt:formatNumber value="${decor.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                                            </div>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-6">
                                                    <label class="radio-box p-3">
                                                        <input type="radio" name="decorId" value="1" data-name="Hoa khô" data-price="25000" onchange="updateModalSummary()" checked>
                                                        <div class="radio-content fw-bold text-dark">Hoa khô <br><span class="text-success fw-bold small">25.000 ₫</span></div>
                                                    </label>
                                                </div>
                                                 <div class="col-6">
                                                    <label class="radio-box p-3">
                                                        <input type="radio" name="decorId" value="2" data-name="Nơ ruy băng" data-price="15000" onchange="updateModalSummary()">
                                                        <div class="radio-content fw-bold text-dark">Nơ ruy băng <br><span class="text-success fw-bold small">15.000 ₫</span></div>
                                                    </label>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="fw-bold text-dark mb-2"><i class="ph-fill ph-package text-primary me-2"></i>Đóng gói</label>
                                    <div class="row g-2">
                                        <c:choose>
                                            <c:when test="${not empty packagings}">
                                                <c:forEach var="pack" items="${packagings}" varStatus="status">
                                                    <div class="col-6">
                                                        <label class="radio-box p-3">
                                                            <input type="radio" name="packId" value="${pack.id}" data-name="${pack.name}" data-price="${pack.price}" onchange="updateModalSummary()" ${status.first ? 'checked' : ''}>
                                                            <div class="radio-content fw-bold text-dark">
                                                                <c:if test="${not empty pack.image}"><img src="${pack.image}" style="height: 30px; object-fit: contain; margin-bottom: 5px;"><br></c:if>
                                                                ${pack.name} <br><span class="text-success fw-bold small"><fmt:formatNumber value="${pack.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                                            </div>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="col-6">
                                                    <label class="radio-box p-3">
                                                        <input type="radio" name="packId" value="1" data-name="Màng co" data-price="20000" onchange="updateModalSummary()" checked>
                                                        <div class="radio-content fw-bold text-dark">Màng co <br><span class="text-success fw-bold small">20.000 ₫</span></div>
                                                    </label>
                                                </div>
                                                 <div class="col-6">
                                                    <label class="radio-box p-3">
                                                        <input type="radio" name="packId" value="2" data-name="Túi quà" data-price="35000" onchange="updateModalSummary()">
                                                        <div class="radio-content fw-bold text-dark">Túi quà <br><span class="text-success fw-bold small">35.000 ₫</span></div>
                                                    </label>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="mt-4 d-flex justify-content-between align-items-center pt-3 border-top">
                                    <button type="button" class="btn btn-outline-secondary fw-bold px-4 py-2 rounded-3" onclick="nextModalStep(2)"><i class="ph-bold ph-arrow-left me-2"></i> Quay lại</button>
                                    <button type="button" class="btn btn-success fw-bold px-5 py-2 rounded-3" id="btnSubmitModal" onclick="submitModalMixBasket()" disabled>THÊM VÀO GIỎ HÀNG</button>
                                </div>
                            </div>
                        </div>

                        <!-- CỘT PHẢI: SUMMARY -->
                        <div class="col-lg-4">
                            <div class="summary-sidebar bg-white border p-4 rounded-4 sticky-top" style="top: 20px;">
                                <h6 class="fw-bold mb-3 border-bottom pb-3 brand-font text-center text-success">TÓM TẮT GIỎ QUÀ</h6>

                                <div id="modalBasketItemsArea" class="mb-3" style="max-height: 250px; overflow-y: auto;">
                                    <div class="text-muted small text-center pt-3 pb-3">Chưa chọn trái cây</div>
                                </div>

                                <div class="border-top pt-3">
                                    <div class="summary-item text-muted">
                                        <span id="sum-basket-name-modal">Giỏ (Chưa chọn)</span>
                                        <span class="text-dark fw-medium" id="sum-basket-price-modal">0 ₫</span>
                                    </div>
                                    <div class="summary-item text-muted">
                                        <span id="sum-decor-name-modal">Trang trí (Chưa chọn)</span>
                                        <span class="text-dark fw-medium" id="sum-decor-price-modal">0 ₫</span>
                                    </div>
                                    <div class="summary-item text-muted">
                                        <span id="sum-pack-name-modal">Đóng gói (Chưa chọn)</span>
                                        <span class="text-dark fw-medium" id="sum-pack-price-modal">0 ₫</span>
                                    </div>
                                </div>

                                <div class="summary-item summary-total">
                                    <span>TỔNG CỘNG</span>
                                    <span class="text-success fs-3" id="sum-total-modal">0 ₫</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ========================================================= -->
    <!-- MODAL 2: TRA CỨU ĐƠN HÀNG (Dành cho Khách Vãng Lai) -->
    <!-- ========================================================= -->
    <div class="modal fade" id="trackOrderModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold brand-font text-dark"><i class="ph-fill ph-package text-success me-2"></i>Tra Cứu Nhanh</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/track-order" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-medium text-dark small">Mã đơn hàng</label>
                            <input type="text" name="orderId" class="form-control bg-light" placeholder="Ví dụ: 1024" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-medium text-dark small">Số điện thoại đặt hàng</label>
                            <input type="text" name="phone" class="form-control bg-light" placeholder="Nhập số điện thoại" required>
                        </div>
                        <button type="submit" class="btn btn-dark w-100 fw-bold py-2 rounded-3">Kiểm Tra Ngay</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JS LOGIC CHO MIX GIỎ QUÀ -->
    <script>
        let modalBasketItems = [];
        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

        function changeModalQty(id, name, price, img, change) {
            let existingItem = modalBasketItems.find(item => item.id === id);
            let currentQty = existingItem ? existingItem.quantity : 0;
            let newQty = currentQty + change;

            if (newQty < 0) newQty = 0;

            if (newQty === 0) {
                modalBasketItems = modalBasketItems.filter(item => item.id !== id);
            } else if (existingItem) {
                existingItem.quantity = newQty;
            } else {
                modalBasketItems.push({ id: id, name: name, price: parseFloat(price), image: img, quantity: newQty });
            }

            let qtyInput = document.getElementById('modal_qty_' + id);
            if(qtyInput) qtyInput.value = newQty;

            renderModalBasket();
            updateModalSummary();
        }

        function removeModalFruit(id) {
            modalBasketItems = modalBasketItems.filter(item => item.id !== id);
            let qtyInput = document.getElementById('modal_qty_' + id);
            if(qtyInput) qtyInput.value = 0;

            renderModalBasket();
            updateModalSummary();
        }

        function renderModalBasket() {
            const container = document.getElementById('modalBasketItemsArea');
            if(modalBasketItems.length === 0) {
                container.innerHTML = '<div class="text-muted small text-center pt-3 pb-3">Chưa chọn trái cây</div>';
                return;
            }

            let html = '';
            modalBasketItems.forEach(item => {
                html += `
                    <div class="d-flex align-items-center mb-3">
                        <img src="\${item.image}" alt="\${item.name}" class="rounded border p-1 bg-light" style="width: 45px; height: 45px; object-fit: contain; margin-right: 12px;">
                        <div class="flex-grow-1">
                            <div class="fw-bold text-dark text-truncate" style="font-size: 13px; max-width: 130px;" title="\${item.name}">\${item.name}</div>
                            <div class="text-muted" style="font-size: 12px;">Số lượng: \${item.quantity}</div>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold text-success" style="font-size: 13px;">\${formatter.format(item.price * item.quantity)}</div>
                            <i class="ph-bold ph-trash text-danger mt-1" style="cursor:pointer; font-size: 14px;" onclick="removeModalFruit('\${item.id}')"></i>
                        </div>
                    </div>
                `;
            });
            container.innerHTML = html;
        }

        function nextModalStep(targetStep) {
            if (targetStep > 1 && modalBasketItems.length === 0) {
                alert("Vui lòng chọn ít nhất 1 loại trái cây nhé!");
                return;
            }
            if (targetStep === 3) {
                let basketChecked = document.querySelector('input[name="basketId"]:checked');
                if (!basketChecked) {
                    alert("Vui lòng chọn vỏ giỏ quà trước khi tiếp tục!");
                    return;
                }
            }

            document.querySelectorAll('.mix-basket-modal .step').forEach((el, index) => {
                el.classList.remove('active');
                if (index < targetStep) el.classList.add('active');
            });

            document.querySelectorAll('.mix-basket-modal .step-content').forEach(el => el.classList.remove('active'));
            document.getElementById('modal-content-' + targetStep).classList.add('active');

            updateModalSummary();
        }

        function updateModalSummary() {
            let fruitTotal = modalBasketItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);

            let basketPrice = 0;
            let basketInput = document.querySelector('input[name="basketId"]:checked');
            if(basketInput) {
                basketPrice = parseFloat(basketInput.dataset.price);
                document.getElementById('sum-basket-name-modal').innerText = basketInput.dataset.name;
                document.getElementById('sum-basket-price-modal').innerText = formatter.format(basketPrice);
            }

            let decorPrice = 0;
            let decorInput = document.querySelector('input[name="decorId"]:checked');
            if(decorInput) {
                decorPrice = parseFloat(decorInput.dataset.price);
                document.getElementById('sum-decor-name-modal').innerText = decorInput.dataset.name;
                document.getElementById('sum-decor-price-modal').innerText = formatter.format(decorPrice);
            }

            let packPrice = 0;
            let packInput = document.querySelector('input[name="packId"]:checked');
            if(packInput) {
                packPrice = parseFloat(packInput.dataset.price);
                document.getElementById('sum-pack-name-modal').innerText = packInput.dataset.name;
                document.getElementById('sum-pack-price-modal').innerText = formatter.format(packPrice);
            }

            let finalTotal = fruitTotal + basketPrice + decorPrice + packPrice;
            document.getElementById('sum-total-modal').innerText = formatter.format(finalTotal);

            const btnSubmit = document.getElementById('btnSubmitModal');
            if(modalBasketItems.length > 0 && basketInput && decorInput && packInput) {
                btnSubmit.disabled = false;
            } else {
                btnSubmit.disabled = true;
            }
        }

        async function submitModalMixBasket() {
            const btn = document.getElementById('btnSubmitModal');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang đóng gói...';
            btn.disabled = true;

            try {
                const formData = new URLSearchParams();

                modalBasketItems.forEach(item => {
                    formData.append('fruit_qty_' + item.id, item.quantity);
                });

                formData.append('basketId', document.querySelector('input[name="basketId"]:checked').value);
                formData.append('decorationId', document.querySelector('input[name="decorId"]:checked').value);
                formData.append('packagingId', document.querySelector('input[name="packId"]:checked').value);
                formData.append('cardMessage', document.getElementById('cardMessageInput').value);

                let response = await fetch('${pageContext.request.contextPath}/gift-basket', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                });

                if(response.ok) {
                    window.location.href = '${pageContext.request.contextPath}/cart';
                } else {
                    alert("Có lỗi xảy ra từ Server. Vui lòng thử lại!");
                    btn.innerHTML = 'THÊM VÀO GIỎ HÀNG';
                    btn.disabled = false;
                }
            } catch (error) {
                console.error(error);
                alert("Lỗi kết nối khi thêm giỏ quà!");
                btn.innerHTML = 'THÊM VÀO GIỎ HÀNG';
                btn.disabled = false;
            }
        }
    </script>
</body>
</html>