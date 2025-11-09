<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<head>
    <title>Thêm Khuyến Mãi Mới</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">  
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">  
</head>

<body class="admin-page">
    <%@include file="header_admin.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <h2>📝 THÊM CHƯƠNG TRÌNH KHUYẾN MÃI MỚI</h2>
                <hr>
                
                <c:if test="${not empty sessionScope.error_admin}">
                    <div class="alert alert-danger">${sessionScope.error_admin}</div>
                    <c:remove var="error_admin" scope="session"/>
                </c:if>

                <form method="POST" action="addkhuyenmai" class="p-4 border shadow-sm bg-white">
                    
                    <div class="form-group mb-3">
                        <label>Tên Chương Trình (*):</label>
                        <input type="text" name="tenKM" class="form-control" required>
                    </div>

                    <div class="form-group mb-3">
                        <label>Mô Tả Chi Tiết:</label>
                        <textarea name="moTa" rows="3" class="form-control"></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 form-group mb-3">
                            <label>Ngày Bắt Đầu (*):</label>
                            <input type="date" name="ngayBatDau" class="form-control" required>
                        </div>
                        <div class="col-md-6 form-group mb-4">
                            <label>Ngày Kết Thúc (*):</label>
                            <input type="date" name="ngayKetThuc" class="form-control" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg w-100">Thêm Khuyến Mãi</button>
                    <a href="${pageContext.request.contextPath}/khuyenmai" class="btn btn-outline-secondary mt-3 w-100">Hủy bỏ</a>
                </form>
            </div>
        </div>
    </div>
    
   <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>