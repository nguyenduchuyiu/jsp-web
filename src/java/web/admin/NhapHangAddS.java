package web.admin;

import dao.ProdDAO;
import dao.NhaCungCapDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.Collections;
import java.util.List;
import java.sql.SQLException; // Import SQLException

@WebServlet("/admin/nhaphangadd")
public class NhapHangAddS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        System.out.println("[NhapHangAddS] ===== SERVLET ĐƯỢC GỌI =====");
        System.err.println("[NhapHangAddS] ===== SERVLET ĐƯỢC GỌI (stderr) =====");
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        System.out.println("[NhapHangAddS] Session: " + (session != null ? "có" : "không"));
        System.out.println("[NhapHangAddS] User: " + (user != null ? user.getUser() : "null"));
        System.out.println("[NhapHangAddS] LoaiNguoiDung: " + (user != null ? user.getLoaiNguoiDung() : "null"));
        
        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            System.out.println("[NhapHangAddS] Redirect về login - không có quyền admin");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        System.out.println("[NhapHangAddS] Đã qua kiểm tra quyền, bắt đầu tải dữ liệu...");

        // Khởi tạo List rỗng để đảm bảo JSP không bị lỗi dù DAO thất bại
        List<?> emptyList = Collections.emptyList();
        
        try {
            ProdDAO prodDao = new ProdDAO();
            NhaCungCapDAO nccDao = new NhaCungCapDAO();
            
            // 2. TẢI DỮ LIỆU CẦN THIẾT CHO FORM
            
            // --- Tải danh sách NCC ---
            System.out.println("[NhapHangAddS] Bắt đầu gọi getAllNhaCungCap()...");
            try {
                 List<?> nccList = nccDao.getAllNhaCungCap();
                 System.out.println("[NhapHangAddS] ✓ Đã tải được " + (nccList != null ? nccList.size() : 0) + " NCC");
                 System.err.println("[NhapHangAddS] ✓ Đã tải được " + (nccList != null ? nccList.size() : 0) + " NCC (stderr)");
                 req.setAttribute("nhaCungCapList", nccList); 
            } catch (SQLException | ClassNotFoundException ex) {
                 // Gán List rỗng và thiết lập thông báo lỗi chi tiết
                 System.err.println("[NhapHangAddS] ✗ Lỗi khi tải NCC: " + ex.getMessage());
                 System.err.println("[NhapHangAddS] ✗ Stack trace:");
                 ex.printStackTrace(); // Ghi lỗi chi tiết ra Log Server
                 req.setAttribute("nhaCungCapList", emptyList);
                 req.setAttribute("error", "Lỗi CSDL khi tải NCC. Vui lòng kiểm tra Log Server để xem chi tiết lỗi: " + ex.getMessage());
            }
            
            // Tải danh sách Sản phẩm và Danh mục
            req.setAttribute("productList", prodDao.getAllProducts()); 
            req.setAttribute("categoryList", prodDao.getAllCategories()); 
            
        } catch (Exception e) {
            // Lỗi chung (ví dụ: lỗi ProdDAO hoặc lỗi trong quá trình setup)
            req.setAttribute("error", "Lỗi không xác định khi tải dữ liệu. Chi tiết lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        // 3. Forward đến trang form nhập liệu
        req.getRequestDispatcher("/nhaphang_add.jsp").forward(req, resp);
    }
}