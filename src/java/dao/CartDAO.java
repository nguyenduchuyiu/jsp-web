package dao;

import model.CartItem; // Bạn sẽ cần tạo Model này (Bước 1.1)
import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
public class CartDAO {
    
    // 1. Tìm hoặc tạo MaGH dựa trên MaND
    public int findOrCreateCart(int maND) throws SQLException, ClassNotFoundException {
        // 1a. Kiểm tra Giỏ hàng đã tồn tại chưa
        String checkSql = "SELECT MaGH FROM giohang WHERE MaND = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, maND);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("MaGH"); // Đã tồn tại, trả về MaGH
            }
        }

        // 1b. Chưa tồn tại: Tạo Giỏ hàng mới (Tạo tự động MaGH)
        String insertSql = "INSERT INTO giohang (MaND) VALUES (?)";
        try (Connection con = DB.getCon(); 
             // Trả về khóa được tạo tự động (MaGH)
             PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, maND);
            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Trả về MaGH mới
                    }
                }
            }
        }
        throw new SQLException("Không thể tạo Giỏ hàng mới.");
    }
    
  

// 2. Thêm hoặc cập nhật sản phẩm vào chi tiết giỏ hàng
public int addItem(int maGH, String maSP, int soLuong) throws SQLException, ClassNotFoundException {
    
    // 2a. Kiểm tra sản phẩm đã có trong chi tiết giỏ hàng chưa
    String checkItemSql = "SELECT MaCTGH, SoLuong FROM chitietgiohang WHERE MaGH = ? AND MaSP = ?";
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(checkItemSql)) {
        ps.setInt(1, maGH);
        ps.setString(2, maSP);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // Đã có: Cập nhật số lượng
            int currentMaCtgh = rs.getInt("MaCTGH"); // Lấy MaCTGH cũ
            int currentSoLuong = rs.getInt("SoLuong");
            int newSoLuong = currentSoLuong + soLuong;
            
            String updateSql = "UPDATE chitietgiohang SET SoLuong = ? WHERE MaGH = ? AND MaSP = ?";
            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                updatePs.setInt(1, newSoLuong);
                updatePs.setInt(2, maGH);
                updatePs.setString(3, maSP);
                updatePs.executeUpdate();
            }
            return currentMaCtgh; // TRẢ VỀ MACTGH CŨ
            
        } else {
            // Chưa có: Thêm mới (Và lấy MaCTGH mới)
            String insertItemSql = "INSERT INTO chitietgiohang (MaGH, MaSP, SoLuong) VALUES (?, ?, ?)";
            try (Connection conInsert = DB.getCon(); // Cần kết nối mới nếu kết nối cũ đã bị đóng
                 PreparedStatement insertPs = conInsert.prepareStatement(insertItemSql, Statement.RETURN_GENERATED_KEYS)) {
                
                insertPs.setInt(1, maGH);
                insertPs.setString(2, maSP);
                insertPs.setInt(3, soLuong);
                int affectedRows = insertPs.executeUpdate();

                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = insertPs.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            return generatedKeys.getInt(1); // TRẢ VỀ MACTGH MỚI
                        }
                    }
                }
            }
        }
    }
    // Trả về -1 hoặc ném exception nếu có lỗi nghiêm trọng
    return -1; 
}
    
    // 3. Lấy chi tiết Giỏ hàng theo Mã Người Dùng
    public List<CartItem> getCartItemsByUser(int maND) {
        List<CartItem> items = new ArrayList<>();
        
        String sql = "SELECT ch.MaCTGH, ch.MaSP, ch.SoLuong, " +
                     "p.TenSP, p.Gia, p.DonVi, p.HinhAnh " +
                     "FROM giohang gh " +
                     "JOIN chitietgiohang ch ON gh.MaGH = ch.MaGH " +
                     "JOIN sanpham p ON ch.MaSP = p.MaSP " +
                     "WHERE gh.MaND = ?";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maND);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setMaCTGH(rs.getInt("MaCTGH"));
                item.setMaSP(rs.getString("MaSP"));
                item.setSoLuong(rs.getInt("SoLuong"));
                
                // Thông tin sản phẩm
                item.setTenSP(rs.getString("TenSP"));
                item.setGia(rs.getBigDecimal("Gia"));
                item.setDonVi(rs.getString("DonVi"));
                item.setHinhAnh(rs.getString("HinhAnh"));
                
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }
    
    // 4. Xóa toàn bộ chi tiết giỏ hàng (Không xóa bảng giohang, chỉ xóa chi tiết)
public void clearCart(int maND) throws SQLException, ClassNotFoundException {
    // 1. Tìm MaGH của người dùng
    String getMaGHSql = "SELECT MaGH FROM giohang WHERE MaND = ?";
    int maGH = -1;
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(getMaGHSql)) {
        ps.setInt(1, maND);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            maGH = rs.getInt("MaGH");
        }
    }

    if (maGH != -1) {
        // 2. Xóa các mục trong chitietgiohang bằng MaGH
        String deleteSql = "DELETE FROM chitietgiohang WHERE MaGH = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(deleteSql)) {
            ps.setInt(1, maGH);
            ps.executeUpdate();
        }
    }
}

// 5. Xóa một sản phẩm cụ thể khỏi giỏ hàng
public boolean removeItem(int maCTGH) throws SQLException, ClassNotFoundException {
    String sql = "DELETE FROM chitietgiohang WHERE MaCTGH = ?";
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maCTGH);
        return ps.executeUpdate() > 0;
    }
}

// 6. Lấy chi tiết Giỏ hàng theo danh sách MaCTGH được chọn
public List<model.CartItem> getSelectedCartItems(List<String> maCtghList) {
    List<model.CartItem> items = new ArrayList<>();
    if (maCtghList == null || maCtghList.isEmpty()) {
        return items;
    }

    // Tạo chuỗi placeholders (?, ?, ?)
    String placeholders = String.join(",", Collections.nCopies(maCtghList.size(), "?"));
    
    String sql = "SELECT ch.MaCTGH, ch.MaSP, ch.SoLuong, " +
                 "p.TenSP, p.Gia, p.DonVi, p.HinhAnh " +
                 "FROM chitietgiohang ch " +
                 "JOIN sanpham p ON ch.MaSP = p.MaSP " +
                 "WHERE ch.MaCTGH IN (" + placeholders + ")";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        
        // Gán các MaCTGH vào PreparedStatement
        for (int i = 0; i < maCtghList.size(); i++) {
            // Giả sử MaCTGH là số nguyên
            ps.setInt(i + 1, Integer.parseInt(maCtghList.get(i)));
        }
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            // Tái sử dụng logic ánh xạ từ CartS.java (giả định bạn có CartItem model)
            model.CartItem item = new model.CartItem();
            item.setMaCTGH(rs.getInt("MaCTGH"));
            item.setMaSP(rs.getString("MaSP"));
            item.setSoLuong(rs.getInt("SoLuong"));
            item.setTenSP(rs.getString("TenSP"));
            item.setGia(rs.getBigDecimal("Gia"));
            item.setDonVi(rs.getString("DonVi"));
            item.setHinhAnh(rs.getString("HinhAnh"));
            
            items.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return items;
}
/**
 * 7. Ghi đè số lượng sản phẩm trong chi tiết giỏ hàng (Dùng cho BuyNow).
 * Nếu sản phẩm chưa có, nó sẽ được thêm mới.
 */
public int setItemQuantity(int maGH, String maSP, int newSoLuong) throws SQLException, ClassNotFoundException {
    
    // 7a. Kiểm tra sản phẩm đã có trong chi tiết giỏ hàng chưa
    String checkItemSql = "SELECT MaCTGH FROM chitietgiohang WHERE MaGH = ? AND MaSP = ?";
    int currentMaCtgh = -1;
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(checkItemSql)) {
        ps.setInt(1, maGH);
        ps.setString(2, maSP);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // Đã có: Cập nhật số lượng (GHI ĐÈ)
            currentMaCtgh = rs.getInt("MaCTGH");
            
            String updateSql = "UPDATE chitietgiohang SET SoLuong = ? WHERE MaCTGH = ?";
            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                updatePs.setInt(1, newSoLuong); // Dùng newSoLuong thay vì cộng dồn
                updatePs.setInt(2, currentMaCtgh);
                updatePs.executeUpdate();
            }
            return currentMaCtgh; // TRẢ VỀ MACTGH CŨ
            
        } else {
            // Chưa có: Thêm mới (Và lấy MaCTGH mới)
            String insertItemSql = "INSERT INTO chitietgiohang (MaGH, MaSP, SoLuong) VALUES (?, ?, ?)";
            try (Connection conInsert = DB.getCon(); 
                 PreparedStatement insertPs = conInsert.prepareStatement(insertItemSql, Statement.RETURN_GENERATED_KEYS)) {
                
                insertPs.setInt(1, maGH);
                insertPs.setString(2, maSP);
                insertPs.setInt(3, newSoLuong); // Dùng newSoLuong
                int affectedRows = insertPs.executeUpdate();

                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = insertPs.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            return generatedKeys.getInt(1); // TRẢ VỀ MACTGH MỚI
                        }
                    }
                }
            }
        }
    }
    return -1; 
}

}

