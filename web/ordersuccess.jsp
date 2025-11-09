<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt Hàng Thành Công</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg border-0 text-center">
                    <div class="card-header bg-success text-white">
                        <h2 class="mb-0" style="font-weight: 700;"><i class="fa fa-check-circle"></i> ĐẶT HÀNG THÀNH CÔNG</h2>
                    </div>
                    <div class="card-body p-5">
                        
                        <c:if test="${not empty sessionScope.success_order}">
                            <p class="h4 text-success mb-4">${sessionScope.success_order}</p>
                            <c:remove var="success_order" scope="session"/> 
                        </c:if>

                        <p class="lead">Cảm ơn bạn đã tin tưởng và đặt hàng tại TMN Shop!</p>
                        
                        <c:if test="${not empty param.maDh}">
                            <p class="h5 mt-4">Mã Đơn hàng của bạn là: <strong class="text-danger">#${param.maDh}</strong></p>
                            <p class="text-muted">Đơn hàng của bạn sẽ được xử lý sớm nhất. Vui lòng chuẩn bị tiền mặt để thanh toán khi nhận hàng.</p>
                        </c:if>
                        
                        <a href="home" class="btn btn-outline-secondary mt-3">Tiếp tục Mua sắm</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
</body>
</html>