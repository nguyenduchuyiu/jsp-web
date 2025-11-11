package web;

import dao.OrderDAO;
import model.User;
import model.Order;
import model.CartItem;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Đặt ánh xạ là /admin/orderdetailadmin
@WebServlet("/admin/orderdetailadmin") 
public class OrderDetailAdminS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String maDhStr = req.getParameter("maDh");
        
        if (maDhStr == null || maDhStr.isEmpty()) {
            resp.sendRedirect("orders"); // Quay lại trang QL Đơn hàng nếu thiếu mã
            return;
        }

        try {
            int maDh = Integer.parseInt(maDhStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // 2. Lấy Chi tiết Sản phẩm của đơn hàng
            List<CartItem> orderDetails = orderDAO.getOrderDetails(maDh); // Sử dụng hàm đã có
            
            // 3. Lấy thông tin chung của Đơn hàng (Nếu cần) - Bạn cần thêm hàm này vào OrderDAO
            // Giả sử bạn có hàm getOrderById(maDh)
            // Order orderHeader = orderDAO.getOrderById(maDh);
            
            req.setAttribute("orderDetails", orderDetails);
            // req.setAttribute("orderHeader", orderHeader);
            
            // 4. Chuyển hướng đến trang hiển thị chi tiết
            req.getRequestDispatcher("/order_detail_admin.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã đơn hàng không hợp lệ.");
            resp.sendRedirect("orders");
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải chi tiết đơn hàng.");
            e.printStackTrace();
            req.getRequestDispatcher("/order_detail_admin.jsp").forward(req, resp);
        }
    }
}