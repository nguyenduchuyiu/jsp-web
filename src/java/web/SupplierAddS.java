package web;

import dao.SupplierDAO;
import model.NhaCungCap;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/supplieradd")
public class SupplierAddS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền Admin (cần thêm logic)
        req.getRequestDispatcher("/supplier_form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        
        try {
            NhaCungCap ncc = new NhaCungCap();
            ncc.setTenNCC(req.getParameter("tenNCC"));
            ncc.setDiaChi(req.getParameter("diaChi"));
            ncc.setSdt(req.getParameter("sdt"));
            ncc.setEmail(req.getParameter("email"));
            ncc.setXuatXu(req.getParameter("xuatXu"));

            SupplierDAO dao = new SupplierDAO();
            dao.addSupplier(ncc);
            
            session.setAttribute("success_admin", "Thêm nhà cung cấp mới thành công!");
            resp.sendRedirect("suppliers");

        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("supplieradd");
        }
    }
}