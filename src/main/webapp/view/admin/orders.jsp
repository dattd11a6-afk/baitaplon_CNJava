<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý Đơn hàng | Fruit Admin</title>
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

        .admin-card { background: var(--surface); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: none; overflow: hidden; }
        .admin-table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        .admin-table th { padding: 16px 20px; color: var(--text-muted); background: #F9FAFB; text-transform: uppercase; font-size: 11px; font-weight: 600; border-bottom: 1px solid var(--border-color); text-align: left; }
        .admin-table td { padding: 16px 20px; vertical-align: middle; border-bottom: 1px solid var(--border-color); color: var(--text-main); text-align: left; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .col-number { text-align: right !important; font-family: 'DM Sans', sans-serif; font-weight: 600; }
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

    <main class="flex-grow-1 overflow-auto" style="height: 100vh;">
        <header class="topbar p-3"></header>
        <div class="p-4 px-5">
            <h2 class="fw-bold mb-4 brand-font text-dark">Tất cả Đơn hàng</h2>
            <div class="admin-card p-0">
                <table class="admin-table mb-0">
                    <thead>
                        <tr>
                            <th style="width: 10%;">Mã đơn</th><th style="width: 15%;">Ngày đặt</th><th style="width: 20%;">Khách hàng</th><th class="col-number" style="width: 15%;">Tổng tiền</th><th style="width: 15%;">Trạng thái</th><th class="text-end" style="width: 25%;">Cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td class="fw-bold text-primary">#DH${o.id}</td>
                                <td class="text-muted"><fmt:formatDate value="${o.createdAt}" pattern="dd/MM HH:mm"/></td>
                                <td class="fw-semibold">${o.receiverName}</td>
                                <td class="col-number text-success"><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 'PENDING'}"><span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-2 py-1">Chờ xác nhận</span></c:when>
                                        <c:when test="${o.orderStatus == 'CONFIRMED'}"><span class="badge bg-info-subtle text-info-emphasis border border-info-subtle px-2 py-1">Đã xác nhận</span></c:when>
                                        <c:when test="${o.orderStatus == 'PREPARING'}"><span class="badge bg-primary-subtle text-primary-emphasis border border-primary-subtle px-2 py-1">Đang chuẩn bị</span></c:when>
                                        <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge bg-secondary-subtle text-secondary-emphasis border border-secondary-subtle px-2 py-1">Đang giao</span></c:when>
                                        <c:when test="${o.orderStatus == 'COMPLETED'}"><span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">Hoàn thành</span></c:when>
                                        <c:when test="${o.orderStatus == 'CANCELLED'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">Đã hủy</span></c:when>
                                        <c:otherwise><span class="badge bg-light text-dark border px-2 py-1">${o.orderStatus}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-flex gap-2 justify-content-end m-0">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="id" value="${o.id}">
                                        <select name="status" class="form-select form-select-sm" style="width: 140px; border-radius: 6px;">
                                            <option value="PENDING" ${o.orderStatus == 'PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
                                            <option value="CONFIRMED" ${o.orderStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                            <option value="PREPARING" ${o.orderStatus == 'PREPARING' ? 'selected' : ''}>Đang chuẩn bị</option>
                                            <option value="SHIPPING" ${o.orderStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                                            <option value="COMPLETED" ${o.orderStatus == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                            <option value="CANCELLED" ${o.orderStatus == 'CANCELLED' ? 'selected' : ''}>Hủy đơn</option>
                                        </select>
                                        <button type="submit" class="btn btn-dark btn-sm rounded-2">Lưu</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>