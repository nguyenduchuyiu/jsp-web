#!/bin/bash

# Script tạo user MySQL cho ứng dụng web

echo "Đang tạo user MySQL cho ứng dụng..."

# Thử kết nối với sudo
if sudo mysql -u root -e "SELECT 1" &>/dev/null; then
    MYSQL_CMD="sudo mysql -u root"
else
    echo "Lỗi: Cần quyền sudo để tạo user MySQL"
    echo "Vui lòng chạy: sudo ./setup_db_user.sh"
    exit 1
fi

# Tạo user và cấp quyền
$MYSQL_CMD <<EOF
-- Tạo user nếu chưa tồn tại
CREATE USER IF NOT EXISTS 'webapp'@'localhost' IDENTIFIED BY 'webapp123';

-- Cấp quyền truy cập database web
GRANT ALL PRIVILEGES ON web.* TO 'webapp'@'localhost';

-- Áp dụng thay đổi
FLUSH PRIVILEGES;

-- Hiển thị thông tin user
SELECT user, host FROM mysql.user WHERE user='webapp';
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Đã tạo user MySQL thành công!"
    echo "  User: webapp"
    echo "  Password: webapp123"
    echo "  Database: web"
    echo ""
    echo "Đang cập nhật file DB.java..."
else
    echo "Lỗi: Không thể tạo user MySQL"
    exit 1
fi

