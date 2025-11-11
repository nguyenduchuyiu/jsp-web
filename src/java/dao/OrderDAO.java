package dao;

import model.CartItem;
import model.User;
import model.Order;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;
import java.sql.Timestamp;

// NHUNGKM
import java.sql.Types;

// ENDKM
public class OrderDAO {

 public int saveOrder(User user, List<CartItem> orderItems, BigDecimal totalFinal,
                     String receiverName, String receiverPhone,
                     String shippingAddress, String paymentMethod, String notes,
                     int maKM, BigDecimal giamGia) throws Exception {

    Connection con = null;
    int maDH = -1;
    
    // ĐIỀU CHỈNH LOGIC TRẠNG THÁI Ở ĐÂY:
    // Nếu paymentMethod là "COD" (Cash On Delivery), đặt trạng thái là "DangGiao".
    // Ngược lại (ví dụ: ChuyenKhoan), đặt trạng thái là "ChoThanhToan".
    String trangThai = "COD".equalsIgnoreCase(paymentMethod) ? "DangGiao" : "ChoThanhToan";

    try {
        con = DB.getCon();
        con.setAutoCommit(false);

        // A. LƯU ĐƠN HÀNG CHÍNH (HEADER) - BẢNG `chitietdonhang`
        // Tổng cộng 11 cột cần điền (MaND, TenNguoiNhan, SDTNguoiNhan, NgayDatHang, TongTien, DiaChiGiaoHang, PhuongThucThanhToan, GhiChu, TrangThai, MaKM, GiamGia)
        String insertOrderSql = "INSERT INTO chitietdonhang (MaND, TenNguoiNhan, SDTNguoiNhan, NgayDatHang, TongTien, DiaChiGiaoHang, PhuongThucThanhToan, GhiChu, TrangThai, MaKM, GiamGia) VALUES (?, ?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement psOrder = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
            int paramIndex = 1;

            // Tham số 1-3: Thông tin cơ bản
            psOrder.setInt(paramIndex++, user.getMaND());
            psOrder.setString(paramIndex++, receiverName);
            psOrder.setString(paramIndex++, receiverPhone);

            // Tham số 4-7: Tổng tiền, Địa chỉ, PTTT, Ghi chú
            psOrder.setBigDecimal(paramIndex++, totalFinal);
            psOrder.setString(paramIndex++, shippingAddress);
            psOrder.setString(paramIndex++, paymentMethod);
            psOrder.setString(paramIndex++, notes);

            // Tham số 8: TrangThai (ĐÃ TÍNH TOÁN DỰA TRÊN PTTT)
            psOrder.setString(paramIndex++, trangThai); // <-- Dùng biến đã tính toán

            // Tham số 9: MaKM
            if (maKM > 0) {
                psOrder.setInt(paramIndex++, maKM);
            } else {
                psOrder.setNull(paramIndex++, Types.INTEGER);
            }
            // Tham số 10: GiamGia
            psOrder.setBigDecimal(paramIndex++, giamGia);

            psOrder.executeUpdate();

            try (ResultSet rs = psOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    maDH = rs.getInt(1);
                }
            }
        }

        // B. LƯU CHI TIẾT SẢN PHẨM (ITEMS) - BẢNG `donhang`
        String insertDetailSql = "INSERT INTO donhang (MaDH, MaSP, SoLuong, GiaBan) VALUES (?, ?, ?, ?)";
        try (PreparedStatement psDetail = con.prepareStatement(insertDetailSql)) {
            for (CartItem item : orderItems) {
                psDetail.setInt(1, maDH);
                psDetail.setString(2, item.getMaSP());
                psDetail.setInt(3, item.getSoLuong());
                psDetail.setBigDecimal(4, item.getGia());
                psDetail.addBatch();
            }
            psDetail.executeBatch();
        }

        // C. XÓA CÁC MỤC ĐÃ ĐẶT KHỎI GIỎ HÀNG (từ chitietgiohang)
        CartDAO cartDAO = new CartDAO();
        for (CartItem item : orderItems) {
            cartDAO.removeItem(item.getMaCTGH());
        }

        con.commit();
        return maDH;

    } catch (SQLException e) {
        if (con != null) { con.rollback(); }
        // Ném lỗi SQL để hiển thị nguyên nhân chi tiết
        throw new Exception("LỖI SQL: " + e.getMessage() + ". Đã thực hiện ROLLBACK.");
    } finally {
        if (con != null) { con.setAutoCommit(true); con.close(); }
    }
    }

//=======ENDKM======

    // Hàm 3: Lấy danh sách Đơn hàng theo MaND
    public List<model.Order> getOrdersByUserId(int maND) {
    List<model.Order> orders = new ArrayList<>();
    // Truy vấn tất cả các cột cần thiết cho Order Header
    String sql = "SELECT MaDH, NgayDatHang, TongTien, TrangThai, PhuongThucThanhToan, DiaChiGiaoHang, TenNguoiNhan, SDTNguoiNhan " +
                 "FROM chitietdonhang WHERE MaND = ? ORDER BY NgayDatHang DESC";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maND);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            model.Order order = new model.Order();
            
            order.setMaDH(rs.getInt("MaDH"));
            
            // FIX LỖI: Lấy và gán trực tiếp Timestamp vào Model
            java.sql.Timestamp ts = rs.getTimestamp("NgayDatHang"); 
            if (ts != null) {
                order.setNgayDat(ts); // GÁN TIMESTAMP TRỰC TIẾP
            }
            
            order.setTongTien(rs.getBigDecimal("TongTien"));
            order.setTrangThai(rs.getString("TrangThai"));
            order.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
            
            order.setDiaChiGiaoHang(rs.getString("DiaChiGiaoHang"));
            order.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
            order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
            
            orders.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return orders;
}

    // Hàm 4: Lấy Chi tiết các sản phẩm trong một Đơn hàng cụ thể (MaDH)
    public List<model.CartItem> getOrderDetails(int maDH) {
        List<model.CartItem> details = new ArrayList<>();
        // Dùng tên bảng đã bị đảo ngược: 'donhang' là bảng Order Detail
        String sql = "SELECT d.MaSP, d.SoLuong, d.GiaBan, p.TenSP, p.HinhAnh " +
                     "FROM donhang d " +
                     "JOIN sanpham p ON d.MaSP = p.MaSP " +
                     "WHERE d.MaDH = ?";
                     
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maDH);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                model.CartItem item = new model.CartItem();
                item.setMaSP(rs.getString("MaSP"));
                item.setTenSP(rs.getString("TenSP"));
                item.setSoLuong(rs.getInt("SoLuong"));
                item.setGia(rs.getBigDecimal("GiaBan")); 
                item.setHinhAnh(rs.getString("HinhAnh"));
                details.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }
    
    // Hàm 5: Cập nhật trạng thái đơn hàng (Dùng cho Admin và Khách hàng)
    public boolean updateOrderStatus(int maDH, String trangThaiMoi) throws SQLException, ClassNotFoundException {
        // Tên bảng bị đảo ngược: 'chitietdonhang' là bảng Order Header
        String sql = "UPDATE chitietdonhang SET TrangThai = ? WHERE MaDH = ?";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trangThaiMoi);
            ps.setInt(2, maDH);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<model.Order> getAllOrders() {
    List<model.Order> orders = new ArrayList<>();
    
    // SỬA: Truy vấn tường minh tất cả các cột cần cho bảng Admin
    String sql = "SELECT MaDH, MaND, TenNguoiNhan, SDTNguoiNhan, NgayDatHang, TongTien, TrangThai, PhuongThucThanhToan " +
                 "FROM chitietdonhang ORDER BY NgayDatHang DESC";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            model.Order order = new model.Order();
            
            // Ánh xạ dữ liệu
            order.setMaDH(rs.getInt("MaDH"));
            order.setMaND(rs.getInt("MaND"));
            order.setTenNguoiNhan(rs.getString("TenNguoiNhan"));
            order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan"));
            
            // Lấy NgayDatHang an toàn
            order.setNgayDat(rs.getTimestamp("NgayDatHang")); // Sử dụng getTimestamp()
            
            order.setTongTien(rs.getBigDecimal("TongTien"));
            order.setTrangThai(rs.getString("TrangThai"));
            order.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
            
            orders.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return orders;
} 
    public Order getOrderById(int maDH) {
    Order order = null;
    String sql = "SELECT * FROM chitietdonhang WHERE MaDH = ?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maDH);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            order = new Order();
            order.setMaDH(rs.getInt("MaDH"));
            order.setMaND(rs.getInt("MaND"));
            java.sql.Timestamp ts = rs.getTimestamp("NgayDatHang"); 
            if (ts != null) {
                order.setNgayDat(ts); // LỖI ĐƯỢC SỬA: Gán trực tiếp Timestamp vào setter yêu cầu Timestamp
            }
            order.setTongTien(rs.getBigDecimal("TongTien"));
            order.setTrangThai(rs.getString("TrangThai"));
            order.setPhuongThucThanhToan(rs.getString("PhuongThucThanhToan"));
            order.setTenNguoiNhan(rs.getString("TenNguoiNhan")); 
            order.setSdtNguoiNhan(rs.getString("SDTNguoiNhan")); 
            order.setDiaChiGiaoHang(rs.getString("DiaChiGiaoHang"));
            order.setGhiChu(rs.getString("GhiChu"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return order;
}
}