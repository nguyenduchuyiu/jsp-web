package dao;

import java.sql.*;

public class ConDAO {
    // Hàm lưu thông tin liên hệ vào bảng LienHe
    public void save(String name, String email, String subject, String content) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO LienHe (HoTen, Email, TieuDe, NoiDung, TrangThaiPhanHoi) VALUES (?, ?, ?, ?, 'ChuaDoc')";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, content);
            ps.executeUpdate();
        }
    }
}