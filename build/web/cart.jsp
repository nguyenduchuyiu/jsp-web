<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ Hàng Của Bạn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Tùy chỉnh nhỏ để căn chỉnh */
        .cart-image { max-width: 60px; height: auto; }
        .cart-table th, .cart-table td { vertical-align: middle; }
    </style>
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="card shadow-lg border-0">
            <div class="card-header bg-white text-center">
                <h2 class="mb-0 text-tmn-red" style="font-weight: 900;">🛒 GIỎ HÀNG CỦA BẠN</h2>
            </div>
            <div class="card-body p-4">
                
                <c:if test="${not empty sessionScope.error}"><div class="alert alert-danger">${sessionScope.error}</div><c:remove var="error" scope="session"/></c:if>
                <c:if test="${not empty sessionScope.success_cart}"><div class="alert alert-success">${sessionScope.success_cart}</div><c:remove var="success_cart" scope="session"/></c:if>

                <%-- KIỂM TRA GIỎ HÀNG CÓ SẢN PHẨM KHÔNG --%>
                <c:choose>
                    <c:when test="${empty cartItems}">
                        <%-- GIỎ HÀNG TRỐNG --%>
                        <div class="alert alert-warning text-center">
                            Giỏ hàng của bạn đang trống.
                            <br><a href="home" class="alert-link">Tiếp tục mua sắm</a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <%-- GIỎ HÀNG CÓ SẢN PHẨM --%>
                        <form method="POST" action="checkout" id="checkoutForm"> 
                            <input type="hidden" name="selectedItemsString" id="selectedItemsString"> 
                            
                            <table class="table table-bordered cart-table">
                                <thead class="table-dark">
                                    <tr>
                                        <th style="width: 5%;"><input type="checkbox" id="selectAllCheckbox"></th>
                                        <th style="width: 40%;">SẢN PHẨM</th>
                                        <th style="width: 15%;">ĐƠN GIÁ</th>
                                        <th style="width: 10%;">SỐ LƯỢNG</th>
                                        <th style="width: 15%;">THÀNH TIỀN</th>
                                        <th style="width: 5%;">THAO TÁC</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <td>
                                                <input type="checkbox" class="cart-item-checkbox" 
                                                       data-price="${item.gia}" 
                                                       data-quantity="${item.soLuong}"
                                                       data-mactgh="${item.maCTGH}">
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/img/${item.hinhAnh}" alt="${item.tenSP}" class="cart-image me-3">
                                                    <div>
                                                        <a href="detail?maSp=${item.maSP}">${item.tenSP}</a>
                                                        <br><small class="text-muted">Đơn vị: ${item.donVi}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${item.formatCurrency(item.gia)}</td>
                                            <td>
                                                <input type="number" name="quantity_${item.maCTGH}" value="${item.soLuong}" min="1" class="form-control form-control-sm text-center">
                                            </td>
                                            <td>
                                                <span class="text-danger fw-bold">${item.formatCurrency(item.thanhTien)}</span>
                                            </td>
                                            <td>
                                                <a href="removeitem?maCtgh=${item.maCTGH}" class="btn btn-sm btn-danger">Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            
                            <%-- KHỐI TỔNG TIỀN VÀ THANH TOÁN --%>
                            <div class="row mt-4">
                                <div class="col-md-7">
                                    <p class="text-muted">Chọn tất cả sản phẩm muốn thanh toán</p>
                                    <a href="home" class="btn btn-outline-primary"><i class="fa fa-arrow-left"></i> Tiếp tục mua sắm</a>
                                    
                                    <form method="POST" action="clearallcart" id="clearCartForm" class="d-inline ms-2">
                                        <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Bạn chắc chắn muốn xóa toàn bộ sản phẩm trong giỏ hàng?');">
                                            Xóa toàn bộ giỏ hàng
                                        </button>
                                    </form>
                                </div>
                                <div class="col-md-5 text-end">
                                    <div class="p-3 border bg-light">
                                        <p class="mb-1">Số sản phẩm được chọn: <span id="totalQuantityValue" class="fw-bold text-danger">0</span></p>
                                        <h4 class="mb-3">Tổng tiền: <span id="totalAmountValue" class="text-danger">0 VND</span></h4>
                                        
                                        <button type="submit" id="checkoutButton" class="btn btn-danger btn-lg w-100" disabled>THANH TOÁN</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function formatCurrency(amount) {
        return amount.toLocaleString('vi-VN', { maximumFractionDigits: 0 }) + ' VND';
    }

    function updateCartSummary() {
        const itemCheckboxes = document.querySelectorAll('.cart-item-checkbox');
        let totalAmount = 0;
        let totalItemsSelected = 0; 
        const selectedIds = []; 

        itemCheckboxes.forEach(checkbox => {
            const price = parseFloat(checkbox.dataset.price) || 0;
            const quantity = parseInt(checkbox.dataset.quantity) || 0;
            
            if (checkbox.checked) {
                totalAmount += price * quantity;
                totalItemsSelected += 1;
                
                if (checkbox.dataset.mactgh) {
                    selectedIds.push(checkbox.dataset.mactgh);
                }
            }
        });

        // CẬP NHẬT INPUT ẨN TRƯỚC KHI SUBMIT FORM
        const hiddenInput = document.getElementById('selectedItemsString');
        if (hiddenInput) {
            hiddenInput.value = selectedIds.join(',');
        }

        // 1. Cập nhật Tổng tiền
        const totalAmountElement = document.getElementById('totalAmountValue');
        if (totalAmountElement) {
            totalAmountElement.textContent = formatCurrency(totalAmount);
        }
        
        // 2. Cập nhật Tổng số mặt hàng được chọn
        const totalQuantityElement = document.getElementById('totalQuantityValue');
        if (totalQuantityElement) {
            totalQuantityElement.textContent = totalItemsSelected;
        }

        // 3. Cập nhật trạng thái nút THANH TOÁN
        const checkoutButton = document.getElementById('checkoutButton');
        if (checkoutButton) {
            checkoutButton.disabled = totalAmount <= 0;
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const selectAll = document.getElementById('selectAllCheckbox');
        const itemCheckboxes = document.querySelectorAll('.cart-item-checkbox');
        
        // Gắn sự kiện cho tất cả checkbox và input số lượng
        const elementsToWatch = [...itemCheckboxes, selectAll, ...document.querySelectorAll('input[type="number"][name^="quantity_"]')];

        elementsToWatch.forEach(element => {
            element.addEventListener('change', function() {
                
                if (element.type === 'number') {
                    // Cập nhật thuộc tính data-quantity khi số lượng thay đổi
                    const checkbox = element.closest('tr').querySelector('.cart-item-checkbox');
                    if(checkbox) {
                        const newQuantity = parseInt(element.value) > 0 ? parseInt(element.value) : 1;
                        element.value = newQuantity; 
                        checkbox.dataset.quantity = newQuantity;
                    }
                }
                
                // Xử lý sự kiện Chọn Tất Cả (Select All)
                if (element === selectAll) {
                    itemCheckboxes.forEach(checkbox => {
                        checkbox.checked = selectAll.checked;
                    });
                } else if (element.classList.contains('cart-item-checkbox')) {
                    // Xử lý sự kiện checkbox con (tích/bỏ tích)
                    const allChecked = Array.from(itemCheckboxes).every(cb => cb.checked);
                    selectAll.checked = allChecked;
                }
                
                updateCartSummary();
            });
        });
        
        // CẬP NHẬT LẮNG NGHE SỰ KIỆN GỬI FORM (ĐỂ KIỂM TRA TRỐNG)
        const checkoutForm = document.getElementById('checkoutForm');
        checkoutForm.addEventListener('submit', function(e) {
            const selectedIdsString = document.getElementById('selectedItemsString').value;
            
            if (!selectedIdsString || selectedIdsString.length === 0) {
                e.preventDefault();
                alert("Vui lòng chọn ít nhất một sản phẩm để tiến hành thanh toán.");
                return false;
            }
        });


        // Thiết lập ban đầu: KHÔNG có gì được chọn và cập nhật summary
        itemCheckboxes.forEach(checkbox => checkbox.checked = false);
        selectAll.checked = false; 

        updateCartSummary();
    });
</script>