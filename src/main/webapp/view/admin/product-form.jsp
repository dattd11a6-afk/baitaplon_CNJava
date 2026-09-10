<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>${empty product ? 'Thêm sản phẩm' : 'Sửa sản phẩm'} | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --border-color: #EAEAEC; --text-main: #1F2937; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; padding: 32px; box-shadow: none; }
        .form-label { font-weight: 500; color: #4B5563; font-size: 13px; }
        .form-control, .form-select { border-radius: 6px; border-color: var(--border-color); padding: 10px 14px; font-size: 14px; box-shadow: none; }
        .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1); }
    </style>
</head>
<body>
    <div class="container py-5" style="max-width: 800px;">
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none text-muted d-inline-flex align-items-center gap-1 mb-2"><i class="ph ph-arrow-left"></i> Quay lại</a>
            <h2 class="fw-bold m-0 brand-font">${empty product ? 'Thêm Sản Phẩm Mới' : 'Cập Nhật Sản Phẩm'}</h2>
        </div>

        <div class="admin-card">
            <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="${product.id}">

                <div class="row g-4">
                    <div class="col-md-8"><label class="form-label">Tên trái cây <span class="text-danger">*</span></label><input type="text" class="form-control" name="name" value="${product.name}" required placeholder="VD: Táo Fuji Nhật Bản"></div>
                    <div class="col-md-4">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" name="status">
                            <option value="ACTIVE" ${product.status == 'ACTIVE' ? 'selected' : ''}>Đang bán</option>
                            <option value="INACTIVE" ${product.status == 'INACTIVE' ? 'selected' : ''}>Ngừng bán</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                        <select class="form-select" name="categoryId" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="cat" items="${categories}"><option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option></c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4"><label class="form-label">Xuất xứ</label><input type="text" class="form-control" name="origin" value="${product.origin}"></div>
                    <div class="col-md-4"><label class="form-label">Tên file ảnh</label><input type="text" class="form-control" name="image" value="${product.image}"></div>

                    <div class="col-md-4"><label class="form-label">Giá bán (VNĐ) <span class="text-danger">*</span></label><input type="number" class="form-control" name="price" value="${product.price}" required min="0"></div>
                    <div class="col-md-4"><label class="form-label">Đơn vị tính <span class="text-danger">*</span></label><input type="text" class="form-control" name="unit" value="${product.unit != null ? product.unit : 'kg'}" required></div>
                    <div class="col-md-4"><label class="form-label">Tồn kho ban đầu <span class="text-danger">*</span></label><input type="number" class="form-control" name="stock" value="${product.stock != null ? product.stock : 0}" required min="0"></div>

                    <div class="col-12"><label class="form-label">Mô tả chi tiết</label><textarea class="form-control" name="description" rows="4">${product.description}</textarea></div>

                    <div class="col-12 text-end mt-5 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-light border me-2 px-4">Hủy bỏ</a>
                        <button type="submit" class="btn btn-success"><i class="ph ph-floppy-disk me-2"></i> Lưu sản phẩm</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>