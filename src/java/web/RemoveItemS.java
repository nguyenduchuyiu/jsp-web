package web;

import dao.CartDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/removeitem")
public class RemoveItemS extends HttpServlet {
    
    // Xử lý bằng GET (thường dùng cho liên kết)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login"); 
            return;
        }

        String maCTGHStr = req.getParameter("maCtgh");
        
        try {
            int maCTGH = Integer.parseInt(maCTGHStr);
            CartDAO dao = new CartDAO();
            
            if (dao.removeItem(maCTGH)) {
                session.setAttribute("success_cart", "Đã xóa sản phẩm khỏi giỏ hàng.");
            } else {
                session.setAttribute("error_cart", "Không thể xóa sản phẩm. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            session.setAttribute("error_cart", "Lỗi xử lý khi xóa sản phẩm.");
            e.printStackTrace();
        }
        
        // Chuyển hướng về trang giỏ hàng để cập nhật hiển thị
        resp.sendRedirect("cart");
    }
}