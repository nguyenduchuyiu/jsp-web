<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Chi Tiết Phiếu Nhập #${phieuNhap.maPN}</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css"> 
    </head>

    <body class="admin-page">
     
    <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

        <%-- Dùng chung.jspf để gọi header/footer. Thêm class no-print vào các thẻ được tạo ra từ chung.jspf nếu cần --%>
        <%-- Trong chế độ in, header và footer sẽ bị ẩn bởi CSS @media print .no-print --%>
        <%@include file="chung.jspf" %>

        <div class="container-fluid page-content my-5" style="max-width: 1250px;">
            
            <%-- KHỐI THAO TÁC (Ẩn khi in) --%>
            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                <h2 class="text-primary"><i class="fa fa-file-invoice"></i> CHI TIẾT PHIẾU NHẬP</h2>
                <a href="${pageContext.request.contextPath}/admin/live" class="btn btn-secondary">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
            </div>
            <hr class="no-print">

            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

            <c:if test="${not empty phieuNhap}">

                <%-- KHỐI THÔNG TIN CHUNG --%>
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">PHIẾU NHẬP HÀNG: <strong>${phieuNhap.maPN}</strong></h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Mã Phiếu Nhập:</strong> ${phieuNhap.maPN}</p>
                                <p><strong>Ngày Lập:</strong><fmt:formatDate value="${phieuNhap.ngayLap}" pattern="dd/MM/yyyy HH:mm" /></p>
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

                <%-- KHỐI CHI TIẾT SẢN PHẨM --%>
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
                                                <td class="text-end">
                                                    ${String.format("%,.0f", ct.giaNhap)} VND
                                                </td>
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
            
            <%-- NÚT IN (Chỉ hiển thị khi không phải chế độ in tự động) --%>
            <div class="mt-4 no-print text-center">
                 <button class="btn btn-primary btn-lg" onclick="window.print()">
                     <i class="fa fa-print"></i> In/Xuất PDF Phiếu Nhập
                 </button>
            </div>
            
        </div>

        <%@include file="footer.jspf" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Logic tự động in khi có tham số 'print=true' (Dùng cho chức năng Xuất PDF thuần JS)
            document.addEventListener('DOMContentLoaded', function() {
                const urlParams = new URLSearchParams(window.location.search);
                const isPrintMode = urlParams.get('print') === 'true';
                
                // Nếu tham số 'print=true' tồn tại, kích hoạt in sau một khoảng trễ
                if (isPrintMode) {
                    setTimeout(() => {
                        window.print();
                        // Bạn có thể thêm window.close() ở đây nếu muốn cửa sổ tự đóng
                    }, 500); 
                }
            });
        </script>
    </body>
</html>