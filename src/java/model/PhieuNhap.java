package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PhieuNhap {
    private int id;
    private String maPN;
    private int maNCC;
    private String tenNCC; // Thuộc tính bổ sung
    private Timestamp ngayLap;
    private BigDecimal tongTien;
    private String trangThai; 
    private int maNguoiLap;
    private String ghiChu;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getMaPN() { return maPN; }
    public void setMaPN(String maPN) { this.maPN = maPN; }
    
    public int getMaNCC() { return maNCC; }
    public void setMaNCC(int maNCC) { this.maNCC = maNCC; }
    
    public String getTenNCC() { return tenNCC; }
    public void setTenNCC(String tenNCC) { this.tenNCC = tenNCC; }

    public Timestamp getNgayLap() { return ngayLap; }
    public void setNgayLap(Timestamp ngayLap) { this.ngayLap = ngayLap; }

    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public int getMaNguoiLap() { return maNguoiLap; }
    public void setMaNguoiLap(int maNguoiLap) { this.maNguoiLap = maNguoiLap; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    
    // Phương thức định dạng tiền tệ
    public String getTongTienVND() {
        if (this.tongTien == null) return "0 VNĐ";
        return String.format("%,.0f VNĐ", this.tongTien.doubleValue());
    }
}