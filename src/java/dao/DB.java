package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DB {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/web?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root"; 
    private static final String PASS = ""; 

    // Khối static để tải Driver chỉ MỘT LẦN khi class DB được load
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Ném RuntimeException nếu Driver không tìm thấy (lỗi nghiêm trọng)
            throw new RuntimeException("Lỗi: Không tìm thấy JDBC Driver cho MySQL.", e);
        }
    }

    public static Connection getCon() throws SQLException {
        // Driver đã được tải, chỉ cần gọi getConnection
        // Loại bỏ ClassNotFoundException khỏi hàm throws vì nó đã được xử lý ở khối static
        return DriverManager.getConnection(URL, USER, PASS);
    }
}