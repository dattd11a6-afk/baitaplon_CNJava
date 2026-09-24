package com.fruitfarmermarket.service;

import com.fruitfarmermarket.dao.GiftBasketDAO;
import com.fruitfarmermarket.model.Basket;
import com.fruitfarmermarket.model.Decoration;
import com.fruitfarmermarket.model.Packaging;

import java.util.List;

public class GiftBasketService {

    private GiftBasketDAO dao = new GiftBasketDAO();

    /**
     * Lấy toàn bộ danh sách vỏ giỏ (baskets) đang ACTIVE
     * Để đổ lên giao diện "Bước 2: Chọn giỏ"
     */
    public List<Basket> getAvailableBaskets() {
        return dao.getActiveBaskets();
    }

    /**
     * Lấy toàn bộ danh sách đồ trang trí (decorations) đang ACTIVE
     * Để đổ lên giao diện "Bước 3: Thiệp + Trang trí"
     */
    public List<Decoration> getAvailableDecorations() {
        return dao.getActiveDecorations();
    }

    /**
     * Lấy toàn bộ danh sách kiểu đóng gói (packagings) đang ACTIVE
     * Để đổ lên giao diện "Bước 3: Đóng gói"
     */
    public List<Packaging> getAvailablePackagings() {
        return dao.getActivePackagings();
    }

    // --- Các hàm lấy chi tiết 1 phần tử (Dùng cho Phase tính tiền Backend) ---
    public Basket getBasket(int id) {
        return dao.getBasketById(id);
    }

    public Decoration getDecoration(int id) {
        return dao.getDecorationById(id);
    }

    public Packaging getPackaging(int id) {
        return dao.getPackagingById(id);
    }
}