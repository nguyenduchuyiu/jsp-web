<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${product.tenSP} - Chi Tiết Sản Phẩm</title>
    <link rel="stylesheet" href="css/bootstrap.min.css"> 
    <link rel="stylesheet" href="css/style.css"> 
</head>
<body>
    <%@include file="chung.jspf" %>
    
    <div class="container page-content">
        
        <%-- KHỐI THÔNG BÁO Ở VỊ TRÍ NÀY RẤT TỐT --%>
        <c:if test="${not empty sessionScope.cart_message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Thành công!</strong> ${sessionScope.cart_message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="cart_message" scope="session"/>
        </c:if>

        <c:if test="${product != null}">
            <h2>CHI TIẾT SẢN PHẨM: ${product.tenSP}</h2>
            <div class="product-detail-box bg-white p-4 shadow-sm">
                
                <div class="row">
                    <div class="col-md-5 text-center">
                        <img src="img/${product.hinhAnh}" class="img-fluid detail-img" alt="${product.tenSP}">
                    </div>
                    <div class="col-md-7 product-summary">
                        <p class="text-muted small">${product.thuongHieu} | Xuất xứ: ${product.xuatXu}</p>
                        <h3>Giá: ${product.priceVND} / ${product.donVi}</h3>
                        <p>Tình trạng: <span class="text-success">${product.soLuongTon > 0 ? 'Còn hàng' : 'Hết hàng'}</span></p>
                        

                        <c:if test="${sessionScope.account == null || sessionScope.account.loaiNguoiDung != 'QuanTriVien'}">
                            <%-- SỬA LỖI: CHỈ MỘT FORM BAO TRỌN 2 NÚT --%>
                            <div class="mt-4">
                                <form method="POST" action="addtocart" id="purchaseForm" style="display: flex; align-items: center;">
                                    <input type="hidden" name="maSp" value="${product.maSP}">

                                    <input type="number" name="soLuong" value="1" min="1" class="form-control me-2" style="width: 80px;" required>

                                    <button type="submit" class="btn btn-danger btn-lg me-2">
                                        Thêm vào giỏ hàng
                                    </button>

                                    <button type="button" id="buyNowButton" class="btn btn-outline-secondary">Mua ngay</button>
                                </form>
                            </div>
                        </c:if>

                        <%-- NẾU LÀ QUẢN TRỊ VIÊN, KHÔNG CÓ GÌ HIỂN THỊ TẠI ĐÂY (NÚT BỊ ẨN) --%>
                    </div>
                </div>
                
                <ul class="nav nav-tabs mt-5" id="productTabs">
                    <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" data-bs-target="#moTaTab">Mô Tả Sản Phẩm</a></li>
                    <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" data-bs-target="#huongDanTab">Hướng Dẫn Sử Dụng</a></li>
                </ul>
                
                <div class="tab-content p-4 border border-top-0 bg-light">
                    <div class="tab-pane fade show active" id="moTaTab">
                        <pre>${product.moTa}</pre>
                    </div>
                    <div class="tab-pane fade" id="huongDanTab">
                        <pre>${product.huongDan}</pre>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${product == null}">
            <div class="alert alert-warning">Sản phẩm này không tồn tại.</div>
        </c:if>
    </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('purchaseForm');
        const buyNowButton = document.getElementById('buyNowButton');

        if (buyNowButton && form) {
            buyNowButton.addEventListener('click', function(e) {
                // 1. Thay đổi action của form thành Servlet xử lý "Mua ngay"
                form.action = 'buynow';
                
                // 2. Gửi form đi
                form.submit();
            });
            
            // Đảm bảo nút Thêm vào giỏ hàng giữ action mặc định
            // (Hiện tại action mặc định đã là addtocart)
        }
    });
</script>
</body>
</html>