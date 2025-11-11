package model;

import java.sql.Date;
import java.math.BigDecimal;
public class KhuyenMai {
    private int maKM;
    private String tenKM;
    private String moTa;
    private Date ngayBatDau;
    private Date ngayKetThuc;
    private int maNguoiLap;
    private String loaiKM;
    private BigDecimal dieuKienMin;
    private int phanTramGiam;

    public int getMaNguoiLap() {
        return maNguoiLap;
    }

    public void setMaNguoiLap(int maNguoiLap) {
        this.maNguoiLap = maNguoiLap;
    }
    
    
    public int getPhanTramGiam() { 
    return phanTramGiam; 
    }
    public void setPhanTramGiam(int phanTramGiam) { 
        this.phanTramGiam = phanTramGiam; 
    }
    public String getLoaiKM() { return loaiKM; }
    public void setLoaiKM(String loaiKM) { this.loaiKM = loaiKM; }
    public BigDecimal getDieuKienMin() { 
        return dieuKienMin; 
    }
    public void setDieuKienMin(BigDecimal dieuKienMin) { 
        this.dieuKienMin = dieuKienMin; 
    }
    
    
    // Getters and Setters
    public int getMaKM() { return maKM; }
    public void setMaKM(int maKM) { this.maKM = maKM; }
    
    public String getTenKM() { return tenKM; }
    public void setTenKM(String tenKM) { this.tenKM = tenKM; }
    
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    
    public Date getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Date ngayBatDau) { this.ngayBatDau = ngayBatDau; }
    
    public Date getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(Date ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }
}