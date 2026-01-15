<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.bar.beans.Post" %>
<%@ page import="com.bar.beans.Bar" %>
<%@ page import="com.bar.beans.User" %>
<%@ page import="com.bar.service.PostService" %>
<%@ page import="com.bar.service.BarService" %>
<%@ page import="com.bar.service.CommentService" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bar.beans.Comment" %>
<%
    // 设置请求和响应编码
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 获取帖子ID
    String postIdParam = request.getParameter("postId");
    Integer postId = null;
    Post post = null;
    Bar bar = null;
    List<Comment> comments = null;
    User currentUser = (User) session.getAttribute("user");
    boolean isLoggedIn = currentUser != null;
    
    try {
        if (postIdParam != null && !postIdParam.isEmpty()) {
            postId = Integer.parseInt(postIdParam);
            
            // 获取帖子详情
            PostService postService = new PostService();
            post = postService.getPostById(postId);
            
            if (post != null) {
                // 获取贴吧信息
                BarService barService = new BarService();
                bar = barService.getBarById(post.getBarId());
                
                // 获取评论列表
                CommentService commentService = new CommentService();
                comments = commentService.getCommentsByPostId(postId);
                
                // 增加浏览量
                postService.incrementViewCount(postId);
            }
        }
    } catch (NumberFormatException e) {
        // 无效的帖子ID
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= post != null ? post.getTitle() : "帖子不存在" %></title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .post-detail-card {
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .post-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 0.375rem 0.375rem 0 0;
        }
        
        .post-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .post-meta {
            opacity: 0.9;
            font-size: 0.9rem;
        }
        
        .post-content {
            padding: 1.5rem;
            line-height: 1.8;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .post-stats {
            display: flex;
            gap: 1rem;
            padding: 1rem 1.5rem;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .comment-section {
            margin-top: 2rem;
        }
        
        .comment-card {
            border-left: 3px solid #e9ecef;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .comment-card:hover {
            border-left-color: #667eea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem 0.5rem;
            border-bottom: 1px solid #f1f3f5;
        }
        
        .comment-author {
            font-weight: 600;
            color: #495057;
        }
        
        .comment-time {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .comment-content {
            padding: 0.75rem 1rem;
            line-height: 1.6;
        }
        
        .comment-form {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.375rem;
            margin-top: 2rem;
            border-top: 2px solid #e9ecef;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
        }
        
        .empty-state {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        
        .bar-tag {
            background-color: rgba(255,255,255,0.2);
            border-radius: 12px;
            padding: 2px 10px;
            font-size: 0.8rem;
            display: inline-block;
            margin-top: 0.5rem;
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
                    <% if (post == null) { %>
                    <div class="empty-state">
                        <i class="bi bi-exclamation-triangle" style="font-size: 3rem;"></i>
                        <h4>帖子不存在</h4>
                        <p>您访问的帖子可能已被删除或不存在</p>
                        <a href="index.jsp" class="btn btn-primary">
                            <i class="bi bi-house"></i> 返回首页
                        </a>
                    </div>
                    <% } else { %>
                    <!-- 帖子详情 -->
                    <div class="card post-detail-card">
                        <div class="post-header">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h1 class="post-title"><%= post.getTitle() %></h1>
                                    <div class="post-meta">
                                        <div class="d-flex align-items-center gap-3">
                                            <span><i class="bi bi-person-circle"></i> 用户ID: <%= post.getUserId() %></span>
                                            <span><i class="bi bi-calendar3"></i> <%= post.getPubtime() %></span>
                                            <% if (bar != null) { %>
                                            <div class="bar-tag">
                                                <i class="bi bi-tag-fill"></i> <%= bar.getName() %>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="post-content">
                            <%= post.getContent() %>
                        </div>
                        
                        <div class="post-stats">
                            <div class="stat-item">
                                <i class="bi bi-eye"></i>
                                <span>浏览: <%= post.getViewCount() %></span>
                            </div>
                            <div class="stat-item">
                                <i class="bi bi-hand-thumbs-up"></i>
                                <span>点赞: <%= post.getLikeCount() %></span>
                            </div>
                            <div class="stat-item">
                                <i class="bi bi-chat"></i>
                                <span>评论: <%= post.getCommentCount() %></span>
                            </div>
                        </div>
                        
                        <div class="action-buttons px-3 pb-3">
                            <% if (isLoggedIn && post.getUserId().equals(currentUser.getId())) { %>
                            <button class="btn btn-outline-primary btn-sm" onclick="editPost(<%= post.getId() %>)">
                                <i class="bi bi-pencil"></i> 编辑
                            </button>
                            <button class="btn btn-outline-danger btn-sm" onclick="deletePost(<%= post.getId() %>)">
                                <i class="bi bi-trash"></i> 删除
                            </button>
                            <% } %>
                            <% if (bar != null) { %>
                            <a href="dispBar.jsp?id=<%= bar.getId() %>" class="btn btn-outline-info btn-sm">
                                <i class="bi bi-house"></i> 返回贴吧首页
                            </a>
                            <% } %>
                            <button class="btn btn-outline-secondary btn-sm" onclick="goBack()">
                                <i class="bi bi-arrow-left"></i> 返回
                            </button>
                        </div>
                    </div>
                    
                    <!-- 评论区 -->
                    <div class="comment-section">
                        <h3 class="mb-4">评论区</h3>
                        
                        <!-- 评论列表 -->
                        <div id="commentsContainer">
                            <% if (comments == null || comments.isEmpty()) { %>
                            <div class="empty-state">
                                <i class="bi bi-chat" style="font-size: 2rem;"></i>
                                <p>暂无评论，快来发表第一条评论吧！</p>
                            </div>
                            <% } else { %>
                            <% for (Comment comment : comments) { %>
                            <div class="card comment-card">
                                <div class="comment-header">
                                    <div class="comment-author">
                                        <i class="bi bi-person-circle"></i> 用户ID: <%= comment.getUserId() %>
                                    </div>
                                    <div class="comment-time">
                                        <%= comment.getPubtime() %>
                                    </div>
                                </div>
                                <div class="comment-content">
                                    <%= comment.getContent() %>
                                </div>
                                <% if (isLoggedIn && comment.getUserId().equals(currentUser.getId())) { %>
                                <div class="card-footer bg-transparent border-0">
                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteComment(<%= comment.getId() %>)">
                                        <i class="bi bi-trash"></i> 删除
                                    </button>
                                </div>
                                <% } %>
                            </div>
                            <% } %>
                            <% } %>
                        </div>
                        
                        <% if (isLoggedIn) { %>
                        <!-- 发表评论表单 -->
                        <div class="comment-form mt-4">
                            <h5 class="mb-3">发表评论</h5>
                            <form id="commentForm">
                                <div class="mb-3">
                                    <textarea class="form-control" id="commentContent" rows="4" placeholder="写下你的评论..." maxlength="500" required></textarea>
                                    <div class="form-text text-end">
                                        <span id="commentCounter">0</span>/500
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send"></i> 发表评论
                                </button>
                            </form>
                        </div>
                        <% } else { %>
                        <div class="alert alert-info mt-4">
                            <i class="bi bi-info-circle"></i> 
                            请 <a href="Login.jsp?redirect=<%= java.net.URLEncoder.encode(request.getRequestURL().toString() + (request.getQueryString() != null ? "?" + request.getQueryString() : ""), "UTF-8") %>">登录</a> 后发表评论
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </section>
        </div>
    </div>

    <%@ include file="common/bottom.txt" %>

    <script>
        // 评论字数统计
        document.getElementById('commentContent').addEventListener('input', function() {
            const length = this.value.length;
            document.getElementById('commentCounter').textContent = length;
        });
        
        // 提交评论
        document.getElementById('commentForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const content = document.getElementById('commentContent').value.trim();
            if (!content) {
                showToast('请输入评论内容', 'warning');
                return;
            }
            
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>发表中...';
            
            try {
                const response = await fetch('api/comment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        postId: <%= postId %>,
                        content: content
                    })
                });
                
                const data = await response.json();
                
                if (data && data.success) {
                    // 清空表单
                    document.getElementById('commentContent').value = '';
                    document.getElementById('commentCounter').textContent = '0';
                    
                    // 立即添加新评论到页面（不等待服务器刷新）
                    addCommentToPage(data.data);
                    
                    showToast('评论发表成功！', 'success');
                } else {
                    showToast('评论发表失败：' + (data.message || '未知错误'), 'error');
                }
            } catch (error) {
                console.error('发表评论时出错:', error);
                showToast('发表评论时发生错误，请稍后再试', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
        
        // 加载评论列表
        async function loadComments() {
            try {
                const response = await fetch('api/comment?postId=<%= postId %>');
                const data = await response.json();
                
                if (data && data.success) {
                    const comments = data.data || [];
                    const container = document.getElementById('commentsContainer');
                    
                    if (comments.length === 0) {
                        container.innerHTML = '<div class="empty-state">' +
                            '<i class="bi bi-chat" style="font-size: 2rem;"></i>' +
                            '<p>暂无评论，快来发表第一条评论吧！</p>' +
                            '</div>';
                    } else {
                        let html = '';
                        comments.forEach(comment => {
                            const isAuthor = <%= isLoggedIn %> && <%= currentUser != null ? currentUser.getId() : 0 %> === comment.userId;
                            
                            html += '<div class="card comment-card">' +
                                '<div class="comment-header">' +
                                    '<div class="comment-author">' +
                                        '<i class="bi bi-person-circle"></i> 用户ID: ' + comment.userId +
                                    '</div>' +
                                    '<div class="comment-time">' +
                                        comment.pubtime +
                                    '</div>' +
                                '</div>' +
                                '<div class="comment-content">' +
                                    escapeHtml(comment.content) +
                                '</div>';
                            
                            if (isAuthor) {
                                html += '<div class="card-footer bg-transparent border-0">' +
                                    '<button class="btn btn-sm btn-outline-danger" onclick="deleteComment(' + comment.id + ')">' +
                                        '<i class="bi bi-trash"></i> 删除' +
                                    '</button>' +
                                '</div>';
                            }
                            
                            html += '</div>';
                        });
                        
                        container.innerHTML = html;
                    }
                }
            } catch (error) {
                console.error('加载评论时出错:', error);
            }
        }
        
        // 删除评论
        async function deleteComment(commentId) {
            if (!confirm('确定要删除这条评论吗？')) {
                return;
            }
            
            try {
                const response = await fetch('api/comment/' + commentId, {
                    method: 'DELETE'
                });
                
                const data = await response.json();
                
                if (data && data.success) {
                    // 立即从页面移除评论（不等待服务器刷新）
                    const commentElement = document.querySelector('.comment-card button[onclick*="deleteComment(' + commentId + ')"]').closest('.comment-card');
                    if (commentElement) {
                        commentElement.style.transition = 'opacity 0.3s, transform 0.3s';
                        commentElement.style.opacity = '0';
                        commentElement.style.transform = 'translateX(20px)';
                        
                        setTimeout(() => {
                            commentElement.remove();
                            
                            // 更新评论计数
                            const commentCountElement = document.querySelector('.stat-item:nth-child(3) span');
                            if (commentCountElement) {
                                const currentCount = parseInt(commentCountElement.textContent.replace('评论: ', '')) || 0;
                                commentCountElement.textContent = '评论: ' + (currentCount - 1);
                            }
                            
                            // 如果没有评论了，显示空状态
                            const remainingComments = document.querySelectorAll('.comment-card');
                            if (remainingComments.length === 0) {
                                const container = document.getElementById('commentsContainer');
                                container.innerHTML = '<div class="empty-state">' +
                                    '<i class="bi bi-chat" style="font-size: 2rem;"></i>' +
                                    '<p>暂无评论，快来发表第一条评论吧！</p>' +
                                    '</div>';
                            }
                        }, 300);
                    }
                    
                    showToast('评论删除成功！', 'success');
                } else {
                    showToast('评论删除失败：' + (data.message || '未知错误'), 'error');
                }
            } catch (error) {
                console.error('删除评论时出错:', error);
                showToast('删除评论时发生错误，请稍后再试', 'error');
            }
        }
        
        // 删除帖子
        async function deletePost(postId) {
            if (!confirm('确定要删除这篇帖子吗？此操作不可恢复！')) {
                return;
            }
            
            try {
                const response = await fetch('api/post/' + postId, {
                    method: 'DELETE'
                });
                
                const data = await response.json();
                
                if (data && data.success) {
                    alert('帖子删除成功！');
                    // 跳转到贴吧页面
                    <% if (bar != null) { %>
                    window.location.href = 'dispBar.jsp?id=<%= bar.getId() %>';
                    <% } else { %>
                    window.location.href = 'index.jsp';
                    <% } %>
                } else {
                    alert('帖子删除失败：' + (data.message || '未知错误'));
                }
            } catch (error) {
                console.error('删除帖子时出错:', error);
                alert('删除帖子时发生错误，请稍后再试');
            }
        }
        
        // 编辑帖子
        function editPost(postId) {
            window.location.href = 'Post.jsp?postId=' + postId + '&referrer=' + encodeURIComponent(window.location.href);
        }
        
        // 返回上一页
        function goBack() {
            if (document.referrer) {
                window.location.href = document.referrer;
            } else {
                <% if (bar != null) { %>
                window.location.href = 'dispBar.jsp?id=<%= bar.getId() %>';
                <% } else { %>
                window.location.href = 'index.jsp';
                <% } %>
            }
        }
        
        // HTML转义
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        // 显示提示消息
        function showToast(message, type) {
            type = type || 'info';
            
            // 创建toast容器（如果不存在）
            let toastContainer = document.getElementById('toastContainer');
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.id = 'toastContainer';
                toastContainer.className = 'position-fixed top-0 end-0 p-3';
                toastContainer.style.zIndex = '1050';
                document.body.appendChild(toastContainer);
            }
            
            // 创建toast元素
            const toastId = 'toast-' + Date.now();
            const toastClass = type === 'success' ? 'success' : (type === 'error' ? 'danger' : (type === 'warning' ? 'warning' : 'primary'));
            
            const toastHtml = '<div id="' + toastId + '" class="toast align-items-center text-white bg-' + toastClass + ' border-0" role="alert" aria-live="assertive" aria-atomic="true">' +
                '<div class="d-flex">' +
                    '<div class="toast-body">' + message + '</div>' +
                    '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>' +
            '</div>';
            
            toastContainer.insertAdjacentHTML('beforeend', toastHtml);
            
            // 显示toast
            const toastElement = document.getElementById(toastId);
            const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
            toast.show();
            
            // 自动移除
            toastElement.addEventListener('hidden.bs.toast', function() {
                toastElement.remove();
            });
        }
        
        // 添加评论到页面
        function addCommentToPage(comment) {
            const container = document.getElementById('commentsContainer');
            
            // 如果当前没有评论，先清空空状态提示
            if (container.querySelector('.empty-state')) {
                container.innerHTML = '';
            }
            
            // 创建新评论元素
            const commentHtml = '<div class="card comment-card new-comment" style="opacity: 0; transform: translateY(-20px);">' +
                '<div class="comment-header">' +
                    '<div class="comment-author">' +
                        '<i class="bi bi-person-circle"></i> 用户ID: ' + comment.userId +
                    '</div>' +
                    '<div class="comment-time">' +
                        comment.pubtime +
                    '</div>' +
                '</div>' +
                '<div class="comment-content">' +
                    escapeHtml(comment.content) +
                '</div>' +
                '<div class="card-footer bg-transparent border-0">' +
                    '<button class="btn btn-sm btn-outline-danger" onclick="deleteComment(' + comment.id + ')">' +
                        '<i class="bi bi-trash"></i> 删除' +
                    '</button>' +
                '</div>' +
            '</div>';
            
            // 添加到评论列表顶部
            container.insertAdjacentHTML('afterbegin', commentHtml);
            
            // 获取新添加的评论元素并添加动画效果
            const newCommentElement = container.querySelector('.new-comment');
            if (newCommentElement) {
                // 移除临时类名
                newCommentElement.classList.remove('new-comment');
                
                // 触发动画
                setTimeout(() => {
                    newCommentElement.style.transition = 'opacity 0.5s, transform 0.5s';
                    newCommentElement.style.opacity = '1';
                    newCommentElement.style.transform = 'translateY(0)';
                }, 10);
                
                // 滚动到新评论位置
                setTimeout(() => {
                    newCommentElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }, 100);
            }
            
            // 更新评论计数
            const commentCountElement = document.querySelector('.stat-item:nth-child(3) span');
            if (commentCountElement) {
                const currentCount = parseInt(commentCountElement.textContent.replace('评论: ', '')) || 0;
                commentCountElement.textContent = '评论: ' + (currentCount + 1);
            }
        }
    </script>
</body>
</html>