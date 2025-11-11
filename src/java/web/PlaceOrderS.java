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
import dao.KhuyenMaiDAO;
import model.KhuyenMai;
// ENDKM

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
        
                // LẤY DỮ LIỆU KHUYẾN MÃI TỪ FORM
        String selectedMaKMStr = req.getParameter("selectedMaKM"); // MaKM đã chọn
        String giamGiaStr = req.getParameter("giamGiaHienThi");     // CẦN THÊM INPUT ẨN NÀY VÀO JSP
        
        // 2. Lấy dữ liệu Giỏ hàng từ SESSION
        @SuppressWarnings("unchecked")
        List<CartItem> orderItems = (List<CartItem>) session.getAttribute("orderItemsSession"); 
        BigDecimal totalFinal = (BigDecimal) session.getAttribute("totalFinalSession"); 
        BigDecimal tongHang = BigDecimal.ZERO;
        

        
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
// XỬ LÝ KHUYẾN MÃI VÀ GIẢM GIÁ
        int maKM = 0;
        BigDecimal giamGia = BigDecimal.ZERO;
        
        if (selectedMaKMStr != null && !selectedMaKMStr.isEmpty()) {
             try {
                maKM = Integer.parseInt(selectedMaKMStr);
                
                // GIẢI QUYẾT GIAM GIA: Cần lấy giá trị giảm giá ĐÃ TÍNH TOÁN từ JavaScript
                // GIẢ ĐỊNH BẠN ĐÃ THÊM INPUT ẨN CÓ ID/NAME LÀ 'giamGiaInput' VÀO orders.jsp
                String finalGiamGiaStr = req.getParameter("giamGiaInput"); 
                
                if (finalGiamGiaStr != null && !finalGiamGiaStr.isEmpty()) {
                    // Chuyển đổi chuỗi tiền tệ (có thể chứa dấu phẩy/chấm) về BigDecimal
                    // Nếu JS chỉ trả về số nguyên (VD: 110000), việc parse sẽ dễ dàng hơn
                    giamGia = new BigDecimal(finalGiamGiaStr.replaceAll("[^0-9]", "")); // Loại bỏ dấu phân cách
                }
                
                // CẬP NHẬT TỔNG TIỀN CUỐI CÙNG (Trừ đi giảm giá)
                // LƯU Ý: totalFinal BAN ĐẦU là (Tiền hàng + Phí VC). 
                // Ta phải trừ giảm giá khỏi nó để lưu vào DB.
                totalFinal = totalFinal.subtract(giamGia);

            } catch (Exception e) {
                // Lỗi xử lý KM/parse, coi như không áp dụng KM
                maKM = 0;
                giamGia = BigDecimal.ZERO;
            }
        }
        // ENDKM

        try {
            OrderDAO orderDAO = new OrderDAO();
            
            // 3. Thực hiện lưu đơn hàng
            int maDH = orderDAO.saveOrder(user, orderItems, totalFinal, 
                                          receiverName, receiverPhone, 
                                          shippingAddress, paymentMethod, notes,
                                          // THAM SỐ MỚI
                                          maKM, giamGia);


            
            // 4. Xóa các biến session tạm thời (Chỉ xóa sau khi lưu CSDL thành công)
            session.removeAttribute("orderItemsSession");
            session.removeAttribute("totalFinalSession");
            
            // 5. CHUYỂN HƯỚNG DỰA TRÊN PHƯƠNG THỨC THANH TOÁN
            if ("ChuyenKhoan".equals(paymentMethod)) {
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