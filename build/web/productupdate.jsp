<%-- File: nhaphang_add.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %> 
<!DOCTYPE html>
<html>
<head>
    <title>Cập Nhật Sản Phẩm</title>
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
                <h2>✏️ CẬP NHẬT SẢN PHẨM: ${product.tenSP}</h2>
                <hr>
                
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                <c:if test="${product == null}"><div class="alert alert-warning">Không tìm thấy sản phẩm này.</div></c:if>

                <c:if test="${product != null}">
                    <form method="POST" action="productupdate" class="p-4 border shadow-sm bg-white">
                        
                        <div class="form-group mb-3">
                            <label>Mã Sản Phẩm:</label>
                            <%-- Mã SP thường không đổi, nên disabled để tránh Admin sửa nhầm --%>
                            <input type="text" name="maSpDisplay" class="form-control" value="${product.maSP}" disabled>
                            <input type="hidden" name="maSp" value="${product.maSP}">
                        </div>

                        <div class="form-group mb-3">
                            <label>Tên Sản Phẩm (*):</label>
                            <input type="text" name="tenSp" class="form-control" value="${product.tenSP}" required>
                        </div>

                        <div class="row">
                            <div class="col-md-4 form-group mb-3">
                                <label>Giá (*):</label>
                                <input type="number" name="gia" class="form-control" min="0" value="${product.gia}" required>
                            </div>
                            <div class="col-md-4 form-group mb-3">
                                <label>Số Lượng Tồn (*):</label>
                                <input type="number" name="soLuongTon" class="form-control" min="0" value="${product.soLuongTon}" required>
                            </div>
                            <div class="col-md-4 form-group mb-3">
                                <label>Đơn Vị Tính:</label>
                                <input type="text" name="donVi" class="form-control" value="${product.donVi}">
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 form-group mb-3">
                                <label>Danh Mục (*):</label>
                                <select name="maDm" class="form-select" required>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <option value="${cat.id}" 
                                            <c:if test="${product.maDM == cat.id}">selected</c:if>>
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 form-group mb-3">
                                <label>Hình Ảnh (Tên file):</label>
                                <input type="text" name="hinhAnh" class="form-control" value="${product.hinhAnh}">
                                <small class="text-muted">Đang dùng file: ${product.hinhAnh}</small>
                            </div>
                        </div>
                        
                        <div class="row">
                             <div class="col-md-6 form-group mb-3">
                                <label>Thương Hiệu:</label>
                                <input type="text" name="thuongHieu" class="form-control" value="${product.thuongHieu}">
                            </div>
                            <div class="col-md-6 form-group mb-3">
                                <label>Xuất Xứ:</label>
                                <input type="text" name="xuatXu" class="form-control" value="${product.xuatXu}">
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label>Mô Tả:</label>
                            <textarea name="moTa" rows="3" class="form-control">${product.moTa}</textarea>
                        </div>
                        <div class="form-group mb-4">
                            <label>Hướng Dẫn Sử Dụng:</label>
                            <textarea name="huongDan" rows="3" class="form-control">${product.huongDan}</textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-warning btn-lg w-100">Lưu Cập Nhật Sản Phẩm</button>
                        <a href="products" class="btn btn-outline-secondary mt-3 w-100">Hủy bỏ</a>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
    
    <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>