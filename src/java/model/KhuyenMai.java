package model;

import java.sql.Date;

public class KhuyenMai {
    private int maKM;
    private String tenKM;
    private String moTa;
    private Date ngayBatDau;
    private Date ngayKetThuc;
    
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