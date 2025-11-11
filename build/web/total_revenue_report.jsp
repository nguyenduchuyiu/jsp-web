<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Báo Cáo Tổng Doanh Thu (Admin)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* CSS cho chức năng in */
        @media print {
            
            /* Ẩn Header (từ chung.jspf) và Footer (từ footer.jspf) */
            header.main-header, footer.main-footer-area {
                display: none !important;
            }
            
            /* Ẩn các nút hành động */
            .no-print {
                display: none !important;
            }
            
            /* Tinh chỉnh trang in */
            body {
                background: #fff; /* Nền trắng */
            }
            .page-content {
                margin-top: 0 !important;
                margin-bottom: 0 !important;
            }
            .alert-success { /* Hộp tóm tắt  */
                border: 1px solid #ccc;
                box-shadow: none;
                background: #f9f9f9 !important; /* Dùng !important để ghi đè Bootstrap */
                color: #000 !important;
            }
            .table {
                width: 100%;
            }
        }
    </style>
</head>
<body class="admin-page">
    
    <%@include file="/chung.jspf" %>
    
    <div class="container-fluid page-content my-5">
        <h2>💰 BÁO CÁO TỔNG DOANH THU</h2>
        <h4 class="text-primary mb-4">Kết quả từ ${reportNgayBD} đến ${reportNgayKT}</h4>
        <hr>
        
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <%-- 1. HỘP TỔNG KẾT DOANH THU --%>
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="alert alert-success shadow-sm">
                    <p class="h5 mb-1">TỔNG DOANH THU (Tất cả sản phẩm)</p>
                    <p class="h3 mb-0 fw-bold">
                        <%-- Định dạng số tiền --%>
                        <fmt:formatNumber value="${grandTotalRevenue}" pattern="#,###" /> VND
                    </p>
                </div>
            </div>
        </div>

        <%-- 2. BẢNG CHI TIẾT SẢN PHẨM ĐÃ BÁN --%>
        <h4 class="mb-3">Chi tiết doanh thu theo sản phẩm</h4>
        <table class="table table-bordered table-striped admin-table">
            <thead class="table-dark">
                <tr>
                    <th>Mã SP</th>
                    <th>Tên Sản Phẩm</th>
                    <th>Tổng Số Lượng Bán</th>
                    <th>Tổng Doanh Thu (VND)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${soldProductsList}">
                    <tr>
                        <td>${item.maSP}</td>
                        <td>${item.tenSP}</td>
                        <td>${item.tongSoLuong}</td>
                        <td class="fw-bold">
                            <fmt:formatNumber value="${item.tongDoanhThu}" pattern="#,###" />
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty soldProductsList}">
                    <tr>
                        <td colspan="4" class="text-center">Không có sản phẩm nào được bán trong khoảng thời gian này.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
        
        <%-- Khối nút hành động (sẽ bị ẩn khi in) --%>
<div class="d-flex justify-content-between mt-4 no-print">
    
    <%-- Nút quay lại [cite: 30] --%>
    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-secondary">
        <i class="fa fa-arrow-left"></i> Quay lại Form Báo cáo
    </a>
    
    <%-- NÚT IN VÀ XUẤT PDF --%>
    <div>
        <button class="btn btn-success" onclick="window.print()">
            <i class="fa fa-file-pdf"></i> Xuất PDF
        </button>
    </div>
</div>
        
    </div>
    
    <%@include file="/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>