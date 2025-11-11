package web;

import dao.OrderDAO;
import model.User;
import model.Order; // Cần thiết nếu bạn muốn hiển thị trạng thái hiện tại
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Ánh xạ URL: /admin/orderupdatestatus
@WebServlet("/admin/orderupdatestatus") 
public class OrderUpdateStatusAdminS extends HttpServlet {

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
            resp.sendRedirect("orders"); // Quay lại trang QL Đơn hàng
            return;
        }

        try {
            int maDh = Integer.parseInt(maDhStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // Lấy thông tin đơn hàng hiện tại để hiển thị trên form (Trạng thái cũ)
            // LƯU Ý: HÀM getOrderById() PHẢI ĐƯỢC THÊM VÀO OrderDAO
            // Order order = orderDAO.getOrderById(maDh); 
            
            // req.setAttribute("order", order); // Truyền đối tượng đơn hàng
            req.setAttribute("maDh", maDh); // Truyền mã đơn hàng
            
            req.getRequestDispatcher("/order_update_status.jsp").forward(req, resp);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error_admin", "Mã đơn hàng không hợp lệ.");
            resp.sendRedirect("orders");
        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi khi tải thông tin đơn hàng.");
            e.printStackTrace();
            resp.sendRedirect("orders");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) { 
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        
        String maDhStr = req.getParameter("maDh");
        String newStatus = req.getParameter("newStatus"); // Trạng thái mới từ form
        
        if (maDhStr == null || maDhStr.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            session.setAttribute("error_admin", "Thiếu Mã Đơn hàng hoặc Trạng thái mới.");
            resp.sendRedirect("orders"); 
            return;
        }

        try {
            int maDh = Integer.parseInt(maDhStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // 2. Cập nhật trạng thái trong CSDL
            if (orderDAO.updateOrderStatus(maDh, newStatus)) { // Hàm này đã có trong OrderDAO
                session.setAttribute("success_admin", "Cập nhật trạng thái đơn hàng #" + maDh + " thành công (" + newStatus + ").");
            } else {
                session.setAttribute("error_admin", "Lỗi CSDL: Không tìm thấy đơn hàng hoặc không thể cập nhật trạng thái.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error_admin", "Mã đơn hàng không hợp lệ.");
        } catch (Exception e) {
            session.setAttribute("error_admin", "Lỗi hệ thống khi cập nhật đơn hàng.");
            e.printStackTrace();
        }

        // Chuyển hướng về trang quản lý đơn hàng
        resp.sendRedirect("orders"); 
    }
}