<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>搜索结果</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        /* 结果卡片通用样式（复用首页） */
        .bar-card{
            transition:all .3s ease;cursor:pointer;height:100%;border:1px solid #e9ecef;border-radius:.5rem;overflow:hidden;box-shadow:0 2px 4px rgba(0,0,0,.05);position:relative;transform-origin:center;background:#fff
        }
        .bar-card:hover{transform:translateY(-5px) scale(1.02);box-shadow:0 8px 16px rgba(0,0,0,.1);border-color:#0d6efd}
        .bar-card::before{content:'';position:absolute;top:0;left:0;width:100%;height:4px;background:linear-gradient(90deg,#0d6efd,#6610f2);opacity:0;transition:opacity .3s ease}
        .bar-card:hover::before{opacity:1}
        .bar-card-body{padding:1rem;display:flex;flex-direction:column;height:100%}
        .bar-icon{width:50px;height:50px;border-radius:50%;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);display:flex;align-items:center;justify-content:center;color:#fff;font-weight:bold;font-size:1.2rem;margin-bottom:.75rem;transition:all .3s ease}
        .bar-card:hover .bar-icon{transform:rotate(10deg) scale(1.1);box-shadow:0 4px 8px rgba(102,126,234,.4)}
        .bar-title{font-weight:600;font-size:1rem;margin-bottom:.5rem;color:#212529;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;transition:color .2s ease}
        .bar-card:hover .bar-title{color:#0d6efd}
        .bar-description{color:#6c757d;font-size:.85rem;flex-grow:1;overflow:hidden;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;transition:color .2s ease}
        .bar-card:hover .bar-description{color:#495057}
        /* 容器 */
        #resultContainer{gap:1rem}
        @media(max-width:768px){.bar-card{width:100% !important}}

        /* 帖子结果样式 */
        .post-item{cursor:pointer;transition:all .2s ease;border:1px solid #e9ecef;border-radius:.5rem;overflow:hidden;background:#fff}
        .post-item:hover{border-color:#198754;box-shadow:0 6px 14px rgba(0,0,0,.08);transform:translateY(-2px)}
        .post-title{font-weight:700;font-size:1rem;color:#212529;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
        .post-meta{font-size:.85rem;color:#6c757d}
        .post-snippet{color:#6c757d;font-size:.9rem;margin-top:.5rem;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
        .tab-btn{cursor:pointer}
    </style>
</head>
<body>
<!-- 顶部导航 -->
<jsp:include page="common/top.jsp"/>

<div class="d-flex justify-content-start" style="padding-top: 56px;">
    <jsp:include page="common/left.jsp"/>

    <!-- 主内容 -->
    <div class="p-2 w-75">
        <section class="p-4">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                    <h5 class="mb-0">搜索结果：<span class="text-primary" id="kwText"></span></h5>
                    <div class="btn-group" role="group" aria-label="search type">
                        <button id="tabBar" type="button" class="btn btn-outline-primary tab-btn">贴吧</button>
                        <button id="tabPost" type="button" class="btn btn-outline-success tab-btn">帖子</button>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div id="resultContainer" class="p-4 d-flex flex-wrap justify-content-start">
                            <!-- 结果插入 -->
                        </div>
                        <div id="noResult" class="text-center py-5 text-muted" style="display: none;">
                            <i class="bi bi-search" style="font-size: 3rem;"></i>
                            <p class="mt-2" id="noResultText">未找到相关内容</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // 解析查询参数
    function getQueryParam(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name) || '';
    }

    function formatDate(timestamp) {
        if (!timestamp) return '-';
        const date = new Date(timestamp);
        return date.toLocaleDateString('zh-CN');
    }

    const keyword = decodeURIComponent(getQueryParam('keyword'));
    document.getElementById('kwText').textContent = keyword;

    // type=bar|post，默认 bar
    let currentType = (getQueryParam('type') || 'bar').toLowerCase();

    function setActiveTab() {
        const tabBar = document.getElementById('tabBar');
        const tabPost = document.getElementById('tabPost');
        if (currentType === 'post') {
            tabBar.classList.remove('btn-primary');
            tabBar.classList.add('btn-outline-primary');
            tabPost.classList.remove('btn-outline-success');
            tabPost.classList.add('btn-success');
        } else {
            tabPost.classList.remove('btn-success');
            tabPost.classList.add('btn-outline-success');
            tabBar.classList.remove('btn-outline-primary');
            tabBar.classList.add('btn-primary');
        }
    }

    async function loadResults() {
        const container = document.getElementById('resultContainer');
        const noResult = document.getElementById('noResult');
        const noResultText = document.getElementById('noResultText');

        container.innerHTML = '';
        noResult.style.display = 'none';

        if (!keyword) {
            noResultText.textContent = '请输入搜索关键词';
            noResult.style.display = 'block';
            return;
        }

        try {
            if (currentType === 'post') {
                const resp = await fetch('api/post/search?keyword=' + encodeURIComponent(keyword) + '&limit=50');
                const data = await resp.json();
                if (data && data.success && Array.isArray(data.data) && data.data.length > 0) {
                    renderPostCards(data.data);
                } else {
                    noResultText.textContent = '未找到相关帖子';
                    noResult.style.display = 'block';
                }
            } else {
                const resp = await fetch('api/bar/search?keyword=' + encodeURIComponent(keyword));
                const data = await resp.json();
                if (data && data.success && Array.isArray(data.data) && data.data.length > 0) {
                    renderBarCards(data.data);
                } else {
                    noResultText.textContent = '未找到相关贴吧';
                    noResult.style.display = 'block';
                }
            }
        } catch (e) {
            console.error('搜索失败', e);
            noResultText.textContent = '搜索失败，请稍后重试';
            noResult.style.display = 'block';
        }
    }

    function renderBarCards(bars) {
        const container = document.getElementById('resultContainer');
        container.innerHTML = bars.map(function(bar){
            const name = bar.name || '未命名';
            const desc = bar.description ? (bar.description.length > 60 ? bar.description.substring(0, 60) + '...' : bar.description) : '暂无简介';
            const firstChar = name.charAt(0).toUpperCase();
            return '<div class="bar-card" style="width: 18rem;" onclick="viewBar(' + bar.id + ')">' +
                        '<div class="bar-card-body">' +
                            '<div class="d-flex align-items-center mb-3">' +
                                '<div class="bar-icon me-3">' + firstChar + '</div>' +
                                '<h6 class="bar-title mb-0">' + name + '</h6>' +
                            '</div>' +
                            '<p class="bar-description">' + desc + '</p>' +
                        '</div>' +
                    '</div>';
        }).join('');
    }

    function renderPostCards(posts) {
        const container = document.getElementById('resultContainer');
        container.classList.remove('flex-wrap');
        container.classList.add('flex-column');

        container.innerHTML = posts.map(function(p){
            const title = p.title || '无标题';
            const barName = p.barName ? ('[' + p.barName + '] ') : '';
            const time = formatDate(p.pubtime);
            const snippet = p.content ? (p.content.length > 80 ? p.content.substring(0, 80) + '...' : p.content) : '';
            const commentCount = (p.comment_count != null ? p.comment_count : (p.commentCount || 0));

            return '<div class="post-item p-3 mb-3" onclick="viewPost(' + p.id + ')">' +
                        '<div class="d-flex justify-content-between align-items-start gap-2">' +
                            '<div class="flex-grow-1">' +
                                '<div class="post-title">' + barName + title + '</div>' +
                                '<div class="post-meta mt-1">' + time + '</div>' +
                            '</div>' +
                            '<div class="text-nowrap">' +
                                '<span class="badge bg-primary">评论 ' + commentCount + '</span>' +
                            '</div>' +
                        '</div>' +
                        (snippet ? ('<div class="post-snippet">' + snippet + '</div>') : '') +
                    '</div>';
        }).join('');
    }

    function viewBar(id) {
        window.location.href = 'dispBar.jsp?id=' + id;
    }

    function viewPost(id) {
        window.location.href = 'dispPost.jsp?id=' + id;
    }

    document.addEventListener('DOMContentLoaded', function(){
        // tabs
        document.getElementById('tabBar').addEventListener('click', function(){
            currentType = 'bar';
            setActiveTab();
            // 恢复容器布局
            const container = document.getElementById('resultContainer');
            container.classList.remove('flex-column');
            container.classList.add('flex-wrap');
            loadResults();
        });
        document.getElementById('tabPost').addEventListener('click', function(){
            currentType = 'post';
            setActiveTab();
            loadResults();
        });

        setActiveTab();
        loadResults();
    });
</script>
</body>
</html>
