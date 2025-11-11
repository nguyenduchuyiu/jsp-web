package web.admin;

import dao.NhapHangDAO;
import dao.ProdDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/viewphieunhap")
public class ViewPhieuNhapS extends HttpServlet {

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
            NhapHangDAO nhapHangDao = new NhapHangDAO();
            ProdDAO prodDao = new ProdDAO();
            
            // Lấy thông tin phiếu nhập
            req.setAttribute("phieuNhap", nhapHangDao.getPhieuNhapByMaPN(maPN));
            
            // Lấy chi tiết phiếu nhập
            req.setAttribute("chiTietList", nhapHangDao.getChiTietPhieuNhap(maPN));
            
            // Tải danh mục cho header
            req.setAttribute("categoryList", prodDao.getAllCategories());
            
            if (req.getAttribute("phieuNhap") == null) {
                session.setAttribute("error", "Không tìm thấy phiếu nhập " + maPN + ".");
                resp.sendRedirect(req.getContextPath() + "/admin/live");
                return;
            }
            
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi khi tải chi tiết phiếu nhập: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/live");
            return;
        }

        req.getRequestDispatcher("/nhaphang_detail.jsp").forward(req, resp);
    }
}