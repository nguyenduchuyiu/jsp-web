<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn #${order.maDH}</title>
    
    <%-- Sử dụng chung.jspf để tải CSS và Header --%>
    <%-- Chúng ta sẽ ẩn header khi in bằng CSS --%>
    <jsp:include page="chung.jspf" />

    <style>
        body { background: #f6f7fb; }
        .invoice-box { 
            max-width: 980px; 
            margin: 24px auto; 
            padding: 30px; 
            border: 1px solid #e5e7eb; 
            background: #fff; 
            box-shadow: 0 0 10px rgba(0,0,0, .05);
        }
        .brand { 
            font-weight: 900; 
            font-size: 1.5rem; 
            color: #d9534f; /* Màu đỏ của TMN Shop */
        }
        .meta strong { min-width: 100px; display: inline-block; }
        .table th, .table td { vertical-align: middle; }
        
        /* CSS cho chức năng in */
        @media print {
            /* Ẩn mọi thứ không phải là hóa đơn */
            body > *:not(.invoice-box) {
                display: none !important;
            }
            .no-print { 
                display: none !important; 
            }
            body { 
                background: #fff; 
                margin: 0;
            }
            .invoice-box { 
                border: none; 
                box-shadow: none; 
                margin: 0; 
                padding: 0;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>

<%-- Thêm class no-print vào header để tự ẩn khi in --%>
<div class="no-print">
    <%@include file="chung.jspf" %>
</div>

<div class="invoice-box">
    <div class="d-flex justify-content-between align-items-start mb-4">
        <div>
            <div class="brand">TMN SHOP</div> [cite: 29]
            <div class="text-muted">Dụng Cụ Chăm Sóc Sức Khỏe</div> [cite: 24]
        </div>
        <div class="text-end meta">
            <div><strong>Hóa đơn:</strong> #${order.maDH}</div> [cite: 64]
            <div><strong>Ngày đặt:</strong> 
                <fmt:formatDate value="${order.ngayDat}" pattern="dd/MM/yyyy HH:mm"/> [cite: 64]
            </div>
            <div><strong>Trạng thái:</strong> ${order.trangThai}</div> [cite: 64]
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-6">
            <h6>Thông tin Khách hàng:</h6>
            <div><strong>${order.tenNguoiNhan}</strong></div> [cite: 64]
            <div>${customer.email}</div> [cite: 70]
            <div>ĐT: ${order.sdtNguoiNhan}</div> [cite: 64]
            <div>Địa chỉ: ${order.diaChiGiaoHang}</div> [cite: 64]
        </div>
        <div class="col-6 text-end">
            <h6>Thông tin Cửa hàng:</h6>
            <div>TMN Shop</div> [cite: 29]
            <div>Email: admin@tmnshop.com.vn</div> [cite: 25]
            <div>Hotline: (028) 7302 3456</div> [cite: 25]
            <div>Địa chỉ: Hoàng Mai, Hà Nội</div> [cite: 25]
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered">
            <thead class="table-light">
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th class="text-end">Đơn giá</th>
                <th class="text-center">Số lượng</th>
                <th class="text-end">Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:set var="subtotal" value="0"/>
            <c:forEach var="item" items="${items}" varStatus="s">
                <tr>
                    <td>${s.index + 1}</td>
                    <td>${item.tenSP}</td> [cite: 62]
                    <td class="text-end"><fmt:formatNumber value="${item.gia}" pattern="#,###"/> đ</td> [cite: 62]
                    <td class="text-center">${item.soLuong}</td> [cite: 62]
                    <td class="text-end">
                        <fmt:formatNumber value="${item.thanhTien}" pattern="#,###"/> đ
                    </td> [cite: 62]
                </tr>
                <c:set var="subtotal" value="${subtotal + item.thanhTien}"/>
            </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" class="text-end">Tổng tiền hàng</th>
                    <th class="text-end"><fmt:formatNumber value="${subtotal}" pattern="#,###"/> đ</th>
                </tr>
                <tr>
                    <th colspan="4" class="text-end">Phí vận chuyển</th>
                    <th class="text-end">
                        <%-- Tính phí vận chuyển = Tổng hóa đơn - Tổng tiền hàng --%>
                        <fmt:formatNumber value="${order.tongTien - subtotal}" pattern="#,###"/> đ
                    </th>
                </tr>
                <tr class>
                    <th colspan="4" class="text-end h5">TỔNG CỘNG</th>
                    <th class="text-end h5 text-danger">
                        <fmt:formatNumber value="${order.tongTien}" pattern="#,###"/> đ [cite: 64]
                    </th>
                </tr>
            </tfoot>
        </table>
    </div>

    <div class="d-flex justify-content-between mt-4 no-print">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/orders">
            <i class="fa fa-arrow-left"></i> Quay lại QL Đơn hàng
        </a>
        
        <div>
            <button class="btn btn-primary" onclick="window.print()">
                <i class="fa fa-print"></i> In
            </button>
            
            <button class="btn btn-success" onclick="window.print()">
                <i class="fa fa-file-pdf"></i> Xuất PDF
            </button>
        </div>
    </div>
</div>

<%-- Thêm script bootstrap (nếu chung.jspf chưa có) --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>