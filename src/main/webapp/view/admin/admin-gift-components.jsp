<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Phụ kiện Giỏ Quà | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        body { background: #F9FAFB; font-family: 'Inter', sans-serif; }
        .admin-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: 1px solid #E5E7EB; }
        .nav-tabs .nav-link { color: #6B7280; font-weight: 600; padding: 16px 24px; border: none; border-bottom: 2px solid transparent; }
        .nav-tabs .nav-link.active { color: #10B981; border-bottom: 2px solid #10B981; background: transparent; }
        .table img { width: 50px; height: 50px; object-fit: contain; border: 1px solid #eee; border-radius: 8px; }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="ph-fill ph-magic-wand text-success me-2"></i>Quản lý Phụ kiện Giỏ Quà</h3>
            <button class="btn btn-success fw-bold" data-bs-toggle="modal" data-bs-target="#addModal"><i class="ph-bold ph-plus me-1"></i> Thêm Phụ kiện</button>
        </div>

        <div class="admin-card">
            <!-- TABS -->
            <ul class="nav nav-tabs px-3" id="myTab" role="tablist">
                <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#baskets">Vỏ Giỏ</button></li>
                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#decorations">Trang Trí</button></li>
                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#packagings">Đóng Gói</button></li>
            </ul>

            <div class="tab-content p-4">
                <!-- TAB VỎ GIỎ -->
                <div class="tab-pane fade show active" id="baskets">
                    <table class="table align-middle">
                        <thead class="table-light"><tr><th>Ảnh</th><th>Tên vỏ giỏ</th><th>Mô tả</th><th>Giá (VNĐ)</th><th>Thao tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${baskets}">
                                <tr>
                                    <td><img src="${item.image}"></td>
                                    <td class="fw-bold">${item.name}</td>
                                    <td class="text-muted small">${item.description}</td>
                                    <td class="text-success fw-bold"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/gift-components" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa mục này?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="basket"><input type="hidden" name="id" value="${item.id}">
                                            <button class="btn btn-sm btn-outline-danger"><i class="ph-bold ph-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- TAB TRANG TRÍ (Tương tự vỏ giỏ nhưng dùng biến decorations) -->
                <div class="tab-pane fade" id="decorations">
                    <table class="table align-middle">
                        <thead class="table-light"><tr><th>Ảnh</th><th>Tên đồ trang trí</th><th>Mô tả</th><th>Giá (VNĐ)</th><th>Thao tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${decorations}">
                                <tr>
                                    <td><img src="${item.image}"></td><td class="fw-bold">${item.name}</td><td class="text-muted small">${item.description}</td><td class="text-success fw-bold"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/gift-components" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa mục này?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="decoration"><input type="hidden" name="id" value="${item.id}">
                                            <button class="btn btn-sm btn-outline-danger"><i class="ph-bold ph-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- TAB ĐÓNG GÓI (Tương tự vỏ giỏ nhưng dùng biến packagings) -->
                <div class="tab-pane fade" id="packagings">
                     <table class="table align-middle">
                        <thead class="table-light"><tr><th>Ảnh</th><th>Tên đóng gói</th><th>Mô tả</th><th>Giá (VNĐ)</th><th>Thao tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${packagings}">
                                <tr>
                                    <td><img src="${item.image}"></td><td class="fw-bold">${item.name}</td><td class="text-muted small">${item.description}</td><td class="text-success fw-bold"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/gift-components" method="POST" class="m-0" onsubmit="return confirm('Vô hiệu hóa mục này?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="type" value="packaging"><input type="hidden" name="id" value="${item.id}">
                                            <button class="btn btn-sm btn-outline-danger"><i class="ph-bold ph-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM MỚI -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/admin/gift-components" method="POST" class="modal-content rounded-4 border-0 shadow">
                <input type="hidden" name="action" value="add">
                <div class="modal-header"><h5 class="fw-bold m-0">Thêm phụ kiện mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Loại phụ kiện</label>
                        <select name="type" class="form-select" required>
                            <option value="basket">Vỏ Giỏ</option><option value="decoration">Trang Trí</option><option value="packaging">Đóng Gói</option>
                        </select>
                    </div>
                    <div class="mb-3"><label class="form-label fw-bold">Tên phụ kiện</label><input type="text" name="name" class="form-control" required></div>
                    <div class="mb-3"><label class="form-label fw-bold">Mức giá cộng thêm (VNĐ)</label><input type="number" name="price" class="form-control" value="0" required></div>
                    <div class="mb-3"><label class="form-label fw-bold">Link Ảnh / Tên file ảnh</label><input type="text" name="image" class="form-control"></div>
                    <div class="mb-3"><label class="form-label fw-bold">Mô tả thêm</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                </div>
                <div class="modal-footer border-0"><button type="submit" class="btn btn-success fw-bold w-100">LƯU PHỤ KIỆN</button></div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>