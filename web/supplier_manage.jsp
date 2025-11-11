<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản Lý Nhà Cung Cấp(Admin)</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.0/dist/chart.min.js"></script>
    </head>
<body class="admin-page">
    
    <%@include file="/chung.jspf" %>
    
    <div class="container-fluid page-content my-5">
        <h2><i class="fa fa-industry"></i> QUẢN LÝ NHÀ CUNG CẤP</h2>
        <hr>
        
        <c:if test="${not empty sessionScope.success_admin}">
            <div class="alert alert-success">${sessionScope.success_admin}</div>
            <c:remove var="success_admin" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.error_admin}">
            <div class="alert alert-danger">${sessionScope.error_admin}</div>
            <c:remove var="error_admin" scope="session"/>
        </c:if>

        <div class="mb-3 d-flex justify-content-end">
            <a href="${pageContext.request.contextPath}/admin/supplieradd" class="btn btn-success">
                <i class="fa fa-plus"></i> Thêm Nhà Cung Cấp Mới
            </a>
        </div>

        <table class="table table-bordered table-striped admin-table">
            <thead class="table-dark">
                <tr>
                    <th>Mã NCC</th>
                    <th>Tên Nhà Cung Cấp</th>
                    <th>Địa chỉ</th>
                    <th>SĐT</th>
                    <th>Email</th>
                    <th>Xuất Xứ</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ncc" items="${supplierList}">
                    <tr>
                        <td>${ncc.maNCC}</td>
                        <td>${ncc.tenNCC}</td>
                        <td>${ncc.diaChi}</td>
                        <td>${ncc.sdt}</td>
                        <td>${ncc.email}</td>
                        <td>${ncc.xuatXu}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/supplierupdate?maNcc=${ncc.maNCC}" class="btn btn-sm btn-info me-2">
                                <i class="fa fa-edit"></i> Sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/supplierdelete?maNcc=${ncc.maNCC}" class="btn btn-sm btn-danger" 
                               onclick="return confirm('Bạn chắc chắn muốn xóa ${ncc.tenNCC}? (Nếu NCC này đã cung cấp sản phẩm, việc xóa có thể thất bại)');">
                                <i class="fa fa-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
       
        <c:if test="${empty supplierList}">
            <div class="alert alert-warning text-center">Không tìm thấy nhà cung cấp nào.</div>
        </c:if>
    </div>
    
    <%@include file="/footer.jspf" %>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
</body>
</html>