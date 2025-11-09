<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hỗ Trợ Trực Tuyến (<c:out value="${conversation.tieuDe}" default="Tạo liên hệ mới"/>)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    /* STYLE CHUNG */
    .chat-box { 
        max-height: 400px;
        overflow-y: auto; 
        padding: 15px; 
        border: 1px solid #ddd; 
        border-radius: 5px; 
        background-color: #f9f9f9;
    }
    
    /* CĂN LỀ TIN NHẮN (Dùng Flexbox) */
    .message-row { 
        display: flex;
        margin-bottom: 10px; 
    }
    .user-message { 
        justify-content: flex-end; /* User: Căn phải */
    }
    .admin-message { 
        justify-content: flex-start; /* Admin: Căn trái */
    }
    
    /* BUBBLE CHUNG (Giới hạn chiều rộng) */
    .user-bubble, .admin-bubble {
        max-width: 100%; 
        padding: 8px 12px; 
        border-radius: 15px;
        display: inline-block;
        word-wrap: break-word; 
    }
    
    /* STYLE CHO TIN NHẮN CỦA USER */
    .user-bubble {
        background-color: #dcf8c6; 
    }
    
    /* STYLE CHO TIN NHẮN CỦA ADMIN */
    .admin-bubble { 
        background-color: #ffffff; 
        border: 1px solid #eee; 
    }
    
    .time-label { 
        font-size: 0.7em; 
        color: #999; 
        margin-top: 3px; 
    }
</style>
</head>
<body>
    
    <%@include file="chung.jspf" %>
    
    <div class="container page-content mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <h2 class="mb-4">💬 HỖ TRỢ TRỰC TUYẾN:</h2>
                <hr>
                
                <%-- HIỂN THỊ THÔNG BÁO LỖI VÀ XÓA SESSION --%>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger">${sessionScope.error}</div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <%-- KHỐI HIỂN THỊ LỊCH SỬ CHAT --%>
                <div class="chat-box" id="chatBox">
                    <c:forEach var="msg" items="${history}">
                        <c:choose>
                            <c:when test="${msg.maNguoiGui == sessionScope.account.maND}">
                                <%-- Tin nhắn của User (Sát lề phải) --%>
                                <div class="message-row user-message">
                                    <div class="text-end" style="max-width: 70%;"> 
                                        <div class="user-bubble">${msg.noiDung}</div>
                                        <div class="time-label">
                                            <fmt:formatDate value="${msg.thoiGianGui}" pattern="HH:mm dd/MM"/>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <%-- Tin nhắn của Admin (Sát lề trái) --%>
                                <div class="message-row admin-message">
                                    <div class="text-start" style="max-width: 70%;"> 
                                        <div class="admin-bubble">
                                            <strong>Admin:</strong> ${msg.noiDung}
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
                
                <%-- FORM GỬI TIN NHẮN MỚI --%>
                <form method="POST" action="contact" class="mt-3">
                    <input type="hidden" name="maTC" value="${conversation.maTC}">
                    
                    <div class="input-group">
                        <textarea name="noiDung" rows="2" class="form-control" placeholder="Nhập tin nhắn của bạn..." required></textarea>
                        <button type="submit" class="btn btn-primary" style="min-width: 90px;border-radius: 8px !important;">Gửi</button>
                    </div>
                </form>
            
            </div>
        </div>
    </div>
    
    <%@include file="footer.jspf" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cuộn xuống cuối chat box khi tải trang
        const chatBox = document.getElementById('chatBox');
        if (chatBox) {
             chatBox.scrollTop = chatBox.scrollHeight;
        }
    </script>
</body>
</html>