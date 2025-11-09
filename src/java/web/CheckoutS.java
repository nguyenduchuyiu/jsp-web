package web;

import dao.CartDAO;
import model.CartItem;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.math.BigDecimal;
import java.util.ArrayList; // Thêm import này

@WebServlet("/checkout")
public class CheckoutS extends HttpServlet {
    
    
    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    
    // Nếu ai đó cố gắng truy cập /checkout bằng GET, chuyển hướng họ về Giỏ hàng.
    // Điều này ngăn chặn lỗi HTTP 405.
    resp.sendRedirect("cart"); 
}

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User)session.getAttribute("account") : null;

        if (user == null) {
            resp.sendRedirect("login"); 
            return;
        }

        // 1. Lấy chuỗi ID sản phẩm được chọn từ input ẩn
        String selectedIdsString = req.getParameter("selectedItemsString"); // ID từ cart.jsp
        
        if (selectedIdsString == null || selectedIdsString.isEmpty()) {
            session.setAttribute("error_cart", "Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
            resp.sendRedirect("cart");
            return;
        }

        // 2. Chuyển chuỗi "ID1,ID2,ID3" thành List<String>
        List<String> selectedMaCtghs = Arrays.asList(selectedIdsString.split(","))
                                              .stream()
                                              .map(String::trim)
                                              .filter(s -> !s.isEmpty()) // Lọc bỏ chuỗi rỗng
                                              .collect(Collectors.toList());
        
        if (selectedMaCtghs.isEmpty()) {
            session.setAttribute("error_cart", "Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
            resp.sendRedirect("cart");
            return;
        }

        try {
            CartDAO cartDAO = new CartDAO();
            
            // LƯU Ý QUAN TRỌNG: Gọi hàm DAO MỚI để lấy chi tiết CỦA CÁC MỤC ĐÃ CHỌN
            List<CartItem> selectedItems = cartDAO.getSelectedCartItems(selectedMaCtghs);
            
            // 4. Tính toán tổng tiền chỉ dựa trên các mục đã chọn
            BigDecimal tongHang = BigDecimal.ZERO;
            for (CartItem item : selectedItems) {
                tongHang = tongHang.add(item.getThanhTien());
            }

            // Phí vận chuyển (Giả định 30.000 VNĐ)
            BigDecimal shippingFee = new BigDecimal("30000");
            BigDecimal totalFinal = tongHang.add(shippingFee);

            // 5. LƯU THÔNG TIN ĐÃ ĐƯỢC LỌC VÀO REQUEST/SESSION
            // Lưu orderItemsSession và totalFinalSession vào Session cho PlaceOrderS (nếu cần)
            session.setAttribute("orderItemsSession", selectedItems); 
            session.setAttribute("totalFinalSession", totalFinal); 
            
            // Lưu thông tin cần thiết vào Request (để hiển thị orders.jsp)
            req.setAttribute("userInfo", user); 
            req.setAttribute("orderItems", selectedItems); // CHỈ TRUYỀN CÁC MỤC ĐÃ CHỌN
            req.setAttribute("tongHang", tongHang);
            req.setAttribute("shippingFee", shippingFee);

            // 6. Chuyển hướng đến trang đặt hàng
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
            
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi CSDL hoặc xử lý đơn hàng. Vui lòng kiểm tra log.");
            e.printStackTrace();
            resp.sendRedirect("cart");
        }
    }
}