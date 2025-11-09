<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Nhập Tài Khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-white text-center">
                        <h2 class="mb-0 text-tmn-red" style="font-weight: 900;">ĐĂNG NHẬP HỆ THỐNG</h2>
                    </div>
                    <div class="card-body p-4">
                        
                        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
                        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                        <form method="POST" action="login">
                            <div class="form-group mb-3">
                                <label for="user" class="form-label">Tên Đăng Nhập:</label>
                                <input type="text" id="user" name="user" class="form-control" required>
                            </div>
                            <div class="form-group mb-4">
                                <label for="pass" class="form-label">Mật Khẩu:</label>
                                <input type="password" id="pass" name="pass" class="form-control" required>
                            </div>
                            
                            <button type="submit" class="btn bg-tmn-red text-white w-100 mb-3" 
                                    style="font-weight: 700; font-size: 1.1em;">Đăng nhập</button>
                            <p class="mt-3 text-center">
                                Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
                            </p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>