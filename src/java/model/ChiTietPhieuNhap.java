package model;

import java.math.BigDecimal;

public class ChiTietPhieuNhap {
    private String maCTPN;
    private String maPN;
    private String maSP;
    private String tenSP; // Thuộc tính bổ sung
    private int soLuong;
    private BigDecimal giaNhap;

    // Getters and Setters
    public String getMaCTPN() { return maCTPN; }
    public void setMaCTPN(String maCTPN) { this.maCTPN = maCTPN; }

    public String getMaPN() { return maPN; }
    public void setMaPN(String maPN) { this.maPN = maPN; }

    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }
    
    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public BigDecimal getGiaNhap() { return giaNhap; }
    public void setGiaNhap(BigDecimal giaNhap) { this.giaNhap = giaNhap; }
    
    // Tính Thành tiền
    public BigDecimal getThanhTien() {
        if (giaNhap == null) return BigDecimal.ZERO;
        return giaNhap.multiply(new BigDecimal(soLuong));
    }
    
    // Phương thức định dạng tiền tệ
    public String getThanhTienVND() {
        return String.format("%,.0f VNĐ", this.getThanhTien().doubleValue());
    }
}