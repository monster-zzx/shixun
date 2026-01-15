<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>贴吧详情</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        /* 贴吧信息区域样式 */
        #barInfoCard {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .bar-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.375rem 0.375rem 0 0;
        }
        
        .bar-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        
        /* 帖子区域样式 */
        #postListContainer {
            min-height: 400px;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 1.5rem;
            background-color: #ffffff;
        }
        
        .post-item {
            transition: all 0.3s ease;
            cursor: pointer;
            margin-bottom: 1rem;
            border-radius: 0.375rem;
            overflow: hidden;
        }
        
        .post-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .post-item .card-title a:hover {
            color: #667eea !important;
        }
        
        .post-item .card-body {
            padding: 1.25rem;
        }
        
        .post-item .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
        }
        
        .post-item .card-text {
            line-height: 1.5;
            margin-bottom: 1rem;
        }
        
        .post-item .post-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .post-item .post-stats {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            align-items: flex-end;
        }
        
        .post-item .badge {
            font-size: 0.75rem;
            padding: 0.375rem 0.75rem;
        }
        
        /* 加载动画 */
        .loading-spinner {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 200px;
        }
    </style>
</head>
<body>
    <!-- 顶部导航 -->
    <jsp:include page="common/top.jsp"/>
    
    <!-- 主体区域 -->
    <div class="d-flex justify-content-start" style="padding-top: 56px;">
        <!-- 左侧用户信息栏 -->
        <jsp:include page="common/left.jsp"/>
        
        <!-- 右侧主内容 -->
        <div class="p-2 w-75">
            <section class="p-4">
                <div class="container-fluid">
                    <!-- 贴吧基础信息区域 -->
                    <div class="card mb-4" id="barInfoCard">
                        <!-- 加载状态 -->
                        <div id="barInfoLoading" class="loading-spinner">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">加载中...</span>
                            </div>
                            <span class="ms-3">正在加载贴吧信息...</span>
                        </div>
                        
                        <!-- 贴吧信息内容 -->
                        <div id="barInfoContent" style="display: none;">
                            <div class="bar-header">
                                <div class="d-flex align-items-center">
                                    <div class="bar-icon me-3">
                                        <i class="bi bi-tag-fill"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h2 class="mb-2" id="barName">贴吧名称</h2>
                                        <div id="barTagsContainer" class="d-flex flex-wrap gap-2"></div>
                                        <div class="d-flex align-items-center gap-3">
                                            <span id="barStatusBadge" class="badge bg-light text-dark">状态</span>
                                            <small>
                                                <i class="bi bi-calendar"></i> 
                                                创建于 <span id="barCreateTime">-</span>
                                            </small>
                                        </div>
                                    </div>
                                    <div style="display: flex; flex-direction: column; gap: 0.5rem;">
                                        <a href="index.jsp" class="btn btn-light btn-sm">
                                            <i class="bi bi-arrow-left"></i> 返回首页
                                        </a>
                                        <button id="favoriteButton" class="btn btn-light btn-sm" onclick="toggleFavorite()" style="display: none;">
                                            <i class="bi-star" id="favoriteIcon"></i>
                                            <span id="favoriteText">收藏</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-body p-4">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5 class="mb-3">
                                            <i class="bi bi-info-circle"></i> 贴吧简介
                                        </h5>
                                        <p class="text-muted" id="barDescription" style="line-height: 1.8;">
                                            暂无简介
                                        </p>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <h6 class="card-title">
                                                    <i class="bi bi-person"></i> 贴吧信息
                                                </h6>
                                                <hr>
                                                <div class="mb-2">
                                                    <small class="text-muted">贴吧ID：</small>
                                                    <strong id="barId">-</strong>
                                                </div>
                                                <div class="mb-2">
                                                    <small class="text-muted">创建者ID：</small>
                                                    <strong id="barOwnerId">-</strong>
                                                </div>
                                                <div class="mb-2">
                                                    <small class="text-muted">最后更新：</small>
                                                    <strong id="barUpdateTime">-</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 错误提示 -->
                        <div id="barInfoError" class="card-body text-center py-5" style="display: none;">
                            <i class="bi bi-exclamation-triangle text-warning" style="font-size: 3rem;"></i>
                            <p class="mt-3 text-danger" id="errorMessage">加载失败</p>
                            <button class="btn btn-primary" onclick="loadBarInfo()">
                                <i class="bi bi-arrow-clockwise"></i> 重新加载
                            </button>
                        </div>
                    </div>

                    <!-- 帖子列表区域（预留） -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-chat-dots"></i> 帖子列表
                            </h5>
                            <div>
                                <button class="btn btn-light btn-sm" onclick="loadPosts()">
                                    <i class="bi bi-arrow-clockwise"></i> 刷新
                                </button>
                                <button class="btn btn-light btn-sm ms-2" onclick="createPost()">
                                    <i class="bi bi-plus-circle"></i> 发帖
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div id="postListContainer">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-file-text" style="font-size: 3rem;"></i>
                                    <p class="mt-2">帖子功能开发中，敬请期待...</p>
                                    <p class="small">这里将显示该贴吧的所有帖子</p>
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
        // 从 URL 获取贴吧 ID
        function getBarIdFromUrl() {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get('id') || urlParams.get('barId');
        }

        // 格式化日期时间
        function formatDateTime(timestamp) {
            if (!timestamp) return '-';
            const date = new Date(timestamp);
            return date.toLocaleString('zh-CN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

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
            return badges[status] || '<span class="badge bg-secondary">' + status + '</span>';
        }

        // 加载贴吧信息
        async function loadBarInfo() {
            const barId = getBarIdFromUrl();
            if (!barId) {
                showError('缺少贴吧ID参数');
                return;
            }

            const loading = document.getElementById('barInfoLoading');
            const content = document.getElementById('barInfoContent');
            const error = document.getElementById('barInfoError');

            loading.style.display = 'flex';
            content.style.display = 'none';
            error.style.display = 'none';

            try {
                const resp = await fetch('api/bar/manage?action=detail&id=' + barId, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });

                const text = await resp.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON解析失败:', text);
                    showError('服务器返回格式错误');
                    return;
                }

                loading.style.display = 'none';

                if (data && data.success && data.data) {
                    const bar = data.data;
                    
                    // 填充贴吧信息
                    document.getElementById('barId').textContent = bar.id || '-';
                    document.getElementById('barName').textContent = bar.name || '未命名贴吧';
                    document.getElementById('barDescription').textContent = bar.description || '该贴吧暂无简介';
                    document.getElementById('barOwnerId').textContent = bar.ownerUserId || '-';
                    document.getElementById('barStatusBadge').innerHTML = getStatusBadge(bar.status);
                    document.getElementById('barCreateTime').textContent = formatDate(bar.pubtime);
                    document.getElementById('barUpdateTime').textContent = formatDateTime(bar.updatedAt);
                    
                    // 更新页面标题
                    document.title = (bar.name || '贴吧详情') + ' - 贴吧';
                    
                    content.style.display = 'block';

                    // 加载收藏状态
                    loadFavoriteStatus(bar.id);
                    // 加载标签
                    loadTagsForBar(bar.id);
                } else {
                    showError(data.message || '贴吧不存在或已被删除');
                }
            } catch (err) {
                loading.style.display = 'none';
                console.error('加载失败:', err);
                showError('加载失败: ' + err.message);
            }
        }

        // 显示错误信息
        function showError(message) {
            const loading = document.getElementById('barInfoLoading');
            const content = document.getElementById('barInfoContent');
            const error = document.getElementById('barInfoError');
            
            loading.style.display = 'none';
            content.style.display = 'none';
            error.style.display = 'block';
            document.getElementById('errorMessage').textContent = message;
        }

        // 加载帖子列表
        async function loadPosts() {
            const barId = getBarIdFromUrl();
            if (!barId) {
                alert('缺少贴吧ID参数');
                return;
            }

            const container = document.getElementById('postListContainer');
            
            try {
                container.innerHTML = '<div class="text-center py-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">加载中...</span></div><p class="mt-3">正在加载帖子...</p></div>';

                const resp = await fetch('api/post?barId=' + barId, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });

                const text = await resp.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON解析失败:', text);
                    container.innerHTML = '<div class="text-center py-5 text-danger"><i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i><p class="mt-3">数据格式错误</p></div>';
                    return;
                }

                if (data && data.success) {
                    const posts = data.data || [];
                    if (posts.length === 0) {
                        container.innerHTML = '<div class="text-center py-5 text-muted"><i class="bi bi-file-earmark-text" style="font-size: 3rem;"></i><p class="mt-3">暂无帖子</p><p class="small">成为第一个发帖的人吧！</p></div>';
                    } else {
                        let html = '';
                        const currentUserId = getCurrentUserId();

                        posts.forEach(function(post) {
                            const isAuthor = currentUserId && currentUserId == post.userId;

                            html += '<div class="card mb-3 post-item" style="border-left: 4px solid #667eea;">';
                            html += '<div class="card-body">';
                            html += '<div class="d-flex justify-content-between align-items-start">';
                            html += '<div class="flex-grow-1">';
                            html += '<h5 class="card-title"><a href="#" class="text-decoration-none text-dark" onclick="viewPost(' + post.id + ')">' + escapeHtml(post.title) + '</a></h5>';
                            html += '<p class="card-text text-muted">' + escapeHtml(post.content) + '</p>';
                            html += '<div class="post-meta">';
                            html += '<span><i class="bi bi-person"></i> 用户ID: ' + post.userId + '</span>';
                            html += '<span><i class="bi bi-clock"></i> ' + formatDateTime(post.pubtime) + '</span>';
                            html += '</div>';
                            html += '</div>';
                            html += '<div class="post-stats">';
                            html += '<span class="badge bg-light text-dark"><i class="bi bi-eye"></i> ' + (post.viewCount || 0) + '</span>';
                            html += '<span class="badge bg-light text-dark"><i class="bi bi-hand-thumbs-up"></i> ' + (post.likeCount || 0) + '</span>';
                            html += '<span class="badge bg-light text-dark"><i class="bi bi-chat"></i> ' + (post.commentCount || 0) + '</span>';

                            // 如果是作者，显示删除按钮
                            if (isAuthor) {
                                html += '<button class="btn btn-sm btn-danger mt-2" onclick="deletePost(' + post.id + ')">';
                                html += '<i class="bi bi-trash"></i> 删除';
                                html += '</button>';
                            }

                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                        });
                        container.innerHTML = html;
                    }
                } else {
                    container.innerHTML = '<div class="text-center py-5 text-danger"><i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i><p class="mt-3">' + (data.message || '加载失败') + '</p></div>';
                }
            } catch (err) {
                console.error('加载失败:', err);
                container.innerHTML = '<div class="text-center py-5 text-danger"><i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i><p class="mt-3">加载失败: ' + err.message + '</p></div>';
            }
        }

        // 查看帖子详情
        function viewPost(postId) {
            alert('查看帖子详情功能开发中，帖子ID: ' + postId);
        }

        // 检查登录状态
        function isLoggedIn() {
            // 这里可以根据实际情况判断，比如检查cookie或session
            // 简单示例：检查是否有用户信息在session中（需要在JSP中设置）
            return ${not empty sessionScope.user};
        }

        // 获取当前登录用户ID
        function getCurrentUserId() {
            // 这里需要从session中获取当前用户ID
            return ${not empty sessionScope.user ? sessionScope.user.id : 'null'};
        }

        // HTML 转义
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // 加载标签并渲染
        async function loadTagsForBar(barId) {
            const container = document.getElementById('barTagsContainer');
            container.innerHTML = '';
            try {
                const resp = await fetch('api/tag/byBar?barId=' + barId, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });
                if (!resp.ok) return;
                const data = await resp.json();
                if (data && data.success && data.data) {
                    data.data.forEach(tag => {
                        const span = document.createElement('span');
                        span.className = 'badge me-2';
                        span.style.backgroundColor = tag.color || '#6c757d';
                        span.textContent = tag.name;
                        container.appendChild(span);
                    });
                }
            } catch (e) { console.error('加载标签失败', e); }
        }

        // 删除帖子
        async function deletePost(postId) {
            if (!confirm('确定要删除这个帖子吗？删除后无法恢复。')) {
                return;
            }

            try {
                const resp = await fetch('api/post/' + postId, {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });

                const text = await resp.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON解析失败:', text);
                    alert('删除失败：服务器返回格式错误');
                    return;
                }

                if (data && data.success) {
                    alert('删除成功');
                    // 重新加载帖子列表
                    loadPosts();
                } else {
                    alert('删除失败：' + (data.message || '未知错误'));
                }
            } catch (err) {
                console.error('删除失败:', err);
                alert('删除失败：' + err.message);
            }
        }

        // 创建帖子
        function createPost() {
            const barId = getBarIdFromUrl();
            if (!barId) {
                alert('缺少贴吧ID参数');
                return;
            }
            // 添加当前页面作为referrer
            const currentUrl = encodeURIComponent(window.location.href);
            window.location.href = "Post.jsp?barId=" + barId + "&referrer=" + currentUrl;
        }

        // 加载收藏状态
        async function loadFavoriteStatus(barId) {
            try {
                const resp = await fetch('api/bar/BarMember?barId=' + barId, {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });

                const text = await resp.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON解析失败:', text);
                    // 如果未登录或其他错误，隐藏收藏按钮
                    document.getElementById('favoriteButton').style.display = 'none';
                    return;
                }

                if (data && data.success && data.data) {
                    const isFavorite = data.data.isFavorite || false;
                    updateFavoriteButton(isFavorite);
                    document.getElementById('favoriteButton').style.display = '';
                } else {
                    // 未登录或其他错误，隐藏收藏按钮
                    document.getElementById('favoriteButton').style.display = 'none';
                }
            } catch (err) {
                console.error('加载收藏状态失败:', err);
                // 出错时隐藏收藏按钮
                document.getElementById('favoriteButton').style.display = 'none';
            }
        }

        // 更新收藏按钮显示状态
        function updateFavoriteButton(isFavorite) {
            const icon = document.getElementById('favoriteIcon');
            const text = document.getElementById('favoriteText');
            const button = document.getElementById('favoriteButton');

            if (isFavorite) {
                icon.className = 'bi-star-fill';
                text.textContent = '取消收藏';
                button.classList.remove('btn-light');
                button.classList.add('btn-warning');
            } else {
                icon.className = 'bi-star';
                text.textContent = '收藏';
                button.classList.remove('btn-warning');
                button.classList.add('btn-light');
            }
        }

        // 切换收藏状态
        async function toggleFavorite() {
            const barId = getBarIdFromUrl();
            if (!barId) {
                alert('缺少贴吧ID参数');
                return;
            }

            const button = document.getElementById('favoriteButton');
            const icon = document.getElementById('favoriteIcon');
            const text = document.getElementById('favoriteText');
            const currentIsFavorite = icon.className.includes('star-fill');

            // 禁用按钮，防止重复点击
            button.disabled = true;
            const originalText = text.textContent;
            text.textContent = '处理中...';

            try {
                const action = currentIsFavorite ? 'remove' : 'add';
                const resp = await fetch('api/bar/BarMember', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'action=' + action + '&barId=' + barId
                });

                const text = await resp.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error('JSON解析失败:', text);
                    alert('操作失败，请稍后再试');
                    text.textContent = originalText;
                    button.disabled = false;
                    return;
                }

                if (data && data.success) {
                    // 更新按钮状态
                    const newIsFavorite = data.data.isFavorite;
                    updateFavoriteButton(newIsFavorite);

                    // 触发自定义事件，通知侧边栏刷新收藏列表
                    window.dispatchEvent(new CustomEvent('favoriteChanged', {
                        detail: { barId: barId, isFavorite: newIsFavorite }
                    }));
                } else {
                    alert(data.message || '操作失败，请稍后再试');
                    text.textContent = originalText;
                }
            } catch (err) {
                console.error('操作失败:', err);
                alert('操作失败：' + err.message);
                text.textContent = originalText;
            } finally {
                button.disabled = false;
            }
        }

        // 页面加载时自动加载贴吧信息和帖子列表
        document.addEventListener('DOMContentLoaded', function() {
            loadBarInfo();
            loadPosts();
        });

        // 顶栏按钮交互（如果存在）
        const btnNotify = document.getElementById('btnNotify');
        if (btnNotify) btnNotify.addEventListener('click', function() { alert('暂无新通知'); });
        const btnMsg = document.getElementById('btnMsg');
        if (btnMsg) btnMsg.addEventListener('click', function() { alert('暂无新私信'); });
    </script>
</body>
</html>
