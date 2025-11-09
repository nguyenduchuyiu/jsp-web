package web.admin;

import dao.KhuyenMaiDAO;
import model.KhuyenMai;
import model.User;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/addkhuyenmai")
public class AddKhuyenMaiS extends HttpServlet {
    
    // Xử lý GET để hiển thị Form
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // Kiểm tra quyền Admin
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        // Dùng getRequestDispatcher trỏ đến file JSP TẠI THƯ MỤC GỐC
        req.getRequestDispatcher("/addkhuyenmai.jsp").forward(req, resp);
    }
    
    // Xử lý POST để thêm dữ liệu
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        String redirectUrl = req.getContextPath() + "/admin/addkhuyenmai"; // URL chuyển hướng lỗi
        
        // Kiểm tra quyền Admin
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        String tenKM = req.getParameter("tenKM");
        String moTa = req.getParameter("moTa");
        String ngayBDStr = req.getParameter("ngayBatDau");
        String ngayKTStr = req.getParameter("ngayKetThuc");
        
        // Kiểm tra dữ liệu bắt buộc
        if (tenKM == null || tenKM.isEmpty() || ngayBDStr == null || ngayKTStr == null) {
            session.setAttribute("error_admin", "Vui lòng điền đầy đủ Tên, Ngày Bắt Đầu và Ngày Kết Thúc.");
            resp.sendRedirect(redirectUrl); 
            return;
        }
        
        try {
            KhuyenMai km = new KhuyenMai();
            km.setTenKM(tenKM);
            km.setMoTa(moTa);
            km.setNgayBatDau(Date.valueOf(ngayBDStr));
            km.setNgayKetThuc(Date.valueOf(ngayKTStr));
            
            KhuyenMaiDAO dao = new KhuyenMaiDAO();
            dao.addKhuyenMai(km);
            
            session.setAttribute("success_admin", "Thêm chương trình khuyến mãi thành công!");
            // Chuyển hướng thành công về trang danh sách khuyến mãi
            resp.sendRedirect(req.getContextPath() + "/khuyenmai");
            
        } catch (IllegalArgumentException e) {
            session.setAttribute("error_admin", "Lỗi định dạng ngày tháng. Vui lòng kiểm tra lại.");
            resp.sendRedirect(redirectUrl);
        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL khi thêm khuyến mãi.");
            e.printStackTrace();
            resp.sendRedirect(redirectUrl);
        }
    }
}