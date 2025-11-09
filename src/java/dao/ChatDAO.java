package dao;

import model.Conversation;
import model.Message;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {

    // Quy ước: MA_ADMIN = 1 (Nên được định nghĩa là hằng số nếu ID Admin cố định)
    private static final int MA_ADMIN = 1;

    // Hàm hỗ trợ cập nhật trạng thái và cờ AdminRead
    public void updateConversationStatusAndRead(int maTC, String trangThai, boolean adminRead) {
        String sql = "UPDATE trochuyen SET TrangThai = ?, AdminRead = ? WHERE MaTC = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setBoolean(2, adminRead);
            ps.setInt(3, maTC);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm 1: Tìm phiên chat đang mở hoặc tạo mới cho người dùng
    public Conversation findOrCreateConversation(int maND, String tieuDe) throws SQLException, ClassNotFoundException {
        // A. Kiểm tra phiên chat đang Mở/Chờ (Open/Waiting)
        // Nếu user đã có chat cũ (kể cả đã closed) thì mở lại phiên chat gần nhất
        String checkSql = "SELECT MaTC, TieuDe, NgayTao, TrangThai, AdminRead FROM trochuyen WHERE MaND = ? ORDER BY NgayTao DESC LIMIT 1";
        
        // --- BƯỚC A: KIỂM TRA PHIÊN CHAT GẦN NHẤT ---
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(checkSql)) {
            ps.setInt(1, maND);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Đã tồn tại phiên chat gần nhất
                Conversation conv = new Conversation();
                conv.setMaTC(rs.getInt("MaTC"));
                conv.setMaND(maND);
                conv.setTieuDe(rs.getString("TieuDe"));
                conv.setNgayTao(rs.getTimestamp("NgayTao"));
                conv.setTrangThai(rs.getString("TrangThai"));
                conv.setAdminRead(rs.getBoolean("AdminRead")); 
                return conv;
            }
        }

        // --- BƯỚC B: TẠO PHIÊN CHAT MỚI ---
        String insertSql = "INSERT INTO trochuyen (MaND, TieuDe, TrangThai, AdminRead) VALUES (?, ?, 'Waiting', FALSE)";
        int maTC = -1;
        
        try (Connection con = DB.getCon(); 
             // Yêu cầu trả về khóa được tạo và TIMESTAMP (NgayTao)
             PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, maND);
            ps.setString(2, tieuDe);
            ps.executeUpdate();

            // Lấy MaTC và NgayTao (Nếu DB hỗ trợ trả về nhiều khóa)
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    maTC = generatedKeys.getInt(1);
                    
                    // Tạo đối tượng ngay lập tức
                    Conversation conv = new Conversation();
                    conv.setMaTC(maTC);
                    conv.setMaND(maND);
                    conv.setTieuDe(tieuDe);
                    conv.setTrangThai("Waiting");
                    conv.setAdminRead(false); 
                    // Lưu ý: NgayTao có thể chưa chính xác tuyệt đối nếu không SELECT lại
                    // Để đơn giản, ta gán Timestamp hiện tại (chấp nhận sai lệch nhỏ)
                    conv.setNgayTao(new java.sql.Timestamp(System.currentTimeMillis())); 
                    return conv;
                }
            }
        }
        
        throw new SQLException("Không thể tìm hoặc tạo phiên trò chuyện.");
    }

    // Hàm 2: Lưu tin nhắn mới
    public void saveMessage(int maTC, int maNguoiGui, String noiDung) throws SQLException, ClassNotFoundException {
        // Tránh SQL Injection từ nội dung tin nhắn
        String sql = "INSERT INTO tinnhan (MaTC, MaNguoiGui, NoiDung) VALUES (?, ?, ?)";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maTC);
            ps.setInt(2, maNguoiGui);
            ps.setString(3, noiDung);
            ps.executeUpdate();
            
            boolean laAdminGui = (maNguoiGui == MA_ADMIN); 

            if (!laAdminGui) { 
                // Nếu User gửi tin: Đánh dấu AdminRead = FALSE, TrangThai = WAITING (Chờ Admin trả lời)
                updateConversationStatusAndRead(maTC, "Waiting", false); 
            } else {
                // Nếu Admin gửi tin: Đánh dấu AdminRead = TRUE (Admin đã đọc tin Admin vừa gửi), TrangThai = OPEN
                updateConversationStatusAndRead(maTC, "Open", true); 
            }
        }
    }

    // Hàm 3: Lấy lịch sử tin nhắn của một phiên chat
    public List<Message> getHistory(int maTC) {
        List<Message> history = new ArrayList<>();
        // Sử dụng * (select all) nếu bạn cần tất cả các trường, hoặc liệt kê cụ thể
        String sql = "SELECT MaTN, MaTC, NoiDung, MaNguoiGui, ThoiGianGui FROM tinnhan WHERE MaTC = ? ORDER BY ThoiGianGui ASC";
        
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maTC);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setMaTN(rs.getInt("MaTN"));
                msg.setMaTC(rs.getInt("MaTC"));
                msg.setNoiDung(rs.getString("NoiDung"));
                msg.setMaNguoiGui(rs.getInt("MaNguoiGui"));
                msg.setThoiGianGui(rs.getTimestamp("ThoiGianGui"));
                history.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return history;
    }

    // Hàm 4: Lấy danh sách các phiên trò chuyện (dành cho Admin)
    public List<Conversation> getAllConversations() {
        List<Conversation> list = new ArrayList<>();
        // Đã sửa: Dùng PreparedStatement cho hiệu suất và bảo mật (mặc dù không có tham số)
        // và dùng MA_ADMIN để loại trừ (nếu cần)
        String sql = "SELECT t.MaTC, t.TieuDe, t.NgayTao, t.TrangThai, u.HoTen, t.AdminRead "
                   + "FROM trochuyen t JOIN nguoidung u ON t.MaND = u.MaND "
                   + "WHERE t.MaND != ? " 
                   + "ORDER BY t.AdminRead ASC, CASE t.TrangThai WHEN 'Waiting' THEN 1 ELSE 2 END, t.NgayTao DESC";
                   
        try (Connection con = DB.getCon();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, MA_ADMIN); // Loại trừ Admin
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Conversation conv = new Conversation();
                conv.setMaTC(rs.getInt("MaTC"));
                conv.setTieuDe(rs.getString("TieuDe"));
                conv.setNgayTao(rs.getTimestamp("NgayTao"));
                conv.setTrangThai(rs.getString("TrangThai"));
                conv.setTenNguoiDung(rs.getString("HoTen"));
                conv.setAdminRead(rs.getBoolean("AdminRead")); 
                list.add(conv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm 5: Cập nhật trạng thái (Open, Waiting, Closed) - Chủ yếu dùng cho Admin thủ công
    public void updateConversationStatus(int maTC, String trangThai) {
        // Tái sử dụng hàm helper nhưng không thay đổi cờ AdminRead (mặc định giữ nguyên)
        String sql = "UPDATE trochuyen SET TrangThai = ? WHERE MaTC = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trangThai);
            ps.setInt(2, maTC);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}