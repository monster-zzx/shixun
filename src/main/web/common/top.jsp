<%--
  Created by IntelliJ IDEA.
  User: monster
  Date: 2026/1/9
  Time: 21:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 顶部导航 -->
<nav class="navbar navbar-theme shadow-sm fixed-top">
    <div class="container-fluid">
        <!-- Logo / 品牌 -->
        <a class="navbar-brand fw-bold" href="#"><img src="images/logo/img_1.png" class="rounded-circle" width="48" height="48" alt=""></a>

        <!-- 居中搜索栏 -->
        <form class="mx-auto w-50 position-relative">
            <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
            <input class="form-control ps-5 rounded-pill" type="search" placeholder="搜索贴吧/帖子" aria-label="Search">
        </form>

        <!-- 右侧按钮 -->
        <div class="d-flex align-items-center">
            <button class="btn position-relative me-3" id="btnNotify">
                <i class="bi bi-bell fs-5"></i>
                <span class="badge bg-danger position-absolute top-0 start-100 translate-middle p-1 rounded-circle small">3</span>
            </button>
            <button class="btn position-relative me-3" id="btnMsg">
                <i class="bi bi-chat-dots fs-5"></i>
                <span class="badge bg-danger position-absolute top-0 start-100 translate-middle p-1 rounded-circle small">5</span>
            </button>
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-decoration-none" data-bs-toggle="dropdown">
                    <img src="images/faces/face2.jpg" alt="avatar" class="rounded-circle" width="32" height="32">
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="#">个人中心</a></li>
                    <li><a class="dropdown-item" href="#">设置</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="#">退出登录</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>