<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Nhà Cung Cấp | Fruit Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --primary: #2F6B3F; --bg-admin: #F9FAFB; --surface: #FFFFFF; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #EAEAEC; }
        body { background-color: var(--bg-admin); font-family: 'Inter', sans-serif; font-size: 14px; color: var(--text-main); }
        .brand-font { font-family: 'DM Sans', sans-serif; }
        .sidebar { width: 260px; background-color: #111827; color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar-menu { list-style: none; padding: 0; margin: 0; }
        .menu-label { padding: 24px 24px 8px; font-size: 11px; font-weight: 700; color: #6B7280; text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 10px 24px; color: #9CA3AF; text-decoration: none; font-weight: 500; font-size: 14px; transition: all 0.2s ease; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; transition: 0.2s; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.03); }
        .sidebar-menu li a:hover i { color: var(--primary); transform: scale(1.1); }
        .sidebar-menu li.active a { color: #fff; background-color: rgba(47, 107, 63, 0.15); border-left-color: var(--primary); font-weight: 600; }
        .sidebar-menu li.active a i { color: var(--primary); }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.2); }
        .topbar { height: 70px; background: var(--surface); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 40px; flex-shrink: 0;}
        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: none; overflow: hidden; }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 16px 24px; color: var(--text-muted); background: #F9FAFB; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--border-color); text-align: left; }
        .admin-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-main); text-align: left; }
    </style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
                <div class="p-4 d-flex align-items-center gap-3 border-bottom" style="border-color: rgba(255,255,255,0.05) !important;">
                    <div class="d-flex align-items-center justify-content-center rounded" style="width: 36px; height: 36px; background: linear-gradient(135deg, var(--primary), #10B981);">
                        <i class="ph-bold ph-leaf text-white fs-5"></i>
                    </div>
                    <div>
                        <div class="fw-bold fs-5 brand-font text-white" style="letter-spacing: 0.5px;">Fruit Farmer</div>
                        <div style="font-size: 10px; color: #10B981; font-weight: 600; letter-spacing: 1px;">ADMIN WORKSPACE</div>
                    </div>
                </div>

                <div class="overflow-auto flex-grow-1 pb-4 custom-scrollbar">
                    <ul class="sidebar-menu">
                        <div class="menu-label mt-2">Phân tích</div>
                        <li class="${pageContext.request.servletPath == '/view/admin/dashboard.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="ph-fill ph-squares-four"></i> Tổng quan</a></li>
                        <li class="${pageContext.request.servletPath == '/view/admin/reports.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/reports"><i class="ph-fill ph-chart-line-up"></i> Báo cáo kinh doanh</a></li>

                        <div class="menu-label">Bán hàng</div>
                        <li class="${pageContext.request.servletPath == '/view/admin/orders.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng</a></li>
                        <li class="${pageContext.request.servletPath == '/view/admin/customers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/customers"><i class="ph-fill ph-users"></i> Khách hàng</a></li>
                        <li class="${pageContext.request.servletPath == '/view/admin/vouchers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/vouchers"><i class="ph-fill ph-ticket"></i> Khuyến mãi</a></li>

                        <!-- LUÔN GIỮ ĐÁNH GIÁ Ở ĐÂY -->
                        <li class="${pageContext.request.servletPath == '/view/admin/reviews.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/reviews"><i class="ph-fill ph-star"></i> Đánh giá</a></li>

                        <div class="menu-label">Kho & Hàng hóa</div>
                        <li class="${pageContext.request.servletPath == '/view/admin/products.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/products"><i class="ph-fill ph-package"></i> Danh sách Sản phẩm</a></li>
                        <li class="${pageContext.request.servletPath == '/view/admin/categories.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/categories"><i class="ph-fill ph-tag"></i> Danh mục</a></li>

                        <!-- LUÔN GIỮ PHỤ KIỆN TẠI ĐÂY -->
                        <li class="${pageContext.request.servletPath == '/view/admin/admin-accessories.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/accessories"><i class="ph-fill ph-magic-wand"></i> Phụ kiện Mix Giỏ</a></li>

                        <li class="${pageContext.request.servletPath == '/view/admin/inventory.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/inventory"><i class="ph-fill ph-box-arrow-down"></i> Lập phiếu Nhập kho</a></li>
                        <li class="${pageContext.request.servletPath == '/view/admin/suppliers.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/suppliers"><i class="ph-fill ph-truck"></i> Nhà cung cấp</a></li>

                        <div class="menu-label">Cấu hình</div>
                        <li class="${pageContext.request.servletPath == '/view/admin/staff.jsp' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/admin/staff"><i class="ph-fill ph-identification-badge"></i> Nhân viên</a></li>
                                        <li><a href="${pageContext.request.contextPath}/shipper" target="_blank"><i class="ph-fill ph-motorcycle"></i> Giao diện Shipper</a></li>

                    </ul>
                </div>

                <div class="p-4 border-top" style="border-color: rgba(255,255,255,0.05)!important;">
                    <a href="${pageContext.request.contextPath}/logout" class="d-flex align-items-center justify-content-center py-2 px-3 text-decoration-none rounded" style="background: rgba(239, 68, 68, 0.1); color: #EF4444; border: 1px solid rgba(239, 68, 68, 0.2); transition: 0.2s;">
                        <i class="ph-bold ph-sign-out fs-5 me-2"></i> Đăng xuất
                    </a>
                </div>
            </aside>

    <main class="flex-grow-1 d-flex flex-column" style="height: 100vh; overflow-y: auto;">
        <header class="topbar"><div class="fw-medium text-muted"></div></header>
        <div class="p-4 px-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h2 class="fw-bold mb-1 brand-font text-dark">Nhà Cung Cấp</h2>
                </div>
                <button class="btn btn-success fw-medium" data-bs-toggle="modal" data-bs-target="#addSupplierModal"><i class="ph-bold ph-plus me-1"></i> Thêm Nhà cung cấp</button>
            </div>

            <div class="admin-card p-0">
                <table class="admin-table mb-0">
                    <thead><tr><th>Tên nhà cung cấp</th><th>Số điện thoại</th><th>Email</th><th>Địa chỉ</th><th>Trạng thái</th><th class="text-end">Thao tác</th></tr></thead>
                    <tbody>
                        <c:forEach var="s" items="${suppliers}">
                            <tr>
                                <td class="fw-bold text-dark">${s.name}</td>
                                <td>${s.phone}</td>
                                <td>${s.email}</td>
                                <td class="text-truncate" style="max-width: 200px;">${s.address}</td>
                                <td><span class="badge border ${s.status == 'ACTIVE' ? 'bg-success-subtle text-success border-success-subtle' : 'bg-light text-muted'} px-2 py-1">${s.status}</span></td>
                                <td class="text-end">
                                    <button class="btn btn-sm btn-light border text-primary" data-bs-toggle="modal" data-bs-target="#editSupplierModal${s.id}"><i class="ph-bold ph-pencil-simple"></i></button>
                                    <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST" class="d-inline" onsubmit="return confirm('Xóa nhà cung cấp [${s.name}]?');">
                                        <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${s.id}">
                                        <button type="submit" class="btn btn-sm btn-light border text-danger"><i class="ph-bold ph-trash"></i></button>
                                    </form>
                                </td>
                            </tr>

                            <!-- MODAL SỬA -->
                            <div class="modal fade" id="editSupplierModal${s.id}">
                                <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
                                    <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Sửa Nhà Cung Cấp</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                                    <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST">
                                        <div class="modal-body text-start">
                                            <input type="hidden" name="action" value="update"><input type="hidden" name="id" value="${s.id}">
                                            <div class="mb-3"><label class="form-label fw-medium">Tên nhà cung cấp</label><input type="text" name="name" class="form-control fw-bold" value="${s.name}" required></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Số điện thoại</label><input type="text" name="phone" class="form-control" value="${s.phone}"></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Email</label><input type="email" name="email" class="form-control" value="${s.email}"></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Địa chỉ</label><textarea name="address" class="form-control" rows="2">${s.address}</textarea></div>
                                            <div class="mb-3"><label class="form-label fw-medium">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE" ${s.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option><option value="INACTIVE" ${s.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hợp tác</option></select></div>
                                        </div>
                                        <div class="modal-footer border-0"><button type="submit" class="btn btn-success w-100">Cập nhật</button></div>
                                    </form>
                                </div></div>
                            </div>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- MODAL THÊM -->
<div class="modal fade" id="addSupplierModal">
    <div class="modal-dialog modal-dialog-centered"><div class="modal-content border-0 rounded-4 shadow">
        <div class="modal-header"><h5 class="fw-bold m-0 brand-font">Thêm Nhà Cung Cấp</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <form action="${pageContext.request.contextPath}/admin/suppliers" method="POST">
            <div class="modal-body text-start">
                <input type="hidden" name="action" value="add">
                <div class="mb-3"><label class="form-label fw-medium">Tên nhà cung cấp <span class="text-danger">*</span></label><input type="text" name="name" class="form-control fw-bold" required></div>
                <div class="mb-3"><label class="form-label fw-medium">Số điện thoại</label><input type="text" name="phone" class="form-control"></div>
                <div class="mb-3"><label class="form-label fw-medium">Email</label><input type="email" name="email" class="form-control"></div>
                <div class="mb-3"><label class="form-label fw-medium">Địa chỉ</label><textarea name="address" class="form-control" rows="2"></textarea></div>
                <div class="mb-3"><label class="form-label fw-medium">Trạng thái</label><select name="status" class="form-select"><option value="ACTIVE">Hoạt động</option><option value="INACTIVE">Ngừng hợp tác</option></select></div>
            </div>
            <div class="modal-footer border-0"><button type="submit" class="btn btn-success w-100">Lưu</button></div>
        </form>
    </div></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>