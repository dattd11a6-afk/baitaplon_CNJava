<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Nhập kho Sản phẩm | Fruit Admin</title>
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

        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: none; overflow: hidden; padding: 24px;}
        .form-label { font-weight: 500; color: #4B5563; font-size: 13px; margin-bottom: 6px; }
        .form-control, .form-select { border-radius: 6px; border-color: var(--border-color); padding: 10px 14px; font-size: 14px; box-shadow: none; }
        .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(47, 107, 63, 0.1); }

        .table-inventory th { font-size: 12px; color: var(--text-muted); text-transform: uppercase; font-weight: 600; background: #F9FAFB; padding: 12px 16px; border-bottom: 1px solid var(--border-color); }
        .table-inventory td { padding: 12px 16px; vertical-align: middle; border-bottom: 1px solid var(--border-color); }
        .btn-add-row { border: 1px dashed var(--primary); color: var(--primary); background: rgba(47, 107, 63, 0.05); font-weight: 500; transition: 0.2s; }
        .btn-add-row:hover { background: rgba(47, 107, 63, 0.1); color: var(--primary); }
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
        <header class="topbar p-3 border-bottom"><a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none text-muted fw-medium"><i class="ph-bold ph-arrow-left me-1"></i> Quay lại Kho tổng</a></header>
        <div class="p-4 px-5">
            <div class="mb-4">
                <h2 class="fw-bold mb-1 brand-font text-dark">Tạo Phiếu Nhập Kho</h2>
            </div>

            <form action="${pageContext.request.contextPath}/admin/inventory" method="POST" id="inventoryForm">
                <div class="admin-card mb-4">
                    <h6 class="fw-bold brand-font mb-4"><i class="ph-fill ph-info text-primary me-2"></i>Thông tin chứng từ</h6>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Nhà cung cấp <span class="text-danger">*</span></label>
                            <select name="supplierId" class="form-select" required>
                                <option value="">-- Chọn Nhà cung cấp --</option>
                                <c:forEach var="sup" items="${suppliers}">
                                    <option value="${sup.id}">${sup.name} - ${sup.phone}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6"><label class="form-label">Ghi chú phiếu nhập</label><input type="text" name="note" class="form-control"></div>
                    </div>
                </div>

                <div class="admin-card mb-4 p-0">
                    <div class="p-4 border-bottom d-flex justify-content-between align-items-center bg-light">
                        <h6 class="fw-bold brand-font m-0"><i class="ph-fill ph-package text-success me-2"></i>Chi tiết sản phẩm nhập</h6>
                        <button type="button" class="btn btn-add-row btn-sm px-3 py-2" onclick="addRow()"><i class="ph-bold ph-plus me-1"></i> Thêm dòng</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-inventory mb-0" id="inventoryTable">
                            <thead><tr><th style="width: 40%;">Sản phẩm *</th><th style="width: 15%;">Số lượng *</th><th style="width: 20%;">Giá vốn (VNĐ) *</th><th class="text-end" style="width: 20%;">Thành tiền</th><th class="text-center" style="width: 5%;">Xóa</th></tr></thead>
                            <tbody id="inventoryBody">
                                <tr class="item-row">
                                    <td><select name="productIds[]" class="form-select" required onchange="calculateTotal()"><option value="">-- Chọn sản phẩm --</option><c:forEach var="p" items="${products}"><option value="${p.id}">${p.name} (Kho: ${p.stock})</option></c:forEach></select></td>
                                    <td><input type="number" name="quantities[]" class="form-control text-center row-qty" min="1" value="1" required oninput="calculateTotal()"></td>
                                    <td><input type="number" name="importPrices[]" class="form-control row-price" min="0" value="0" required oninput="calculateTotal()"></td>
                                    <td class="text-end fw-bold text-success row-subtotal align-middle">0 ₫</td>
                                    <td class="text-center align-middle"><button type="button" class="btn text-muted p-0" disabled><i class="ph-bold ph-trash"></i></button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center bg-white p-4 border rounded-3 shadow-sm mb-5">
                    <div class="d-flex align-items-center gap-4">
                        <span class="text-muted fw-medium">Tổng SL: <span id="grandQty" class="text-dark fw-bold fs-5 ms-1">1</span></span>
                        <div class="vr"></div>
                        <span class="text-muted fw-medium">Tổng tiền: <span id="grandTotal" class="text-danger fw-bold fs-3 ms-2">0 ₫</span></span>
                    </div>
                    <div><button type="submit" class="btn btn-success px-4 fw-bold"><i class="ph-fill ph-check-circle me-1"></i> Nhập kho ngay</button></div>
                </div>
            </form>
        </div>
    </main>
</div>

<template id="rowTemplate">
    <tr class="item-row">
        <td><select name="productIds[]" class="form-select" required onchange="calculateTotal()"><option value="">-- Chọn sản phẩm --</option><c:forEach var="p" items="${products}"><option value="${p.id}">${p.name} (Kho: ${p.stock})</option></c:forEach></select></td>
        <td><input type="number" name="quantities[]" class="form-control text-center row-qty" min="1" value="1" required oninput="calculateTotal()"></td>
        <td><input type="number" name="importPrices[]" class="form-control row-price" min="0" value="0" required oninput="calculateTotal()"></td>
        <td class="text-end fw-bold text-success row-subtotal align-middle">0 ₫</td>
        <td class="text-center align-middle"><button type="button" class="btn text-danger p-0" onclick="removeRow(this)"><i class="ph-bold ph-trash"></i></button></td>
    </tr>
</template>

<script>
    const currencyFormatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
    function addRow() { document.getElementById('inventoryBody').appendChild(document.getElementById('rowTemplate').content.cloneNode(true)); calculateTotal(); }
    function removeRow(btn) { btn.closest('tr').remove(); calculateTotal(); }
    function calculateTotal() {
        let total = 0, qty = 0;
        document.querySelectorAll('#inventoryBody .item-row').forEach(row => {
            const q = parseFloat(row.querySelector('.row-qty').value) || 0;
            const p = parseFloat(row.querySelector('.row-price').value) || 0;
            row.querySelector('.row-subtotal').innerText = currencyFormatter.format(q * p);
            total += (q * p); qty += q;
        });
        document.getElementById('grandTotal').innerText = currencyFormatter.format(total);
        document.getElementById('grandQty').innerText = qty;
    }
</script>
</body>
</html>