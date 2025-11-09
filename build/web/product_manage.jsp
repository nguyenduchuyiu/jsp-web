<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Sản Phẩm (ADMIN)</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">  
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">  
    
   </head>
        <body class="admin-page">
            <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
            <%@include file="/chung.jspf" %>
    
    <div class="container-fluid page-content my-5">
        <h2>🛠️ QUẢN LÝ SẢN PHẨM</h2>
        <hr>
        
        <c:if test="${not empty sessionScope.success_admin}">
            <div class="alert alert-success">${sessionScope.success_admin}</div>
            <c:remove var="success_admin" scope="session"/>
        </c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <div class="mb-3 d-flex justify-content-end">
            <!--tâms-->
            <a href="${pageContext.request.contextPath}/admin/productadd" class="btn btn-success"><i class="fa fa-plus"></i> Thêm Sản Phẩm Mới</a>
            <!--tâme-->
        </div>

        <table class="table table-bordered table-striped admin-table">
            <thead class="table-dark">
                <tr>
                    <th>Mã SP</th>
                    <th>Ảnh</th>
                    <th>Tên SP</th>
                    <th>Giá</th>
                    <th>Tồn kho</th>
                    <th>Danh mục</th>
                    <th>Hãng</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${productList}">
                    <tr>
                        <td>${p.maSP}</td>
                        <td><img src="${pageContext.request.contextPath}/img/${p.hinhAnh}" alt="${p.tenSP}"></td>
                        <td>${p.tenSP}</td>
                        <td>${p.priceVND}</td>
                        <td>${p.soLuongTon}</td>
                        <td>${p.maDM}</td> 
                        <td>${p.thuongHieu}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/productupdate?maSp=${p.maSP}" class="btn btn-sm btn-info me-2"><i class="fa fa-edit"></i> Sửa</a> 
                            <a href="productdelete?maSp=${p.maSP}" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận xóa sản phẩm ${p.maSP}?');"><i class="fa fa-trash"></i> Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
       
        <c:if test="${empty productList}"><div class="alert alert-warning text-center">Không tìm thấy sản phẩm nào.</div></c:if>

    </div>
  <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>