package model;

public class User {
    private int maND; 
    private String user; private String name; private String email;
    private String phone; private String address;
    private String loaiNguoiDung;
    
    // Getters and Setters
    public int getMaND() { return maND; } 
    public void setMaND(int maND) { this.maND = maND; }
    
    public String getLoaiNguoiDung() { return loaiNguoiDung; }
    public void setLoaiNguoiDung(String loaiNguoiDung) { this.loaiNguoiDung = loaiNguoiDung; }
    
    public String getUser() { return user; } public void setUser(String user) { this.user = user; }
    public String getName() { return name; } public void setName(String name) { this.name = name; }
    public String getEmail() { return email; } public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; } public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; } public void setAddress(String address) { this.address = address; }
}