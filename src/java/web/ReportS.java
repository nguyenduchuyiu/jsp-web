package web;

import dao.ProdDAO;
import dao.ReportDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
// Import tạm thời cho Product/ProdDAO để tải danh sách gợi ý sản phẩm
import model.Product;
// Giả định bạn có ReportDAO.java để xử lý logic CSDL phức tạp
// import dao.ReportDAO; 

@WebServlet("/admin/reports")
public class ReportS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            ProdDAO prodDAO = new ProdDAO();

            // Tải danh sách TẤT CẢ sản phẩm để cung cấp cho ô chọn (Select Box)
            List<Product> productList = prodDAO.getAllProducts();
            req.setAttribute("productList", productList);

            // Xử lý logic THỐNG KÊ (nếu người dùng bấm nút Thống kê - POST)
            // Tuy nhiên, báo cáo phức tạp thường được xử lý qua POST để tránh URL quá dài.
            // Tôi sẽ để trang này chỉ là GET (hiển thị form) và xử lý dữ liệu qua POST.
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi CSDL khi tải danh sách sản phẩm.");
            e.printStackTrace();
        }

        req.getRequestDispatcher("/reports.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String maSp = req.getParameter("maSp");
        String ngayBD = req.getParameter("ngayBatDau");
        String ngayKT = req.getParameter("ngayKetThuc");

        HttpSession session = req.getSession(false);
        // TODO: Check admin permission if needed

        if (maSp != null && !maSp.isEmpty() && ngayBD != null && ngayKT != null) {
            try {
                ReportDAO reportDAO = new ReportDAO();
                BigDecimal totalRevenue = reportDAO.getTotalRevenue(maSp, ngayBD, ngayKT);
                // Keep order with LinkedHashMap from DAO
                Map<String, Integer> dailySales = reportDAO.getDailySales(maSp, ngayBD, ngayKT);

                int inventoryCurrent = reportDAO.getInitialInventory(maSp);

                // Build JSON manually for JS
                java.util.List<String> labels = new java.util.ArrayList<>(dailySales.keySet());
                java.util.List<Integer> values = new java.util.ArrayList<>(dailySales.values());

                // Build JSON string for labels
                StringBuilder labelsJson = new StringBuilder("[");
                for (int i = 0; i < labels.size(); i++) {
                    if (i > 0) labelsJson.append(",");
                    labelsJson.append("\"").append(labels.get(i).replace("\"", "\\\"")).append("\"");
                }
                labelsJson.append("]");

                // Build JSON string for values
                StringBuilder valuesJson = new StringBuilder("[");
                for (int i = 0; i < values.size(); i++) {
                    if (i > 0) valuesJson.append(",");
                    valuesJson.append(values.get(i));
                }
                valuesJson.append("]");

                req.setAttribute("chartLabelsJson", labelsJson.toString()); // e.g. ["2025-11-01","2025-11-02"]
                req.setAttribute("chartDataJson", valuesJson.toString());   // e.g. [5,3,8]

                // Optional extras for header/summary
                req.setAttribute("inventoryRemaining", inventoryCurrent);
                req.setAttribute("reportGenerated", true);
                req.setAttribute("reportMaSp", maSp);
                req.setAttribute("reportNgayBD", ngayBD);
                req.setAttribute("reportNgayKT", ngayKT);
                req.setAttribute("totalRevenue", totalRevenue);
                // If you have this in DAO, you can also set:
                // req.setAttribute("totalRevenue", reportDAO.getTotalRevenue(maSp, ngayBD, ngayKT));
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi CSDL khi tạo báo cáo: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            req.setAttribute("error", "Vui lòng chọn sản phẩm và khoảng thời gian để thống kê.");
        }

        // Reload products
        try {
            ProdDAO prodDAO = new ProdDAO();
            req.setAttribute("productList", prodDAO.getAllProducts());
        } catch (Exception e) {
            // log if needed
        }

        req.getRequestDispatcher("/reports.jsp").forward(req, resp);
    }
}
