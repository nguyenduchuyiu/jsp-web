<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chương Trình Khuyến Mãi</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        
        <h2>🔥 CÁC CHƯƠNG TRÌNH KHUYẾN MÃI ĐANG DIỄN RA</h2>
        <hr>

        <%-- HIỂN THỊ THÔNG BÁO THÀNH CÔNG/LỖI TỪ SERVLET ADMIN --%>
        <c:if test="${not empty sessionScope.success_admin}">
            <div class="alert alert-success">${sessionScope.success_admin}</div>
            <c:remove var="success_admin" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error_admin}">
            <div class="alert alert-danger">${sessionScope.error_admin}</div>
            <c:remove var="error_admin" scope="session"/>
        </c:if>
        
        <%-- KHỐI CHỨC NĂNG ADMIN: NÚT THÊM (CHỈ HIỂN THỊ MỘT LẦN) --%>
        <c:if test="${isAdmin}">
            <div class="alert alert-info d-flex justify-content-between align-items-center mb-4">
                <span>Bạn đang ở chế độ Quản trị, có thể thêm/xóa khuyến mãi.</span>
                <a href="admin/addkhuyenmai" class="btn btn-success"><i class="fa fa-plus"></i> Thêm Khuyến Mãi Mới</a>
            </div>
        </c:if>

        <c:if test="${not empty khuyenMaiList}">
            <div class="row g-4">
                <c:forEach var="km" items="${khuyenMaiList}">
                    <div class="col-md-6">
                        <div class="card shadow-sm border-0 h-100" style="border-left: 5px solid #ffc107 !important;">
                            <div class="card-body">
                                <h5 class="card-title text-danger">${km.tenKM}</h5>
                                <h6 class="card-subtitle mb-2 text-muted">Thời gian: ${km.ngayBatDau} đến ${km.ngayKetThuc}</h6>
                                <p class="card-text">${km.moTa}</p>
                                
                                <%-- NÚT XÓA: CHỈ HIỂN THỊ CHO ADMIN (Bên dưới mỗi KM) --%>
                                <%-- Trong file khuyenmai.jsp (bên trong <c:forEach>) --%>

                                    <c:if test="${isAdmin}">
                                        <hr class="mt-3 mb-2">
                                        <form method="POST" action="admin/deletekhuyenmai" onsubmit="return confirm('Bạn chắc chắn muốn xóa khuyến mãi: ${km.tenKM}?');" class="d-inline">
                                            <input type="hidden" name="maKM" value="${km.maKM}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Xóa Khuyến Mãi</button>
                                        </form>
                                    </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <c:if test="${empty khuyenMaiList}">
            <div class="alert alert-warning mt-4">Hiện tại không có chương trình khuyến mãi nào đang diễn ra.</div>
        </c:if>

    </div>
    
    <%@include file="footer.jspf" %>
</body>
</html>