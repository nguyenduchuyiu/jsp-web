package web;

import dao.CartDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/clearallcart")
public class ClearAllCartS extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }
        
        try {
            CartDAO dao = new CartDAO();
            
            // Xóa tất cả chi tiết giỏ hàng của người dùng này
            dao.clearCart(user.getMaND()); 
            
            session.setAttribute("success_cart", "Đã xóa toàn bộ giỏ hàng thành công.");
        } catch (Exception e) {
            session.setAttribute("error_cart", "Lỗi CSDL khi xóa toàn bộ giỏ hàng.");
            e.printStackTrace();
        }
        
        // Chuyển hướng về trang giỏ hàng
        resp.sendRedirect("cart");
    }
}