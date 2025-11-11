package dao;

import model.User;
import java.sql.*;

public class UserDAO {
    
    // 1. Hàm kiểm tra tên đăng nhập hoặc email đã tồn tại chưa (Giữ nguyên)
    public boolean checkExists(String user, String email) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM nguoidung WHERE TenDangNhap = ? OR Email = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // 2. Hàm đăng ký người dùng mới (Luôn là KhachHang) (Giữ nguyên)
    public void register(User u, String pass) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO nguoidung (TenDangNhap, MatKhau, HoTen, Email, SoDienThoai, DiaChi, LoaiNguoiDung) VALUES (?, ?, ?, ?, ?, ?, 'KhachHang')";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getUser());
            ps.setString(2, pass);
            ps.setString(3, u.getName());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getAddress());
            ps.executeUpdate();
        }
    }
    
    // 3. PHƯƠNG THỨC ĐĂNG NHẬP MỚI
// Trong file dao/UserDAO.java

public User login(String user, String pass) throws SQLException, ClassNotFoundException {
    User u = null;
    // Kiểm tra TenDangNhap và MatKhau
    String sql = "SELECT * FROM nguoidung WHERE TenDangNhap = ? AND MatKhau = ?"; 
    
    try (Connection con = DB.getCon(); 
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, user);
        ps.setString(2, pass); 
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            u = new User();
            
            // GÁN THUỘC TÍNH MỚI VÀO MODEL
            u.setMaND(rs.getInt("MaND")); // Đảm bảo bạn đã thêm MaND
            u.setLoaiNguoiDung(rs.getString("LoaiNguoiDung").trim()); 

            // Thiết lập các thuộc tính người dùng
            u.setUser(rs.getString("TenDangNhap"));
            u.setName(rs.getString("HoTen"));
            u.setEmail(rs.getString("Email"));
            u.setPhone(rs.getString("SoDienThoai"));
            u.setAddress(rs.getString("DiaChi"));
        }
    }
    return u;
}
// 4. Hàm cập nhật thông tin người dùng
public void updateUserInfo(int maND, String name, String email, String phone, String address) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE nguoidung SET HoTen = ?, Email = ?, SoDienThoai = ?, DiaChi = ? WHERE MaND = ?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, address);
        ps.setInt(5, maND);
        ps.executeUpdate();
    }
}

// 5. Hàm cập nhật mật khẩu
public void updatePassword(int maND, String newPass) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE nguoidung SET MatKhau = ? WHERE MaND = ?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, newPass);
        ps.setInt(2, maND);
        ps.executeUpdate();
    }
}
// Thêm hàm này vào file dao/UserDAO.java
public User getUserById(int maND) {
    User u = null;
    String sql = "SELECT * FROM nguoidung WHERE MaND = ?"; 
    
    try (Connection con = DB.getCon(); 
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, maND);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            u = new User();
            u.setMaND(rs.getInt("MaND"));
            u.setLoaiNguoiDung(rs.getString("LoaiNguoiDung"));
            u.setUser(rs.getString("TenDangNhap"));
            u.setName(rs.getString("HoTen"));
            u.setEmail(rs.getString("Email"));
            u.setPhone(rs.getString("SoDienThoai"));
            u.setAddress(rs.getString("DiaChi"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return u;
}
}