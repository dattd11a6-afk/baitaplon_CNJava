<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} | Fruit Farmer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root { --primary: #2F6B3F; }
        .thumb-img { width: 70px; height: 70px; object-fit: cover; border-radius: 8px; cursor: pointer; border: 2px solid transparent; transition: 0.2s; }
        .thumb-img:hover, .thumb-img.active { border-color: var(--primary); }
        .nav-tabs .nav-link { color: #555; font-weight: 500; padding: 16px 32px; border: none; border-bottom: 2px solid transparent; }
        .nav-tabs .nav-link.active { color: var(--primary); border-bottom-color: var(--primary); background: transparent; font-weight: 600; }

        /* HIỂN THỊ REVIEW */
        .review-item { border-bottom: 1px solid #EAEAEC; padding: 24px 0; display: flex; gap: 16px; }
        .review-avatar { width: 44px; height: 44px; border-radius: 50%; object-fit: cover; }
        .star-display i { color: #F59E0B; }
        .media-preview { width: 100px; height: 100px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; cursor: pointer; transition: 0.2s; }
        .media-preview:hover { filter: brightness(0.9); }
        .seller-reply { background: #F8FAFC; border-left: 3px solid var(--primary); padding: 12px 16px; border-radius: 4px; margin-top: 12px; }

        /* CSS TƯƠNG TÁC RATING FORM */
        .rating-stars { display: flex; gap: 8px; flex-direction: row-reverse; justify-content: flex-end; }
        .rating-stars input { display: none; }
        .rating-stars label { font-size: 28px; color: #E5E7EB; cursor: pointer; transition: color 0.2s ease; }
        .rating-stars input:checked ~ label,
        .rating-stars label:hover,
        .rating-stars label:hover ~ label { color: #F59E0B; }
        #ratingTextStatus { font-weight: 600; color: #F59E0B; margin-left: 12px; font-size: 14px; align-self: center;}
    </style>
</head>
<body class="bg-light">

    <!-- NAVBAR (Giữ nguyên) -->
    <nav class="navbar navbar-expand-lg sticky-top border-bottom bg-white py-3">
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
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb" style="font-size: 13px;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-muted text-decoration-none">Cửa hàng</a></li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <!-- THÔNG TIN SẢN PHẨM -->
        <div class="bg-white p-4 p-md-5 rounded-4 shadow-sm mb-4">
            <div class="row g-5">
                <c:set var="images" value="${fn:split(product.image, ',')}" />
                <c:set var="mainImage" value="${fn:trim(images[0])}" />

                <div class="col-md-5">
                    <div class="d-flex align-items-center justify-content-center" style="height: 400px;">
                        <c:choose>
                            <c:when test="${not empty mainImage && fn:startsWith(mainImage, 'http')}"><img id="mainProductImage" src="${mainImage}" class="img-fluid" style="max-height: 100%; object-fit: contain;"></c:when>
                            <c:when test="${not empty mainImage}"><img id="mainProductImage" src="${pageContext.request.contextPath}/assets/images/products/${mainImage}" class="img-fluid" style="max-height: 100%; object-fit: contain;"></c:when>
                            <c:otherwise><img id="mainProductImage" src="https://images.unsplash.com/photo-1610832958506-aa56368176cf?q=80&w=600" class="img-fluid rounded"></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="d-flex gap-2 mt-4 overflow-auto pb-2 justify-content-center">
                        <c:forEach var="img" items="${images}">
                            <c:set var="thumb" value="${fn:trim(img)}" />
                            <c:choose>
                                <c:when test="${fn:startsWith(thumb, 'http')}"><img src="${thumb}" class="thumb-img" onclick="changeMainImage(this.src)"></c:when>
                                <c:otherwise><img src="${pageContext.request.contextPath}/assets/images/products/${thumb}" class="thumb-img" onclick="changeMainImage(this.src)"></c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-7">
                    <div class="d-flex gap-2 mb-3">
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">${product.categoryName}</span>
                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill"><i class="fa-solid fa-certificate me-1"></i> Chuẩn VietGAP</span>
                    </div>

                    <h1 class="brand-font mb-2 fw-bold" style="font-size: 32px;">${product.name}</h1>

                    <!-- CHỈ SỐ SAO VÀ ĐÃ BÁN -->
                    <div class="d-flex align-items-center mb-4">
                        <div class="text-warning star-display me-2" style="font-size: 15px;">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1" var="fmtAvg" />
                            <span class="text-dark fw-bold text-decoration-underline me-1">${fmtAvg}</span>
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fa-solid ${i <= averageRating ? 'fa-star' : (i - averageRating <= 0.5 ? 'fa-star-half-stroke' : 'fa-star text-light')}"></i>
                            </c:forEach>
                            <span class="text-muted ms-1">(${reviewCount} Đánh giá)</span>
                        </div>
                        <div class="vr mx-2 text-muted"></div>
                        <div class="text-muted" style="font-size: 14px;">Đã bán: <span class="fw-bold text-dark">${totalSold}</span></div>
                    </div>

                    <div class="brand-font text-success mb-4 pb-4 border-bottom" style="font-size: 40px; font-weight: 700;">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        <span class="text-muted fw-normal" style="font-size: 18px;">/ ${product.unit}</span>
                    </div>

                    <ul class="list-unstyled mb-4 pb-4 border-bottom text-muted">
                        <li class="mb-3"><span class="d-inline-block" style="width: 100px;">Xuất xứ:</span> <span class="fw-medium text-dark">${product.origin}</span></li>
                        <li class="mb-3"><span class="d-inline-block" style="width: 100px;">Giao hàng:</span> <span class="text-dark"><i class="fa-solid fa-truck-fast text-success me-2"></i> Hỏa tốc 2H</span></li>
                        <li class="mb-3"><span class="d-inline-block" style="width: 100px;">Tình trạng:</span>
                            <c:choose>
                                <c:when test="${product.stock > 0}"><span class="fw-bold text-success"><i class="fa-solid fa-check-circle me-1"></i>Còn hàng (${product.stock} ${product.unit})</span></c:when>
                                <c:otherwise><span class="fw-bold text-danger"><i class="fa-solid fa-xmark-circle me-1"></i>Hết hàng</span></c:otherwise>
                            </c:choose>
                        </li>
                    </ul>

                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="mb-2">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="${product.id}">
                        <div class="d-flex gap-3 align-items-center">
                            <c:choose>
                                <c:when test="${product.stock > 0}">
                                    <div class="qty-input-group d-flex border rounded">
                                        <button type="button" class="btn btn-light border-0 fw-bold" onclick="let input=document.getElementById('quantity'); if(input.value>1) input.value--;" style="width: 40px;">-</button>
                                        <input type="number" class="form-control text-center border-0 border-start border-end rounded-0" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" readonly style="width: 60px;">
                                        <button type="button" class="btn btn-light border-0 fw-bold" onclick="let input=document.getElementById('quantity'); if(input.value<${product.stock}) input.value++;" style="width: 40px;">+</button>
                                    </div>
                                    <button type="submit" class="btn btn-success flex-grow-1 py-2 fw-bold fs-6">
                                        <i class="fa-solid fa-cart-plus me-2"></i> Thêm vào giỏ
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn btn-secondary flex-grow-1 py-2 opacity-50 fw-bold" disabled>Sản phẩm tạm hết hàng</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- TABS MÔ TẢ VÀ ĐÁNH GIÁ -->
        <div class="bg-white rounded-4 shadow-sm p-4 p-md-5">
            <ul class="nav nav-tabs border-bottom mb-4" id="productTabs" role="tablist">
                <li class="nav-item" role="presentation"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#desc-tab">Mô tả sản phẩm</button></li>
                <li class="nav-item" role="presentation"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#review-tab">Đánh giá (${reviewCount})</button></li>
            </ul>

            <div class="tab-content" id="productTabsContent">
                <div class="tab-pane fade show active text-muted" id="desc-tab" style="line-height: 1.8;">
                    ${not empty product.description ? product.description : 'Sản phẩm được trồng tại nông trại Fruit Farmer đạt chuẩn VietGAP, không sử dụng thuốc hóa học, an toàn tuyệt đối cho sức khỏe.'}
                </div>

                <div class="tab-pane fade" id="review-tab">

                    <!-- DANH SÁCH ĐÁNH GIÁ CÓ HÌNH ẢNH & SELLER REPLY -->
                    <c:if test="${empty reviews}">
                        <div class="text-center py-5 text-muted">
                            <i class="fa-regular fa-comments mb-3" style="font-size: 48px; opacity: 0.3;"></i>
                            <div>Chưa có đánh giá nào. Mua ngay và trở thành người đầu tiên đánh giá sản phẩm này!</div>
                        </div>
                    </c:if>

                    <c:forEach var="rev" items="${reviews}">
                        <div class="review-item">
                            <c:choose>
                                <c:when test="${not empty rev.userAvatar}"><img src="${pageContext.request.contextPath}/assets/images/users/${rev.userAvatar}" class="review-avatar"></c:when>
                                <c:otherwise><img src="https://ui-avatars.com/api/?name=${rev.userName}&background=E5E7EB&color=4B5563" class="review-avatar"></c:otherwise>
                            </c:choose>

                            <div class="flex-grow-1">
                                <div class="fw-bold text-dark">${rev.userName}</div>
                                <div class="star-display mb-2" style="font-size: 12px;">
                                    <c:forEach begin="1" end="${rev.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                    <c:forEach begin="1" end="${5 - rev.rating}"><i class="fa-solid fa-star text-light"></i></c:forEach>
                                    <span class="text-muted ms-2"><fmt:formatDate value="${rev.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>

                                <p class="mb-2 text-dark" style="font-size: 14px;">${rev.comment}</p>

                                <!-- Render Ảnh/Video minh chứng -->
                                <c:if test="${not empty rev.mediaUrl}">
                                    <div class="mt-2">
                                        <c:choose>
                                            <c:when test="${fn:endsWith(rev.mediaUrl, '.mp4') || fn:endsWith(rev.mediaUrl, '.mov')}">
                                                <video width="150" height="150" controls class="rounded border bg-dark object-fit-contain">
                                                    <source src="${pageContext.request.contextPath}/assets/images/reviews/${rev.mediaUrl}" type="video/mp4">
                                                </video>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/images/reviews/${rev.mediaUrl}" class="media-preview" onclick="window.open(this.src, '_blank')">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>

                                <!-- Trả lời của Cửa hàng -->
                                <c:if test="${not empty rev.sellerReply}">
                                    <div class="seller-reply">
                                        <div class="fw-bold text-success mb-1" style="font-size: 13px;"><i class="fa-solid fa-store"></i> Phản hồi từ Người bán</div>
                                        <div class="text-dark" style="font-size: 13px;">${rev.sellerReply}</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- FORM VIẾT ĐÁNH GIÁ KHI ĐÃ ĐĂNG NHẬP -->
                    <c:if test="${not empty sessionScope.user}">
                        <div class="bg-white p-4 rounded-4 mt-5 border border-light-subtle shadow-sm">
                            <h6 class="fw-bold mb-3 brand-font">Gửi đánh giá của bạn</h6>
                            <form action="${pageContext.request.contextPath}/review" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="orderId" value="0"> <!-- Đánh giá tự do -->

                                <div class="mb-3 d-flex align-items-center">
                                    <label class="form-label fw-medium mb-0 me-3">Chất lượng sản phẩm:</label>
                                    <!-- SAO TƯƠNG TÁC HTML -->
                                    <div class="rating-stars">
                                        <input type="radio" name="rating" id="star5" value="5" required checked><label for="star5" class="fa-solid fa-star"></label>
                                        <input type="radio" name="rating" id="star4" value="4"><label for="star4" class="fa-solid fa-star"></label>
                                        <input type="radio" name="rating" id="star3" value="3"><label for="star3" class="fa-solid fa-star"></label>
                                        <input type="radio" name="rating" id="star2" value="2"><label for="star2" class="fa-solid fa-star"></label>
                                        <input type="radio" name="rating" id="star1" value="1"><label for="star1" class="fa-solid fa-star"></label>
                                    </div>
                                    <span id="ratingTextStatus">Tuyệt vời</span>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-medium">Chi tiết trải nghiệm</label>
                                    <textarea name="comment" class="form-control" rows="3" placeholder="Chia sẻ cảm nhận về độ tươi ngon, chất lượng đóng gói..." required></textarea>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-medium"><i class="fa-solid fa-camera"></i> Đính kèm Ảnh / Video (Tùy chọn)</label>
                                    <input type="file" name="mediaFile" class="form-control" accept="image/*,video/mp4,video/quicktime">
                                </div>

                                <button type="submit" class="btn btn-success fw-bold px-4">Gửi đánh giá</button>
                            </form>
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </div>

    <!-- JS Đổi ảnh -->
    <script>
        function changeMainImage(src) { document.getElementById('mainProductImage').src = src; }

        // SCRIPT: Chạy chữ khi Hover và Chọn Sao
        const texts = { 1: "Rất tệ", 2: "Kém", 3: "Bình thường", 4: "Tốt", 5: "Tuyệt vời" };
        const statusSpan = document.getElementById('ratingTextStatus');

        document.querySelectorAll('.rating-stars label').forEach(label => {
            label.addEventListener('mouseover', function() {
                let val = this.previousElementSibling.value;
                statusSpan.innerText = texts[val];
            });
            label.addEventListener('mouseleave', function() {
                let checkedVal = document.querySelector('.rating-stars input:checked').value;
                statusSpan.innerText = texts[checkedVal];
            });
            label.addEventListener('click', function() {
                let val = this.previousElementSibling.value;
                statusSpan.innerText = texts[val];
            });
        });
    </script>

    <!-- TOAST -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
        <c:if test="${not empty sessionScope.successMsg}">
            <div class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex"><div class="toast-body fw-medium"><i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
            </div><c:remove var="successMsg" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="toast align-items-center text-bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex"><div class="toast-body fw-medium"><i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.errorMsg}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
            </div><c:remove var="errorMsg" scope="session" />
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script> document.addEventListener("DOMContentLoaded", function() { var ts = [].slice.call(document.querySelectorAll('.toast')); ts.map(function(t) { return new bootstrap.Toast(t, { delay: 3000 }); }).forEach(t => t.show()); }); </script>
</body>
</html>