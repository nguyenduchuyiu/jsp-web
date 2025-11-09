package web;

import dao.OrderDAO; 
import model.User;
import model.CartItem; 
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/placeorder")
public class PlaceOrderS extends HttpServlet {

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }
        
        // 1. Lấy dữ liệu từ Form (orders.jsp)
        String receiverName = req.getParameter("receiverName");
        String receiverPhone = req.getParameter("receiverPhone");
        String shippingAddress = req.getParameter("shippingAddress");
        String paymentMethod = req.getParameter("paymentMethod"); 
        String notes = req.getParameter("notes");
        
        // 2. Lấy dữ liệu Giỏ hàng từ SESSION
        @SuppressWarnings("unchecked")
        List<CartItem> orderItems = (List<CartItem>) session.getAttribute("orderItemsSession"); 
        BigDecimal totalFinal = (BigDecimal) session.getAttribute("totalFinalSession"); 
        
        // KIỂM TRA DỮ LIỆU BẮT BUỘC TRÊN FORM
        if (isBlank(receiverName) || isBlank(receiverPhone) || isBlank(shippingAddress)) {
             // Dùng biến "error" cho lỗi chung
             session.setAttribute("error", "Vui lòng điền đủ Tên người nhận, Số điện thoại và Địa chỉ giao hàng.");
             resp.sendRedirect("checkout"); // Chuyển hướng về checkout để hiển thị lỗi trên form
             return;
        }
        
        if (orderItems == null || orderItems.isEmpty() || totalFinal == null) {
             session.setAttribute("error_cart", "Lỗi dữ liệu giỏ hàng. Vui lòng thử lại.");
             resp.sendRedirect("cart"); // Chuyển về giỏ hàng nếu lỗi
             return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            
            // 3. Thực hiện lưu đơn hàng
            int maDH = orderDAO.saveOrder(user, orderItems, totalFinal, 
                                          receiverName, receiverPhone, 
                                          shippingAddress, paymentMethod, notes);
            
            // 4. Xóa các biến session tạm thời (Chỉ xóa sau khi lưu CSDL thành công)
            session.removeAttribute("orderItemsSession");
            session.removeAttribute("totalFinalSession");
            
            // 5. CHUYỂN HƯỚNG DỰA TRÊN PHƯƠNG THỨC THANH TOÁN
            if ("TRANSFER".equals(paymentMethod)) {
                // Chuyển hướng đến trang xác nhận chuyển khoản
                resp.sendRedirect("orderconfirm?maDh=" + maDH);
            } else {
                // Chuyển hướng đến trang xác nhận COD
                session.setAttribute("success_order", "Đơn hàng của bạn đã được tiếp nhận thành công.");
                resp.sendRedirect("ordersuccess?maDh=" + maDH); 
            }
            
        } catch (Exception e) {
            // SỬA LỖI CSDL: Lưu lỗi vào biến "error"
            session.setAttribute("error", "Lỗi đặt hàng không thành công do lỗi CSDL. Vui lòng kiểm tra log server.");
            e.printStackTrace();
            // CHUYỂN HƯỚNG VỀ GIỎ HÀNG để người dùng có thể làm mới session
            resp.sendRedirect("cart"); 
        }
    }
}