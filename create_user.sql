-- Tạo user MySQL cho ứng dụng web
CREATE USER IF NOT EXISTS 'webapp'@'localhost' IDENTIFIED BY 'webapp123';
GRANT ALL PRIVILEGES ON web.* TO 'webapp'@'localhost';
FLUSH PRIVILEGES;

