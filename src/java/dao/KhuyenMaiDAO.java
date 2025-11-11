package dao;

import model.KhuyenMai;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KhuyenMaiDAO {

    // Ánh xạ ResultSet sang KhuyenMai
    private KhuyenMai mapKhuyenMai(ResultSet rs) throws SQLException {
        KhuyenMai km = new KhuyenMai();
        km.setMaKM(rs.getInt("MaKM"));
        km.setTenKM(rs.getString("TenKM"));
        km.setMoTa(rs.getString("MoTa"));
        km.setLoaiKM(rs.getString("LoaiKM"));
        km.setNgayBatDau(rs.getDate("NgayBatDau"));
        km.setNgayKetThuc(rs.getDate("NgayKetThuc"));
        km.setPhanTramGiam(rs.getInt("PhanTramGiam"));
        km.setDieuKienMin(rs.getBigDecimal("DieuKienMin"));
        return km;
    }

    // 1. Lấy tất cả Khuyến Mãi (Cho cả Guest/Customer/Admin)
    public List<KhuyenMai> getAllKhuyenMai() {
        List<KhuyenMai> list = new ArrayList<>();
        // Chỉ lấy các KM đang còn hiệu lực
        String sql = "SELECT * FROM khuyenmai WHERE NgayKetThuc >= CURDATE() ORDER BY NgayBatDau DESC"; 
        try (Connection con = DB.getCon(); 
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapKhuyenMai(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // 2. Thêm Khuyến Mãi (Chỉ Admin)
    public void addKhuyenMai(KhuyenMai km) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO khuyenmai (TenKM, MoTa, NgayBatDau, NgayKetThuc) VALUES (?, ?, ?, ?)";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, km.getTenKM());
            ps.setString(2, km.getMoTa());
            ps.setDate(3, km.getNgayBatDau());
            ps.setDate(4, km.getNgayKetThuc());
            ps.executeUpdate();
        }
    }

    // 3. Xóa Khuyến Mãi (Chỉ Admin)
    public boolean deleteKhuyenMai(int maKM) {
        String sql = "DELETE FROM khuyenmai WHERE MaKM = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maKM);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 4. Lấy danh sách TẤT CẢ Khuyến Mãi đang còn hiệu lực

public List<KhuyenMai> getActiveKhuyenMai() {
    List<KhuyenMai> list = new ArrayList<>();
    
    // SỬA: Lọc theo NgayBatDau <= CURDATE() VÀ NgayKetThuc >= CURDATE()
    String sql = "SELECT * FROM khuyenmai " +
                 "WHERE NgayBatDau <= CURDATE() AND NgayKetThuc >= CURDATE() " + 
                 "ORDER BY DieuKienMin ASC"; 

    try (Connection con = DB.getCon(); 
         Statement stmt = con.createStatement(); 
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            list.add(mapKhuyenMai(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
// 5. Lấy Chi tiết Khuyến Mãi theo MaKM
public KhuyenMai getKhuyenMaiById(int maKM) {
    KhuyenMai km = null;
    String sql = "SELECT * FROM khuyenmai WHERE MaKM = ?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maKM);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            km = mapKhuyenMai(rs); // Sử dụng hàm map đã có
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return km;
}
}