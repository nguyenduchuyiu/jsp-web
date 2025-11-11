package web;

import dao.SupplierDAO;
import model.NhaCungCap;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/supplierupdate")
public class SupplierUpdateS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền Admin (cần thêm logic)
        try {
            int maNcc = Integer.parseInt(req.getParameter("maNcc"));
            SupplierDAO dao = new SupplierDAO();
            NhaCungCap ncc = dao.getSupplierById(maNcc);
            req.setAttribute("ncc", ncc);
            req.getRequestDispatcher("/supplier_form.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("suppliers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        
        try {
            NhaCungCap ncc = new NhaCungCap();
            ncc.setMaNCC(Integer.parseInt(req.getParameter("maNCC")));
            ncc.setTenNCC(req.getParameter("tenNCC"));
            ncc.setDiaChi(req.getParameter("diaChi"));
            ncc.setSdt(req.getParameter("sdt"));
            ncc.setEmail(req.getParameter("email"));
            ncc.setXuatXu(req.getParameter("xuatXu"));

            SupplierDAO dao = new SupplierDAO();
            dao.updateSupplier(ncc);
            
            session.setAttribute("success_admin", "Cập nhật nhà cung cấp thành công!");
            resp.sendRedirect("suppliers");

        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi CSDL: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("supplierupdate?maNcc=" + req.getParameter("maNCC"));
        }
    }
}