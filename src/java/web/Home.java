package web;

import dao.ProdDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/home") 
public class Home extends HttpServlet {
    
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String sortBy = req.getParameter("sortBy"); 
        
        // LẤY TỪ KHÓA TÌM KIẾM
        String keyword = req.getParameter("keyword");
        
        // 1. LẤY MÃ DANH MỤC TỪ URL (maDm)
        Integer maDm = null;
        String maDmStr = req.getParameter("maDm");
        if (maDmStr != null && !maDmStr.isEmpty()) {
            try {
                // Chuyển đổi chuỗi thành Integer
                maDm = Integer.parseInt(maDmStr);
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu maDm không phải là số
                System.err.println("Lỗi NumberFormatException khi parse maDm: " + e.getMessage());
            }
        }
        
        // Logic lọc (Giữ nguyên cho Giá bán)
        String selectedGia = req.getParameter("radioGia");
        String[] giaArr = selectedGia != null && !selectedGia.equals("all") ? new String[]{selectedGia} : null;
        
        try {
            ProdDAO dao = new ProdDAO();
            
            // 2. TRUYỀN THAM SỐ maDm VÀO HÀM getFilteredProducts
            // (Đã có thêm tham số maDm ở cuối)
            req.setAttribute("productList", dao.getFilteredProducts(sortBy, null, null, giaArr, keyword, maDm)); 
            
            // Tải danh sách danh mục (QUAN TRỌNG: để hiển thị Menu danh mục trong header.jspf)
            req.setAttribute("categoryList", dao.getAllCategories());
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải dữ liệu trang chủ. Vui lòng kiểm tra log server.");
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/productlist.jsp").forward(req, resp);
    }
}