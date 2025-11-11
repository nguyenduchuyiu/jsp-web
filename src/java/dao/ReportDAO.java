package dao;

import model.RevenueReportItem;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ReportDAO {

    // 1. Thống kê số lượng bán ra hàng ngày
    public Map<String, Integer> getDailySales(String maSp, String ngayBatDau, String ngayKetThuc) throws Exception {
        // Dùng LinkedHashMap để giữ thứ tự ngày tháng
        Map<String, Integer> dailySales = new LinkedHashMap<>();

        // Truy vấn CSDL: JOIN donhang (chi tiết) và chitietdonhang (header)
        String sql = "SELECT DATE(dh.NgayDatHang) AS saleDate, SUM(d.SoLuong) AS totalSold "
                + "FROM donhang d "
                + "JOIN chitietdonhang dh ON d.MaDH = dh.MaDH "
                + "WHERE d.MaSP = ? AND DATE(dh.NgayDatHang) BETWEEN ? AND ? "
                + "GROUP BY saleDate "
                + "ORDER BY saleDate ASC";

        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maSp);
            ps.setString(2, ngayBatDau);
            ps.setString(3, ngayKetThuc);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                dailySales.put(rs.getString("saleDate"), rs.getInt("totalSold"));
            }
        }
        return dailySales;
    }

    // 2. Lấy Số lượng tồn kho ban đầu (hoặc hiện tại)
    public int getInitialInventory(String maSp) throws Exception {
        String sql = "SELECT SoLuongTon FROM sanpham WHERE MaSP = ?";
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maSp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("SoLuongTon");
            }
        }
        return 0;
    }
    public BigDecimal getTotalRevenue(String maSp, String ngayBatDau, String ngayKetThuc) throws Exception {
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        String sql = "SELECT SUM(d.SoLuong * d.GiaBan) AS totalRevenue " +
                     "FROM donhang d " +
                     "JOIN chitietdonhang dh ON d.MaDH = dh.MaDH " +
                     "WHERE d.MaSP = ? AND DATE(dh.NgayDatHang) BETWEEN ? AND ?";
                     
        try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maSp);
            ps.setString(2, ngayBatDau);
            ps.setString(3, ngayKetThuc);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Lấy kết quả SUM, có thể là NULL nếu không bán được gì
                BigDecimal revenue = rs.getBigDecimal("totalRevenue");
                if (revenue != null) {
                    totalRevenue = revenue;
                }
            }
        }
        return totalRevenue;
    }
    public List<RevenueReportItem> getSoldProductsInRange(String ngayBatDau, String ngayKetThuc) throws Exception {
    List<RevenueReportItem> list = new ArrayList<>();
    
    // JOIN 3 bảng: donhang (lấy SL, GiaBan), chitietdonhang (lấy NgayDatHang), sanpham (lấy TenSP)
    String sql = "SELECT d.MaSP, s.TenSP, SUM(d.SoLuong) AS TongSoLuong, SUM(d.SoLuong * d.GiaBan) AS TongDoanhThu " +
                 "FROM donhang d " +
                 "JOIN chitietdonhang dh ON d.MaDH = dh.MaDH " +
                 "JOIN sanpham s ON d.MaSP = s.MaSP " +
                 "WHERE DATE(dh.NgayDatHang) BETWEEN ? AND ? " +
                 "GROUP BY d.MaSP, s.TenSP " +
                 "ORDER BY TongDoanhThu DESC"; // Sắp xếp theo doanh thu cao nhất
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, ngayBatDau);
        ps.setString(2, ngayKetThuc);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            RevenueReportItem item = new RevenueReportItem();
            item.setMaSP(rs.getString("MaSP"));
            item.setTenSP(rs.getString("TenSP"));
            item.setTongSoLuong(rs.getInt("TongSoLuong"));
            item.setTongDoanhThu(rs.getBigDecimal("TongDoanhThu"));
            list.add(item);
        }
    }
    return list;
    }
    public BigDecimal getTotalRevenueInRange(String ngayBatDau, String ngayKetThuc) throws Exception {
    BigDecimal totalRevenue = BigDecimal.ZERO;
    
    String sql = "SELECT SUM(d.SoLuong * d.GiaBan) AS TongTatCa " +
                 "FROM donhang d " +
                 "JOIN chitietdonhang dh ON d.MaDH = dh.MaDH " +
                 "WHERE DATE(dh.NgayDatHang) BETWEEN ? AND ?";
    
    try (Connection con = DB.getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, ngayBatDau);
        ps.setString(2, ngayKetThuc);
        
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            BigDecimal revenue = rs.getBigDecimal("TongTatCa");
            if (revenue != null) {
                totalRevenue = revenue;
            }
        }
    }
    return totalRevenue;
}
}
