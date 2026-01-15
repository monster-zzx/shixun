<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>贴吧首页</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <!-- 引入 Bootstrap Icons 用于图标 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        /* 贴吧列表区域优化 */
        #barListContainer {
            height: 450px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 1.25rem;
            background-color: #f8f9fa;
        }

        /* 动态布局容器 */
        .masonry-container {
            column-count: 3;
            column-gap: 1rem;
        }

        .masonry-item {
            break-inside: avoid;
            margin-bottom: 1rem;
        }

        /* 自定义滚动条样式 */
        #barListContainer::-webkit-scrollbar {
            width: 8px;
        }
        #barListContainer::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        #barListContainer::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        #barListContainer::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        /* 贴吧卡片样式优化 */
        .bar-card {
            transition: all 0.3s ease;
            cursor: pointer;
            height: 100%;
            border: 1px solid #e9ecef;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            position: relative;
            transform-origin: center;
        }
        .bar-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            border-color: #0d6efd;
        }
        .bar-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #0d6efd, #6610f2);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .bar-card:hover::before {
            opacity: 1;
        }

        /* 贴吧图标区域 */
        .bar-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 0.75rem;
            transition: all 0.3s ease;
        }
        .bar-card:hover .bar-icon {
            transform: rotate(10deg) scale(1.1);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.4);
        }

        /* 贴吧卡片内容布局优化 */
        .bar-card-body {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .bar-title {
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.5rem;
            color: #212529;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            transition: color 0.2s ease;
        }
        .bar-card:hover .bar-title {
            color: #0d6efd;
        }
        .bar-description {
            color: #6c757d;
            font-size: 0.85rem;
            flex-grow: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            transition: color 0.2s ease;
        }
        .bar-card:hover .bar-description {
            color: #495057;
        }
        .bar-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.75rem;
            font-size: 0.75rem;
            color: #6c757d;
        }

        /* 加载动画 */
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(0,0,0,.1);
            border-radius: 50%;
            border-top-color: #0d6efd;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* 淡入动画 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }

        /* 刷新按钮动画 */
        .refreshing {
            animation: spin 1s linear infinite;
        }
        
        /* 帖子区域样式 */
        #postListContainer {
            min-height: 300px;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 1.5rem;
            background-color: #ffffff;
        }

        /* 封禁提示样式 */
        .banned-alert {
            position: fixed;
            top: 56px;
            left: 0;
            right: 0;
            z-index: 1030;
            border-radius: 0;
            margin: 0;
            animation: slideDown 0.5s ease-out;
        }
        @keyframes slideDown {
            from { transform: translateY(-100%); }
            to { transform: translateY(0); }
        }

        /* 响应式设计优化 */
        @media (max-width: 992px) {
            .masonry-container {
                column-count: 2;
            }
            .bar-card {
                margin-bottom: 1rem;
            }
            .bar-icon {
                width: 45px;
                height: 45px;
                font-size: 1rem;
            }
        }

        @media (max-width: 768px) {
            #barListContainer {
                height: 500px;
                padding: 1rem;
            }
            .masonry-container {
                column-count: 1;
            }
            .bar-card-body {
                padding: 1rem;
            }
        }

        @media (max-width: 576px) {
            #barListContainer {
                height: 550px;
            }
            .bar-card:hover {
                transform: translateY(-3px) scale(1.01);
            }
            .bar-icon {
                width: 40px;
                height: 40px;
                font-size: 0.9rem;
            }
            .bar-title {
                font-size: 0.9rem;
            }
            .bar-description {
                font-size: 0.8rem;
                -webkit-line-clamp: 3;
            }
        }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<jsp:include page="common/top.jsp"/>

<!-- 封禁提示（只有被封禁的用户才显示） -->
<c:if test="${not empty sessionScope.user and (sessionScope.userStatus == 'banned' or sessionScope.userStatus == 'BANNED')}">
    <div class="alert alert-danger banned-alert d-flex justify-content-between align-items-center" role="alert">
        <div>
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            您的账号已被封禁，仅能浏览内容，无法进行发帖、评论、收藏等操作。
            如有疑问，请联系管理员。
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- 禁言提示 -->
<c:if test="${not empty sessionScope.user and sessionScope.userStatus == 'MUTED'}">
    <div class="alert alert-warning banned-alert d-flex justify-content-between align-items-center" role="alert">
        <div>
            <i class="bi bi-megaphone-fill me-2"></i>
            您的账号已被禁言，仅能浏览内容，无法进行发帖、评论等操作。
            禁言到期时间：${sessionScope.muteEndTime}
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- 主体区域 -->
<div class="d-flex justify-content-start" style="padding-top: 56px;">
    <!-- 左侧用户信息栏 -->
    <jsp:include page="common/left.jsp"/>
    <!-- 右侧主内容 -->
    <div class="p-2 w-75">
        <section class="p-4">
            <div class="container-fluid">
                <!-- 贴吧列表区域 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-collection"></i> 站内贴吧
                        </h5>
                        <div>
                            <button id="btnRefreshBars" class="btn btn-light btn-sm">
                                <i class="bi bi-arrow-clockwise"></i> 刷新
                            </button>
                            <!-- 封禁用户不能创建贴吧 -->
                            <c:if test="${empty sessionScope.user or sessionScope.userStatus == 'banned' or sessionScope.userStatus == 'BANNED' or sessionScope.userStatus == 'MUTED'}">
                                <button class="btn btn-light btn-sm ms-2" disabled title="您没有权限创建贴吧">
                                    <i class="bi bi-plus-circle"></i> 创建贴吧
                                </button>
                            </c:if>
                            <c:if test="${not empty sessionScope.user and sessionScope.userStatus != 'banned' and sessionScope.userStatus != 'BANNED' and sessionScope.userStatus != 'MUTED'}">
                                <a href="registerBar.jsp" class="btn btn-light btn-sm ms-2">
                                    <i class="bi bi-plus-circle"></i> 创建贴吧
                                </a>
                            </c:if>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div id="barListContainer">
                                <div id="barLoading" class="text-center py-5">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">加载中...</span>
                                    </div>
                                    <p class="mt-2 text-muted">正在加载贴吧列表...</p>
                                </div>
                                <div id="barListContent" class="masonry-container p-3" style="display: none;">
                            <!-- 动态填充贴吧卡片 -->
                        </div>
                                <div id="barEmpty" class="text-center py-5 text-muted" style="display: none;">
                                    <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                    <p class="mt-2">暂无已通过的贴吧</p>
                                </div>
                            </div>
                        </div>
                    </div>

                <!-- 最新帖子区域（预留） -->
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-chat-dots"></i> 最新帖子
                        </h5>
                    </div>
                    <div class="card-body">
                        <div id="postListContainer">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-file-text" style="font-size: 3rem;"></i>
                                <p class="mt-2">帖子功能开发中，敬请期待...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // 检查用户是否被封禁
    function isUserBanned() {
        const userStatus = '${sessionScope.userStatus}';
        const isBanned = userStatus === 'banned' || userStatus === 'BANNED';
        console.log('检查封禁状态 - userStatus:', userStatus, 'isBanned:', isBanned);
        return isBanned;
    }

    function isUserMuted() {
        const userStatus = '${sessionScope.userStatus}';
        const isMuted = userStatus === 'MUTED';
        console.log('检查禁言状态 - userStatus:', userStatus, 'isMuted:', isMuted);
        return isMuted;
    }

    // 被封禁用户的限制操作
    function restrictBannedUser() {
        console.log('执行封禁用户限制检查');
        if (isUserBanned() || isUserMuted()) {
            console.log('用户被封禁或禁言，应用限制');
            // 禁用创建贴吧按钮（已在前端HTML中处理）
            const createBarBtn = document.querySelector('a[href="registerBar.jsp"]');
            if (createBarBtn) {
                createBarBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    alert('您的账号已被限制，无法创建贴吧！');
                });
            }

            // 禁用刷新按钮的特定功能（如果需要）
            // 封禁用户只能浏览，不能刷新？这里保持浏览功能
        } else {
            console.log('用户未被封禁或禁言');
        }
    }

    // 页面加载时自动加载贴吧列表
    document.addEventListener('DOMContentLoaded', function() {
        console.log('页面加载完成');
        console.log('sessionScope.userStatus:', '${sessionScope.userStatus}');
        console.log('sessionScope.user:', '${not empty sessionScope.user}');
        
        loadBars();

        // 检查并限制被封禁用户
        restrictBannedUser();

        const refreshBtn = document.getElementById('btnRefreshBars');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', loadBars);
        }

        // 创建贴吧按钮点击事件
        const createBarBtn = document.querySelector('a[href="registerBar.jsp"]');
        if (createBarBtn) {
            createBarBtn.addEventListener('click', function(e) {
                console.log('点击创建贴吧按钮');
                // 检查是否登录
                if (!isLoggedIn()) {
                    e.preventDefault();
                    alert('请先登录后再创建贴吧！');
                    window.location.href = 'Login.jsp';
                    return;
                }
                // 检查是否被封禁
                if (isUserBanned() || isUserMuted()) {
                    e.preventDefault();
                    alert('您的账号已被限制，无法创建贴吧！');
                    return false;
                }
            });
        } else {
            console.log('创建贴吧按钮未找到（可能已被禁用）');
        }
    });

    // 检查登录状态
    function isLoggedIn() {
        const isLoggedIn = <c:choose><c:when test="${not empty sessionScope.user}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
        return isLoggedIn;
    }

    // 原有的贴吧加载函数保持不变...
    // 格式化日期
    function formatDate(timestamp) {
        if (!timestamp) return '-';
        const date = new Date(timestamp);
        return date.toLocaleDateString('zh-CN');
    }

    // 获取状态徽章
    function getStatusBadge(status) {
        const badges = {
            'PENDING': '<span class="badge bg-warning">待审核</span>',
            'ACTIVE': '<span class="badge bg-success">已通过</span>',
            'REJECTED': '<span class="badge bg-danger">已拒绝</span>'
        };
        return badges[status] || '';
    }

        // 加载贴吧列表
        async function loadBars() {
            const loading = document.getElementById('barLoading');
            const content = document.getElementById('barListContent');
            const empty = document.getElementById('barEmpty');
            const refreshBtn = document.getElementById('btnRefreshBars');

            loading.style.display = 'block';
            content.style.display = 'none';
            empty.style.display = 'none';

            // 添加刷新按钮动画
            if (refreshBtn) {
                refreshBtn.querySelector('i').classList.add('refreshing');
            }

        try {
            const resp = await fetch('api/bar/manage', {
                method: 'GET',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' }
            });

            const text = await resp.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                console.error('JSON解析失败:', text);
                loading.innerHTML = '<p class="text-danger">加载失败，请刷新重试</p>';
                return;
            }

            loading.style.display = 'none';

            // 移除刷新按钮动画
            if (refreshBtn) {
                refreshBtn.querySelector('i').classList.remove('refreshing');
            }

            if (data && data.success && data.data) {
                // 只显示状态为 ACTIVE 的贴吧
                const activeBars = data.data.filter(function(bar) {
                    return bar.status === 'ACTIVE';
                });

                    if (activeBars.length === 0) {
                        empty.style.display = 'block';
                        content.style.display = 'none';
                    } else {
                        empty.style.display = 'none';
                        content.style.display = 'block';
                        
                        // 生成贴吧卡片
                        content.innerHTML = activeBars.map(function(bar) {
                            const description = bar.description || '暂无简介';
                            const barName = bar.name || '未命名';
                            const firstChar = barName.charAt(0).toUpperCase();

                            // 随机生成不同高度的内容，使动态排列更明显
                            const descriptionLength = Math.floor(Math.random() * 3) + 2;
                            const randomDesc = description.length > 30 * descriptionLength ?
                                description.substring(0, 30 * descriptionLength) + '...' : description;

                            return '<div class="masonry-item">' +
                                '<div class="card bar-card h-100" onclick="viewBar(' + bar.id + ')">' +
                                    '<div class="bar-card-body">' +
                                        '<div class="d-flex align-items-center mb-3">' +
                                            '<div class="bar-icon me-3">' + firstChar + '</div>' +
                                            '<div class="flex-grow-1">' +
                                                '<h6 class="bar-title mb-1">' + barName + '</h6>' +
                                            '</div>' +
                                        '</div>' +
                                        '<p class="bar-description">' + randomDesc + '</p>' +
                                        '<div class="d-flex flex-wrap gap-1 mb-2">' +
                                            (Array.isArray(bar.tags) && bar.tags.length
                                                ? bar.tags.slice(0, 3).map(function(t){ return '<span class="badge bg-light text-dark border">#' + (t.name || '') + '</span>'; }).join('')
                                                : '<span class="text-muted small">暂无标签</span>') +
                                        '</div>' +
                                        '<div class="bar-meta">' +
                                            '<span class="text-muted">' + formatDate(bar.pubtime) + '</span>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                        }).join('');

                        // 添加淡入动画
                        const cards = content.querySelectorAll('.bar-card');
                        cards.forEach((card, index) => {
                            setTimeout(() => {
                                card.classList.add('fade-in');
                            }, index * 100);
                        });
                    }
                } else {
                    loading.innerHTML = '<p class="text-warning">' + (data.message || '加载失败') + '</p>';
                }
            } catch (err) {
                loading.style.display = 'none';

                // 移除刷新按钮动画
                if (refreshBtn) {
                    refreshBtn.querySelector('i').classList.remove('refreshing');
                }

                console.error('加载失败:', err);
                content.innerHTML = '<div class="col-12"><p class="text-danger text-center">加载失败: ' + err.message + '</p></div>';
                content.style.display = 'block';
            }
        }

    // 查看贴吧详情
    function viewBar(barId) {
        window.location.href = 'dispBar.jsp?id=' + barId;
    }

    // 收藏磁贴分页逻辑（如果存在）
    (function () {
        const tiles = document.querySelectorAll('#favTiles .col');
        if (tiles.length === 0) return;

        const pageSize = 4;
        const pagination = document.getElementById('favPagination');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');

        if (!pagination || !prevBtn || !nextBtn) return;

        const totalPages = Math.ceil(tiles.length / pageSize);
        let currentPage = 1;

        function updateButtons() {
            prevBtn.classList.toggle('disabled', currentPage === 1);
            nextBtn.classList.toggle('disabled', currentPage === totalPages);
        }

        function renderPage(page) {
            currentPage = page;
            tiles.forEach(function(div, idx) {
                div.style.display = (idx >= (page - 1) * pageSize && idx < page * pageSize) ? '' : 'none';
            });
            const pageItems = pagination.querySelectorAll('[data-page]');
            for (var i = 0; i < pageItems.length; i++) {
                pageItems[i].classList.remove('active');
            }
            const activeLi = pagination.querySelector('[data-page="' + page + '"]');
            if (activeLi) activeLi.classList.add('active');
            updateButtons();
        }

        // 创建页码按钮
        for (var i = 1; i <= totalPages; i++) {
            const li = document.createElement('li');
            li.className = 'page-item';
            li.dataset.page = i;
            li.innerHTML = '<a class="page-link" href="#">' + i + '</a>';
            li.addEventListener('click', function(e) {
                e.preventDefault();
                renderPage(parseInt(this.dataset.page));
            });
            pagination.insertBefore(li, nextBtn);
        }

        prevBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (currentPage > 1) renderPage(currentPage - 1);
        });

        nextBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (currentPage < totalPages) renderPage(currentPage + 1);
        });

        renderPage(1);
    })();
</script>
</body>
</html>