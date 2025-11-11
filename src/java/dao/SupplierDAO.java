package dao;

import model.NhaCungCap;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    // Ánh xạ ResultSet sang Model
    private NhaCungCap mapSupplier(ResultSet rs) throws SQLException {
        NhaCungCap ncc = new NhaCungCap();
        ncc.setMaNCC(rs.getInt("MaNCC"));
        ncc.setTenNCC(rs.getString("TenNCC"));
        ncc.setDiaChi(rs.getString("DiaChi"));
        ncc.setSdt(rs.getString("SDT"));
        ncc.setEmail(rs.getString("Email"));
        ncc.setXuatXu(rs.getString("XuatXu"));
        return ncc;
    }

    // 1. Lấy tất cả Nhà cung cấp (Read)
    public List<NhaCungCap> getAllSuppliers() {
        List<NhaCungCap> list = new ArrayList<>();
        String sql = "SELECT * FROM nhacungcap ORDER BY TenNCC ASC";
        try (Connection con = DB.getCon(); 
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapSupplier(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy NCC theo ID (Cần cho Update)
    public NhaCungCap getSupplierById(int maNCC) {
        String sql = "SELECT * FROM nhacungcap WHERE MaNCC = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNCC);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapSupplier(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Thêm NCC (Create)
    public void addSupplier(NhaCungCap ncc) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO nhacungcap (TenNCC, DiaChi, SDT, Email, XuatXu) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ncc.getTenNCC());
            ps.setString(2, ncc.getDiaChi());
            ps.setString(3, ncc.getSdt());
            ps.setString(4, ncc.getEmail());
            ps.setString(5, ncc.getXuatXu());
            ps.executeUpdate();
        }
    }

    // 4. Cập nhật NCC (Update)
    public void updateSupplier(NhaCungCap ncc) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE nhacungcap SET TenNCC = ?, DiaChi = ?, SDT = ?, Email = ?, XuatXu = ? WHERE MaNCC = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, ncc.getTenNCC());
            ps.setString(2, ncc.getDiaChi());
            ps.setString(3, ncc.getSdt());
            ps.setString(4, ncc.getEmail());
            ps.setString(5, ncc.getXuatXu());
            ps.setInt(6, ncc.getMaNCC());
            ps.executeUpdate();
        }
    }
    
    // 5. Xóa NCC (Delete)
    public boolean deleteSupplier(int maNCC) {
        String sql = "DELETE FROM nhacungcap WHERE MaNCC = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNCC);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Lỗi (thường là do khóa ngoại từ bảng sanpham)
            e.printStackTrace();
            return false;
        }
    }
}