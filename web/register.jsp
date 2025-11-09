<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Ký Tài Khoản</title>
    <link rel="stylesheet" href="css/bootstrap.min.css"> 
    <link rel="stylesheet" href="css/style.css"> 
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container-fluid page-content">
        <div class="row">
            <div class="col-md-3 filter-sidebar">
                </div>
            <div class="col-md-9 product-area">
                <h2>ĐĂNG KÝ TÀI KHOẢN MỚI</h2>
                
                <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                <form method="POST" action="register" class="register-form">
                    <div class="form-group mb-3"><label>Họ Tên (*):</label><input type="text" name="name" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Tên Đăng Nhập (*):</label><input type="text" name="user" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Email (*):</label><input type="email" name="email" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Số Điện Thoại:</label><input type="text" name="phone" class="form-control"></div>
                    <div class="form-group mb-3"><label>Địa Chỉ:</label><input type="text" name="address" class="form-control"></div>
                    <div class="form-group mb-3"><label>Mật Khẩu (*):</label><input type="password" name="pass" class="form-control" required></div>
                    <div class="form-group mb-3"><label>Nhập Lại Mật Khẩu (*):</label><input type="password" name="rePass" class="form-control" required></div>
                    <button type="submit" class="btn btn-primary">Đăng Ký</button>
                </form>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
</body>
</html>