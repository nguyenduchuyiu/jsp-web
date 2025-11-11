package dao;

import model.Product;
import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ProdDAO {
    
    // Hàm ánh xạ (map) giúp code gọn hơn
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setMaSP(rs.getString("MaSP")); p.setTenSP(rs.getString("TenSP"));
        p.setGia(rs.getBigDecimal("Gia")); p.setHinhAnh(rs.getString("HinhAnh"));
        p.setDonVi(rs.getString("DonVi")); p.setThuongHieu(rs.getString("ThuongHieu"));
        p.setMoTa(rs.getString("MoTa")); p.setHuongDan(rs.getString("HuongDanSuDung"));
        p.setSoLuongTon(rs.getInt("SoLuongTon")); p.setMaDM(rs.getInt("MaDM"));
        p.setXuatXu(rs.getString("XuatXu")); 
        return p;
    }
    public List<Category> getAllCategories() throws SQLException, ClassNotFoundException {
    List<Category> categories = new ArrayList<>();
    // Truy vấn MaDM, TenDanhMuc từ bảng danhmuc
    String sql = "SELECT MaDM, TenDanhMuc FROM danhmuc ORDER BY MaDM ASC";
    try (Connection con = DB.getCon(); Statement stmt = con.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            Category cat = new Category();
            cat.setId(rs.getInt("MaDM"));
            cat.setName(rs.getString("TenDanhMuc"));
            // Bỏ hàm countProductsByDM() để tránh lỗi nếu chưa có
            // Nếu bạn có hàm này và nó hoạt động, hãy giữ lại
            // cat.setCount(this.countProductsByDM(cat.getId())); 
            categories.add(cat);
        }
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return categories;
}
    
    public Product getProductById(String maSp) {
    Product p = null;
    String sql = "SELECT * FROM sanpham WHERE MaSP = ?"; 
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, maSp);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            // Giả sử mapProduct là một hàm hợp lệ để ánh xạ ResultSet sang Product
            p = mapProduct(rs); 
        }
    } catch (Exception e) { 
        // Lỗi này thường do ClassNotFoundException (Driver MySQL) hoặc SQLException
        e.printStackTrace(); 
    }
    return p;
}
    // =======================================================
    // PHƯƠNG THỨC LỌC ĐỘNG, SẮP XẾP, VÀ TÌM KIẾM
    // =======================================================
    // THÊM THAM SỐ CUỐI CÙNG: String keyword
  public List<Product> getFilteredProducts(String sortBy, String[] xuatXuArr, String[] donViArr, String[] giaArr, String keyword, Integer maDm) {
    List<Product> list = new ArrayList<>();
    
    StringBuilder sql = new StringBuilder("SELECT * FROM sanpham");
    List<Object> params = new ArrayList<>(); 
    
    sql.append(" WHERE 1=1 "); 

    // 1. LỌC THEO MA DANH MỤC (Integer)
    if (maDm != null) {
        sql.append(" AND MaDM = ? ");
        params.add(maDm); 
    }
    
    // 2. LỌC THEO TỪ KHÓA TÌM KIẾM (String)
    if (keyword != null && !keyword.isEmpty()) {
        sql.append(" AND TenSP LIKE ? ");
        params.add("%" + keyword + "%"); 
    }

    // 3. Lọc theo Xuất xứ (String)
    if (xuatXuArr != null && xuatXuArr.length > 0) {
        sql.append(" AND XuatXu IN (");
        for (int i = 0; i < xuatXuArr.length; i++) {
            sql.append("?");
            if (i < xuatXuArr.length - 1) sql.append(",");
            params.add(xuatXuArr[i]); 
        }
        sql.append(")");
    }
    
    // 4. Lọc theo Đơn vị tính (String)
    if (donViArr != null && donViArr.length > 0) {
        sql.append(" AND DonVi IN (");
        for (int i = 0; i < donViArr.length; i++) {
            sql.append("?");
            if (i < donViArr.length - 1) sql.append(",");
            params.add(donViArr[i]); 
        }
        sql.append(")");
    }
    
    // 5. Lọc theo Giá bán (Range) (BigDecimal) - ĐÃ THÊM LÀM SẠCH CHUỖI
    if (giaArr != null && giaArr.length > 0) {
        sql.append(" AND (");
        for (int i = 0; i < giaArr.length; i++) {
            String[] range = giaArr[i].split("-"); 
            if (range.length == 2) {
                if (i > 0) sql.append(" OR ");
                
                sql.append("(Gia >= ? AND Gia <= ?)");
                
                // QUAN TRỌNG: Làm sạch chuỗi trước khi tạo BigDecimal
                String minStr = range[0].trim();
                String maxStr = range[1].trim();

                params.add(new BigDecimal(minStr)); 
                params.add(new BigDecimal(maxStr)); 
            }
        }
        sql.append(")");
    }

    // 6. Thêm Sắp xếp
    String orderBy = " ORDER BY MaSP DESC"; 
    if ("asc".equalsIgnoreCase(sortBy)) {
        orderBy = " ORDER BY Gia ASC";
    } else if ("desc".equalsIgnoreCase(sortBy)) {
        orderBy = " ORDER BY Gia DESC";
    }
    sql.append(orderBy);

    // Thực thi truy vấn
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
        
        int index = 1; 
        for (Object param : params) {
            
            // XỬ LÝ KIỂU DỮ LIỆU ĐỂ GÁN CHÍNH XÁC
            if (param instanceof Integer) {
                ps.setInt(index++, (Integer) param);
            } else if (param instanceof String) {
                ps.setString(index++, (String) param);
            } else if (param instanceof BigDecimal) {
                // Đảm bảo BigDecimal được set đúng
                ps.setBigDecimal(index++, (BigDecimal) param);
            }
        }
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) list.add(mapProduct(rs));
        
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return list;
}
  
  // Hàm 1: Lấy tất cả sản phẩm (Không lọc) - Dùng cho Admin
public List<model.Product> getAllProducts() {
    List<model.Product> list = new ArrayList<>();
    String sql = "SELECT * FROM sanpham ORDER BY MaSP DESC"; 
    try (Connection con = DB.getCon(); 
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) list.add(mapProduct(rs)); // Giả sử mapProduct đã có
        
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return list;
}

// Hàm 2: Thêm Sản phẩm mới (CREATE)
public void addProduct(model.Product p) throws SQLException, ClassNotFoundException {
    String sql = "INSERT INTO sanpham (MaSP, TenSP, Gia, HinhAnh, DonVi, ThuongHieu, XuatXu, MoTa, HuongDanSuDung, SoLuongTon, MaDM) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, p.getMaSP());
        ps.setString(2, p.getTenSP());
        ps.setBigDecimal(3, p.getGia());
        ps.setString(4, p.getHinhAnh());
        ps.setString(5, p.getDonVi());
        ps.setString(6, p.getThuongHieu());
        ps.setString(7, p.getXuatXu());
        ps.setString(8, p.getMoTa());
        ps.setString(9, p.getHuongDan());
        ps.setInt(10, p.getSoLuongTon());
        ps.setInt(11, p.getMaDM());
        ps.executeUpdate();
    }
}

// Hàm 3: Cập nhật Sản phẩm (UPDATE)
public void updateProduct(model.Product p) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE sanpham SET TenSP=?, Gia=?, HinhAnh=?, DonVi=?, ThuongHieu=?, XuatXu=?, MoTa=?, HuongDanSuDung=?, SoLuongTon=?, MaDM=? WHERE MaSP=?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, p.getTenSP());
        ps.setBigDecimal(2, p.getGia());
        ps.setString(3, p.getHinhAnh());
        ps.setString(4, p.getDonVi());
        ps.setString(5, p.getThuongHieu());
        ps.setString(6, p.getXuatXu());
        ps.setString(7, p.getMoTa());
        ps.setString(8, p.getHuongDan());
        ps.setInt(9, p.getSoLuongTon());
        ps.setInt(10, p.getMaDM());
        ps.setString(11, p.getMaSP()); // Mã SP dùng trong điều kiện WHERE
        ps.executeUpdate();
    }
}

// Hàm 4: Xóa Sản phẩm (DELETE)
public boolean deleteProduct(String maSp) {
    String sql = "DELETE FROM sanpham WHERE MaSP = ?";
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, maSp);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

// Hàm 5: Lấy sản phẩm theo nhà cung cấp (dựa trên lịch sử nhập hàng)
public List<Product> getProductsBySupplier(int maNCC) {
    List<Product> list = new ArrayList<>();
    // Lấy các sản phẩm đã từng được nhập từ nhà cung cấp này
    String sql = "SELECT DISTINCT sp.* FROM sanpham sp "
               + "INNER JOIN chitietphieunhap ct ON sp.MaSP = ct.MaSP "
               + "INNER JOIN phieunhap pn ON ct.MaPN = pn.MaPN "
               + "WHERE pn.MaNCC = ? "
               + "ORDER BY sp.MaSP DESC";
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, maNCC);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapProduct(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}