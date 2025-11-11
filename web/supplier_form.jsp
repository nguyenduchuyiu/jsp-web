<%-- File: nhaphang_add.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %> 
<!DOCTYPE html>
<html>
<head>
    <title>Nhà Cung Cấp</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"> 
</head>
<body class="admin-page">
    <%@include file="/chung.jspf" %>
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <h2>${isUpdate ? '✏️ Cập nhật' : '➕ Thêm'} Nhà Cung Cấp</h2>
                <hr>
                
                <form method="POST" action="${isUpdate ? 'supplierupdate' : 'supplieradd'}" class="p-4 border shadow-sm bg-white">
                    <c:if test="${isUpdate}">
                        <input type="hidden" name="maNCC" value="${ncc.maNCC}">
                    </c:if>

                    <div class="form-group mb-3">
                        <label>Tên Nhà Cung Cấp (*):</label>
                        <input type="text" name="tenNCC" class="form-control" value="${ncc.tenNCC}" required>
                    </div>
                    <div class="form-group mb-3">
                        <label>Địa chỉ:</label>
                        <input type="text" name="diaChi" class="form-control" value="${ncc.diaChi}">
                    </div>
                    <div class="form-group mb-3">
                        <label>Số Điện Thoại:</label>
                        <input type="text" name="sdt" class="form-control" value="${ncc.sdt}">
                    </div>
                    <div class="form-group mb-3">
                        <label>Email:</label>
                        <input type="email" name="email" class="form-control" value="${ncc.email}">
                    </div>
                    <div class="form-group mb-4">
                        <label>Xuất Xứ:</label>
                        <input type="text" name="xuatXu" class="form-control" value="${ncc.xuatXu}">
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">${isUpdate ? 'Lưu Cập Nhật' : 'Thêm Mới'}</button>
                    <a href="${pageContext.request.contextPath}/admin/suppliers" class="btn btn-outline-secondary mt-3 w-100">Hủy bỏ</a>
                </form>
            </div>
        </div>
    </div>
    <%@include file="/footer.jspf" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
</body>
</html>