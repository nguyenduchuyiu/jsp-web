package web;

import dao.ConDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/contact_contamngulon")
public class ContactS extends HttpServlet {
    
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String content = req.getParameter("content");
        
        // KIỂM TRA ĐIỀU KIỆN TỐI THIỂU
        if (name.isEmpty() || !email.contains("@") || subject.isEmpty() || content.isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đủ thông tin bắt buộc và đảm bảo email đúng định dạng.");
            req.getRequestDispatcher("/contact.jsp").forward(req, resp);
            return;
        }
        
        try {
            ConDAO dao = new ConDAO();
            dao.save(name, email, subject, content);
            req.setAttribute("success", "Ý kiến của bạn đã được gửi thành công đến quản trị viên.");
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi lưu thông tin liên hệ.");
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/contact.jsp").forward(req, resp);
    }
}