package model;

import java.math.BigDecimal;

public class Product {
    private String maSP; private String tenSP; private BigDecimal gia;
    private String hinhAnh; private String thuongHieu; private String xuatXu;
    private String donVi; private String moTa; private String huongDan; 
    private int soLuongTon; private int maDM;

 
    public Product() {}

    // Getters and Setters (Đã sửa lỗi)
    public String getMaSP() { return maSP; }
    public void setMaSP(String maSP) { this.maSP = maSP; }
    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }
    public BigDecimal getGia() { return gia; }
    public void setGia(BigDecimal gia) { this.gia = gia; }
    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }
    public String getThuongHieu() { return thuongHieu; }
    public void setThuongHieu(String thuongHieu) { this.thuongHieu = thuongHieu; }
    public String getDonVi() { return donVi; }
    public void setDonVi(String donVi) { this.donVi = donVi; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public String getHuongDan() { return huongDan; }
    public void setHuongDan(String huongDan) { this.huongDan = huongDan; }
    public int getSoLuongTon() { return soLuongTon; }
    public void setSoLuongTon(int soLuongTon) { this.soLuongTon = soLuongTon; }
    public int getMaDM() { return maDM; }
    public void setMaDM(int maDM) { this.maDM = maDM; }
    public String getXuatXu() { return xuatXu; }
    public void setXuatXu(String xuatXu) { this.xuatXu = xuatXu; }

    public String getPriceVND() {
        if (this.gia == null) return "0 VNĐ";
        return String.format("%,.0f VNĐ", this.gia.doubleValue());
    }

}