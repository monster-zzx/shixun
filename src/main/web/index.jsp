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
        /* 贴吧列表区域固定高度，超出可滚动 */
        #barListContainer {
            height: 400px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 1rem;
            background-color: #f8f9fa;
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
        
        /* 贴吧卡片样式 */
        .bar-card {
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            height: 100%;
        }
        .bar-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        /* 帖子区域样式 */
        #postListContainer {
            min-height: 300px;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 1.5rem;
            background-color: #ffffff;
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
                                <a href="registerBar.jsp" class="btn btn-light btn-sm ms-2">
                                    <i class="bi bi-plus-circle"></i> 创建贴吧
                                </a>
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
                                <div id="barListContent" class="row g-3 p-3" style="display: none;">
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
        // 顶栏按钮交互（如果存在）
        const btnNotify = document.getElementById('btnNotify');
        if (btnNotify) btnNotify.addEventListener('click', function() { alert('暂无新通知'); });
        const btnMsg = document.getElementById('btnMsg');
        if (btnMsg) btnMsg.addEventListener('click', function() { alert('暂无新私信'); });

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

            loading.style.display = 'block';
            content.style.display = 'none';
            empty.style.display = 'none';

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
                            const shortDesc = description.length > 50 ? description.substring(0, 50) + '...' : description;
                            
                            return '<div class="col-md-3 col-sm-6">' +
                                '<div class="card bar-card h-100" onclick="viewBar(' + bar.id + ')">' +
                                    '<div class="card-body">' +
                                        '<h6 class="card-title mb-2">' +
                                            '<i class="bi bi-tag-fill text-primary"></i> ' +
                                            (bar.name || '未命名') +
                                        '</h6>' +
                                        '<p class="card-text text-muted small" style="min-height: 40px;">' + shortDesc + '</p>' +
                                        '<div class="d-flex justify-content-between align-items-center mt-2">' +
                                            '<small class="text-muted">' +
                                                '<i class="bi bi-calendar"></i> ' + formatDate(bar.pubtime) +
                                            '</small>' +
                                            getStatusBadge(bar.status) +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>';
                        }).join('');
                    }
                } else {
                    loading.innerHTML = '<p class="text-warning">' + (data.message || '加载失败') + '</p>';
                }
            } catch (err) {
                loading.style.display = 'none';
                console.error('加载失败:', err);
                content.innerHTML = '<div class="col-12"><p class="text-danger text-center">加载失败: ' + err.message + '</p></div>';
                content.style.display = 'block';
            }
        }

        // 查看贴吧详情
        function viewBar(barId) {
            window.location.href = 'dispBar.jsp?id=' + barId;
        }

        // 页面加载时自动加载贴吧列表
        document.addEventListener('DOMContentLoaded', function() {
            loadBars();
            const refreshBtn = document.getElementById('btnRefreshBars');
            if (refreshBtn) {
                refreshBtn.addEventListener('click', loadBars);
            }
        });

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
