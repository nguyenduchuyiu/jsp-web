package web;

import dao.KhuyenMaiDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/khuyenmai")
public class KhuyenMaiS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        try {
            KhuyenMaiDAO dao = new KhuyenMaiDAO();
            
            // Lấy danh sách khuyến mãi
            req.setAttribute("khuyenMaiList", dao.getAllKhuyenMai());
            
            // Xác định vai trò để hiển thị giao diện phù hợp
            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User)session.getAttribute("account") : null;
            
            // LOGIC KIỂM TRA QUYỀN ADMIN (ĐÃ SỬA LỖI NullPointerException)
            boolean isAdmin = false;
            
            if (user != null) {
                String userRole = user.getLoaiNguoiDung();
                // Chỉ kiểm tra và trim nếu userRole KHÔNG phải là null
                if (userRole != null && "QuanTriVien".equalsIgnoreCase(userRole.trim())) {
                    isAdmin = true;
                }
            }
            
            // Thiết lập thuộc tính isAdmin
            req.setAttribute("isAdmin", isAdmin);

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải danh sách khuyến mãi.");
            e.printStackTrace();
        }

        req.getRequestDispatcher("/khuyenmai.jsp").forward(req, resp);
    }
}