package web; // Hoặc 'package web;' tùy bạn

import dao.OrderDAO;
import dao.UserDAO;
import model.CartItem;
import model.Order;
import model.User;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/invoice")
public class InvoiceS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("account") : null;

        // 1. Kiểm tra quyền Admin
        if (adminUser == null || !"QuanTriVien".equalsIgnoreCase(adminUser.getLoaiNguoiDung())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int maDh = Integer.parseInt(req.getParameter("maDh"));
            
            OrderDAO orderDAO = new OrderDAO();
            UserDAO userDAO = new UserDAO();

            // 2. Tải 3 thông tin cần thiết
            Order order = orderDAO.getOrderById(maDh);
            List<CartItem> items = orderDAO.getOrderDetails(maDh);
            User customer = userDAO.getUserById(order.getMaND());

            // 3. Gửi dữ liệu qua JSP
            req.setAttribute("order", order);
            req.setAttribute("items", items);
            req.setAttribute("customer", customer);

            req.getRequestDispatcher("/invoice.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error_admin", "Lỗi khi tải hóa đơn: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
        }
    }
}