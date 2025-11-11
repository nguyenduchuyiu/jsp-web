package web.admin;

import dao.NhapHangDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/deletephieunhap")
public class DeletePhieuNhapS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        // Kiểm tra quyền Admin
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String maPN = req.getParameter("maPN");
        if (maPN == null || maPN.isEmpty()) {
            session.setAttribute("error", "Mã phiếu nhập không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/live");
            return;
        }

        try {
            NhapHangDAO dao = new NhapHangDAO();
            if (dao.deletePhieuNhap(maPN)) {
                session.setAttribute("success_admin", "Đã xóa phiếu nhập " + maPN + " thành công.");
            } else {
                session.setAttribute("error", "Không thể xóa phiếu nhập " + maPN + ".");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi khi xóa phiếu nhập: " + e.getMessage());
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin/live");
    }
}