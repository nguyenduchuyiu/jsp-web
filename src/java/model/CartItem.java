package model;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

public class CartItem {
    private int maCTGH;
    private String maSP;
    private int soLuong;
    
    // Thông tin sản phẩm từ bảng sanpham
    private String tenSP;
    private BigDecimal gia;
    private String donVi;
    private String hinhAnh;
    
    // Getters and Setters
    public int getMaCTGH() { return maCTGH; }
    public void setMaCTGH(int maCTGH) { this.maCTGH = maCTGH; }
    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }
    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }
    public BigDecimal getGia() { return gia; }
    public void setGia(BigDecimal gia) { this.gia = gia; }
    public String getDonVi() { return donVi; }
    public void setDonVi(String donVi) { this.donVi = donVi; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    // Phương thức tính tổng tiền cho từng item
    public BigDecimal getThanhTien() {
        if (gia == null) return BigDecimal.ZERO;
        return gia.multiply(new BigDecimal(soLuong));
    }
    

        // Phương thức định dạng tiền tệ (sử dụng format cho đồng nhất)
    // NHUNGKM
    // Phương thức định dạng tiền tệ (sử dụng format cho đồng nhất)
    public static String formatCurrency(java.math.BigDecimal amount) {
        if (amount == null) return "0 VND";
        return String.format("%,.0f VND", amount.doubleValue());
    }
    // ENDKM
}