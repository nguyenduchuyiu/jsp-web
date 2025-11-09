<%-- File: nhaphang_manage.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Nhập Hàng</title>
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
        <h2 class="mb-4 text-primary"><i class="fa fa-truck-loading"></i> QUẢN LÝ NHẬP HÀNG</h2>
        <hr>
        
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

        <ul class="nav nav-tabs tabs-nh" id="nhapHangTabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" data-bs-target="#qlDonDatHang">1. Lập Hóa Đơn</a></li>
            <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" data-bs-target="#qlThanhToan">2. Thanh Toán cho NCC</a></li>
        </ul>

        <div class="tab-content border p-4 bg-white shadow-sm">
            
            <%-- TAB 1: QUẢN LÝ ĐƠN ĐẶT HÀNG--%>
            <div class="tab-pane fade show active" id="qlDonDatHang" role="tabpanel">
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Đơn đặt hàng chờ xử lý</h4>
                    <div>
                        <a href="nhapkho_manage.jsp" class="btn btn-info me-2"><i class="fa fa-box"></i> QL Nhập Kho</a> 
                        <a href="${pageContext.request.contextPath}/nhaphang_add.jsp" class="btn btn-primary"><i class="fa fa-plus"></i> Lập Phiếu Nhập Mới</a>
                    </div>
                </div>

                <p>Nơi lập phiếu yêu cầu mua hàng và tạo đơn đặt hàng chính thức gửi NCC.</p>
                
                <table class="table table-bordered admin-table">
                    <thead class="table-dark">
                        <tr><th>Mã PN</th><th>Ngày Lập</th><th>Nhà Cung Cấp</th><th>Tổng Tiền</th><th>Trạng Thái</th><th>Thao Tác</th></tr>
                    </thead>
                    <tbody>
                        </tbody>
                </table>
            </div>

            <%-- TAB 3: QUẢN LÝ THANH TOÁN CÔNG NỢ --%>
            <div class="tab-pane fade" id="qlThanhToan" role="tabpanel">
                <h4>Công nợ cần thanh toán</h4>
                <p>Quản lý quy trình đối chiếu hóa đơn và thực hiện thanh toán cho NCC.</p>
            </div>
            
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>