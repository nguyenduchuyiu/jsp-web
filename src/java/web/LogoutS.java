package web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout") 
public class LogoutS extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // Lấy phiên làm việc hiện tại
        HttpSession session = req.getSession(false); 
        
        if (session != null) {
            // Vô hiệu hóa phiên làm việc (xóa tất cả session attributes, bao gồm 'account')
            session.invalidate(); 
        }
        
        // Chuyển hướng người dùng về trang chủ (hoặc trang login)
        resp.sendRedirect("home"); 
    }
}