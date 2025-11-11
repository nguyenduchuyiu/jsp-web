<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Pull request params
    String selectedMaSp = request.getParameter("maSp");
    String ngayBatDau = request.getParameter("ngayBatDau");
    String ngayKetThuc = request.getParameter("ngayKetThuc");

    // Pull attributes set by the servlet
    boolean reportGenerated = Boolean.TRUE.equals(request.getAttribute("reportGenerated"));
    String chartLabelsJson = (String) request.getAttribute("chartLabelsJson");   // e.g. ["2025-11-01","2025-11-02"]
    String chartDataJson = (String) request.getAttribute("chartDataJson");     // e.g. [5,3,8]
    Integer inventoryRemaining = (Integer) request.getAttribute("inventoryRemaining");
    String error = (String) request.getAttribute("error");
    String reportMaSp = (String) request.getAttribute("reportMaSp");
    String reportNgayBD = (String) request.getAttribute("reportNgayBD");
    String reportNgayKT = (String) request.getAttribute("reportNgayKT");
    Object totalRevenueObj = request.getAttribute("totalRevenue");

    // Number formatting (e.g., 1.234.567)
    java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
    String totalRevenueFmt = "0";
    if (totalRevenueObj instanceof Number) {
        totalRevenueFmt = nf.format(((Number) totalRevenueObj).longValue());
    }

    // Products list (type-agnostic loop using reflection for maSP/tenSP getters)
    java.util.List<?> productList = null;
    Object plObj = request.getAttribute("productList");
    if (plObj instanceof java.util.List<?>) {
        productList = (java.util.List<?>) plObj;
    }

    // Helper to extract bean properties safely
    java.util.function.Function<Object, String> getMaSP = (
              
        obj) -> {
        try {
            return String.valueOf(obj.getClass().getMethod("getMaSP").invoke(obj));
        } catch (Exception ignore) {
            return "";
        }
    };
    java.util.function.Function<Object, String> getTenSP = (
              
        obj) -> {
        try {
            return String.valueOf(obj.getClass().getMethod("getTenSP").invoke(obj));
        } catch (Exception ignore) {
            return "";
        }
    };
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Báo Cáo Thống Kê Sản Phẩm (Admin)</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.7.0/dist/chart.min.js"></script>
    </head>
    <body class="admin-page">

        <%@include file="chung.jspf" %>

        <div class="container page-content mt-5 mb-5">
            <h2>📈 BÁO CÁO THỐNG KÊ SẢN PHẨM</h2>
            <hr>

            <% if (error != null && !error.isEmpty()) {%>
            <div class="alert alert-danger"><%= error%></div>
            <% } %>

            <div class="report-form mb-5">
                
    <form method="POST" action="${pageContext.request.contextPath}/admin/reports" id="reportForm">
                    <div class="row g-3 align-items-end">
                        <!-- 1. Ô CHỌN SẢN PHẨM -->
                        <div class="col-md-5">
                            <label class="form-label fw-bold">Chọn Sản Phẩm:</label>
                            <select name="maSp" class="form-select" required>
                                <option value="">-- Chọn Tên hoặc Mã Sản Phẩm --</option>
                                <% if (productList != null) {
                                        for (Object p : productList) {
                                            String ma = getMaSP.apply(p);
                                            String ten = getTenSP.apply(p);
                                            boolean sel = (selectedMaSp != null && selectedMaSp.equals(ma));
                                %>
                                <option value="<%= ma%>" <%= sel ? "selected" : ""%>>[<%= ma%>] <%= ten%></option>
                                <%     }
                                    }%>
                            </select>
                        </div>

                        <!-- 2. Ô CHỌN KHOẢNG THỜI GIAN -->
                        <div class="col-md-3">
                            <label class="form-label fw-bold">Từ Ngày:</label>
                            <input type="date" name="ngayBatDau" class="form-control" required value="<%= (ngayBatDau != null ? ngayBatDau : "")%>">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label fw-bold">Đến Ngày:</label>
                            <input type="date" name="ngayKetThuc" class="form-control" required value="<%= (ngayKetThuc != null ? ngayKetThuc : "")%>">
                        </div>

                        <!-- 3. NÚT THỐNG KÊ -->
                        <div class="col-md-auto ms-auto d-flex gap-2">
                
                <%-- Nút Thống kê --%>
                <button type="submit" class="btn btn-primary" 
                         onclick="updateFormAction('reports')">
                    <i class="fa fa-chart-line"></i> Thống kê
                </button>
                
                <%-- Nút Báo cáo Doanh thu --%>
                 <button type="submit" class="btn btn-success" 
                        onclick="updateFormAction('totalrevenue')">
                    <i class="fa fa-dollar-sign"></i> Doanh thu
                </button>
            </div>
                    </div>
                </form>
            </div>

            <!-- HIỂN THỊ KẾT QUẢ THỐNG KÊ -->
            <% if (reportGenerated) {%>
            <div class="row">
                <div class="col-12">
                    <h4 class="mb-3 text-primary">
                        Kết quả Báo cáo Doanh số từ (<%= reportNgayBD != null ? reportNgayBD : ""%>) đến (<%= reportNgayKT != null ? reportNgayKT : ""%>)
                    </h4>
                    <div class="chart-container">
                        <canvas id="salesChart"></canvas>
                    </div>
                </div>
            </div>

            <hr class="mt-4 mb-4">

            <div class="row">
                <div class="col-md-6">
                    <div class="alert alert-info shadow-sm">
                        <p class="h5 mb-1">Mã Sản Phẩm: <strong class="text-dark"><%= reportMaSp != null ? reportMaSp : ""%></strong></p>
                        <p class="h4 mb-0">Số lượng Tồn kho (Ước tính):
                            <strong class="text-danger"><%= (inventoryRemaining != null ? inventoryRemaining : 0)%></strong>
                        </p>
                        <small class="text-muted">*Tính bằng cách lấy tồn kho trừ đi số lượng đã bán trong CSDL.</small>
                    </div>
                </div>

                <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <fmt:formatNumber var="formattedRevenue" value="${totalRevenue}" pattern="#,###" />

                <div class="col-md-6">
                    <div class="alert alert-success shadow-sm">
                        <p class="h5 mb-1">
                            Mã Sản Phẩm:
                            <strong class="text-dark"><%= reportMaSp != null ? reportMaSp : ""%></strong>
                        </p>
                        <p class="h4 mb-0">
                            Tổng Doanh Thu (Đã bán):
                            <strong class="text-success"><%=totalRevenueFmt%> VND</strong>
                        </p>
                        <small class="text-muted">
                            *Tổng (Số lượng * Giá bán) trong khoảng thời gian đã chọn.
                        </small>
                    </div>
                </div>
                
            <% } %>
        </div>

         <%@include file="/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

        <% if (reportGenerated) {%>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Inject raw JSON produced by the servlet (Gson). No JSON.parse needed.
                const labels = <%= (chartLabelsJson != null ? chartLabelsJson : "[]")%>;
                const dataValues = <%= (chartDataJson != null ? chartDataJson : "[]")%>;

                const ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels,
                        datasets: [{
                                label: 'Số Lượng Bán Được',
                                data: dataValues,
                                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 1
                            }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {beginAtZero: true, title: {display: true, text: 'Số Lượng Sản Phẩm'}},
                            x: {title: {display: true, text: 'Ngày'}}
                        }, scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Số Lượng Sản Phẩm'
                                },
                                suggestedMax: 10,
                                // THÊM KHỐI ticks NÀY VÀO:
                                ticks: {
                                    stepSize: 1, // Buộc các bước nhảy là 1 (0, 1, 2, 3...)
                                    precision: 0 // Đảm bảo không hiển thị số thập phân
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Ngày'
                                }
                            }
                        },
                        plugins: {title: {display: true, text: 'Doanh Số Bán Hàng Hàng Ngày'}}
                    }
                });
            });
        </script>
        <% }%>
        <script>
    function updateFormAction(actionType) {
        const form = document.getElementById('reportForm');
        const contextPath = "${pageContext.request.contextPath}/admin";
        
        if (actionType === 'reports') {
            form.action = contextPath + '/reports';
        } else if (actionType === 'totalrevenue') {
            form.action = contextPath + '/totalrevenue';
        } else if (actionType === 'exportexcel') {
            form.action = contextPath + '/exportexcel';
        }
    }
</script>
    </body>
</html>