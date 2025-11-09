package web;

import dao.CartDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import model.CartItem;
import model.User; // Giả sử bạn import class User

@WebServlet("/cart") 
public class CartS extends HttpServlet {
    
   @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        // 1. Kiểm tra trạng thái đăng nhập (đã có)
        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }
        
        // 2. Đã đăng nhập: Tải dữ liệu giỏ hàng
        try {
            CartDAO dao = new CartDAO();
            List<CartItem> cartItems = dao.getCartItemsByUser(user.getMaND());
            
            // Tính tổng tiền (optional, nhưng cần thiết)
            BigDecimal totalAmount = BigDecimal.ZERO;
            int totalQuantity = 0;
            for (CartItem item : cartItems) {
                totalAmount = totalAmount.add(item.getThanhTien());
                totalQuantity += item.getSoLuong();
            }
            
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("totalAmount", totalAmount);
            req.setAttribute("totalQuantity", totalQuantity);

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải Giỏ hàng.");
            e.printStackTrace();
        }
        
        // 3. Chuyển hướng đến trang Giỏ hàng thực tế
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }
    
    // Thường thì giỏ hàng cũng cần xử lý POST (thêm sản phẩm)
    // Nếu bạn muốn xử lý POST, logic tương tự cũng cần kiểm tra đăng nhập
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}