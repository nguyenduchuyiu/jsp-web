package web;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class Reg extends HttpServlet {
    
    // Hàm isBlank được đặt TẠI ĐÂY (ngay sau định nghĩa class)
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        
        // Khai báo và khởi tạo url ngay tại đây để nó có phạm vi toàn hàm doPost
        String url = "/register.jsp"; // <-- Đã được khởi tạo
        
        User u = new User();
        // Lấy dữ liệu từ form
        u.setName(req.getParameter("name"));
        u.setUser(req.getParameter("user"));
        u.setEmail(req.getParameter("email"));
        u.setPhone(req.getParameter("phone"));
        u.setAddress(req.getParameter("address"));
        String pass = req.getParameter("pass");
        String rePass = req.getParameter("rePass");
        
        // 1. Kiểm tra Mật khẩu có khớp không
        if (!pass.equals(rePass)) {
            req.setAttribute("error", "Mật khẩu nhập lại không khớp.");
        
        // 2. Kiểm tra điều kiện Bắt buộc (sử dụng hàm isBlank an toàn)
        } else if (isBlank(u.getName()) || 
                   isBlank(u.getEmail()) || 
                   isBlank(u.getUser()) || 
                   u.getUser().length() < 5 || 
                   pass.length() < 6) 
        {
            req.setAttribute("error", "Vui lòng điền đủ thông tin. Tên ĐN >=5 ký tự, Mật khẩu >=6 ký tự.");
        
        // 3. Thực hiện Đăng ký
        } else {
            try {
                UserDAO dao = new UserDAO();
                if (dao.checkExists(u.getUser(), u.getEmail())) {
                    req.setAttribute("error", "Tên đăng nhập hoặc Email đã tồn tại trong hệ thống.");
                } else {
                    dao.register(u, pass);
                    req.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    url = "/login.jsp"; // Thay đổi giá trị url
                }
            } catch (Exception e) {
                // Khối catch không cần phải khai báo lại url, vì nó đã có sẵn
                req.setAttribute("error", "Lỗi CSDL khi đăng ký: " + e.getMessage());
                e.printStackTrace();
                // Giữ nguyên url = "/register.jsp" (Giá trị ban đầu)
            }
        }
        
        // Chuyển hướng
        req.getRequestDispatcher(url).forward(req, resp);
    }
}