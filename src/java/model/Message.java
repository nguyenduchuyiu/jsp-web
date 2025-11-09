package model;

import java.sql.Timestamp;

public class Message {
    private int maTN;
    private int maTC;
    private String noiDung;
    private int maNguoiGui;
    private Timestamp thoiGianGui;
    
    // Getters and Setters
    public int getMaTN() { return maTN; }
    public void setMaTN(int maTN) { this.maTN = maTN; }
    
    public int getMaTC() { return maTC; }
    public void setMaTC(int maTC) { this.maTC = maTC; }
    
    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    
    public int getMaNguoiGui() { return maNguoiGui; }
    public void setMaNguoiGui(int maNguoiGui) { this.maNguoiGui = maNguoiGui; }
    
    public Timestamp getThoiGianGui() { return thoiGianGui; }
    public void setThoiGianGui(Timestamp thoiGianGui) { this.thoiGianGui = thoiGianGui; }
}