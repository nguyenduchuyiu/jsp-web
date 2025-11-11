package web.admin;

import dao.KhuyenMaiDAO;
import model.KhuyenMai;
import model.User;
import java.io.IOException;
import java.sql.Date;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/addkhuyenmai")
public class AddKhuyenMaiS extends HttpServlet {
    
    // Xử lý GET để hiển thị Form (Giữ nguyên logic kiểm tra Admin và tải form)
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
        
        req.getRequestDispatcher("/addkhuyenmai.jsp").forward(req, resp);
    }
    


    // Xử lý POST để thêm dữ liệu
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        String redirectUrl = req.getContextPath() + "/admin/addkhuyenmai"; 
        
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
        
        // 1. LẤY CÁC THAM SỐ MỚI
        String loaiKM = req.getParameter("loaiKM");
        String dieuKienMinStr = req.getParameter("dieuKienMin");
        String phanTramGiamStr = req.getParameter("phanTramGiam");
        
        // Kiểm tra dữ liệu bắt buộc 
        if (tenKM == null || tenKM.isEmpty() || ngayBDStr == null || ngayKTStr == null || loaiKM == null) {
            session.setAttribute("error_admin", "Vui lòng điền đầy đủ Tên, Loại KM, Ngày Bắt Đầu và Ngày Kết Thúc.");
            resp.sendRedirect(redirectUrl); 
            return;
        }
        
        try {
            KhuyenMai km = new KhuyenMai();
            km.setTenKM(tenKM);
            km.setMoTa(moTa);
            km.setNgayBatDau(Date.valueOf(ngayBDStr));
            km.setNgayKetThuc(Date.valueOf(ngayKTStr));
            
            // 2. GÁN CÁC THAM SỐ MỚI VÀ CHUYỂN ĐỔI KIỂU DỮ LIỆU
            km.setLoaiKM(loaiKM);
            
            // Chuyển đổi DieuKienMin (Decimal)
            km.setDieuKienMin(new BigDecimal(dieuKienMinStr)); 
            
            // Chuyển đổi PhanTramGiam (Int)
            km.setPhanTramGiam(Integer.parseInt(phanTramGiamStr));
            
            // Lấy MaNguoiLap (Giả định ID Admin là MaND từ session)
            km.setMaNguoiLap(user.getMaND());
            
            KhuyenMaiDAO dao = new KhuyenMaiDAO();
            dao.addKhuyenMai(km);
            
            session.setAttribute("success_admin", "Thêm chương trình khuyến mãi thành công!");
            // Chuyển hướng thành công về trang danh sách khuyến mãi
            resp.sendRedirect(req.getContextPath() + "/khuyenmai");
            
        } catch (IllegalArgumentException e) {
            session.setAttribute("error_admin", "Lỗi định dạng ngày tháng hoặc số (Phần trăm giảm, Điều kiện). Vui lòng kiểm tra lại.");
            resp.sendRedirect(redirectUrl);
        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL khi thêm khuyến mãi: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(redirectUrl);
        }
    }

}