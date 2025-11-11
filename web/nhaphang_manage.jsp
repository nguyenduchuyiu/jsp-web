<%-- File: nhaphang_manage.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
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
    <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

    
    <div class="container-fluid page-content my-5" style="max-width: 1250px;">
        <h2 class="mb-4 text-primary"><i class="fa fa-truck-loading"></i> QUẢN LÝ NHẬP HÀNG</h2>
        <hr>
        
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
        <c:if test="${not empty success_admin}"><div class="alert alert-success">${success_admin}</div></c:if>

        <ul class="nav nav-tabs tabs-nh" id="nhapHangTabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" data-bs-target="#qlDonDatHang">1. Lập Hóa Đơn</a></li>
            
        </ul>

        <div class="tab-content border p-4 bg-white shadow-sm">
            
            <%-- TAB 1: QUẢN LÝ ĐƠN ĐẶT HÀNG--%>
            <div class="tab-pane fade show active" id="qlDonDatHang" role="tabpanel">
                

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>Đơn đặt hàng từ NCC</h4>
                    <div>
                        
            
            <a href="${pageContext.request.contextPath}/admin/nhaphangadd" class="btn btn-primary"><i class="fa fa-plus"></i> Lập Phiếu Nhập Mới</a>
                    </div>
                </div>

                <p>Nơi lập phiếu yêu cầu mua hàng và tạo đơn đặt hàng chính thức gửi NCC.</p>
            
    
                <table class="table table-bordered admin-table">
                    <thead class="table-dark">
                        <tr><th>Mã PN</th><th>Ngày Lập</th><th>Nhà Cung Cấp</th><th>Tổng Tiền</th><th>Thao Tác</th></tr>
                    </thead>
      
              <tbody>
                        <c:choose>
                            <c:when test="${not empty phieuNhapList}">
                               
 <c:forEach var="pn" items="${phieuNhapList}">
                                    <tr>
                                        <td><strong>${pn.maPN}</strong></td>
                     
                   <td><fmt:formatDate value="${pn.ngayLap}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td>${pn.tenNCC}</td>
                                     
   <td class="text-end">${pn.tongTienVND}</td>
                                        <td>
                                            <%-- ĐÃ SỬA: Thay thế Nút Xem Chi Tiết bằng Nút Xuất PDF / Xem chi tiết --%>
                                            <a href="${pageContext.request.contextPath}/admin/viewphieunhap?maPN=${pn.maPN}" 
                                               class="btn btn-sm btn-secondary me-1" 
                                               title="Xuất File PDF"
                                               onclick="return printPhieuNhap('${pn.maPN}');">
                                               <i class="fa fa-file-pdf"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/viewphieunhap?maPN=${pn.maPN}" 
          
                                     class="btn btn-sm btn-info me-1" 
                                               title="Xem chi tiết">
          
                                     <i class="fa fa-eye"></i>
                                            </a>
                 
                           <a href="${pageContext.request.contextPath}/admin/deletephieunhap?maPN=${pn.maPN}" 
                                               class="btn btn-sm btn-danger" 
                     
                          title="Xóa phiếu nhập" 
                                               onclick="return confirm('Bạn có chắc muốn xóa phiếu nhập ${pn.maPN}?');">❌</a>
                
                        </td>
                                    </tr>
                                </c:forEach>
        
                    </c:when>
                            <c:otherwise>
                                <tr>
                    
                <td colspan="5" class="text-center text-muted">Chưa có phiếu nhập nào</td>
                                </tr>
                            </c:otherwise>
                 
       </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
   
     // Tự động ẩn thông báo sau 5 giây
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
}, 5000);

        // HÀM XUẤT PDF (Sử dụng window.open và window.print)
        function printPhieuNhap(maPN) {
            // Mở trang chi tiết phiếu nhập trong cửa sổ mới, thêm cờ 'print'
            const printWindow = window.open('${pageContext.request.contextPath}/admin/viewphieunhap?maPN=' + maPN + '&print=true', '_blank');
            // Cần chờ cửa sổ mở và tải xong nội dung (sẽ xử lý logic in trong JSP đó)
            return false; // Ngăn liên kết mặc định chuyển hướng
        }
    </script>
</body>
</html>