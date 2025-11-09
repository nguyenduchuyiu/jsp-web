package web;

import dao.ProdDAO; // <-- THÊM DÒNG NÀY (Để sử dụng ProdDAO)
import model.Product; // <-- THÊM DÒNG NÀY (Dù không trực tiếp dùng, nên thêm để đảm bảo)

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/detail")
public class Detail extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String maSp = req.getParameter("maSp");
        
        if (maSp != null && !maSp.isEmpty()) {
            try {
                // Code hiện tại đã đúng sau khi thêm import
                ProdDAO dao = new ProdDAO();
                req.setAttribute("product", dao.getProductById(maSp));
            } catch (Exception e) { 
                req.setAttribute("error", "Không tìm thấy chi tiết sản phẩm.");
                e.printStackTrace(); // Nên có để debug
            }
        }
        
        req.getRequestDispatcher("/detail.jsp").forward(req, resp);
    }
}