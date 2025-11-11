package web;

import dao.SupplierDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/supplierdelete")
public class SupplierDeleteS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        // Kiểm tra quyền Admin (cần thêm logic)
        
        try {
            int maNcc = Integer.parseInt(req.getParameter("maNcc"));
            SupplierDAO dao = new SupplierDAO();
            
            if(dao.deleteSupplier(maNcc)) {
                session.setAttribute("success_admin", "Xóa nhà cung cấp thành công!");
            } else {
                session.setAttribute("error_admin", "Lỗi: Không thể xóa nhà cung cấp. Có thể do ràng buộc (sản phẩm đang tham chiếu đến NCC này).");
            }

        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL: " + e.getMessage());
            e.printStackTrace();
        }
        resp.sendRedirect("suppliers");
    }
}