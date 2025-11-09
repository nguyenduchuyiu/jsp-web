package web;

import dao.ChatDAO;
import model.Conversation;
import model.User; // Giả định lớp User có tồn tại
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/contact") 
public class ChatUserS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login");
            return;
        }
        
        // FIX: Xử lý tên người dùng an toàn (dùng HoTen)
        String userName = (user.getName() != null && !user.getName().trim().isEmpty()) ? user.getName() : user.getUser();
        // Nếu tên vẫn null/rỗng sau khi kiểm tra, dùng tên mặc định
        if (userName == null || userName.isEmpty()) {
            userName = "Khách hàng";
        }


        try {
            ChatDAO dao = new ChatDAO();
            
            // 1. Tìm hoặc tạo phiên chat
            Conversation conv = dao.findOrCreateConversation(user.getMaND(), "Hỗ trợ từ " + userName);
            
            // 2. Lấy lịch sử tin nhắn
            req.setAttribute("conversation", conv);
            req.setAttribute("history", dao.getHistory(conv.getMaTC()));

        } catch (Exception e) {
            // Lỗi CSDL hoặc lỗi khi findOrCreateConversation
            req.setAttribute("error", "Lỗi CSDL khi tải trò chuyện. Vui lòng thử lại sau.");
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/chat.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login");
            return;
        }
        
        // Lấy dữ liệu
        String noiDung = req.getParameter("noiDung");
        String maTCStr = req.getParameter("maTC"); 

        // Kiểm tra an toàn cho các tham số
        if (noiDung == null || noiDung.trim().isEmpty() || maTCStr == null || maTCStr.trim().isEmpty() || maTCStr.equals("0")) {
            session.setAttribute("error", "Nội dung tin nhắn không được để trống hoặc thiếu mã trò chuyện.");
            resp.sendRedirect("contact");  
            return;
        }

        try {
            int maTC = Integer.parseInt(maTCStr);
            ChatDAO dao = new ChatDAO();
            
            // 1. Lưu tin nhắn của User
            dao.saveMessage(maTC, user.getMaND(), noiDung.trim());
            
            // 2. Chuyển hướng lại trang chat (để gọi lại doGet và tải lại lịch sử)
            resp.sendRedirect("contact"); 
            
        } catch (NumberFormatException ex) {
            session.setAttribute("error", "Lỗi mã trò chuyện không hợp lệ.");
            ex.printStackTrace();
            resp.sendRedirect("contact"); 
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi CSDL khi gửi tin nhắn.");
            e.printStackTrace();
            resp.sendRedirect("contact"); 
        }
    }
}