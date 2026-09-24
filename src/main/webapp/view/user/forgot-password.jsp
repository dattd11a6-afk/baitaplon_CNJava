<div class="card shadow-sm border-0 p-4" style="max-width: 450px; margin: 50px auto;">
    <h3 class="fw-bold text-success text-center mb-4">Khôi phục mật khẩu</h3>

    <c:choose>
        <%-- BƯỚC 1: NHẬP EMAIL --%>
        <c:when test="${step == '1'}">
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="action" value="send_otp">
                <div class="mb-3">
                    <label class="form-label">Email của bạn</label>
                    <input type="email" name="email" class="form-control" placeholder="Nhập email đã đăng ký..." required>
                </div>
                <button type="submit" class="btn btn-success w-100">Gửi mã xác nhận</button>
            </form>
        </c:when>

        <%-- BƯỚC 2: NHẬP OTP --%>
        <c:when test="${step == '2'}">
            <p class="text-muted text-center">Mã gồm 6 chữ số đã được gửi tới <b>${sessionScope.resetEmail}</b></p>
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
                <input type="hidden" name="action" value="verify_otp">
                <div class="mb-3">
                    <input type="text" name="otp" class="form-control text-center fs-4 letter-spacing-2" maxlength="6" placeholder="------" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Xác nhận OTP</button>
            </form>
        </c:when>

        <%-- BƯỚC 3: QUYẾT ĐỊNH (GIỐNG GMAIL) --%>
        <c:when test="${step == '3'}">
            <div class="alert alert-success text-center mb-4">Xác minh danh tính thành công!</div>

            <!-- Option 1: Đổi mật khẩu mới -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="mb-3 border-bottom pb-4">
                <input type="hidden" name="action" value="reset_password">
                <div class="mb-3">
                    <label class="form-label">Tạo mật khẩu mới</label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Lưu mật khẩu mới</button>
            </form>

            <!-- Option 2: Giữ nguyên mật khẩu cũ -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="text-center">
                <input type="hidden" name="action" value="keep_old_password">
                <p class="text-muted" style="font-size:13px;">Bạn chợt nhớ ra mật khẩu cũ?</p>
                <button type="submit" class="btn btn-outline-secondary w-100">Bỏ qua và tiếp tục bằng mật khẩu cũ</button>
            </form>
        </c:when>
    </c:choose>
</div>