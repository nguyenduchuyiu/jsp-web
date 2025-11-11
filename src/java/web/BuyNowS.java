package web;

import dao.CartDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/buynow")
public class BuyNowS extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login");
            return;
        }
        
        String maSp = req.getParameter("maSp");
        String soLuongStr = req.getParameter("soLuong");
        int soLuong = 1;
        
        try {
            soLuong = Integer.parseInt(soLuongStr);
            if (soLuong <= 0) soLuong = 1;
        } catch (NumberFormatException e) {
            soLuong = 1; 
        }

        try {
            CartDAO cartDAO = new CartDAO();
            
            // 1. TÌM HOẶC TẠO GIỎ HÀNG
            int maGH = cartDAO.findOrCreateCart(user.getMaND());
            
            // NHUNG
            // 2. THÊM SẢN PHẨM VÀO CHI TIẾT GIỎ HÀNG VÀ LẤY MACTGH (Giả định hàm trả về int)
            int maCtghBaru = cartDAO.setItemQuantity(maGH, maSp, soLuong); 
            // END
            
            // 3. CHUYỂN HƯỚNG TRỰC TIẾP ĐẾN XỬ LÝ THANH TOÁN (confirmcheckout)
            if (maCtghBaru > 0) {
                 // Gửi MaCTGH vừa tạo/cập nhật qua URL
                resp.sendRedirect("confirmcheckout?maCtgh=" + maCtghBaru); 
                return;
            } else {
                session.setAttribute("error", "Lỗi: Không thể thêm sản phẩm vào giỏ.");
                resp.sendRedirect("detail?maSp=" + maSp);
            }
            
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi xử lý mua ngay. Vui lòng kiểm tra log CSDL.");
            e.printStackTrace();
            resp.sendRedirect("detail?maSp=" + maSp);
        }
    }
}