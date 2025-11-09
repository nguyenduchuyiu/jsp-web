package web;

import dao.CartDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addtocart")
public class AddToCartS extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        
        // 1. Kiểm tra đăng nhập
        if (session == null || session.getAttribute("account") == null) {
            // Nếu chưa đăng nhập, chuyển hướng đến trang login
            resp.sendRedirect("login");
            return;
        }
        
        // 2. Lấy thông tin người dùng và sản phẩm
        User user = (User) session.getAttribute("account");
        String maSp = req.getParameter("maSp");
        String soLuongStr = req.getParameter("soLuong");
        int soLuong = 1;
        
        try {
            soLuong = Integer.parseInt(soLuongStr);
            if (soLuong <= 0) soLuong = 1;
        } catch (NumberFormatException e) {
            soLuong = 1; 
        }

        if (maSp == null || maSp.isEmpty()) {
            resp.sendRedirect("home"); // Quay lại trang chủ nếu thiếu thông tin
            return;
        }
        
        try {
            CartDAO cartDAO = new CartDAO();
            
            // 3. Tìm hoặc tạo Giỏ hàng (MaGH)
            int maGH = cartDAO.findOrCreateCart(user.getMaND());
            
            // 4. Thêm sản phẩm vào chi tiết giỏ hàng
            cartDAO.addItem(maGH, maSp, soLuong);
            
            // 5. Thông báo thành công và chuyển hướng đến trang chi tiết sản phẩm hoặc trang giỏ hàng
            session.setAttribute("cart_message", "Đã thêm sản phẩm vào giỏ hàng thành công!");
            resp.sendRedirect("detail?maSp=" + maSp); // Quay lại trang chi tiết sản phẩm
            
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi CSDL khi thêm sản phẩm vào giỏ hàng.");
            e.printStackTrace();
            resp.sendRedirect("detail?maSp=" + maSp);
        }
    }
}