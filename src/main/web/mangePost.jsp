<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bar.beans.Post" %>
<%@ page import="com.bar.service.PostService" %>
<%@ page import="com.bar.service.BarService" %>
<%@ page import="com.bar.beans.Bar" %>
<%@ page import="com.bar.beans.User" %>
<%
    // 设置请求和响应编码
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 获取当前登录用户
    User currentUser = (User) session.getAttribute("user");
    Integer currentUserId = null;
    String currentUsername = "未登录";
    
    if (currentUser != null) {
        currentUserId = currentUser.getId();
        currentUsername = currentUser.getUsername();
    }

    // 获取当前用户的帖子
    PostService postService = new PostService();
    List<Post> userPosts = null;
    
    if (currentUserId != null) {
        userPosts = postService.getPostsByUserId(currentUserId);
    }

    // 获取贴吧信息用于显示贴吧名称
    BarService barService = new BarService();
%>
<!DOCTYPE html>
<html>
<head>
    <title>我的帖子</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <!-- 引入 Bootstrap Icons 用于图标 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .post-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
        }
        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .post-title {
            color: #333;
            font-weight: 600;
        }
        .post-meta {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .post-content {
            max-height: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .bar-tag {
            background-color: #f0f2f5;
            border-radius: 12px;
            padding: 2px 10px;
            font-size: 0.8rem;
            color: #495057;
        }
        .action-buttons {
            opacity: 0.7;
            transition: opacity 0.2s ease;
        }
        .post-card:hover .action-buttons {
            opacity: 1;
        }
        .post-stats {
            display: flex;
            gap: 15px;
            font-size: 0.9rem;
            color: #6c757d;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<jsp:include page="common/top.jsp"/>
<!-- 主体区域 -->
<div class="d-flex justify-content-start" style="padding-top: 56px;"> <!-- 给内容留出导航高度 -->
    <!-- 左侧用户信息栏 -->
    <jsp:include page="common/left.jsp"/>
    <!-- 右侧主内容 -->
    <div class="p-4 w-75">
        <section class="mb-4">
            <div class="d-flex justify-content-between align-items-center">
                <h2>我的帖子</h2>
                <div class="d-flex align-items-center">
                    <% if (currentUserId != null) { %>
                        <span class="me-2">共 <%= userPosts != null ? userPosts.size() : 0 %> 篇帖子</span>
                    <% } else { %>
                        <span class="me-2 text-muted">请先登录</span>
                    <% } %>
                    <button class="btn btn-sm btn-outline-secondary" id="refreshBtn">
                        <i class="bi bi-arrow-clockwise"></i> 刷新
                    </button>
                </div>
            </div>
        </section>

        <section id="postsContainer">
            <% if (currentUserId == null) { %>
            <div class="empty-state">
                <i class="bi bi-person-x"></i>
                <h4>请先登录</h4>
                <p>登录后即可查看和管理您的帖子</p>
                <a href="Login.jsp" class="btn btn-primary">
                    <i class="bi bi-box-arrow-in-right"></i> 去登录
                </a>
            </div>
            <% } else if (userPosts == null || userPosts.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-file-text"></i>
                <h4>暂无帖子</h4>
                <p>您还没有发布任何帖子，快去发一篇吧！</p>
                <a href="Post.jsp?referrer=<%= java.net.URLEncoder.encode(request.getRequestURL().toString(), "UTF-8") %>" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> 发布新帖子
                </a>
            </div>
            <% } else { %>
            <div class="row">
                <% for (Post post : userPosts) { 
                    // 获取帖子所属的贴吧信息
                    Bar bar = barService.getBarById(post.getBarId());
                %>
                <div class="col-12 mb-3">
                    <div class="card post-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title post-title">
                                    <a href="dispPost.jsp?postId=<%= post.getId() %>" class="text-decoration-none">
                                        <%= post.getTitle() %>
                                    </a>
                                </h5>
                                <div class="bar-tag">
                                    <i class="bi bi-tag-fill"></i> 
                                    <%= bar != null ? bar.getName() : "未知贴吧" %>
                                </div>
                            </div>
                            
                            <div class="post-content text-muted mb-3">
                                <%= post.getContent() %>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="post-meta">
                                    <i class="bi bi-person-circle"></i> 
                                    <%= currentUsername %> | 
                                    <i class="bi bi-calendar3"></i> 
                                    <%= post.getPubtime() %>
                                </div>
                                
                                <div class="post-stats">
                                    <span><i class="bi bi-eye"></i> <%= post.getViewCount() %></span>
                                    <span><i class="bi bi-hand-thumbs-up"></i> <%= post.getLikeCount() %></span>
                                    <span><i class="bi bi-chat"></i> <%= post.getCommentCount() %></span>
                                </div>
                            </div>
                            
                            <div class="action-buttons mt-2 d-flex justify-content-end gap-2">
                                <a href="dispPost.jsp?postId=<%= post.getId() %>" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye"></i> 查看
                                </a>
                                <a href="Post.jsp?postId=<%= post.getId() %>&referrer=<%= java.net.URLEncoder.encode(request.getRequestURL().toString(), "UTF-8") %>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-pencil"></i> 编辑
                                </a>
                                <button class="btn btn-sm btn-outline-danger delete-post" data-id="<%= post.getId() %>">
                                    <i class="bi bi-trash"></i> 删除
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // 顶栏按钮交互
    document.getElementById('btnNotify').addEventListener('click', () => alert('暂无新通知'));
    document.getElementById('btnMsg').addEventListener('click', () => alert('暂无新私信'));
    
    // 刷新按钮
    document.getElementById('refreshBtn').addEventListener('click', function() {
        location.reload();
    });
    
    // 删除帖子功能
    document.querySelectorAll('.delete-post').forEach(button => {
        button.addEventListener('click', async function() {
            const postId = this.getAttribute('data-id');
            console.log('删除帖子ID:', postId); // 添加调试日志
            const postCard = this.closest('.post-card');
            
            if (!postId) {
                showToast('无法获取帖子ID', 'error');
                return;
            }
            
            if (!confirm('确定要删除这篇帖子吗？此操作不可恢复！')) {
                return;
            }
            
            // 禁用按钮，防止重复点击
            this.disabled = true;
            this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 删除中...';
            
            try {
                console.log('发送删除请求，URL:', 'api/post/' + postId); // 添加调试日志
                const response = await fetch('api/post/' + postId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });
                
                console.log('响应状态:', response.status); // 添加调试日志
                
                if (!response.ok) {
                    throw new Error('HTTP错误: ' + response.status);
                }
                
                const data = await response.json();
                console.log('响应数据:', data); // 添加调试日志
                
                if (data.success) {
                    // 成功删除后，平滑移除帖子卡片
                    postCard.style.transition = 'opacity 0.3s, transform 0.3s';
                    postCard.style.opacity = '0';
                    postCard.style.transform = 'translateX(20px)';
                    
                    setTimeout(() => {
                        postCard.remove();
                        
                        // 检查是否还有帖子，如果没有则显示空状态
                        const remainingPosts = document.querySelectorAll('.post-card');
                        if (remainingPosts.length === 0) {
                            const postsContainer = document.getElementById('postsContainer');
                            postsContainer.innerHTML = `
                                <div class="empty-state">
                                    <i class="bi bi-file-text"></i>
                                    <h4>暂无帖子</h4>
                                    <p>您还没有发布任何帖子，快去发一篇吧！</p>
                                    <a href="Post.jsp?referrer=<%= java.net.URLEncoder.encode(request.getRequestURL().toString(), "UTF-8") %>" class="btn btn-primary">
                                        <i class="bi bi-plus-circle"></i> 发布新帖子
                                    </a>
                                </div>
                            `;
                            
                            // 更新帖子计数
                            const postCountElement = document.querySelector('.me-2');
                            if (postCountElement) {
                                postCountElement.textContent = '共 0 篇帖子';
                            }
                        } else {
                            // 更新帖子计数
                            const postCountElement = document.querySelector('.me-2');
                            if (postCountElement) {
                                postCountElement.textContent = `共 ${remainingPosts.length} 篇帖子`;
                            }
                        }
                    }, 300);
                    
                    // 显示成功提示
                    showToast('帖子删除成功', 'success');
                } else {
                    throw new Error(data.message || '删除失败');
                }
            } catch (error) {
                console.error('删除帖子时出错:', error);
                console.error('错误详情:', error.message); // 添加调试日志
                showToast('删除失败: ' + error.message, 'error');
                
                // 恢复按钮状态
                this.disabled = false;
                this.innerHTML = '<i class="bi bi-trash"></i> 删除';
            }
        });
    });
    
    // 显示提示消息
    function showToast(message, type) {
        // 设置默认类型
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
        const toastClass = type === 'success' ? 'success' : (type === 'error' ? 'danger' : 'primary');
        
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
</script>
</body>
</html>