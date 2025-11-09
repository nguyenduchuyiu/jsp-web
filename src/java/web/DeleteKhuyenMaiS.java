package web.admin;

import dao.KhuyenMaiDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/deletekhuyenmai")
public class DeleteKhuyenMaiS extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // 1. KIỂM TRA QUYỀN ADMIN (Bảo vệ route)
        // Dùng equalsIgnoreCase để đảm bảo kiểm tra vai trò chính xác
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String maKMStr = req.getParameter("maKM");
        if (maKMStr != null && !maKMStr.isEmpty()) {
            try {
                int maKM = Integer.parseInt(maKMStr);
                KhuyenMaiDAO dao = new KhuyenMaiDAO();
                
                if (dao.deleteKhuyenMai(maKM)) {
                    // Lưu thông báo thành công vào session để hiển thị trên khuyenmai.jsp
                    session.setAttribute("success_admin", "Đã xóa chương trình khuyến mãi thành công.");
                } else {
                    session.setAttribute("error_admin", "Lỗi: Không tìm thấy hoặc không thể xóa khuyến mãi.");
                }
            } catch (NumberFormatException e) {
                 session.setAttribute("error_admin", "Lỗi: Mã khuyến mãi không hợp lệ.");
            } catch (Exception e) {
                session.setAttribute("error_admin", "Lỗi CSDL khi xóa khuyến mãi.");
                e.printStackTrace();
            }
        }
        
        // 2. Chuyển hướng về trang danh sách khuyến mãi
        resp.sendRedirect(req.getContextPath() + "/khuyenmai");
    }
}