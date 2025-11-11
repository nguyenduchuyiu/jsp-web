package web;

import dao.ProdDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/productdelete")
public class ProductDeleteS extends HttpServlet {
    
    // Xử lý thông qua GET (do dùng liên kết <a>)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String maSp = req.getParameter("maSp");
        
        if (maSp == null || maSp.isEmpty()) {
            resp.sendRedirect("products"); 
            return;
        }

        try {
            ProdDAO dao = new ProdDAO();
            
            // 2. Xóa sản phẩm khỏi CSDL
            if (dao.deleteProduct(maSp)) { // Dùng hàm đã có
                session.setAttribute("success_admin", "Đã xóa sản phẩm " + maSp + " thành công!");
            } else {
                session.setAttribute("error_admin", "Lỗi: Không thể xóa sản phẩm. Có thể có ràng buộc khóa ngoại.");
            }
        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL khi xóa sản phẩm.");
            e.printStackTrace();
        }
        
        // 3. Chuyển hướng về trang danh sách quản lý
        resp.sendRedirect("products");
    }
}