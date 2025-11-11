package web;

import dao.OrderDAO; // THÊM IMPORT NÀY
import model.User; // THÊM IMPORT NÀY
import model.Order; // THÊM IMPORT NÀY
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Đổi ánh xạ URL để khớp với header_admin.jspf
@WebServlet("/admin/orders") 
public class OrderAdminS extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;
        
        // 1. KIỂM TRA QUYỀN ADMIN (Bảo vệ route)
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            
            // 2. Tải TẤT CẢ đơn hàng (Giả định OrderDAO có hàm getAllOrders() cho Admin)
            List<Order> orderList = orderDAO.getAllOrders(); // CẦN TẠO HÀM NÀY
            
            req.setAttribute("orderList", orderList);

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách đơn hàng.");
            e.printStackTrace();
        }

        // 3. Forward đến trang quản lý
        req.getRequestDispatcher("/order_admin.jsp").forward(req, resp);
    }
}