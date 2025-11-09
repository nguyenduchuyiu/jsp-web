<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<head>
    <title>Quản Lý Liên Hệ</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">  
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">  
</head>
<body class="admin-page">
    
    <%@include file="chung.jspf" %>
    
    <div class="container-fluid page-content mt-5 mb-5">
        <h2 class="mb-4">🛠️ QUẢN LÝ CÁC CUỘC TRÒ CHUYỆN</h2>
        
        <div class="row">
            
            <%-- CỘT TRÁI: DANH SÁCH CUỘC TRÒ CHUYỆN --%>
            <div class="col-md-4 sidebar shadow-sm">
                <div class="card-header bg-primary text-white">Danh sách Users (${conversationList.size()})</div>
                <div class="list-group list-group-flush">
                    <c:forEach var="conv" items="${conversationList}">
                        <a href="chat?maTC=${conv.maTC}" 
                           class="list-group-item list-group-item-action chat-list-item 
                           <c:if test="${conv.maTC == selectedMaTC}">active</c:if>">
                            
                            <div>
                                <span class="fw-bold">${conv.tenNguoiDung}</span>
                                <span class="badge bg-secondary float-end">
                                    <fmt:formatDate value="${conv.ngayTao}" pattern="dd/MM HH:mm"/>
                                </span>
                            </div>
                            <small>
                                Chủ đề: ${conv.tieuDe} | 
                                Trạng thái: 
                                <span class="
                                    <c:if test="${conv.trangThai == 'Waiting'}">status-waiting</c:if>
                                    <c:if test="${conv.trangThai == 'Open'}">status-open</c:if>
                                ">
                                    ${conv.trangThai}
                                </span>
                            </small>
                        </a>
                    </c:forEach>
                    <c:if test="${empty conversationList}">
                         <div class="alert alert-info m-3">Không có cuộc trò chuyện nào.</div>
                    </c:if>
                </div>
            </div>
            
            <%-- CỘT PHẢI: LỊCH SỬ CHAT --%>
            <div class="col-md-8 chat-content shadow-sm bg-white p-0">
                <c:choose>
                    <c:when test="${selectedMaTC != null}">
                        
                        <div class="chat-history" id="chatHistory">
                            <c:forEach var="msg" items="${history}">
                                <c:choose>
                                    <c:when test="${msg.maNguoiGui == 1}">
                                        <%-- Tin nhắn của Admin (Sát lề phải) --%>
                                        <div class="message-row admin-message">
                                            <div class="text-end">
                                                <div class="admin-bubble">
                                                    ${msg.noiDung}
                                                </div>
                                                <div class="time-label">
                                                    <fmt:formatDate value="${msg.thoiGianGui}" pattern="HH:mm dd/MM"/>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Tin nhắn của User (Sát lề trái) --%>
                                        <div class="message-row user-message">
                                            <div class="text-start">
                                                <div class="user-bubble">
                                                    <strong>User:</strong> ${msg.noiDung}
                                                </div>
                                                <div class="time-label text-start">
                                                    <fmt:formatDate value="${msg.thoiGianGui}" pattern="HH:mm dd/MM"/>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        
                        <%-- FORM PHẢN HỒI CỦA ADMIN --%>
                        <div class="p-3 border-top">
                            <form method="POST" action="chat">
                                <input type="hidden" name="maTC" value="${selectedMaTC}">
                                <div class="input-group">
                                    <textarea name="noiDung" rows="2" class="form-control" placeholder="Phản hồi cho khách hàng..." required></textarea>
                                    <button type="submit" class="btn btn-success" style="min-width: 90px;border-radius: 8px !important;">Gửi Phản Hồi</button>
                                </div>
                            </form>
                        </div>
                    
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info w-100 text-center m-0" style="flex-grow: 1; display: flex; align-items: center; justify-content: center;">
                            Vui lòng chọn một người dùng để xem chi tiết trò chuyện.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <%@include file="/footer.jspf" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cuộn xuống cuối chat box khi tải trang
        const chatHistory = document.getElementById('chatHistory');
        if(chatHistory) {
            chatHistory.scrollTop = chatHistory.scrollHeight;
        }
    </script>
</body>
