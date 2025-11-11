package web;

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

/**
 * Servlet này xử lý việc Cập Nhật Sản Phẩm (Create/Update).
 * doGet: Hiển thị form để cập nhật.
 * doPost: Lưu thay đổi vào CSDL.
 */
// Đảm bảo ánh xạ này khớp với liên kết trong product_manage.jsp
@WebServlet("/admin/productupdate") 
public class ProductUpdateS extends HttpServlet {
    
    /**
     * Xử lý GET: Tải dữ liệu sản phẩm và danh mục, sau đó forward đến form.
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

        String maSp = req.getParameter("maSp");
        
        if (maSp == null || maSp.isEmpty()) {
            session.setAttribute("error_admin", "Thiếu mã sản phẩm để cập nhật.");
            resp.sendRedirect("products"); // Quay lại trang quản lý
            return;
        }

        try {
            ProdDAO dao = new ProdDAO();
            
            // 2. Tải sản phẩm cần sửa (Sử dụng hàm đã có trong ProdDAO)
            Product product = dao.getProductById(maSp); //
            
            // 3. Tải danh sách danh mục (Sử dụng hàm đã có trong ProdDAO)
            List<Category> categories = dao.getAllCategories(); //
            
            // 4. Đặt thuộc tính cho JSP
            req.setAttribute("product", product);
            req.setAttribute("categoryList", categories);

            // 5. Chuyển hướng đến trang JSP để hiển thị form
            // Đảm bảo tệp JSP này tồn tại ở thư mục gốc
            req.getRequestDispatcher("/productupdate.jsp").forward(req, resp); 
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải dữ liệu sản phẩm: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("products"); // Quay lại trang quản lý
        }
    }
    
    /**
     * Xử lý POST: Nhận dữ liệu từ form và cập nhật vào CSDL.
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
        
        // 2. Lấy dữ liệu từ form
        Product p = new Product();
        p.setMaSP(req.getParameter("maSp")); // Lấy từ input hidden
        p.setTenSP(req.getParameter("tenSp"));
        p.setDonVi(req.getParameter("donVi"));
        p.setHinhAnh(req.getParameter("hinhAnh"));
        p.setThuongHieu(req.getParameter("thuongHieu"));
        p.setXuatXu(req.getParameter("xuatXu"));
        p.setMoTa(req.getParameter("moTa"));
        p.setHuongDan(req.getParameter("huongDan"));
        
        String giaStr = req.getParameter("gia");
        String soLuongTonStr = req.getParameter("soLuongTon");
        String maDmStr = req.getParameter("maDm");

        try {
            // 3. Chuyển đổi kiểu dữ liệu
            p.setGia(new BigDecimal(giaStr));
            p.setSoLuongTon(Integer.parseInt(soLuongTonStr));
            p.setMaDM(Integer.parseInt(maDmStr));
            
            ProdDAO dao = new ProdDAO();
            
            // 4. Gọi hàm cập nhật CSDL (Sử dụng hàm đã có trong ProdDAO)
            dao.updateProduct(p); //
            
            // 5. Thông báo thành công và chuyển hướng
            session.setAttribute("success_admin", "Cập nhật sản phẩm " + p.getMaSP() + " thành công!");
            resp.sendRedirect("products"); // Chuyển về trang quản lý
            
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Lỗi: Giá, Tồn kho hoặc Mã Danh mục không hợp lệ.");
            // Nếu lỗi, tải lại form với dữ liệu cũ (gọi lại doGet)
            doGet(req, resp); 
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi cập nhật sản phẩm.");
            e.printStackTrace();
            doGet(req, resp); // Tải lại form
        }
    }
}