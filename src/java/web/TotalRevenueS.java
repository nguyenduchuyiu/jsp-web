package web.admin;

import dao.ReportDAO;
import model.User;
import model.RevenueReportItem;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Ánh xạ này khớp với JavaScript bạn đã tạo (contextPath + '/totalrevenue')
@WebServlet("/admin/totalrevenue") 
public class TotalRevenueS extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Lấy tham số (Bỏ qua maSp, chỉ lấy ngày)
        String ngayBD = req.getParameter("ngayBatDau"); 
        String ngayKT = req.getParameter("ngayKetThuc"); 

        if (ngayBD == null || ngayKT == null || ngayBD.isEmpty() || ngayKT.isEmpty()) {
            req.setAttribute("error", "Vui lòng chọn ngày bắt đầu và ngày kết thúc.");
            // Quay lại trang form báo cáo
            req.getRequestDispatcher("/reports.jsp").forward(req, resp); 
            return;
        }

        try {
            ReportDAO dao = new ReportDAO();
            
            // 3. Gọi DAO
            List<RevenueReportItem> soldProducts = dao.getSoldProductsInRange(ngayBD, ngayKT);
            BigDecimal grandTotal = dao.getTotalRevenueInRange(ngayBD, ngayKT);
            
            // 4. Đặt thuộc tính cho JSP
            req.setAttribute("soldProductsList", soldProducts);
            req.setAttribute("grandTotalRevenue", grandTotal);
            req.setAttribute("reportNgayBD", ngayBD);
            req.setAttribute("reportNgayKT", ngayKT);

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tạo báo cáo doanh thu: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 5. Chuyển đến trang JSP mới
        req.getRequestDispatcher("/total_revenue_report.jsp").forward(req, resp);
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu ai đó truy cập GET, chỉ chuyển hướng về form báo cáo
        resp.sendRedirect(req.getContextPath() + "/admin/reports");
    }
}