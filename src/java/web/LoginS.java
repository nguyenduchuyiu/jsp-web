package web;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login") 
public class LoginS extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        String user = req.getParameter("user");
        String pass = req.getParameter("pass");
        
        if (user == null || user.isEmpty() || pass == null || pass.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập tên đăng nhập và mật khẩu.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        
        try {
            UserDAO dao = new UserDAO();
            User account = dao.login(user, pass); // Gọi hàm kiểm tra
            
            if (account != null) {
                // Đăng nhập thành công: Lưu thông tin vào Session
                HttpSession session = req.getSession();
                session.setAttribute("account", account);
                
                // Chuyển hướng về trang chủ
                resp.sendRedirect("home"); 
            } else {
                // Đăng nhập thất bại
                req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi hệ thống khi đăng nhập.");
            e.printStackTrace();
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
    
    // Xử lý GET để hiển thị trang login.jsp (Chỉ cần forward)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}