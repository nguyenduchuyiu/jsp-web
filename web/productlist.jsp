<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dụng Cụ Y Tế - Trang Sản Phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

<%@include file="chung.jspf" %> 

<div class="container-fluid page-content">
    <div class="row">
        
        <div class="col-md-3 filter-sidebar">
            <form id="filterForm" method="GET" action="home">
                
                <input type="hidden" name="sortBy" value="${param.sortBy}">  
                <input type="hidden" name="maDm" value="${param.maDm}">  
                <input type="hidden" name="keyword" value="${param.keyword}"> 
                
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white filter-header-style">
                        <h3 class="filter-header-text">Bộ lọc nâng cao</h3>
                    </div>
                    
                    <div class="filter-group p-3">
                        <h4 class="filter-title">Giá bán</h4>
                        
                        <div class="price-range">
                            <div class="form-check">
                                <input type="radio" class="form-check-input filter-radio" name="radioGia" value="all" id="allGia"
                                    <c:if test="${empty param.radioGia || param.radioGia == 'all'}">checked</c:if>>
                                <label for="allGia">Tất cả</label>
                            </div>
                            
                            <div class="form-check">
                                <input type="radio" class="form-check-input filter-radio" name="radioGia" id="gia1" value="0-100000"
                                    <c:if test="${param.radioGia == '0-100000'}">checked</c:if>> <label for="gia1">Dưới 100.000đ</label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input filter-radio" name="radioGia" id="gia2" value="100000-300000"
                                    <c:if test="${param.radioGia == '100000-300000'}">checked</c:if>> <label for="gia2">100.000đ - 300.000đ</label>    
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input filter-radio" name="radioGia" id="gia3" value="300000-1000000"
                                    <c:if test="${param.radioGia == '300000-1000000'}">checked</c:if>> <label for="gia3">300.000đ - 1.000.000đ</label>
                            </div>
                            <div class="form-check">
                               <input type="radio" class="form-check-input filter-radio" name="radioGia" id="gia4" value="1000000-999999999"
                                    <c:if test="${param.radioGia == '1000000-999999999'}">checked</c:if>> <label for="gia4">Trên 1.000.000đ</label>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div> <div class="col-md-9 product-area product-list-container">
            
            <div class="d-flex justify-content-between align-items-center mb-3 sort-bar">
                <p class="mb-0 text-muted small">Sản phẩm của chúng tôi</p>
                <div>
                    <span class="me-2 small">Sắp xếp theo:</span>
                    <a href="home?sortBy=asc" class="sort-link ${param.sortBy == 'asc' ? 'active' : ''}">Giá thấp</a>
                    <a href="home?sortBy=desc" class="sort-link ${param.sortBy == 'desc' ? 'active' : ''}">Giá cao</a>
                </div>
            </div>

            <div class="row row-cols-md-4 g-3 product-grid">
                <c:forEach var="sp" items="${productList}">
                    <div class="col">
                        <div class="card product-card h-100 border shadow-sm">
                            <img src="${pageContext.request.contextPath}/img/${sp.hinhAnh}" class="card-img-top" alt="${sp.tenSP}">
                            
                            <div class="card-body"> 
                                <h5 class="card-title">${sp.tenSP}</h5>
                                <p class="card-price">${sp.priceVND} / ${sp.donVi}</p>

                                <%-- LOGIC KIỂM TRA QUANTRIVIEN --%>
                                <c:if test="${sessionScope.account != null && sessionScope.account.loaiNguoiDung == 'QuanTriVien'}">
                                    <a href="detail?maSp=${sp.maSP}" class="btn btn-sm btn-info w-100">Xem chi tiết</a>
                                </c:if>

                                <c:if test="${sessionScope.account == null || sessionScope.account.loaiNguoiDung != 'QuanTriVien'}">
                                    <a href="detail?maSp=${sp.maSP}" class="btn btn-sm btn-primary w-100">Chọn mua</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jspf" %> 
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const filterForm = document.getElementById('filterForm');
        // Lắng nghe sự kiện thay đổi của tất cả các radio buttons
        const filterRadios = document.querySelectorAll('.filter-radio');
        filterRadios.forEach(function(radio) {
            radio.addEventListener('change', function() {
                // Tự động gửi form khi một radio button được chọn
                filterForm.submit();
            });
        });
    });
</script>
</body>
</html>