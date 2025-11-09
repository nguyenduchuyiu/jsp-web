package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Order {
    private int maDH;
    private int maND; 
    private java.sql.Timestamp ngayDat;
    private String diaChiGiaoHang;
    private String phuongThucThanhToan;
    private String trangThai; 
    private String ghiChu;
    private BigDecimal tongTien;
    
    // Thuộc tính bổ sung từ bảng donhang
    private String tenNguoiNhan;
    private String sdtNguoiNhan;
    
    // Getters and Setters
    public int getMaDH() { return maDH; }
    public void setMaDH(int maDH) { this.maDH = maDH; }
    
    public int getMaND() { return maND; }
    public void setMaND(int maND) { this.maND = maND; }
    
    public java.sql.Timestamp getNgayDat() { return ngayDat; }
    public void setNgayDat(java.sql.Timestamp ngayDat) { this.ngayDat = ngayDat; }

    public String getDiaChiGiaoHang() { return diaChiGiaoHang; }
    public void setDiaChiGiaoHang(String diaChiGiaoHang) { this.diaChiGiaoHang = diaChiGiaoHang; }
    
    public String getPhuongThucThanhToan() { return phuongThucThanhToan; }
    public void setPhuongThucThanhToan(String phuongThucThanhToan) { this.phuongThucThanhToan = phuongThucThanhToan; }
    
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    
    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
    
    public BigDecimal getTongTien() { return tongTien; }
    public void setTongTien(BigDecimal tongTien) { this.tongTien = tongTien; }

    // Thuộc tính bổ sung
    public String getTenNguoiNhan() { return tenNguoiNhan; }
    public void setTenNguoiNhan(String tenNguoiNhan) { this.tenNguoiNhan = tenNguoiNhan; }
    
    public String getSdtNguoiNhan() { return sdtNguoiNhan; }
    public void setSdtNguoiNhan(String sdtNguoiNhan) { this.sdtNguoiNhan = sdtNguoiNhan; }
}