package web;

import dao.OrderDAO; 
import model.User;
import model.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.List;

@WebServlet("/orderhistory")
public class OrderHistoryS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        // BẢO VỆ ROUTE: Phải đăng nhập
        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            
            // Lấy danh sách đơn hàng của người dùng hiện tại
            List<Order> orderList = orderDAO.getOrdersByUserId(user.getMaND());
            
            req.setAttribute("orderList", orderList);
            req.getRequestDispatcher("/orderhistory.jsp").forward(req, resp);
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải lịch sử đơn hàng.");
            e.printStackTrace();
            req.getRequestDispatcher("/orderhistory.jsp").forward(req, resp);
        }
    }
}