<%-- File: nhaphang_add.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %> 
<%
    // Redirect nếu truy cập trực tiếp JSP (phải đi qua servlet để có dữ liệu)
    if (request.getAttribute("nhaCungCapList") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/nhaphangadd");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Lập Phiếu Nhập Hàng Mới</title>
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
        <h2 class="mb-4 text-primary">🧾 LẬP PHIẾU YÊU CẦU NHẬP HÀNG</h2>
        <hr>
        
        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
        <c:choose>
    <c:when test="${not empty nhaCungCapList}">
        <div class="alert alert-info">DEBUG: Đã tải thành công ${fn:length(nhaCungCapList)} Nhà Cung Cấp.</div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-warning">DEBUG: Danh sách NCC trống hoặc không tải được.</div>
    </c:otherwise>
</c:choose>

        <form method="POST" action="${pageContext.request.contextPath}/admin/nhaphangsave" class="bg-white p-4 border shadow-sm">
        
            <div class="row mb-4">
                <div class="col-md-6">
                 <label class="form-label fw-bold">Nhà Cung Cấp (*):</label>
                   
                   <%-- INPUT TEXT KẾT HỢP DATALIST CHO TÍNH NĂNG AUTCOMPLETE --%>
                   <input type="text" list="ncc_options" name="tenNCC_input" id="ncc_input" 
                          class="form-control" placeholder="Nhập tên NCC (Ví dụ: OEM)" required>
                   
                   <%-- TRƯỜNG ẨN MỚI: SẼ LƯU MÃ NCC VÀ ĐƯỢC SỬ DỤNG KHI SUBMIT FORM --%>
                   <input type="hidden" name="maNCC" id="maNCC_hidden">
                   
                   <%-- DATALIST CHỨA TẤT CẢ TÙY CHỌN GỢI Ý --%>
                   <datalist id="ncc_options">
                       <c:if test="${not empty nhaCungCapList}">
                           <c:forEach var="ncc" items="${nhaCungCapList}">
                               <%-- Gán Mã NCC vào data-id để JavaScript lấy sau khi chọn --%>
                               <option data-id="${ncc.maNCC}" value="${ncc.tenNCC}">
                           </c:forEach>
                       </c:if>
                   </datalist>
                   
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-bold">Ghi Chú:</label>
                    <textarea name="ghiChu" rows="1" class="form-control" placeholder="Ghi chú thêm về phiếu nhập..."></textarea>
                </div>
            </div>
            
            <h4 class="mb-3 text-secondary border-bottom pb-2">Chi Tiết Sản Phẩm Cần Nhập</h4>
            <table class="table table-bordered admin-table" id="productDetailTable">
                <thead class="table-info">
                    <tr>
                        <th style="width: 40%;">Sản Phẩm (*)(tên)</th>
                        <th style="width: 20%;">Số Lượng (*)</th>
                        <th style="width: 20%;">Giá Nhập/Đơn Vị (*)</th>
                        <th style="width: 10%;">Thành Tiền</th>
                        <th style="width: 10%;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr id="row-0">
                        <td>
                            <select name="maSP" class="form-select product-select" required>
                                <option value="">-- Chọn Sản Phẩm --</option>
                                <%-- Vòng lặp Sản phẩm --%>
                                <c:forEach var="p" items="${productList}">
                                    <option value="${p.maSP}">${p.tenSP}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><input type="number" name="soLuong" value="1" min="1" class="form-control quantity-input" required></td>
                        <td><input type="text" name="giaNhap" value="0" class="form-control price-input" required></td>
                        <td class="total-cell fw-bold text-danger">0 VNĐ</td>
                        <td><button type="button" class="btn btn-sm btn-danger remove-row"><i class="fa fa-trash"></i></button></td>
                    </tr>
                </tbody>
            </table>

            <button type="button" id="addRowBtn" class="btn btn-outline-success btn-sm mb-4"><i class="fa fa-plus"></i> Thêm Sản Phẩm Khác</button>

            <div class="text-end">
                <h4 class="text-secondary">Tạm Tính Phiếu Nhập: <span id="grandTotal" class="text-danger">0 VNĐ</span></h4>
                <button type="submit" class="btn btn-success btn-lg mt-3"><i class="fa fa-save"></i> LƯU VÀ GỬI YÊU CẦU</button>
            </div>
            
        </form> 
        </div>
    
    <%@include file="footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const tableBody = document.querySelector('#productDetailTable tbody');
        const addRowBtn = document.getElementById('addRowBtn');
        const grandTotalElement = document.getElementById('grandTotal');
        let rowCount = 1;
        
        // Lưu danh sách sản phẩm gốc
        let productSelectHTML = tableBody.querySelector('.product-select').innerHTML;
        const originalProductSelectHTML = productSelectHTML; // Lưu bản gốc
        let filteredProducts = null; // Lưu danh sách sản phẩm đã lọc

        // LOGIC TÍNH TOÁN (Giữ nguyên)
        function calculateTotal() {
            let grandTotal = 0;
            const detailRows = tableBody.querySelectorAll('tr');
            
            detailRows.forEach(row => {
                const quantityInput = row.querySelector('.quantity-input');
                const priceInput = row.querySelector('.price-input');
                const totalCell = row.querySelector('.total-cell');

                const quantity = parseInt(quantityInput.value) || 0;
                const price = parseFloat(priceInput.value.replace(/[^0-9.]/g, '')) || 0; 
                
                const lineTotal = quantity * price;
                grandTotal += lineTotal;
                
                totalCell.textContent = lineTotal.toLocaleString('vi-VN', { maximumFractionDigits: 0 }) + ' VNĐ';
            });
            
            grandTotalElement.textContent = grandTotal.toLocaleString('vi-VN', { maximumFractionDigits: 0 }) + ' VNĐ';
        }
        function attachEventListeners(row) {
            const inputs = row.querySelectorAll('.quantity-input, .price-input');
            inputs.forEach(input => { input.addEventListener('input', calculateTotal); });
            row.querySelector('.remove-row').addEventListener('click', function() {
                if (tableBody.querySelectorAll('tr').length > 1) { row.remove(); calculateTotal(); } 
                else { alert("Phiếu nhập phải có ít nhất một sản phẩm."); }
            });
        }
        addRowBtn.addEventListener('click', function() {
            const newRow = tableBody.querySelector('tr').cloneNode(true);
            newRow.id = 'row-' + rowCount;
            newRow.querySelector('.quantity-input').value = '1';
            newRow.querySelector('.price-input').value = '0';
            newRow.querySelector('.total-cell').textContent = '0 VNĐ';
            const newSelect = newRow.querySelector('.product-select');
            // Sử dụng productSelectHTML đã được cập nhật (có thể đã lọc hoặc gốc)
            newSelect.innerHTML = productSelectHTML; 
            newSelect.value = ''; 
            attachEventListeners(newRow);
            tableBody.appendChild(newRow);
            rowCount++;
            calculateTotal();
        });
        tableBody.querySelectorAll('tr').forEach(attachEventListeners);
        calculateTotal();

        // =======================================================
        // LOGIC AUTCOMPLETE CASE-INSENSITIVE ĐÃ SỬA LỖI XÓA OPTION
        // =======================================================
        const nccInput = document.getElementById('ncc_input');
        const nccOptions = document.getElementById('ncc_options');
        const maNCCHidden = document.getElementById('maNCC_hidden');
        
        // Tạo một mảng lưu trữ tất cả các tùy chọn gốc để tìm kiếm
        const allOptions = Array.from(nccOptions.options);

        // HÀM LỌC VÀ CHỌN NCC
        nccInput.addEventListener('input', function() {
            const inputText = this.value.toLowerCase();
            maNCCHidden.value = ''; // Reset ID khi bắt đầu nhập
            
            // ******************************************************
            // SỬA LỖI: XÓA CÁC OPTIONS TRONG DATALIST TRƯỚC KHI THÊM MỚI
            // ******************************************************
            nccOptions.innerHTML = ''; 
            
            if (inputText.length > 0) {
                
                // LỌC KHÔNG PHÂN BIỆT CHỮ HOA CHỮ THƯỜNG (Kiểm tra chứa chuỗi nhập vào)
                const filteredOptions = allOptions.filter(option => 
                    option.value.toLowerCase().includes(inputText)
                );
                
                // THÊM CÁC GỢI Ý ĐÃ LỌC VÀO DATALIST
                filteredOptions.forEach(option => {
                    nccOptions.appendChild(option.cloneNode(true));
                });
            } else {
                // Nếu input rỗng, khôi phục lại TẤT CẢ các tùy chọn gốc
                allOptions.forEach(option => {
                    nccOptions.appendChild(option.cloneNode(true));
                });
            }

            // Xử lý gán ID nếu người dùng nhập chính xác một tên NCC
            // Sử dụng setTimeout để đảm bảo giá trị đã được set từ datalist (nếu chọn từ dropdown)
            setTimeout(() => {
                const selectedOption = allOptions.find(opt => opt.value === this.value);
                if (selectedOption) {
                    // Gán MaNCC vào trường ẩn
                    if (maNCCHidden.value !== selectedOption.dataset.id) {
                        maNCCHidden.value = selectedOption.dataset.id;
                        // Lọc sản phẩm ngay khi nhập đúng tên NCC hoặc chọn từ datalist
                        filterProductsBySupplier(selectedOption.dataset.id);
                    }
                } else if (this.value === '') {
                    // Nếu input rỗng, khôi phục lại tất cả sản phẩm
                    maNCCHidden.value = '';
                    restoreAllProducts();
                }
            }, 150);
        });
        
        // Xử lý khi input mất focus hoặc hoàn thành việc chọn
        nccInput.addEventListener('change', function() {
            // Tìm option có giá trị khớp với input hiện tại
            const selectedOption = allOptions.find(opt => opt.value === this.value);
            if (selectedOption) {
                if (maNCCHidden.value !== selectedOption.dataset.id) {
                    maNCCHidden.value = selectedOption.dataset.id;
                    // Lọc sản phẩm theo nhà cung cấp
                    filterProductsBySupplier(selectedOption.dataset.id);
                }
            } else {
                 // Nếu người dùng nhập tên NCC không tồn tại trong danh sách gốc
                 maNCCHidden.value = ''; 
                 // Hiển thị lại tất cả sản phẩm
                 restoreAllProducts();
            }
        });
        
        // Biến để tránh gọi nhiều lần cùng lúc
        let isFiltering = false;
        
        // Hàm lọc sản phẩm theo nhà cung cấp
        function filterProductsBySupplier(maNCC) {
            if (!maNCC || maNCC === '') {
                restoreAllProducts();
                return;
            }
            
            // Tránh gọi nhiều lần cùng lúc
            if (isFiltering) {
                return;
            }
            
            isFiltering = true;
            const url = '${pageContext.request.contextPath}/admin/getproductsbysupplier?maNCC=' + maNCC;
            
            // Gọi AJAX để lấy danh sách sản phẩm
            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }
                    return response.json();
                })
                .then(products => {
                    filteredProducts = products;
                    
                    // Lấy tất cả các dropdown sản phẩm
                    const productSelects = document.querySelectorAll('.product-select');
                    
                    productSelects.forEach((select) => {
                        const currentValue = select.value;
                        
                        // Xóa tất cả options hiện tại
                        while (select.options.length > 0) {
                            select.remove(0);
                        }
                        
                        // Thêm option mặc định
                        const defaultOption = document.createElement('option');
                        defaultOption.value = '';
                        defaultOption.textContent = '-- Chọn Sản Phẩm --';
                        select.appendChild(defaultOption);
                        
                        // Thêm các sản phẩm
                        if (products && products.length > 0) {
                            products.forEach(product => {
                                const option = document.createElement('option');
                                option.value = product.maSP;
                                option.textContent = product.tenSP;
                                select.appendChild(option);
                            });
                        }
                        
                        // Giữ lại giá trị đã chọn nếu còn trong danh sách đã lọc
                        if (currentValue && products.some(p => p.maSP === currentValue)) {
                            select.value = currentValue;
                        }
                    });
                    
                    // Cập nhật productSelectHTML để dùng cho các dòng mới
                    let filteredHTML = '<option value="">-- Chọn Sản Phẩm --</option>';
                    if (products && products.length > 0) {
                        products.forEach(product => {
                            filteredHTML += `<option value="${product.maSP}">${product.tenSP}</option>`;
                        });
                    }
                    productSelectHTML = filteredHTML;
                    
                    isFiltering = false;
                })
                .catch(error => {
                    console.error('Lỗi khi lọc sản phẩm:', error);
                    restoreAllProducts();
                    isFiltering = false;
                });
        }
        
        // Hàm khôi phục tất cả sản phẩm (khi không chọn NCC hoặc chọn lại)
        function restoreAllProducts() {
            filteredProducts = null;
            productSelectHTML = originalProductSelectHTML;
            // Khôi phục lại danh sách sản phẩm gốc cho tất cả dropdown
            const productSelects = document.querySelectorAll('.product-select');
            productSelects.forEach(select => {
                const currentValue = select.value;
                select.innerHTML = originalProductSelectHTML;
                // Giữ lại giá trị đã chọn nếu còn trong danh sách gốc
                if (currentValue) {
                    select.value = currentValue;
                }
            });
        }
        
        // ******************************************************
        // LƯU Ý: Đảm bảo datalist hiển thị đủ tất cả options ban đầu
        // khi trang tải (trước khi nhập)
        // ******************************************************
        nccOptions.innerHTML = '';
        allOptions.forEach(option => {
            nccOptions.appendChild(option.cloneNode(true));
        });
    });
</script>
</body>
</html>