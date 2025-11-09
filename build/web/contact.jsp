<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liên Hệ Với Chúng Tôi</title>
</head>
<body>
    <%@include file="header.jspf" %>
    
    <div class="container-fluid page-content">
        <div class="row">
            <div class="col-md-3 filter-sidebar">
                </div>
            <div class="col-md-9 product-area">
                <h2>GỬI Ý KIẾN LIÊN HỆ ĐẾN QUẢN TRỊ</h2>
                
                <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                <form method="POST" action="contact" class="contact-form">
                    <div class="form-group mb-3"><label>Họ Tên (*):</label><input type="text" name="name" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Email (*):</label><input type="email" name="email" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Tiêu Đề (*):</label><input type="text" name="subject" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Nội Dung (*):</label><textarea name="content" rows="5" class="form-control" required></textarea></div>
                    <button type="submit" class="btn btn-primary">Gửi Ý Kiến</button>
                </form>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
</body>
</html>