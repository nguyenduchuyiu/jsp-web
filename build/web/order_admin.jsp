<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Đơn Hàng (ADMIN)</title>
    <%-- LƯU Ý: KHÔNG INCLUDE CSS/Bootstrap Ở ĐÂY, VÌ CHUNG.JSPF ĐÃ LÀM THAY (THÔNG QUA header_admin.jspf) --%>
    <style>
        .admin-table img { max-width: 50px; height: auto; }
        .status-pill-ChoThanhToan { background-color: #ffc107; color: #333; }
        .status-pill-DangGiao { background-color: #17a2b8; color: white; }
        .status-pill-DaGiao { background-color: #28a745; color: white; }
        .status-pill-DaHuy { background-color: #dc3545; color: white; }
    </style>
</head>
<body class="admin-page">
    
    <%-- 1. BAO GỒM HEADER VÀ CÁC THẺ CSS/JS CẦN THIẾT --%>
    <%@include file="/chung.jspf" %> 
    
    <div class="container-fluid page-content my-5">
        
        <h2 class="mb-4"><i class="fa fa-file-invoice"></i> QUẢN LÝ ĐƠN HÀNG</h2>
        <hr>
        
        <%-- KHỐI THÔNG BÁO --%>
        <c:if test="${not empty sessionScope.success_admin}">
            <div class="alert alert-success">${sessionScope.success_admin}</div>
            <c:remove var="success_admin" scope="session"/>
        </c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
        
        <c:choose>
            <c:when test="${empty orderList}">
                <div class="alert alert-warning text-center mt-4">Không tìm thấy đơn hàng nào.</div>
            </c:when>
            
            <c:otherwise>
                <table class="table table-bordered table-striped admin-table">
                    <thead class="table-dark">
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Ngày Đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng Thái</th>
                            <th>PTTT</th>
                            <th>Người Nhận</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td>#DH${order.maDH}</td>
                                <td><fmt:formatDate value="${order.ngayDat}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td><fmt:formatNumber value="${order.tongTien}" pattern="#,###" /> VND</td>
                                <td>
                                    <span class="badge status-pill-${order.trangThai}">
                                        ${order.trangThai}
                                    </span>
                                </td>
                                <td>${order.phuongThucThanhToan}</td>
                                <td>${order.tenNguoiNhan} (${order.sdtNguoiNhan})</td>
                                <td>
                                    <a href="orderdetailadmin?maDh=${order.maDH}" class="btn btn-sm btn-info me-2">
                                        <i class="fa fa-info-circle"></i> Chi tiết
                                    </a>
                                    <a href="orderupdatestatus?maDh=${order.maDH}" class="btn btn-sm btn-warning">
                                        <i class="fa fa-pencil-alt"></i> Cập nhật
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </div>
   <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>