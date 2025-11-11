package web;

import dao.CartDAO;
import model.CartItem;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

// NHUNGKM
import dao.KhuyenMaiDAO;
// END

@WebServlet("/confirmcheckout")
public class ConfirmCheckoutS extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }

        String maCtghStr = req.getParameter("maCtgh");
        
        if (maCtghStr == null || maCtghStr.isEmpty()) {
            session.setAttribute("error_cart", "Không tìm thấy sản phẩm. Vui lòng chọn lại.");
            resp.sendRedirect("cart"); // Chuyển về giỏ hàng nếu lỗi
            return;
        }

        try {
            CartDAO cartDAO = new CartDAO();
            
            // 1. Tải chi tiết chỉ mục này
            List<String> selectedList = Arrays.asList(maCtghStr);
            List<CartItem> selectedItems = cartDAO.getSelectedCartItems(selectedList);
            
            if (selectedItems.isEmpty()) {
                 session.setAttribute("error_cart", "Sản phẩm không hợp lệ.");
                 resp.sendRedirect("cart");
                 return;
            }

            // 2. Tính toán tổng tiền
            CartItem singleItem = selectedItems.get(0);
            BigDecimal tongHang = singleItem.getThanhTien(); 
            
            BigDecimal shippingFee = new BigDecimal("30000");
            BigDecimal totalFinal = tongHang.add(shippingFee);

            // --- NHUNGKM ---
            KhuyenMaiDAO kmDAO = new KhuyenMaiDAO();
            req.setAttribute("khuyenMaiList", kmDAO.getActiveKhuyenMai());            
// ---------------END------------------------
            
            // 3. Lưu thông tin cần thiết vào Session/Request
            session.setAttribute("orderItemsSession", selectedItems); 
            session.setAttribute("totalFinalSession", totalFinal); 
            
            req.setAttribute("userInfo", user); 
            req.setAttribute("orderItems", selectedItems);
            req.setAttribute("tongHang", tongHang);
            req.setAttribute("shippingFee", shippingFee);

            // 4. Forward thẳng đến trang đặt hàng
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
            
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi xử lý thanh toán mua ngay.");
            e.printStackTrace();
            resp.sendRedirect("cart");
        }
    }
}