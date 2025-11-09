<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch Sử Đơn Hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    
    <%@include file="chung.jspf" %> 
    
    <jsp:useBean id="orderDAO" class="dao.OrderDAO" scope="page" />

    <div class="container page-content mt-5 mb-5">
        <h2 class="text-primary mb-4 border-bottom pb-2">📋 LỊCH SỬ ĐẶT HÀNG CỦA TÔI</h2>
        
        <%-- FIX: KHỐI HIỂN THỊ VÀ XÓA LỖI/THÀNH CÔNG --%>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${not empty sessionScope.error}"><c:remove var="error" scope="session"/></c:if>
        
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <%-- KẾT THÚC FIX LỖI THÔNG BÁO --%>

        <c:choose>
            <c:when test="${empty orderList}">
                <div class="alert alert-info text-center">
                    Bạn chưa có đơn hàng nào. <a href="home">Bắt đầu mua sắm ngay!</a>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="accordion" id="orderAccordion">
                    
                    <c:forEach var="order" items="${orderList}" varStatus="status">
                        <div class="accordion-item shadow-sm mb-3">
                            <h2 class="accordion-header" id="heading${order.maDH}">
                                <button class="accordion-button collapsed" type="button" 
                                        data-bs-toggle="collapse" 
                                        data-bs-target="#collapse${order.maDH}" 
                                        aria-expanded="false" 
                                        aria-controls="collapse${order.maDH}">
                                    
                                    <span class="col-3 fw-bold text-primary">#DH${order.maDH}</span>
                                    <span class="col-3 text-muted small">Ngày đặt: ${order.ngayDat}</span>
                                    <span class="col-3 text-danger fw-bold">
                                        Tổng: <fmt:formatNumber value="${order.tongTien}" pattern="#,###" /> VND
                                    </span>
                                    <span class="col-3 text-success">${order.trangThai}</span>
                                </button>
                            </h2>
                            
                            <div id="collapse${order.maDH}" 
                                 class="accordion-collapse collapse" 
                                 aria-labelledby="heading${order.maDH}" 
                                 data-bs-parent="#orderAccordion">
                                
                                <div class="accordion-body bg-light">
                                    <h5 class="mb-3 text-secondary">Chi tiết Sản phẩm:</h5>
                                    
                                    <c:set var="orderDetails" value="${orderDAO.getOrderDetails(order.maDH)}" />
                                    
                                    <ul class="list-group list-group-flush small">
                                        <c:forEach var="detail" items="${orderDetails}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/img/${detail.hinhAnh}" 
                                                         alt="${detail.tenSP}" style="max-width: 40px;" class="me-3">
                                                    <span class="fw-medium">${detail.tenSP}</span>
                                                </div>
                                                <span class="text-muted">
                                                    SL: ${detail.soLuong} x <fmt:formatNumber value="${detail.gia}" pattern="#,###" /> VND
                                                </span>
                                                <span class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${detail.thanhTien}" pattern="#,###" /> VND
                                                </span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                    
                                    <h5 class="mt-4 mb-2 text-secondary border-top pt-3">Thông tin Giao nhận:</h5>
                                    <div class="card p-3 border-0 bg-white shadow-sm">
                                        <p class="mb-1 small"><strong>Người nhận:</strong> ${order.tenNguoiNhan} (${order.sdtNguoiNhan})</p>
                                        <p class="mb-1 small"><strong>Địa chỉ:</strong> ${order.diaChiGiaoHang}</p>
                                        <p class="mb-1 small"><strong>Thanh toán:</strong> ${order.phuongThucThanhToan}</p>
                                    </div>
                                    
                                    <%-- KHỐI NÚT HÀNH ĐỘNG --%>
                                    <div class="mt-4 pt-3 border-top d-flex justify-content-start gap-3">
                                        
                                        <c:choose>
                                            <%-- TRƯỜNG HỢP 1: CÓ THỂ NHẬN HÀNG HOẶC HỦY (Chỉ khi trạng thái là DangGiao) --%>
                                            <c:when test="${order.trangThai == 'DangGiao'}">

                                                <%-- NÚT XÁC NHẬN ĐÃ NHẬN HÀNG --%>
                                                <form method="POST" action="updateorderstatus" class="d-inline">
                                                    <input type="hidden" name="maDh" value="${order.maDH}">
                                                    <input type="hidden" name="newStatus" value="DaGiao">
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="fa fa-check-circle"></i> Đã Nhận Hàng
                                                    </button>
                                                </form>

                                                <%-- NÚT HỦY ĐƠN HÀNG --%>
                                                <form method="POST" action="updateorderstatus" class="d-inline" onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn hàng #${order.maDH}?');">
                                                    <input type="hidden" name="maDh" value="${order.maDH}">
                                                    <input type="hidden" name="newStatus" value="DaHuy">
                                                    <button type="submit" class="btn btn-danger">
                                                        <i class="fa fa-times-circle"></i> Hủy Đơn Hàng
                                                    </button>
                                                </form>

                                            </c:when>

                                            <%-- TRƯỜNG HỢP 2: KHÔNG CẦN THAO TÁC (Đã hoàn thành hoặc đã hủy) --%>
                                            <c:otherwise>
                                                <span class="text-muted small">Đơn hàng đã ở trạng thái cuối: ${order.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                </div>
            </c:otherwise>
        </c:choose>

    </div>
    
    <%-- Bao gồm footer --%>
    <%@include file="footer.jspf" %>
    
    <%-- Cần script của Bootstrap để Accordion hoạt động --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>