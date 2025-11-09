package web.admin;

import dao.ProdDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/products")
public class ProductAdminS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // KIỂM TRA QUYỀN ADMIN (Dùng QuanTriVien như bạn đã cấu hình)
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            ProdDAO dao = new ProdDAO();
            
            // Tải danh sách tất cả sản phẩm
            req.setAttribute("productList", dao.getAllProducts());
            
            // Tải danh sách danh mục (cần cho form Thêm/Sửa)
            req.setAttribute("categoryList", dao.getAllCategories()); 
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách sản phẩm.");
            e.printStackTrace();
        }

        // Forward đến trang quản lý chung
        req.getRequestDispatcher("/product_manage.jsp").forward(req, resp);
    }
}