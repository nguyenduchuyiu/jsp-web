package web.admin;

import dao.ProdDAO;
import dao.NhapHangDAO;     
import dao.NhaCungCapDAO;  
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/live")  
public class NhapHangS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            ProdDAO prodDao = new ProdDAO();
            NhapHangDAO nhapHangDao = new NhapHangDAO();
            NhaCungCapDAO nccDao = new NhaCungCapDAO();
            
            // 2. Tải danh mục (BẮT BUỘC cho Header Admin)
            req.setAttribute("categoryList", prodDao.getAllCategories()); 
            
            // 3. Tải danh sách Nhà cung cấp (CẦN THIẾT cho form Thêm mới)
            req.setAttribute("nhaCungCapList", nccDao.getAllNhaCungCap());
            
            // 4. Tải danh sách TẤT CẢ sản phẩm (CẦN THIẾT cho dropdown trong form Nhập hàng)
            req.setAttribute("productList", prodDao.getAllProducts()); 
            
            // 5. Tải danh sách Phiếu nhập hiện tại (CẦN THIẾT cho bảng tổng quan)
            req.setAttribute("phieuNhapList", nhapHangDao.getAllPhieuNhap()); 

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải dữ liệu nhập hàng.");
            e.printStackTrace();
        }
        
        // Chuyển thông báo từ session sang request và xóa khỏi session
        if (session != null) {
            String error = (String) session.getAttribute("error");
            String success = (String) session.getAttribute("success_admin");
            if (error != null) {
                req.setAttribute("error", error);
                session.removeAttribute("error");
            }
            if (success != null) {
                req.setAttribute("success_admin", success);
                session.removeAttribute("success_admin");
            }
        }

        // 6. Forward đến trang quản lý nhập hàng
        req.getRequestDispatcher("/nhaphang_manage.jsp").forward(req, resp);
    }
}