<%-- File: nhaphang_detail.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Phiếu Nhập</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"> 
    
</head>
<body class="admin-page">
    
    <%@include file="chung.jspf" %>
    
    <div class="container-fluid page-content my-5" style="max-width: 1250px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary"><i class="fa fa-file-invoice"></i> CHI TIẾT PHIẾU NHẬP</h2>
            <a href="${pageContext.request.contextPath}/admin/live" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Quay lại
            </a>
        </div>
        <hr>
        
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
        
        <c:if test="${not empty phieuNhap}">
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Thông tin Phiếu Nhập: <strong>${phieuNhap.maPN}</strong></h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Mã Phiếu Nhập:</strong> ${phieuNhap.maPN}</p>
                            <p><strong>Ngày Lập:</strong> <fmt:formatDate value="${phieuNhap.ngayLap}" pattern="dd/MM/yyyy HH:mm" /></p>
                            <p><strong>Nhà Cung Cấp:</strong> ${phieuNhap.tenNCC}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Tổng Tiền:</strong> <span class="text-danger fw-bold">${phieuNhap.tongTienVND}</span></p>
                            <c:if test="${not empty phieuNhap.ghiChu}">
                                <p><strong>Ghi Chú:</strong> ${phieuNhap.ghiChu}</p>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">Chi Tiết Sản Phẩm</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty chiTietList}">
                            <table class="table table-bordered">
                                <thead class="table-dark">
                                    <tr>
                                        <th>STT</th>
                                        <th>Hình Ảnh</th>
                                        <th>Mã SP</th>
                                        <th>Tên Sản Phẩm</th>
                                        <th class="text-end">Số Lượng</th>
                                        <th class="text-end">Giá Nhập</th>
                                        <th class="text-end">Thành Tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ct" items="${chiTietList}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/img/${ct.hinhAnh}" 
                                                     alt="${ct.tenSP}" 
                                                     style="max-width: 60px; height: auto;" 
                                                     class="img-thumbnail">
                                            </td>
                                            <td><strong>${ct.maSP}</strong></td>
                                            <td>${ct.tenSP}</td>
                                            <td class="text-end">${ct.soLuong}</td>
                                            <td class="text-end"><fmt:formatNumber value="${ct.giaNhap}" pattern="#,###" /> VNĐ</td>
                                            <td class="text-end fw-bold text-danger">${ct.thanhTienVND}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="table-secondary">
                                    <tr>
                                        <td colspan="6" class="text-end fw-bold">TỔNG CỘNG:</td>
                                        <td class="text-end fw-bold text-danger fs-5">${phieuNhap.tongTienVND}</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted text-center">Không có chi tiết sản phẩm</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

