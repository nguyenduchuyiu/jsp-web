package dao;

import model.NhaCungCap;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NhaCungCapDAO {
    
    // Hàm ánh xạ (map) đầy đủ các thuộc tính từ ResultSet sang Model
    private NhaCungCap mapNCC(ResultSet rs) throws SQLException {
        NhaCungCap ncc = new NhaCungCap();
        
        // ĐÃ SỬA: Đảm bảo sử dụng tên cột viết hoa CHÍNH XÁC
        ncc.setMaNCC(rs.getInt("MaNCC"));
        ncc.setTenNCC(rs.getString("TenNCC"));
        ncc.setDiaChi(rs.getString("DiaChi"));
        ncc.setSdt(rs.getString("SDT"));
        ncc.setEmail(rs.getString("Email"));
        ncc.setXuatXu(rs.getString("XuatXu"));
        
        return ncc;
    }
    
    // SỬA: Thay đổi khai báo để ném lỗi CSDL ra ngoài
    public List<NhaCungCap> getAllNhaCungCap() throws SQLException, ClassNotFoundException {
        List<NhaCungCap> list = new ArrayList<>();
        
        String sql = "SELECT MaNCC, TenNCC, DiaChi, SDT, Email, XuatXu FROM nhacungcap ORDER BY TenNCC ASC";
        
        // SỬA: Không sử dụng try-with-resources (Statement/ResultSet) ở đây
        // để SQLException được ném ra ngoài và bắt trong Servlet
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DB.getCon(); 
            stmt = con.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                list.add(mapNCC(rs));
            }
        } finally {
            // Đóng tài nguyên trong khối finally
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
        return list;
    }

}
