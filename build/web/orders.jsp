<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
                            
                            <hr>
                            
                            <div class="summary-row h5 text-danger">
                                <span>TỔNG CỘNG:</span>
                                <span class="fw-bold">${orderItems[0].formatCurrency(totalFinal)}</span>
                            </div>
                            
                            <button type="submit" class="btn btn-success btn-lg w-100 mt-3">HOÀN TẤT ĐẶT HÀNG</button>
                            <a href="cart" class="btn btn-outline-secondary w-100 mt-2">← Quay lại giỏ hàng</a>
                            
                        </div>
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
</body>
</html>