<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Đơn hàng | Shipper</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <style>
        :root { --ship-primary: #F59E0B; --ship-sidebar: #111827; --ship-bg: #F9FAFB; --text-main: #1F2937; --text-muted: #6B7280; --border-color: #E2E8F0; }
        body { background-color: var(--ship-bg); font-family: 'Inter', sans-serif; font-size: 13px; color: var(--text-main); margin: 0; }
        .brand-font { font-family: 'DM Sans', sans-serif; }

        .sidebar { width: 250px; background-color: var(--ship-sidebar); color: #fff; height: 100vh; flex-shrink: 0; display: flex; flex-direction: column; position: fixed; left: 0; top: 0; z-index: 100;}
        .sidebar-header { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .sidebar-logo { width: 40px; height: 40px; background: var(--ship-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: #fff;}
        .sidebar-menu { list-style: none; padding: 0; margin: 24px 0 0 0; }
        .sidebar-menu li a { display: flex; align-items: center; padding: 12px 24px; color: #A1A1AA; text-decoration: none; font-weight: 500; font-size: 14px; transition: 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu li a i { font-size: 20px; margin-right: 12px; }
        .sidebar-menu li a:hover { color: #fff; background-color: rgba(255,255,255,0.05); }
        .sidebar-menu li.active a { color: var(--ship-primary); background-color: rgba(245, 158, 11, 0.1); border-left-color: var(--ship-primary); font-weight: 600; }

        .main-content { margin-left: 250px; display: flex; flex-direction: column; min-height: 100vh; width: calc(100% - 250px); }
        .ship-header { height: 72px; background: #fff; padding: 0 32px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 10; }
        .page-body { padding: 32px; flex-grow: 1; }

        .op-card { background: #fff; border: 1px solid var(--border-color); border-radius: 16px; padding: 24px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.02);}
        .section-title { font-size: 12px; font-weight: 700; color: #9CA3AF; text-transform: uppercase; margin-bottom: 24px; letter-spacing: 1px; border-bottom: 1px solid var(--border-color); padding-bottom: 12px;}

        .info-row { display: flex; margin-bottom: 16px; align-items: flex-start; gap: 12px;}
        .info-label { width: 140px; font-weight: 600; color: var(--text-muted); flex-shrink: 0;}
        .info-value { flex-grow: 1; font-weight: 500; color: var(--text-main); }

        .product-list-item { display: flex; align-items: center; gap: 16px; padding: 16px; border: 1px solid var(--border-color); border-radius: 12px; margin-bottom: 12px; background: #FAFAFA;}
        .product-img { width: 64px; height: 64px; object-fit: cover; border-radius: 8px; border: 1px solid #E5E7EB; background: #fff;}

        .receipt-box { background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 12px; padding: 24px; }
        .receipt-row { display: flex; justify-content: space-between; margin-bottom: 16px; font-size: 14px; font-weight: 500; color: #4B5563;}
        .receipt-row.total-row { border-top: 2px dashed #CBD5E1; padding-top: 16px; margin-top: 8px; margin-bottom: 0; color: #0F172A;}

        .btn-call { background: #E0F2FE; color: #0284C7; padding: 12px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; width: 48px; height: 48px; text-decoration: none; transition: 0.2s;}
        .btn-call:hover { background: #BAE6FD; }
        .btn-main { height: 56px; font-size: 15px; font-weight: 700; border-radius: 12px; width: 100%; transition: 0.2s;}
    </style>
</head>
<body>
<div class="d-flex">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo"><i class="ph-bold ph-moped"></i></div>
            <div>
                <div class="fw-bold brand-font text-white" style="font-size: 16px;">Delivery App</div>
                <div style="font-size: 10px; color: var(--ship-primary); font-weight: 700; letter-spacing: 1px;">SHIPPER PORTAL</div>
            </div>
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/shipper/home"><i class="ph-fill ph-house"></i> Tổng quan</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/shipper/orders"><i class="ph-fill ph-receipt"></i> Đơn hàng của tôi</a></li>
            <li><a href="${pageContext.request.contextPath}/shipper/profile"><i class="ph-fill ph-user-circle"></i> Tài khoản cá nhân</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="ship-header">
            <div class="d-flex align-items-center gap-4">
                <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-light border text-dark p-2 rounded-circle"><i class="ph-bold ph-arrow-left fs-5"></i></a>
                <div>
                    <h4 class="fw-bold m-0 brand-font">Chi tiết Đơn hàng #DH${order.id}</h4>
                    <div class="text-muted mt-1" style="font-size: 12px;">Cập nhật lúc: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="HH:mm dd/MM/yyyy"/></div>
                </div>
            </div>
        </header>

        <div class="page-body">
            <div class="row g-4">
                <!-- CỘT TRÁI: KHÁCH HÀNG & ĐƠN HÀNG -->
                <div class="col-lg-7">
                    <div class="op-card">
                        <div class="section-title"><i class="ph-fill ph-user-circle text-primary me-2"></i> Thông tin Khách hàng</div>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <div class="fw-bold fs-4 text-dark mb-1">${order.receiverName}</div>
                                <div class="text-primary fw-bold fs-5">${order.receiverPhone}</div>
                            </div>
                            <a href="tel:${order.receiverPhone}" class="btn-call shadow-sm"><i class="ph-fill ph-phone" style="font-size: 24px;"></i></a>
                        </div>
                        <div class="info-row align-items-center">
                            <div class="info-label"><i class="ph-fill ph-map-pin text-danger me-1"></i> Địa chỉ giao</div>
                            <div class="info-value lh-base bg-light p-3 rounded-3 border">${order.receiverAddress}</div>
                        </div>
                    </div>

                    <div class="op-card">
                        <div class="section-title"><i class="ph-fill ph-shopping-cart text-warning me-2"></i> Tóm tắt Đơn hàng</div>
                        <c:set var="isExpress" value="${order.shippingType == 'EXPRESS' || fn:contains(fn:toUpperCase(order.note), 'HỎA TỐC')}" />

                        <div class="info-row">
                            <div class="info-label">Phương thức giao</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${isExpress}"><span class="badge bg-danger bg-opacity-10 text-danger border border-danger px-3 py-2"><i class="ph-bold ph-lightning"></i> GIAO HỎA TỐC 2H</span></c:when>
                                    <c:otherwise><span class="badge bg-light text-dark border px-3 py-2"><i class="ph-bold ph-truck"></i> GIAO TIÊU CHUẨN</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Ngày giờ đặt</div>
                            <div class="info-value"><fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Trạng thái hiện tại</div>
                            <div class="info-value fw-bold text-primary">${order.orderStatus}</div>
                        </div>
                        <c:if test="${not empty order.note}">
                            <div class="info-row">
                                <div class="info-label">Ghi chú của khách</div>
                                <div class="info-value text-danger fw-medium fst-italic">"${order.note}"</div>
                            </div>
                        </c:if>

                        <!-- CHI TIẾT SẢN PHẨM RÀNH MẠCH TỪNG DÒNG -->
                        <div class="mt-4 pt-3 border-top">
                            <h6 class="fw-bold text-dark mb-3">Sản phẩm chi tiết (${fn:length(details)} món)</h6>
                            <c:set var="calcSubtotal" value="0" />
                            <c:forEach var="item" items="${details}">
                                <c:set var="calcSubtotal" value="${calcSubtotal + item.subtotal}" />
                                <div class="product-list-item">
                                    <img src="${not empty item.productImage ? item.productImage : 'https://placehold.co/100x100?text=SP'}" class="product-img">
                                    <div class="flex-grow-1">
                                        <div class="fw-bold text-dark fs-6 mb-1">${item.productName}</div>
                                        <div class="text-muted"><fmt:formatNumber value="${item.price}" pattern="#,##0"/> đ</div>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold text-dark mb-1">SL: x${fn:replace(item.quantity, ".0", "")}</div>
                                        <div class="fw-bold text-success"><fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> đ</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI: BIÊN LAI & THANH TOÁN -->
                <div class="col-lg-5">
                    <div class="op-card position-sticky" style="top: 100px;">
                        <div class="section-title"><i class="ph-fill ph-receipt text-success me-2"></i> Biên lai & Thanh toán</div>

                        <!-- TOÁN HỌC BÓC TÁCH MINH BẠCH -->
                        <c:set var="safeShip" value="${order.shippingFee != null ? order.shippingFee : 0}" />
                        <c:set var="safeTax" value="${order.taxFee != null ? order.taxFee : 0}" />
                        <c:set var="calcVoucher" value="${calcSubtotal + safeShip + safeTax - order.totalAmount}" />
                        <c:if test="${calcVoucher < 0}"><c:set var="calcVoucher" value="0" /></c:if>

                        <div class="receipt-box mb-4">
                            <div class="receipt-row">
                                <span>Tạm tính hàng hóa</span>
                                <span class="text-dark"><fmt:formatNumber value="${calcSubtotal}" pattern="#,##0"/> đ</span>
                            </div>
                            <c:if test="${calcVoucher > 0}">
                                <div class="receipt-row text-success">
                                    <span>Khuyến mãi (Voucher/Xu)</span>
                                    <span>- <fmt:formatNumber value="${calcVoucher}" pattern="#,##0"/> đ</span>
                                </div>
                            </c:if>
                            <div class="receipt-row">
                                <span>Phí vận chuyển</span>
                                <span class="text-dark">+ <fmt:formatNumber value="${safeShip}" pattern="#,##0"/> đ</span>
                            </div>
                            <div class="receipt-row">
                                <span>Thuế VAT</span>
                                <span class="text-dark">+ <fmt:formatNumber value="${safeTax}" pattern="#,##0"/> đ</span>
                            </div>
                            <div class="receipt-row total-row">
                                <span class="fs-5">TỔNG CỘNG</span>
                                <span class="text-danger fs-4 brand-font"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ</span>
                            </div>
                        </div>

                        <div class="bg-light p-4 rounded-4 border text-center mb-4 shadow-sm">
                            <div class="text-muted fw-bold mb-2 text-uppercase" style="font-size: 11px;">Số tiền Shipper cần thu (COD)</div>
                            <div class="fw-bold text-danger brand-font" style="font-size: 40px; line-height: 1;">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'COD'}"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ</c:when>
                                    <c:otherwise>0 đ</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="mt-3">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'COD'}"><span class="badge bg-danger px-3 py-2 rounded-pill">THU TIỀN MẶT</span></c:when>
                                    <c:otherwise><span class="badge bg-success px-3 py-2 rounded-pill"><i class="ph-fill ph-check-circle"></i> ĐÃ CHUYỂN KHOẢN TRƯỚC</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- HÀNH ĐỘNG CỦA SHIPPER -->
                        <c:if test="${order.orderStatus == 'PREPARING' || order.orderStatus == 'SHIPPING'}">
                            <form action="${pageContext.request.contextPath}/shipper/order-detail" method="POST" id="actionForm">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <input type="hidden" name="currentStatus" value="${order.orderStatus}">
                                <input type="hidden" name="action" id="formAction" value="">

                                <c:choose>
                                    <c:when test="${order.orderStatus == 'PREPARING'}">
                                        <button type="button" class="btn btn-main text-dark shadow-lg" style="background: var(--ship-primary);" onclick="submitAction('START_DELIVERY')">
                                            <i class="ph-bold ph-moped me-2 fs-5"></i> BẮT ĐẦU ĐI GIAO HÀNG
                                        </button>
                                    </c:when>
                                    <c:when test="${order.orderStatus == 'SHIPPING'}">
                                        <button type="button" class="btn btn-success btn-main mb-3 shadow-lg" onclick="submitAction('COMPLETE')">
                                            <i class="ph-bold ph-check-circle me-2 fs-5"></i> GIAO THÀNH CÔNG
                                        </button>
                                        <div class="text-center mt-3">
                                            <a href="#" class="text-danger fw-medium text-decoration-none" data-bs-toggle="modal" data-bs-target="#failModal">Báo cáo giao thất bại</a>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- MODAL GIAO THẤT BẠI -->
<div class="modal fade" id="failModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content rounded-4 border-0 shadow-lg">
            <div class="modal-header border-0 pb-0 p-4">
                <h5 class="fw-bold m-0 text-danger brand-font">Báo cáo Giao thất bại</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4 pt-2">
                <label class="form-label fw-medium mb-2 text-dark">Chọn lý do thực tế:</label>
                <select class="form-select form-select-lg mb-4 rounded-3 bg-light" id="failReason" onchange="document.getElementById('hiddenReason').value = this.value;">
                    <option value="Khách không nghe máy (Thuê bao)">Khách không nghe máy (Thuê bao)</option>
                    <option value="Khách hẹn dời lịch giao">Khách hẹn dời lịch giao</option>
                    <option value="Sai địa chỉ / Không tìm thấy">Sai địa chỉ / Không tìm thấy</option>
                    <option value="Khách từ chối nhận hàng (Bom hàng)">Khách từ chối nhận hàng (Bom hàng)</option>
                    <option value="Hàng hóa bị hỏng trong quá trình vận chuyển">Hàng hóa bị hỏng trong quá trình vận chuyển</option>
                </select>
                <button type="button" class="btn btn-danger btn-main py-3 w-100 shadow-sm" onclick="submitFailAction()">XÁC NHẬN HỦY GIAO HÀNG</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function submitAction(actionCode) {
        if(actionCode === 'COMPLETE' && !confirm('Xác nhận: Khách đã nhận đủ hàng và BẠN ĐÃ THU ĐỦ TIỀN (nếu là đơn COD)?')) return;
        document.getElementById('formAction').value = actionCode;
        document.getElementById('actionForm').submit();
    }
    function submitFailAction() {
        document.getElementById('formAction').value = 'FAIL';
        let input = document.createElement('input');
        input.type = 'hidden'; input.name = 'reason';
        input.value = document.getElementById('failReason').value;
        document.getElementById('actionForm').appendChild(input);
        document.getElementById('actionForm').submit();
    }
</script>
</body>
</html>