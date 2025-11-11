<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html>
    <head>
        <title>Cập Nhật Trạng Thái Đơn Hàng</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.0/dist/chart.min.js"></script>
    </head>
<body class="admin-page">
    <%@include file="/chung.jspf" %> 
    
    <div class="container page-content my-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <h2>CẬP NHẬT TRẠNG THÁI #${param.maDh}</h2>
                <hr>
                
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                
                <form method="POST" action="orderupdatestatus">
                    <input type="hidden" name="maDh" value="${param.maDh}"> 
                    
                    <div class="form-group mb-3">
                        <label class="form-label">Trạng Thái Hiện Tại:</label>
                        <%-- Giả định ${order.trangThai} đã được set từ Servlet --%>
                        <p class="form-control-plaintext fw-bold">Trạng thái hiện tại sẽ được hiển thị ở đây (Ví dụ: Đang Giao)</p>
                    </div>
                    
                    <div class="form-group mb-4">
                        <label class="form-label">Chọn Trạng Thái Mới:</label>
                        <select name="newStatus" class="form-select" required>
                            <option value="ChoThanhToan">Chờ Thanh Toán</option>
                            <option value="DangGiao">Đang Giao</option>
                            <option value="DaGiao">Đã Giao (Hoàn tất)</option>
                            <option value="DaHuy">Đã Hủy</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">Lưu Cập Nhật</button>
                    <a href="orders" class="btn btn-outline-secondary w-100 mt-2">Hủy bỏ</a>
                </form>
            </div>
        </div>
    </div>

    <%@include file="/footer.jspf" %>
</body>
</html>