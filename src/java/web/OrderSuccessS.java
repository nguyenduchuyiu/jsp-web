package web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ordersuccess")
public class OrderSuccessS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        // Bảo vệ route: Nếu chưa đăng nhập, chuyển hướng đến login
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login");
            return;
        }

        String maDhStr = req.getParameter("maDh");
        
        if (maDhStr != null && !maDhStr.isEmpty()) {
            try {
                // Bạn có thể tải chi tiết đơn hàng ở đây nếu muốn, nhưng hiện tại chỉ forward
                // req.setAttribute("order", orderDAO.getOrderById(Integer.parseInt(maDhStr)));
                
                req.getRequestDispatcher("/ordersuccess.jsp").forward(req, resp);
                return;
            } catch (NumberFormatException e) {
                // Bỏ qua lỗi format, chuyển hướng về home
            }
        }
        
        // Nếu không có MaDh hoặc lỗi, chuyển hướng về home
        resp.sendRedirect("home");
    }
}