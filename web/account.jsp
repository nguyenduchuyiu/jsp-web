<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cập Nhật Tài Khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
</head>
<body>
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2>CẬP NHẬT THÔNG TIN TÀI KHOẢN</h2>
                
                <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                <%-- Lấy đối tượng User từ session --%>
                <c:set var="u" value="${sessionScope.account}"/>
                
                <form method="POST" action="account" class="p-4 border shadow-sm bg-white">
                    
                    <div class="form-group mb-3">
                        <label>Tên Đăng Nhập:</label>
                        <input type="text" class="form-control" value="${u.user}" disabled>
                    </div>

                    <div class="form-group mb-3">
                        <label>Họ Tên:</label>
                        <input type="text" name="name" class="form-control" value="${u.name}" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label>Email:</label>
                        <input type="email" name="email" class="form-control" value="${u.email}" required>
                    </div>
                    
                    <div class="form-group mb-3">
                        <label>Số Điện Thoại:</label>
                        <input type="text" name="phone" class="form-control" value="${u.phone}">
                    </div>
                    
                    <div class="form-group mb-4">
                        <label>Địa Chỉ:</label>
                        <input type="text" name="address" class="form-control" value="${u.address}">
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100 mb-4">Cập Nhật Thông Tin</button>
                    
                    <hr>
                    
                    <h4>Đổi Mật Khẩu</h4>
                    
                    <div class="form-group mb-3">
                        <label>Mật khẩu mới:</label>
                        <input type="password" name="newPass" class="form-control" placeholder="Để trống nếu không đổi mật khẩu">
                    </div>
                    
                    <div class="form-group mb-3">
                        <label>Nhập lại mật khẩu mới:</label>
                        <input type="password" name="rePass" class="form-control">
                    </div>

                    <button type="submit" class="btn btn-warning w-100">Đổi Mật Khẩu</button>
                </form>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
</body>
</html>