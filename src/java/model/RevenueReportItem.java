package model;

import java.math.BigDecimal;

/**
 * Model này dùng để lưu trữ kết quả báo cáo doanh thu cho từng sản phẩm.
 */
public class RevenueReportItem {
    private String maSP;
    private String tenSP;
    private int tongSoLuong;
    private BigDecimal tongDoanhThu;

    // Getters and Setters
    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }

    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }

    public int getTongSoLuong() { return tongSoLuong; }
    public void setTongSoLuong(int tongSoLuong) { this.tongSoLuong = tongSoLuong; }

    public BigDecimal getTongDoanhThu() { return tongDoanhThu; }
    public void setTongDoanhThu(BigDecimal tongDoanhThu) { this.tongDoanhThu = tongDoanhThu; }
}