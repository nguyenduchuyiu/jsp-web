package web.amin;

import dao.ChatDAO;
import model.User;
import dao.ProdDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/chat") // Thay thế cho QL Liên hệ
public class ChatAdminS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;
        
        // KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            ChatDAO dao = new ChatDAO();
            
            // 1. Lấy danh sách tất cả các cuộc trò chuyện (Cột trái)
            req.setAttribute("conversationList", dao.getAllConversations());
            
            // 2. Lấy chi tiết cuộc trò chuyện được chọn (Cột phải)
            String maTCStr = req.getParameter("maTC");
            if (maTCStr != null && !maTCStr.isEmpty()) {
                int maTC = Integer.parseInt(maTCStr);
                req.setAttribute("selectedMaTC", maTC);
                req.setAttribute("history", dao.getHistory(maTC));
                
                // Cập nhật trạng thái thành 'Open' khi Admin xem
                dao.updateConversationStatus(maTC, "Open");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách trò chuyện.");
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/admin_chat.jsp").forward(req, resp);
    }
    
    @Override

protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    
    req.setCharacterEncoding("UTF-8");
    HttpSession session = req.getSession(false);
    User user = (session != null) ? (User) session.getAttribute("account") : null;
    
    if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) {
        resp.sendRedirect(req.getContextPath() + "/home");
        return;
    }

    String noiDung = req.getParameter("noiDung");
    String maTCStr = req.getParameter("maTC");

    if (noiDung == null || noiDung.trim().isEmpty() || maTCStr == null) {
        session.setAttribute("error_admin", "Nội dung phản hồi không được để trống.");
        // Chuyển hướng về trang chat hiện tại
        resp.sendRedirect("chat?maTC=" + maTCStr); 
        return;
    }

    try {
        // KHAI BÁO BIẾN MỘT LẦN DUY NHẤT Ở ĐÂY
        int maTC = Integer.parseInt(maTCStr); 
        ChatDAO dao = new ChatDAO();
        
        // 1. Lưu tin nhắn của Admin (Giả sử MaND của Admin được lấy từ session)
        dao.saveMessage(maTC, user.getMaND(), noiDung.trim());
        
        // **LƯU Ý:** Hàm saveMessage() đã tự động gọi updateConversationStatusAndRead(true) 
        // khi Admin (MaNguoiGui != 1) gửi tin, nên bạn không cần gọi lại hàm này ở đây.
        
        // 2. Chuyển hướng lại trang chi tiết chat
        resp.sendRedirect("chat?maTC=" + maTC); 
        
    } catch (NumberFormatException e) {
        session.setAttribute("error_admin", "Mã trò chuyện không hợp lệ.");
        resp.sendRedirect("chat");
    } catch (Exception e) {
        session.setAttribute("error_admin", "Lỗi khi gửi phản hồi.");
        e.printStackTrace();
        resp.sendRedirect("chat"); 
    }
    }
}