package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Conversation {
    private int maTC;
    private int maND;
    private String tieuDe;
    private Timestamp ngayTao;
    private String trangThai;
//    -----NHUNG-----

    private boolean adminRead;
//     ------END------   
    // Thuộc tính bổ sung để hiển thị tên người dùng trên giao diện Admin
    private String tenNguoiDung; 

    // Getters and Setters
//        -----NHUNG-----
   
    public boolean isAdminRead() { return adminRead; }
    public void setAdminRead(boolean adminRead) { this.adminRead = adminRead; }
//    ------END------
    public int getMaTC() { return maTC; }
    public void setMaTC(int maTC) { this.maTC = maTC; }
    
    public int getMaND() { return maND; }
    public void setMaND(int maND) { this.maND = maND; }
    
    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }
    
    public Timestamp getNgayTao() { return ngayTao; }
    public void setNgayTao(Timestamp ngayTao) { this.ngayTao = ngayTao; }
    
    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }
    
    public String getTenNguoiDung() { return tenNguoiDung; }
    public void setTenNguoiDung(String tenNguoiDung) { this.tenNguoiDung = tenNguoiDung; }
}