<%-- File: nhaphang_add.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %> 
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Sản Phẩm</title>
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
            <div class="col-md-8">
                <h2>➕ THÊM SẢN PHẨM MỚI</h2>
                <hr>
                
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                <form method="POST" action="productadd" class="p-4 border shadow-sm bg-white">
                    <div class="row">
                        <div class="col-md-6 form-group mb-3">
                            <label>Mã Sản Phẩm (*):</label>
                            <input type="text" name="maSp" class="form-control" required>
                        </div>
                        <div class="col-md-6 form-group mb-3">
                            <label>Tên Sản Phẩm (*):</label>
                            <input type="text" name="tenSp" class="form-control" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 form-group mb-3">
                            <label>Giá (*):</label>
                            <input type="number" name="gia" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4 form-group mb-3">
                            <label>Số Lượng Tồn (*):</label>
                            <input type="number" name="soLuongTon" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4 form-group mb-3">
                            <label>Đơn Vị Tính:</label>
                            <input type="text" name="donVi" class="form-control">
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 form-group mb-3">
                            <label>Danh Mục (*):</label>
                            <select name="maDm" class="form-select" required>
                                <c:forEach var="cat" items="${categoryList}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 form-group mb-3">
                            <label>Hình Ảnh (Tên file):</label>
                            <input type="text" name="hinhAnh" class="form-control">
                        </div>
                    </div>
                    
                    <div class="row">
                         <div class="col-md-6 form-group mb-3">
                            <label>Thương Hiệu:</label>
                            <input type="text" name="thuongHieu" class="form-control">
                        </div>
                        <div class="col-md-6 form-group mb-3">
                            <label>Xuất Xứ:</label>
                            <input type="text" name="xuatXu" class="form-control">
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label>Mô Tả:</label>
                        <textarea name="moTa" rows="3" class="form-control"></textarea>
                    </div>
                    <div class="form-group mb-4">
                        <label>Hướng Dẫn Sử Dụng:</label>
                        <textarea name="huongDan" rows="3" class="form-control"></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-lg w-100">Thêm Sản Phẩm</button>
                    <a href="products" class="btn btn-outline-secondary mt-3 w-100">Hủy bỏ</a>
                </form>
            </div>
        </div>
    </div>
    
    <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>