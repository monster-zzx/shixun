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
                <h5 class="mb-3">搜索结果：<span class="text-primary" id="kwText"></span></h5>
                <div class="card shadow-sm">
                    <div class="card-body p-0">
                        <div id="resultContainer" class="p-4 d-flex flex-wrap gap-3 justify-content-start">
                            <!-- 结果卡片插入 -->
                        </div>
                        <div id="noResult" class="text-center py-5 text-muted" style="display: none;">
                            <i class="bi bi-search" style="font-size: 3rem;"></i>
                            <p class="mt-2">未找到相关贴吧</p>
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

    const keyword = decodeURIComponent(getQueryParam('keyword'));
    document.getElementById('kwText').textContent = keyword;

    async function loadResults() {
        if (!keyword) {
            document.getElementById('noResult').style.display = 'block';
            return;
        }
        try {
            const resp = await fetch('api/bar/search?keyword=' + encodeURIComponent(keyword));
            const data = await resp.json();
            if (data && data.success && Array.isArray(data.data) && data.data.length > 0) {
                renderCards(data.data);
            } else {
                document.getElementById('noResult').style.display = 'block';
            }
        } catch (e) {
            console.error('搜索失败', e);
            document.getElementById('noResult').style.display = 'block';
        }
    }

    function renderCards(bars) {
        const container = document.getElementById('resultContainer');
        container.innerHTML = bars.map(bar => {
            const name = bar.name || '未命名';
            const desc = bar.description ? (bar.description.length > 60 ? bar.description.substring(0, 60) + '...' : bar.description) : '暂无简介';
            const firstChar = name.charAt(0).toUpperCase();
            return `
                <div class="card bar-card" style="width: 18rem;" onclick="viewBar(${bar.id})">
                    <div class="bar-card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="bar-icon me-3">${firstChar}</div>
                            <h6 class="bar-title mb-0">${name}</h6>
                        </div>
                        <p class="bar-description">${desc}</p>
                    </div>
                </div>`;
        }).join('');
    }

    function viewBar(id) {
        window.location.href = 'dispBar.jsp?id=' + id;
    }

    document.addEventListener('DOMContentLoaded', loadResults);
</script>
</body>
</html>
