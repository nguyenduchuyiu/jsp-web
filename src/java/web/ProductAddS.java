package web.admin;

import dao.ProdDAO;
import model.User;
import model.Product;
import model.Category; // Cần import Category
import java.io.IOException;
import java.math.BigDecimal; // Cần import BigDecimal
import java.util.List; // Cần import List
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/productadd")
public class ProductAddS extends HttpServlet {
    
    /**
     * Sửa lỗi: Phương thức doGet CẦN TẢI danh sách danh mục.
     */
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
         
        try {
            // 2. TẢI DANH SÁCH DANH MỤC
            ProdDAO dao = new ProdDAO();
            List<Category> categoryList = dao.getAllCategories(); //
            
            // 3. ĐẶT DANH SÁCH VÀO REQUEST
            req.setAttribute("categoryList", categoryList);
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách danh mục.");
            e.printStackTrace();
        }
        
        // 4. Chuyển hướng đến form Thêm
        req.getRequestDispatcher("/productadd.jsp").forward(req, resp);
    }

    /**
     * Phương thức doPost (Xử lý Thêm sản phẩm)
     */
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

        Product p = new Product();
        p.setMaSP(req.getParameter("maSp"));
        p.setTenSP(req.getParameter("tenSp"));
        p.setDonVi(req.getParameter("donVi"));
        p.setHinhAnh(req.getParameter("hinhAnh"));
        p.setThuongHieu(req.getParameter("thuongHieu"));
        p.setXuatXu(req.getParameter("xuatXu"));
        p.setMoTa(req.getParameter("moTa"));
        p.setHuongDan(req.getParameter("huongDan"));
        
        try {
            p.setGia(new BigDecimal(req.getParameter("gia")));
            p.setSoLuongTon(Integer.parseInt(req.getParameter("soLuongTon")));
            p.setMaDM(Integer.parseInt(req.getParameter("maDm")));
            
            ProdDAO dao = new ProdDAO();
            dao.addProduct(p); // Dùng hàm đã có
            
            session.setAttribute("success_admin", "Thêm sản phẩm mới (" + p.getTenSP() + ") thành công!");
            resp.sendRedirect("products"); // Chuyển hướng về trang quản lý sản phẩm
            
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Giá, Tồn kho hoặc Mã Danh mục không hợp lệ.");
            // Nếu lỗi, cần tải lại danh mục trước khi forward
            doGet(req, resp);
        } catch (Exception e) {
            // Lỗi này thường là do Trùng Mã SP (Primary Key)
            req.setAttribute("error", "Lỗi CSDL: Mã SP có thể đã tồn tại hoặc thiếu dữ liệu bắt buộc.");
            e.printStackTrace();
            // Nếu lỗi, cần tải lại danh mục trước khi forward
            doGet(req, resp);
        }
    }
}