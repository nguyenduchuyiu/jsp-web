package dao;

import model.PhieuNhap;
import model.ChiTietPhieuNhap; // Cần import ChiTietPhieuNhap cho hàm savePhieuNhap
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class NhapHangDAO {
    
    // Ánh xạ ResultSet sang PhieuNhap (ĐÃ HOÀN THIỆN ÁNH XẠ)
    private PhieuNhap mapPhieuNhap(ResultSet rs) throws SQLException {
        PhieuNhap pn = new PhieuNhap();
        pn.setId(rs.getInt("ID")); // Thêm ID
        pn.setMaPN(rs.getString("MaPN"));
        pn.setNgayLap(rs.getTimestamp("NgayLap"));
        pn.setTongTien(rs.getBigDecimal("TongTien"));
        pn.setTrangThai(rs.getString("TrangThai"));
        
        // BỔ SUNG: Ánh xạ các thuộc tính còn lại từ bảng phieunhap
        pn.setMaNCC(rs.getInt("MaNCC"));
        pn.setMaNguoiLap(rs.getInt("MaNguoiLap"));
        pn.setGhiChu(rs.getString("GhiChu"));
        
        return pn;
    }
    
    // Hàm lấy danh sách phiếu nhập cho Admin
    public List<PhieuNhap> getAllPhieuNhap() throws Exception {
        List<PhieuNhap> list = new ArrayList<>();
        
        // SỬA SQL: Chọn tất cả các cột cần thiết (bao gồm các cột đã thêm vào map)
        String sql = "SELECT pn.*, ncc.TenNCC FROM phieunhap pn "
                   + "JOIN nhacungcap ncc ON pn.MaNCC = ncc.MaNCC "
                   + "ORDER BY pn.NgayLap DESC"; 
        
        try (Connection con = DB.getCon(); 
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                PhieuNhap pn = mapPhieuNhap(rs);
                pn.setTenNCC(rs.getString("TenNCC")); // Gán Tên NCC
                list.add(pn);
            }
        }
        return list;
    }
    
    // ====================================================================
    // HÀM QUAN TRỌNG: THÊM PHIẾU NHẬP VÀ CẬP NHẬT MÃ PN SAU KHI INSERT (TRANSACTION)
    // ====================================================================
    public String savePhieuNhap(PhieuNhap pn, List<ChiTietPhieuNhap> details) throws Exception {
        Connection con = null;
        int idMoi = -1;
        String maPNMoi = null;
        
        try {
            con = DB.getCon();
            con.setAutoCommit(false); // Bắt đầu Transaction

            // A. INSERT PHIEU NHAP HEADER (Lấy ID tự động tăng)
            String sqlHeader = "INSERT INTO phieunhap (MaNCC, NgayLap, TongTien, TrangThai, MaNguoiLap, GhiChu) VALUES (?, NOW(), ?, 'YeuCau', ?, ?)";
            
            try (PreparedStatement psOrder = con.prepareStatement(sqlHeader, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, pn.getMaNCC()); 
                psOrder.setBigDecimal(2, pn.getTongTien());
                psOrder.setInt(3, pn.getMaNguoiLap());
                psOrder.setString(4, pn.getGhiChu());
                
                if (psOrder.executeUpdate() > 0) {
                    try (ResultSet rs = psOrder.getGeneratedKeys()) {
                        if (rs.next()) {
                            idMoi = rs.getInt(1);
                        }
                    }
                }
            }
            
            // B. TẠO MÃ PN VÀ CẬP NHẬT TRỞ LẠI HÀNG VỪA CHÈN
            if (idMoi == -1) throw new SQLException("Không thể lấy ID Phiếu Nhập mới.");
            
            maPNMoi = "PN" + String.format("%04d", idMoi); // Ví dụ: PN0001
            
            String sqlUpdatePN = "UPDATE phieunhap SET MaPN = ? WHERE ID = ?";
            try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdatePN)) {
                psUpdate.setString(1, maPNMoi);
                psUpdate.setInt(2, idMoi);
                psUpdate.executeUpdate();
            }

            // C. LƯU CHI TIẾT PHIEU NHAP DETAIL
            String sqlDetail = "INSERT INTO chitietphieunhap (MaPN, MaSP, SoLuong, GiaNhap) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psDetail = con.prepareStatement(sqlDetail)) {
                for (ChiTietPhieuNhap item : details) {
                    psDetail.setString(1, maPNMoi); // SỬ DỤNG MA PN VỪA TẠO
                    psDetail.setString(2, item.getMaSP());
                    psDetail.setInt(3, item.getSoLuong());
                    psDetail.setBigDecimal(4, item.getGiaNhap()); 
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }
            
            con.commit(); 
            return maPNMoi;

        } catch (SQLException e) {
            if (con != null) { con.rollback(); } // Rollback nếu có lỗi
            throw new Exception("LỖI CSDL khi lưu Phiếu Nhập: " + e.getMessage());
        } finally {
            if (con != null) { con.setAutoCommit(true); con.close(); }
        }
    }
    
    // ====================================================================
    // BỔ SUNG: Khung hàm Update Tồn kho khi xác nhận nhập hàng (DaNhapKho)
    // ====================================================================
    public boolean updateTonKho(String maSP, int soLuong) throws SQLException, ClassNotFoundException {
        // Tăng SoLuongTon trong bảng sanpham
        String sql = "UPDATE sanpham SET SoLuongTon = SoLuongTon + ? WHERE MaSP = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, soLuong);
            ps.setString(2, maSP);
            return ps.executeUpdate() > 0;
        }
    }
}