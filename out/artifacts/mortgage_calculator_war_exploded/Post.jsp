<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Post</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <!-- 引入 Bootstrap Icons 用于图标 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<!-- 顶部导航 -->
<jsp:include page="common/top.jsp"/>
<!-- 主体区域 -->
<div class="d-flex justify-content-start" style="padding-top: 56px;"> <!-- 给内容留出导航高度 -->
    <!-- 左侧用户信息栏 -->
    <jsp:include page="common/left.jsp"/>
    <!-- 右侧主内容占位（保持原有示例） -->
    <div class="p-2 w-75">
        <section class="p-5">
            <div class="container">
                <div class="d-flex">
                    <div>
                        <h1>there is <span class="text-warning">postbar1212</span></h1>
                        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Atque commodi consequatur ducimus eius error eum explicabo facere facilis in ipsum maiores, maxime nihil possimus quaerat quo soluta voluptate voluptatem. Omnis?</p>
                        <p><span>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquam architecto atque autem beatae ducimus, eligendi eos eveniet iste minus molestias odio pariatur ratione repellat, sequi sit sunt vel velit voluptate!</span><span>Aliquam autem commodi consequatur cumque dicta distinctio, esse eveniet, fugiat maxime nihil nisi officia, omnis quia sunt vero. Atque eveniet explicabo harum magni, natus nemo nisi odit pariatur placeat quo!</span></p>
                    </div>
                    <img src="https://tse3.mm.bing.net/th/id/OIP.rii81IFcIMchHImhYWANmwHaKe?rs=1&pid=ImgDetMain&o=7&rm=3" class="w-25 h-auto" alt="">
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // 顶栏按钮交互
    document.getElementById('btnNotify').addEventListener('click', () => alert('暂无新通知'));
    document.getElementById('btnMsg').addEventListener('click', () => alert('暂无新私信'));

    // 收藏磁贴分页逻辑
    (function () {
        const pageSize = 4; // 每页显示 4 个磁贴
        const tiles = document.querySelectorAll('#favTiles .col');
        const pagination = document.getElementById('favPagination');
        const prevBtn = document.getElementById('prevPage');
        const nextBtn = document.getElementById('nextPage');
        const totalPages = Math.ceil(tiles.length / pageSize);
        let currentPage = 1;

        function updateButtons() {
            prevBtn.classList.toggle('disabled', currentPage === 1);
            nextBtn.classList.toggle('disabled', currentPage === totalPages);
        }
        function renderPage(page) {
            currentPage = page;
            tiles.forEach((div, idx) => {
                div.style.display = (idx >= (page - 1) * pageSize && idx < page * pageSize) ? '' : 'none';
            });
            [...pagination.querySelectorAll('[data-page]')].forEach((li) => li.classList.remove('active'));
            const activeLi = pagination.querySelector(`[data-page="${page}"]`);
            if (activeLi) activeLi.classList.add('active');
            updateButtons();
        }

        // 创建页码按钮
        for (let i = 1; i <= totalPages; i++) {
            const li = document.createElement('li');
            li.className = 'page-item';
            li.dataset.page = i;
            li.innerHTML = `<a class="page-link" href="#">${i}</a>`;
            li.addEventListener('click', (e) => {
                e.preventDefault();
                renderPage(i);
            });
            pagination.insertBefore(li, nextBtn);
        }
        prevBtn.addEventListener('click', (e) => { e.preventDefault(); if (currentPage > 1) renderPage(currentPage - 1); });
        nextBtn.addEventListener('click', (e) => { e.preventDefault(); if (currentPage < totalPages) renderPage(currentPage + 1); });
        renderPage(1);
    })();
</script>
</body>
</html>