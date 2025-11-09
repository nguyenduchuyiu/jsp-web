package web;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/account") 
public class AccountS extends HttpServlet {
    
    // Hàm này kiểm tra rỗng/null, cần thiết cho logic POST
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
    
    // Xử lý GET: Hiển thị trang cập nhật tài khoản
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        // Bảo vệ route: Nếu chưa đăng nhập, chuyển hướng đến login
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login");
            return;
        }
        
        // Truyền đối tượng User hiện tại (đã có trong session) tới JSP
        req.getRequestDispatcher("/account.jsp").forward(req, resp);
    }
    
    // Xử lý POST: Cập nhật thông tin và mật khẩu
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login");
            return;
        }
        
        // Lấy User hiện tại (cần MaND để cập nhật)
        User currentUser = (User) session.getAttribute("account");
        
        // Lấy dữ liệu từ Form (Giả sử form có các trường này)
        String newName = req.getParameter("name");
        String newEmail = req.getParameter("email");
        String newPhone = req.getParameter("phone");
        String newAddress = req.getParameter("address");
        String newPass = req.getParameter("newPass"); // Mật khẩu mới
        String rePass = req.getParameter("rePass");   // Nhập lại mật khẩu mới
        
        try {
            UserDAO dao = new UserDAO();
            String message = "";
            boolean success = true;
            
            // 1. Cập nhật thông tin cá nhân
            if (!isBlank(newName) && !isBlank(newEmail)) {
                dao.updateUserInfo(currentUser.getMaND(), newName, newEmail, newPhone, newAddress);
                
                // Cập nhật lại session object
                currentUser.setName(newName);
                currentUser.setEmail(newEmail);
                currentUser.setPhone(newPhone);
                currentUser.setAddress(newAddress);
                session.setAttribute("account", currentUser);
                
                message = "Cập nhật thông tin thành công!";
            }
            
            // 2. Cập nhật mật khẩu (Nếu người dùng nhập mật khẩu mới)
            if (!isBlank(newPass)) {
                if (!newPass.equals(rePass)) {
                    message = "Lỗi: Mật khẩu nhập lại không khớp.";
                    success = false;
                } else if (newPass.length() < 6) {
                    message = "Lỗi: Mật khẩu mới phải từ 6 ký tự trở lên.";
                    success = false;
                } else {
                    dao.updatePassword(currentUser.getMaND(), newPass);
                    message += " Cập nhật mật khẩu thành công!";
                }
            }
            
            if (success) {
                req.setAttribute("success", message);
            } else {
                req.setAttribute("error", message);
            }
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL: Không thể cập nhật dữ liệu.");
            e.printStackTrace();
        }
        
        // Forward lại trang form để hiển thị thông báo
        req.getRequestDispatcher("/account.jsp").forward(req, resp);
    }
}