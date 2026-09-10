<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Hóa đơn #DH${order.id}</title>
    <style>
        body { font-family: 'Courier New', Courier, monospace; font-size: 14px; margin: 0; padding: 20px; background: #f0f0f0; }
        .receipt-wrapper { max-width: 380px; margin: 0 auto; background: #fff; padding: 20px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .text-center { text-align: center; }
        .fw-bold { font-weight: bold; }
        .mb-1 { margin-bottom: 4px; } .mb-3 { margin-bottom: 12px; }
        .dashed-line { border-top: 1px dashed #000; margin: 12px 0; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 4px 0; }
        .text-end { text-align: right; }
        .btn-print { display: block; width: 100%; padding: 15px; background: #2F6B3F; color: #fff; text-align: center; text-decoration: none; font-weight: bold; font-family: Arial, sans-serif; border-radius: 8px; margin-top: 20px; cursor: pointer; border: none;}
        .btn-back { display: block; text-align: center; margin-top: 10px; color: #666; font-family: Arial, sans-serif; text-decoration: none; }
        @media print {
            body { background: #fff; padding: 0; }
            .receipt-wrapper { box-shadow: none; max-width: 100%; padding: 0; }
            .btn-print, .btn-back { display: none; } /* Ẩn các nút khi in */
        }
    </style>
</head>
<body>
    <div class="receipt-wrapper">
        <div class="text-center mb-3">
            <h2 class="fw-bold mb-1" style="margin-top: 0;">FRUIT FARMER MARKET</h2>
            <div>Số 1 Đại Cồ Việt, Hai Bà Trưng, HN</div>
            <div>SĐT: 0988.123.456</div>
        </div>

        <div class="dashed-line"></div>

        <div><span class="fw-bold">Mã đơn:</span> #DH${order.id}</div>
        <div><span class="fw-bold">Ngày:</span> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
        <div><span class="fw-bold">Thu ngân:</span> ${sessionScope.user.fullName}</div>
        <div><span class="fw-bold">Khách hàng:</span> ${order.receiverName}</div>

        <div class="dashed-line"></div>

        <table>
            <c:forEach var="item" items="${details}">
                <tr><td colspan="2" class="fw-bold">${item.productName}</td></tr>
                <tr>
                    <td>${item.quantity} x <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="" maxFractionDigits="0"/></td>
                    <td class="text-end"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="" maxFractionDigits="0"/></td>
                </tr>
            </c:forEach>
        </table>

        <div class="dashed-line"></div>

        <table>
            <tr>
                <td class="fw-bold" style="font-size: 18px;">TỔNG CỘNG:</td>
                <td class="text-end fw-bold" style="font-size: 18px;"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
            </tr>
            <tr>
                <td>Thanh toán:</td>
                <td class="text-end">${order.paymentMethod == 'CASH' ? 'Tiền mặt' : 'Chuyển khoản'}</td>
            </tr>
        </table>

        <div class="dashed-line"></div>

        <div class="text-center">
            <div class="fw-bold">CẢM ƠN QUÝ KHÁCH & HẸN GẶP LẠI!</div>
            <div style="font-size: 12px; margin-top: 5px;">Vui lòng giữ lại hóa đơn để đối chiếu.</div>
        </div>
    </div>

    <!-- Các nút thao tác ngoài lề -->
    <div style="max-width: 380px; margin: 0 auto;">
        <button class="btn-print" onclick="window.print()">🖨️ IN HÓA ĐƠN NÀY</button>
        <a href="${pageContext.request.contextPath}/staff/pos" class="btn-back">← Quay lại màn hình bán hàng</a>
    </div>
</body>
</html>