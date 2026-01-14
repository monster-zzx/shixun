<%-- logout.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>退出登录</title>
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .logout-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
    </style>
</head>
<body>
<%
    // 清除session
    session.removeAttribute("user");
    session.invalidate();

    // 设置响应头防止缓存
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<jsp:include page="common/top.jsp"/>

<div class="container">
    <div class="logout-container">
        <div class="mb-4">
            <i class="bi bi-box-arrow-right text-success" style="font-size: 4rem;"></i>
        </div>
        <h3 class="mb-3">已成功退出登录</h3>
        <p class="text-muted mb-4">您已安全退出当前账号，将返回首页</p>
        <div class="d-grid gap-2">
            <a href="index.jsp" class="btn btn-primary">
                <i class="bi bi-house-door"></i> 返回首页
            </a>
            <a href="Login.jsp" class="btn btn-outline-primary">
                <i class="bi bi-box-arrow-in-right"></i> 重新登录
            </a>
        </div>
    </div>
</div>

<script>
    // 自动跳转回首页（可选）
    setTimeout(function() {
        window.location.href = "index.jsp";
    }, 3000); // 3秒后自动跳转
</script>
</body>
</html>