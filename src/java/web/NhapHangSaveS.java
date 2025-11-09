package web.admin;

import dao.NhapHangDAO;
import dao.ProdDAO;
import model.User;
import model.PhieuNhap;
import model.ChiTietPhieuNhap;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/nhaphangsave")
public class NhapHangSaveS extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("account") : null;

        // 1. KIỂM TRA QUYỀN ADMIN
        if (user == null || !"QuanTriVien".equalsIgnoreCase(user.getLoaiNguoiDung())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy dữ liệu Header
        String maNCCStr = req.getParameter("maNCC");
        String ghiChu = req.getParameter("ghiChu");
        
        // Lấy mảng dữ liệu chi tiết (từ form lặp lại)
        String[] maSPs = req.getParameterValues("maSP");
        String[] soLuongs = req.getParameterValues("soLuong");
        String[] giaNhaps = req.getParameterValues("giaNhap");

        if (maSPs == null || maSPs.length == 0 || maNCCStr == null || maNCCStr.isEmpty()) {
            session.setAttribute("error", "Vui lòng điền đủ thông tin NCC và ít nhất một sản phẩm.");
            resp.sendRedirect(req.getContextPath() + "/admin/live");
            return;
        }

        try {
            int maNCC = Integer.parseInt(maNCCStr);
            BigDecimal tongTien = BigDecimal.ZERO;
            List<ChiTietPhieuNhap> details = new ArrayList<>();
            
            // 2. XỬ LÝ VÀ TÍNH TOÁN TỔNG TIỀN (Build Details List)
            for (int i = 0; i < maSPs.length; i++) {
                String maSP = maSPs[i];
                int soLuong = Integer.parseInt(soLuongs[i]);
                // Chuẩn hóa giá nhập (loại bỏ dấu phẩy, v.v. nếu cần)
                BigDecimal giaNhap = new BigDecimal(giaNhaps[i].replace(",", "").trim());
                
                if (soLuong <= 0) continue; // Bỏ qua nếu số lượng không hợp lệ

                ChiTietPhieuNhap detail = new ChiTietPhieuNhap();
                detail.setMaSP(maSP);
                detail.setSoLuong(soLuong);
                detail.setGiaNhap(giaNhap);
                
                details.add(detail);
                tongTien = tongTien.add(detail.getThanhTien());
            }

            if (details.isEmpty()) {
                 session.setAttribute("error", "Phiếu nhập phải có ít nhất một sản phẩm hợp lệ.");
                 resp.sendRedirect(req.getContextPath() + "/admin/live");
                 return;
            }

            // 3. THỰC HIỆN LƯU GIAO TÁC (Transaction)
            PhieuNhap pn = new PhieuNhap();
            pn.setMaNCC(maNCC);
            pn.setTongTien(tongTien);
            pn.setGhiChu(ghiChu);
            pn.setMaNguoiLap(user.getMaND()); // Lấy MaND của Admin đang đăng nhập

            NhapHangDAO dao = new NhapHangDAO();
            String maPN = dao.savePhieuNhap(pn, details); // Hàm này thực hiện INSERT và tạo mã PN

            // 4. THÔNG BÁO THÀNH CÔNG VÀ CHUYỂN HƯỚNG
            session.setAttribute("success_admin", "Lập phiếu nhập thành công! Mã PN: " + maPN);
            resp.sendRedirect(req.getContextPath() + "/admin/live");
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Lỗi định dạng số lượng hoặc giá nhập không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/live");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi CSDL khi lưu phiếu nhập. Vui lòng kiểm tra log.");
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/live");
        }
    }
}