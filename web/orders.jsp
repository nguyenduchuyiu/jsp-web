<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!--NHUNGKM-->

<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.User"%>
<%@page import="model.CartItem"%>
<%-- CẦN THIẾT: Để sử dụng các đối tượng khuyến mãi --%>
<%@page import="model.KhuyenMai"%>
<%@page import="java.math.BigDecimal"%>
<!--ENDKM-->

<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán Đơn Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .summary-box { background-color: #f8f8f8; padding: 15px; border-radius: 5px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 5px; }
        .product-list-checkout { max-height: 200px; overflow-y: auto; border-bottom: 1px dashed #ccc; margin-bottom: 10px; }
    </style>
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <h2 class="mb-4">💳 THANH TOÁN ĐƠN HÀNG</h2>
        
        <div class="row">
            
            <form method="POST" action="placeorder" class="w-100 d-flex"> 
                
                <%-- CỘT TRÁI: THÔNG TIN GIAO HÀNG VÀ THANH TOÁN (col-md-7) --%>
                <div class="col-md-7">
                    
                    <%-- 1. THÔNG TIN GIAO HÀNG --%>
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-primary text-white"><i class="fa fa-truck"></i> Thông tin giao hàng</div>
                        <div class="card-body">
                            
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Người nhận:</label>
                                    <input type="text" name="receiverName" class="form-control" value="${userInfo.name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Số điện thoại:</label>
                                    <input type="text" name="receiverPhone" class="form-control" value="${userInfo.phone}" required>
                                </div>
                            </div>
                                
                                                            
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <label class="form-label">Email:</label>
                                    <input type="email" name="receiverEmail" class="form-control" value="${userInfo.email}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Địa chỉ giao hàng (*):</label>
                                <textarea name="shippingAddress" class="form-control" rows="2" required>${userInfo.address}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Ghi chú (Tùy chọn):</label>
                                <textarea name="notes" class="form-control" rows="2" placeholder="Ví dụ: Giao hàng giờ hành chính..."></textarea>
                            </div>
                        
                        </div> 
<!--                           =======NHUNGKM-------->




<%-- Trong file /orders.jsp --%>

<div class="card-body">
<%-- Giảm giá --%>
<!--<div class="row mb-3">
    <div class="col-sm-6 text-left">Giảm giá:</div>
    <div class="col-sm-6 text-right text-danger" id="giam-gia-hien-thi">- 0 VNĐ</div>
</div>-->
<%
    // Lấy đối tượng BigDecimal từ Session (dựa trên key đã lưu trong CheckoutS/ConfirmCheckoutS)
    java.math.BigDecimal totalFinalAmount = 
        (java.math.BigDecimal) session.getAttribute("totalFinalSession");
    
    if (totalFinalAmount == null) {
        totalFinalAmount = BigDecimal.ZERO; // Tránh lỗi NullPointer
    }
    
    // Tạo một đối tượng CartItem để gọi hàm formatCurrency (vì bạn đang dùng cú pháp cũ)
    // HOẶC: Nếu bạn đã sửa thành static, bạn có thể bỏ qua bước này.
%>

<%-- Tổng Cộng --%>
<!--<div class="row font-weight-bold" style="border-top: 1px solid #ddd; padding-top: 10px;">
    <div class="col-sm-6 text-left">TỔNG CỘNG:</div>
    <div class="col-sm-6 text-right text-danger" id="tong-cong-hien-thi">
        <%= model.CartItem.formatCurrency(totalFinalAmount) %> <%-- Giá trị mặc định --%>
    </div>
</div>-->
    
<%-- Trong file /orders.jsp --%>


<!--<div class="row font-weight-bold" style="border-top: 1px solid #ddd; padding-top: 10px;">
    <div class="col-sm-6 text-left">TỔNG CỘNG:</div>
    <div class="col-sm-6 text-right text-danger">
        
        <%-- Gọi phương thức tĩnh từ LỚP CartItem --%>
        <%= model.CartItem.formatCurrency(totalFinalAmount) %>
        
    </div>
</div>-->
</div>

<hr/>

<%-- PHẦN MỚI: CHỌN CHƯƠNG TRÌNH KHUYẾN MÃI --%>






<!--------END------->
                    </div> 
                    
                    <%-- 2. PHƯƠNG THỨC THANH TOÁN --%>
                     <div class="card shadow-sm mb-4">
                         <div class="card-header bg-info text-white mb-3"><i class="fa fa-credit-card"></i> Phương thức thanh toán</div>
                         <div class="card-body">

                             <c:set var="currentMethod" value="${param.paymentMethod}"/>
                             <%-- Đặt COD là mặc định nếu không có tham số nào được gửi --%>
                             <c:if test="${empty currentMethod}"><c:set var="currentMethod" value="COD"/></c:if>

                             <div class="form-check mb-2">
                                 <input class="form-check-input payment-method" type="radio" name="paymentMethod" id="cod" value="COD"
                                        <c:if test="${currentMethod == 'COD'}">checked</c:if>>
                                 <label class="form-check-label" for="cod">
                                     Thanh toán khi nhận hàng (COD)
                                 </label>
                             </div>
                             <div class="form-check">
                                 <input class="form-check-input payment-method" type="radio" name="paymentMethod" id="bankTransfer" value="TRANSFER"
                                        <c:if test="${currentMethod == 'TRANSFER'}">checked</c:if>>
                                 <label class="form-check-label" for="bankTransfer">
                                     Chuyển khoản ngân hàng (Đang phát triển)
                                 </label>
                             </div>
                         </div>
                     </div>
                    
                </div> <%-- Đóng col-md-7 (Cột Trái) --%>
                
                
                <%-- CỘT PHẢI: TỔNG KẾT ĐƠN HÀNG (col-md-5) --%>
                <div class="col-md-5">
                    
                    <%-- Thiết lập biến tổng cuối cùng (totalFinal) --%>
                    <c:set var="shippingFee" value="${shippingFee.doubleValue()}"/>
                    <c:set var="totalFinal" value="${tongHang.doubleValue() + shippingFee}"/>
                    
                    <div id="qrCodeBlock" class="card shadow-sm mb-4" style="display: none;">
                        <div class="card-header bg-warning text-dark"><i class="fa fa-qrcode"></i> Mã QR Thanh Toán</div>
                        <div class="card-body text-center">
                            
                            <p>Vui lòng quét mã QR để thanh toán **<span class="fw-bold text-danger">${orderItems[0].formatCurrency(totalFinal)}</span>**</p>
                            
                            <img src="${pageContext.request.contextPath}/img/qr.jpg" 
                                 alt="Mã QR Chuyển Khoản" 
                                 style="max-width: 150px; border: 1px solid #ddd;">
                                 
                            <p class="small mt-2 text-danger">Nội dung chuyển khoản: DH000_TMNSHOP</p>
                            <p class="small text-muted">*(Lưu ý: Mã QR là ảnh tĩnh. Cần chuyển đúng số tiền)</p>
                        </div>
                    </div>
                    
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white"><i class="fa fa-shopping-bag"></i> Đơn hàng của bạn</div>
                        <div class="card-body summary-box">
                            
                            <%-- Danh sách sản phẩm --%>
                            <div class="product-list-checkout">
                                <c:forEach var="item" items="${orderItems}">
                                    <div class="summary-row small">
                                        <span>${item.tenSP} (${item.soLuong} x ${item.formatCurrency(item.gia)})</span>
                                        <span class="fw-bold">${item.formatCurrency(item.thanhTien)}</span>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <%-- Tính toán tổng kết --%>
                            <div class="summary-row">
                                <span>Tổng tiền hàng:</span>
                                <span class="fw-bold">${orderItems[0].formatCurrency(tongHang)}</span>
                            </div>
                            <div class="summary-row">
                                <span>Phí vận chuyển:</span>
                                <span class="fw-bold">${orderItems[0].formatCurrency(shippingFee)}</span>
                            </div>
                            
<!--                            =======NHUNGKM======-->
                            <div class="row mb-3">
                            <div class="col-sm-6 text-left">Giảm giá:</div>
                            <%-- DÒNG HIỂN THỊ GIẢM GIÁ (Cần ID để JS cập nhật) --%>
                            <div class="col-sm-6 text-right text-danger" id="giam-gia-hien-thi">- 0 VNĐ</div> 
                            </div>
                            

                            
                            
                            <div class="row font-weight-bold" style="border-top: 1px solid #ddd; padding-top: 10px;">
                                <div class="col-sm-6 text-left">TỔNG CỘNG:</div>
                                <%-- DÒNG HIỂN THỊ TỔNG CỘNG CUỐI CÙNG (Cần ID để JS cập nhật) --%>
                                <div class="col-sm-6 text-right text-danger" id="tong-cong-hien-thi">
                                     <%= model.CartItem.formatCurrency(totalFinalAmount) %> 
                                </div>
                            </div>
 
 

                        </div>
                                                        
                        <hr/>
                        <div class="p-3 mb-3" style="background-color: #f7f7f7; border-radius: 5px;">
                            <p class="font-weight-bold">🏷️ Chọn Chương trình Khuyến mãi:</p>
                                                <% 
                            List<model.KhuyenMai> kmList = (List<model.KhuyenMai>) request.getAttribute("khuyenMaiList");

                            // Khai báo tổng tiền hàng (được tính toán trong Servlet hoặc tính lại ở đây)
                            // Lấy từ Request (hoặc Session nếu bạn lưu tongHang ở đó)
                            java.math.BigDecimal tongHang = (java.math.BigDecimal) request.getAttribute("tongHang"); 
                            if (tongHang == null) { /* Lấy từ Session nếu cần */ }

                            // Chuyển BigDecimal thành double/long để sử dụng an toàn trong JS
                            long tongHangLong = tongHang != null ? tongHang.longValue() : 0; 

                            if (kmList != null && !kmList.isEmpty()) {
                                for (model.KhuyenMai km : kmList) {
                                    // Điều kiện tối thiểu
                                    long dieuKienMin = km.getDieuKienMin().longValue(); 
                                    boolean isApplicable = (tongHangLong >= dieuKienMin);
                                    boolean isGiamGia = "GIAM_GIA".equalsIgnoreCase(km.getLoaiKM());

                                    String disabledAttr = isApplicable && isGiamGia ? "" : "disabled";
                                    String titleAttr = isApplicable ? "" : "title='Đơn hàng chưa đạt tối thiểu: " + km.getDieuKienMin().toString() + " VNĐ'";
                        %>
                                    <div class="form-check" <%= titleAttr %>>
                                        <input class="form-check-input km-selector" type="radio" 
                                               name="selectedMaKM" id="km<%= km.getMaKM() %>" 
                                               value="<%= km.getMaKM() %>"
                                               <%= disabledAttr %>
                                               data-min="<%= dieuKienMin %>"
                                               data-type="<%= km.getLoaiKM() %>"
                                                data-discount-rate="<%= km.getPhanTramGiam() %>"
                                                >
                                        <label class="form-check-label <%= disabledAttr.isEmpty() ? "" : "text-muted" %>" for="km<%= km.getMaKM() %>">
                                            <strong><%= km.getTenKM() %></strong>
                                            <br><small class="text-muted"><%= km.getMoTa() %></small>
                                        </label>
                                    </div>
                                    <hr style="margin: 5px 0;" />
                        <%
                                }
                            } else {
                        %>
                                <p class="text-muted small">Không có chương trình khuyến mãi nào đang diễn ra.</p>
                        <%
                            }
                        %>

                        </div>
                            <input type="hidden" name="giamGiaInput" id="giamGiaInput" value="0">
 <!--====ENDKM====-->
 
                            <button type="submit" class="btn btn-success btn-lg w-100 mt-3">HOÀN TẤT ĐẶT HÀNG</button>
                            <a href="cart" class="btn btn-outline-secondary w-100 mt-2">← Quay lại giỏ hàng</a>
                            
                    </div>
                </div> <%-- Đóng col-md-5 (Cột Phải) --%>
                
            </form> <%-- Đóng form đặt hàng --%>
            
        </div> <%-- Đóng row --%>
    </div> <%-- Đóng container --%>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const qrBlock = document.getElementById('qrCodeBlock');
            // Lấy tất cả radio button có class 'payment-method'
            const paymentRadios = document.querySelectorAll('.payment-method');

            function updatePaymentMethodDisplay() {
                // Lấy giá trị của radio button đang được chọn
                const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                if (selectedMethod === 'TRANSFER') {
                    // Hiển thị khối QR code khi chọn Chuyển khoản
                    qrBlock.style.display = 'block';
                } else {
                    // Ẩn khối QR code khi chọn COD hoặc phương thức khác
                    qrBlock.style.display = 'none';
                }
            }

            // Gắn sự kiện 'change' cho tất cả radio buttons
            paymentRadios.forEach(radio => {
                radio.addEventListener('change', updatePaymentMethodDisplay);
            });

            // Gọi hàm lần đầu khi tải trang để xử lý trạng thái mặc định (COD)
            updatePaymentMethodDisplay();
        });
    </script>
    
<!--    NHUNGKM-->


<script>
    document.addEventListener('DOMContentLoaded', function () {
        const shippingFee = 30000; // Phí vận chuyển cố định
        // Lấy giá trị tổng tiền hàng từ JSP (dòng này cần được định nghĩa bằng JSP Expression)
        const tongHangElement = document.getElementById('tong-tien-hang'); // TẠO ID MỚI NÀY TRÊN GIAO DIỆN
        
        // Lấy Tổng tiền hàng ban đầu (chưa giảm giá)
        let tongHang = parseFloat("<%= tongHangLong %>"); // Sử dụng giá trị Long từ JSP
        
        const giamGiaElement = document.getElementById('giam-gia-hien-thi'); // ID để hiển thị giảm giá
        const tongCongElement = document.getElementById('tong-cong-hien-thi'); // ID để hiển thị tổng cộng

        function formatCurrency(amount) {
            return amount.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
        }

// -------NHUNGKM-------

// Trong file orders.jsp (Trong <script>)

function calculateTotal() {
    let giamGia = 0;
    const shippingFee = 30000;
    
    // Lấy Tổng tiền hàng ban đầu (chưa giảm giá)
    // Cần đảm bảo tongHang là biến toàn cục hoặc được định nghĩa ở đây
    let tongHang = parseFloat("<%= tongHangLong %>"); // Sử dụng giá trị Long từ JSP
    let currentTongCong = tongHang + shippingFee;

    const selectedKM = document.querySelector('input[name="selectedMaKM"]:checked');

    if (selectedKM) {
        const minCondition = parseFloat(selectedKM.getAttribute('data-min'));
        const kmType = selectedKM.getAttribute('data-type'); 
        const discountPercentage = parseInt(selectedKM.getAttribute('data-discount-rate')); // Lấy GIÁ TRỊ PHẦN TRĂM NGUYÊN

        // 1. CHỈ TÍNH TOÁN NẾU LÀ GIẢM GIÁ VÀ ĐỦ ĐIỀU KIỆN
        if (kmType === 'GIAM_GIA' && tongHang >= minCondition) {
            
            // TÍNH TOÁN TỔNG QUÁT: (Tổng tiền hàng * Phần trăm giảm / 100)
            const discountPercentage = parseInt(selectedKM.getAttribute('data-discount-rate'));
            let rawDiscount = tongHang * (discountPercentage / 100);
            
            // Làm tròn giảm giá đến số nguyên
            giamGia = Math.round(rawDiscount); 

            currentTongCong = currentTongCong - giamGia;
        }
        // Các KM loại 'TANG_KEM' sẽ không ảnh hưởng đến giamGia/tongCong (giamGia = 0)
    }
    
    // Cập nhật giao diện
    giamGiaElement.textContent = '- ' + formatCurrency(giamGia);
    tongCongElement.textContent = formatCurrency(currentTongCong);

// 5. CẬP NHẬT INPUT ẨN (QUAN TRỌNG)
    document.getElementById('giamGiaInput').value = giamGia;
}


        
        //      ENDKM
        
        // Gắn sự kiện cho tất cả radio button
        document.querySelectorAll('input[name="selectedMaKM"]').forEach(radio => {
            radio.addEventListener('change', calculateTotal);
        });
        
        // Chạy lần đầu khi tải trang (để xử lý trường hợp mã KM đã được chọn trước)
        calculateTotal(); 
    });
</script>

<!--ENDKM-->
</body>
</html>