package web;

import dao.SupplierDAO;
import model.NhaCungCap;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/suppliers")
public class SupplierAdminS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            SupplierDAO dao = new SupplierDAO();
            List<NhaCungCap> supplierList = dao.getAllSuppliers();
            req.setAttribute("supplierList", supplierList);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách nhà cung cấp.");
            e.printStackTrace();
        }

        req.getRequestDispatcher("/supplier_manage.jsp").forward(req, resp);
    }
}