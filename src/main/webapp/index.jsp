<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fruit Farmer | Trái cây tươi từ vườn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <!-- ANNOUNCEMENT BAR (Thực tế) -->
    <div class="announcement-bar">
        🌱 Mỗi ngày một lựa chọn tươi mới · Giao nhanh 2H nội thành Hà Nội & Việt Trì
    </div>

    <!-- NAVBAR (Tối giản + Tăng hierarchy cho Intent) -->
    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand text-success" href="${pageContext.request.contextPath}/">
                Fruit Farmer.
            </a>

            <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/products">Mua trái cây</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Danh mục</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Khuyến mãi</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Câu chuyện</a></li>
                </ul>
            </div>

            <div class="d-flex align-items-center gap-3">
                <div class="search-bar-wrapper d-none d-md-flex">
                    <i class="fa-solid fa-magnifying-glass text-muted" style="font-size: 12px;"></i>
                    <input type="text" placeholder="Tìm kiếm...">
                </div>
                <a href="${pageContext.request.contextPath}/login" class="text-dark"><i class="fa-regular fa-user"></i></a>
                <a href="${pageContext.request.contextPath}/cart" class="text-dark position-relative ms-2">
                    <i class="fa-solid fa-bag-shopping"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark" style="font-size: 9px;">2</span>
                </a>
            </div>
        </div>
    </nav>

    <!-- ASYMMETRICAL EDITORIAL HERO -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-5 position-relative z-1 pe-lg-5">
                    <!-- Signature Visual Pattern -->
                    <div class="signature-tag">TỪ VƯỜN → NHÀ</div>

                    <h1 class="hero-title">Tươi từ vườn.<br>Ngon đến bàn.</h1>
                    <p class="hero-text">Trái cây được chọn lọc kỹ từ những nhà vườn tử tế, đóng gói cẩn thận và giao đến tận tay gia đình bạn.</p>

                    <div class="d-flex align-items-center gap-4 mt-4">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary-custom text-decoration-none">Mua trái cây &rarr;</a>
                        <a href="#" class="btn-secondary-link">Xem mùa này &nearr;</a>
                    </div>
                </div>

                <div class="col-lg-7 mt-5 mt-lg-0">
                    <div class="hero-image-wrapper">
                        <!-- Ảnh thật: Giỏ táo gỗ, ánh sáng thực tế, texture tự nhiên -->
                        <img src="https://images.unsplash.com/photo-1601646872248-26f59844f22e?q=80&w=800&auto=format&fit=crop" alt="Thu hoạch táo">

                        <!-- Floating Card Thực dụng E-commerce -->
                        <div class="commerce-float-card d-none d-md-flex">
                            <div class="text-success mt-1"><i class="fa-solid fa-truck-fast"></i></div>
                            <div>
                                <div class="fw-bold text-dark" style="font-size: 14px;">Giao 2H nội thành</div>
                                <div class="text-muted" style="font-size: 12px;">Miễn phí đơn từ 299K</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SEASONAL DISCOVERY -->
    <section class="container mb-5">
        <div class="d-flex align-items-center mb-4">
            <h5 class="brand-font mb-0 me-4">Đang vào mùa</h5>
            <div style="height: 1px; background: var(--border-light); flex-grow: 1;"></div>
        </div>
        <div class="row g-3">
            <div class="col-md-3 col-6">
                <a href="#" class="d-flex align-items-center gap-3 text-decoration-none text-dark">
                    <img src="https://images.unsplash.com/photo-1550258987-190a2d41a8ba?q=80&w=150&auto=format&fit=crop" style="width: 56px; height: 56px; object-fit: cover; border-radius: 4px;">
                    <div>
                        <div class="fw-semibold" style="font-size: 14px;">Dứa MD2</div>
                        <div class="text-muted" style="font-size: 12px;">Đang vụ ngọt nhất</div>
                    </div>
                </a>
            </div>
            <!-- Lặp lại cho Cam, Dâu, Xoài... -->
        </div>
    </section>

    <!-- PRODUCT E-COMMERCE GRID -->
    <section class="py-5 bg-white">
        <div class="container">
            <h2 class="brand-font mb-4">Được chọn nhiều nhất</h2>
            <div class="row g-4">

                <!-- Product Card (Authentic Hierarchy) -->
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="position-absolute top-0 start-0 m-2 bg-white px-2 py-1" style="font-size: 10px; font-weight: 600; border: 1px solid var(--border-light); border-radius: 4px;">Best Seller</span>
                            <img src="https://images.unsplash.com/photo-1560806887-1e4cd0b6faa6?q=80&w=400&auto=format&fit=crop" alt="Táo Fuji">
                        </div>
                        <div class="product-origin">Nhật Bản</div>
                        <h3 class="product-title">Táo Fuji Thượng Hạng</h3>
                        <div class="product-rating"><i class="fa-solid fa-star"></i> 4.9 (128)</div>
                        <div class="product-price-row">
                            <div class="product-price">150.000₫ <span class="fw-normal text-muted" style="font-size: 13px;">/ kg</span></div>
                            <button class="btn-add-text">Thêm</button>
                        </div>
                    </div>
                </div>

                <!-- Product Card 2 -->
                <div class="col-xl-3 col-lg-4 col-md-6">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <img src="https://images.unsplash.com/photo-1582281268143-698e6900a30b?q=80&w=400&auto=format&fit=crop" alt="Nho Mẫu Đơn">
                        </div>
                        <div class="product-origin">Hàn Quốc</div>
                        <h3 class="product-title">Nho Mẫu Đơn Shine Muscat</h3>
                        <div class="product-rating"><i class="fa-solid fa-star"></i> 5.0 (45)</div>
                        <div class="product-price-row">
                            <div class="product-price">450.000₫ <span class="fw-normal text-muted" style="font-size: 13px;">/ hộp</span></div>
                            <button class="btn-add-text">Thêm</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- FARM STORY (Editorial feel) -->
    <section class="py-5 my-4">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 pe-lg-5 mb-4 mb-md-0">
                    <h2 class="brand-font mb-3">Biết trái cây đến từ đâu.</h2>
                    <p class="text-muted mb-4">Trái cây ngon nhất là khi được hái đúng độ chín, từ những vùng đất phù hợp nhất. Chúng tôi làm việc cùng những nhà vườn được lựa chọn kỹ để mang đến sản phẩm rõ nguồn gốc mỗi ngày.</p>
                    <a href="#" class="btn-secondary-link">Câu chuyện của chúng tôi &rarr;</a>
                </div>
                <div class="col-md-6">
                    <img src="https://images.unsplash.com/photo-1592419044706-39796d40f98c?q=80&w=800&auto=format&fit=crop" class="img-fluid rounded" alt="Bàn tay nông dân">
                </div>
            </div>
        </div>
    </section>

    <!-- AUTHENTIC REVIEWS -->
    <section class="py-5 bg-white">
        <div class="container">
            <h3 class="brand-font mb-4">Khách hàng nói gì</h3>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="review-card">
                        <div class="text-warning mb-2" style="font-size: 12px;"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div>
                        <p class="mb-3 font-italic" style="font-size: 15px;">"Cam ngọt, đóng gói rất kỹ. Giao hàng nhanh hơn mình nghĩ, sẽ mua lại."</p>
                        <div class="d-flex align-items-center gap-2">
                            <div class="fw-semibold" style="font-size: 13px;">Khánh N.</div>
                            <span class="text-success" style="font-size: 11px;"><i class="fa-solid fa-circle-check"></i> Đã mua Cam Cao Phong</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- TRUST STRIP -->
    <section class="container mb-5">
        <div class="trust-strip d-flex flex-wrap justify-content-between text-muted">
            <div><i class="fa-solid fa-check text-success me-2"></i>Nguồn gốc rõ ràng</div>
            <div><i class="fa-solid fa-check text-success me-2"></i>Chọn lọc mỗi ngày</div>
            <div><i class="fa-solid fa-check text-success me-2"></i>Đóng gói cẩn thận</div>
            <div><i class="fa-solid fa-check text-success me-2"></i>Giao nhanh 2H</div>
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>