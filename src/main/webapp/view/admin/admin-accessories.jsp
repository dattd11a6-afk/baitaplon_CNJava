<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Phụ kiện | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
</head>
<body class="bg-light">
    <!-- KHU VỰC DÀNH CHO THANH MENU SIDEBAR CỦA BÁC -->

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0"><i class="ph-fill ph-magic-wand text-success me-2"></i>Quản lý Phụ kiện Mix Giỏ</h3>
            <button class="btn btn-success fw-bold" data-bs-toggle="modal" data-bs-target="#addModal"><i class="ph-bold ph-plus me-1"></i> Thêm mới</button>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <!-- TABS -->
            <ul class="nav nav-tabs px-3 bg-white pt-2" id="myTab">
                <li class="nav-item"><button class="nav-link active fw-bold" data-bs-toggle="tab" data-bs-target="#baskets">Vỏ Giỏ Mây/Gỗ</button></li>
                <li class="nav-item"><button class="nav-link fw-bold" data-bs-toggle="tab" data-bs-target="#decorations">Đồ Trang Trí / Nơ</button></li>
                <li class="nav-item"><button class="nav-link fw-bold" data-bs-toggle="tab" data-bs-target="#packagings">Màng co / Giấy gói</button></li>
            </ul>

            <div class="tab-content p-0 bg-white">
                <!-- VÍ DỤ TAB VỎ GIỎ -->
                <div class="tab-pane fade show active" id="baskets">
                    <table class="table align-middle m-0">
                        <thead class="table-light"><tr><th class="ps-4">Tên phụ kiện</th><th>Mức giá</th><th class="text-end pe-4">Thao tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="item" items="${baskets}">
                                <tr>
                                    <td class="ps-4 d-flex align-items-center gap-3">
                                        <img src="${item.image}" class="rounded border" style="width:50px; height:50px; object-fit:contain;">
                                        <span class="fw-bold">${item.name}</span>
                                    </td>
                                    <td class="text-success fw-bold"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                    <td class="text-end pe-4">
                                        <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="m-0" onsubmit="return confirm('Bạn muốn xóa mục này?');">
                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${item.id}">
                                            <button class="btn btn-sm btn-outline-danger"><i class="ph-bold ph-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Bác làm tương tự copy cái <table> trên dán cho tab #decorations và #packagings nhé -->
            </div>
        </div>
    </div>

    <!-- MODAL THÊM MỚI -->
    <div class="modal fade" id="addModal">
        <div class="modal-dialog">
            <form action="${pageContext.request.contextPath}/admin/accessories" method="POST" class="modal-content rounded-4 border-0 shadow">
                <input type="hidden" name="action" value="add">
                <div class="modal-header"><h5 class="fw-bold m-0">Thêm phụ kiện mới</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Phân loại</label>
                        <select name="type" class="form-select" required>
                            <option value="BASKET">Vỏ Giỏ</option><option value="DECORATION">Đồ Trang Trí</option><option value="PACKAGING">Đóng Gói</option>
                        </select>
                    </div>
                    <div class="mb-3"><label class="form-label fw-bold">Tên phụ kiện</label><input type="text" name="name" class="form-control" placeholder="VD: Giỏ mây chữ nhật" required></div>
                    <div class="mb-3"><label class="form-label fw-bold">Giá bán (VNĐ)</label><input type="number" name="price" class="form-control" value="0" required></div>
                    <div class="mb-3"><label class="form-label fw-bold">Link Ảnh / Tên file ảnh</label><input type="text" name="image" class="form-control"></div>
                </div>
                <div class="modal-footer border-0"><button type="submit" class="btn btn-success fw-bold w-100">LƯU PHỤ KIỆN</button></div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>