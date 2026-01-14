<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bar.beans.Post" %>
<%@ page import="com.bar.service.PostService" %>
<%@ page import="com.bar.service.BarService" %>
<%@ page import="com.bar.beans.Bar" %>
<%
    // 设置请求和响应编码
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 获取所有帖子
    PostService postService = new PostService();
    List<Post> allPosts = postService.getAllPosts();

    // 获取贴吧信息用于显示贴吧名称
    BarService barService = new BarService();
%>
<!DOCTYPE html>
<html>
<head>
    <title>所有帖子</title>
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
                <h2>所有帖子</h2>
                <div class="d-flex align-items-center">
                    <span class="me-2">共 <%= allPosts.size() %> 篇帖子</span>
                    <button class="btn btn-sm btn-outline-secondary" id="refreshBtn">
                        <i class="bi bi-arrow-clockwise"></i> 刷新
                    </button>
                </div>
            </div>
        </section>

        <section id="postsContainer">
            <% if (allPosts.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-file-text"></i>
                <h4>暂无帖子</h4>
                <p>还没有用户发布任何帖子，快去发一篇吧！</p>
                <a href="Post.jsp" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> 发布新帖子
                </a>
            </div>
            <% } else { %>
            <div class="row">
                <% for (Post post : allPosts) { 
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
                                    用户ID: <%= post.getUserId() %> | 
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
                                <a href="Post.jsp?postId=<%= post.getId() %>" class="btn btn-sm btn-outline-secondary">
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
        button.addEventListener('click', function() {
            const postId = this.getAttribute('data-id');
            if (confirm('确定要删除这篇帖子吗？此操作不可恢复！')) {
                deletePost(postId);
            }
        });
    });
    
    function deletePost(postId) {
        fetch(`api/post/${postId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('删除失败');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                alert('帖子删除成功！');
                location.reload(); // 刷新页面
            } else {
                alert('删除失败：' + data.message);
            }
        })
        .catch(error => {
            console.error('删除帖子时出错:', error);
            alert('删除帖子时发生错误，请稍后再试');
        });
    }
</script>
</body>
</html>