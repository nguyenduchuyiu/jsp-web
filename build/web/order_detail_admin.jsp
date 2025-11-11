<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Sản Phẩm (ADMIN)</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">  
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">  
    
   </head>
<body class="admin-page">
    <%@include file="/chung.jspf" %> 
    
    <div class="container page-content my-5">
        <h2>🧾 CHI TIẾT ĐƠN HÀNG #${param.maDh}</h2>
        <hr>
        
        <c:if test="${empty orderDetails}">
            <div class="alert alert-warning">Không tìm thấy chi tiết đơn hàng này.</div>
        </c:if>
        
        <c:if test="${not empty orderDetails}">
            
            <%-- Giả định đã có orderHeader được set ở OrderDetailAdminS --%>
            <%-- Nếu chưa, cần phải set/lấy thêm ở Servlet --%>
            
            <h4 class="mb-3">Thông tin Sản phẩm</h4>
            <table class="table table-bordered table-striped">
                <thead class="table-info">
                    <tr>
                        <th>Mã SP</th>
                        <th>Tên Sản Phẩm</th>
                        <th>Số Lượng</th>
                        <th>Giá Bán</th>
                        <th>Thành Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${orderDetails}">
                        <tr>
                            <td>${item.maSP}</td>
                            <td>${item.tenSP}</td>
                            <td>${item.soLuong}</td>
                            <td><fmt:formatNumber value="${item.gia}" pattern="#,###" /> VND</td>
                            <td><fmt:formatNumber value="${item.thanhTien}" pattern="#,###" /> VND</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
        </c:if>
        <a href="orders" class="btn btn-secondary mt-3">← Quay lại Quản lý Đơn hàng</a>
    </div>

    <%@include file="/footer.jspf" %>
</body>
</html>