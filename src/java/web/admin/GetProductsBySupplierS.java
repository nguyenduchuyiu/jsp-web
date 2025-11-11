package web.admin;

import dao.ProdDAO;
import model.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.List;

@WebServlet("/admin/getproductsbysupplier")
public class GetProductsBySupplierS extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        String maNCCStr = req.getParameter("maNCC");
        
        if (maNCCStr == null || maNCCStr.isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }
        
        try {
            int maNCC = Integer.parseInt(maNCCStr);
            ProdDAO dao = new ProdDAO();
            List<Product> products = dao.getProductsBySupplier(maNCC);
            
            // Build JSON manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                if (i > 0) json.append(",");
                Product p = products.get(i);
                json.append("{");
                json.append("\"maSP\":\"").append(escapeJson(p.getMaSP())).append("\",");
                json.append("\"tenSP\":\"").append(escapeJson(p.getTenSP())).append("\"");
                json.append("}");
            }
            json.append("]");
            
            resp.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("[]");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}

