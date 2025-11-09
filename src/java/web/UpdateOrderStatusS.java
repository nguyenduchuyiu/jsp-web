package web;

import dao.OrderDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateorderstatus")
public class UpdateOrderStatusS extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login");
            return;
        }

        String maDhStr = req.getParameter("maDh");
        String newStatus = req.getParameter("newStatus"); // 'DaGiao' hoặc 'DaHuy'

        try {
            int maDh = Integer.parseInt(maDhStr);
            OrderDAO orderDAO = new OrderDAO();
            
            if (orderDAO.updateOrderStatus(maDh, newStatus)) {
                session.setAttribute("success", "Cập nhật trạng thái đơn hàng #" + maDh + " thành công!");
            } else {
                session.setAttribute("error", "Lỗi: Không thể cập nhật trạng thái đơn hàng.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Lỗi: Mã đơn hàng không hợp lệ.");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi CSDL khi cập nhật đơn hàng.");
            e.printStackTrace();
        }

        // Chuyển hướng về trang lịch sử đơn hàng
        resp.sendRedirect("orderhistory");
    }
}