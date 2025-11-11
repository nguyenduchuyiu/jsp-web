package web;

import dao.OrderDAO;
import model.Order;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// ĐẢM BẢO MAPPING NÀY CHÍNH XÁC
@WebServlet("/orderconfirm") 
public class OrderConfirmS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;
        
        // 1. KIỂM TRA ĐĂNG NHẬP
        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        String maDhStr = req.getParameter("maDh");
        if (maDhStr == null || maDhStr.isEmpty()) {
            resp.sendRedirect("orderhistory");
            return;
        }

        try {
            int maDh = Integer.parseInt(maDhStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // Tải chi tiết đơn hàng của người dùng hiện tại
            Order targetOrder = orderDAO.getOrdersByUserId(user.getMaND()).stream()
                                         .filter(o -> o.getMaDH() == maDh)
                                         .findFirst()
                                         .orElse(null);
            
            if (targetOrder != null) {
                req.setAttribute("order", targetOrder);
                
                // THAY ĐỔI QUAN TRỌNG: Forward đến file JSP CÓ SẴN (ordersuccess.jsp)
                req.getRequestDispatcher("/ordersuccess.jsp").forward(req, resp); 
            } else {
                resp.sendRedirect("orderhistory");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi khi xử lý xác nhận đơn hàng chuyển khoản: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect("orderhistory"); 
        }
    }
}