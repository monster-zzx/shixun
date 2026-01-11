<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>贴吧</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <!-- 引入 Bootstrap Icons 用于图标 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
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

    <!-- 主体区域 -->
    <div class="d-flex justify-content-start" style="padding-top: 56px;"> <!-- 给内容留出导航高度 -->
        <!-- 左侧用户信息栏 -->
        <div class="flex-shrink-1 w-25 sidebar-bg border-end" style="min-height:100vh;">
            <section class="p-2">
                <div class="container mt-4">
                    <div class="d-flex align-items-center mb-3">
                        <img src="images/faces/face2.jpg" alt="头像" class="rounded-circle me-2" style="width:48px;height:48px;object-fit:cover;">
                        <h5 class="mb-0">张三</h5>
                    </div>

                    <h6 class="text-muted">个人简介</h6>
                    <p class="small">喜欢分享技术与生活点滴，常年混迹于各大 IT 贴吧。</p>

                    <!-- 收藏磁贴 -->
                    <h6 class="mt-4">收藏的贴吧</h6>
                    <div id="favTiles" class="row row-cols-2 g-2 mb-2">
                        <div class="col"><div class="card text-center p-2 fav-tile">Java 贴吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">Python 贴吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">前端技术吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">算法刷题吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">电影交流吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">动漫研究所</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">足球迷吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">篮球吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">旅行分享吧</div></div>
                        <div class="col"><div class="card text-center p-2 fav-tile">健身打卡吧</div></div>
                    </div>
                    <nav>
                        <ul id="favPagination" class="pagination justify-content-center pagination-sm mb-0">
                            <li class="page-item disabled" id="prevPage"><a class="page-link" href="#">&laquo;</a></li>
                            <!-- page numbers 将插入这里 -->
                            <li class="page-item" id="nextPage"><a class="page-link" href="#">&raquo;</a></li>
                        </ul>
                    </nav>

                    <!-- 贴吧分类 -->
                    <h6 class="mt-4">贴吧分类</h6>
                    <div class="accordion" id="categoryAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingTech">
                                <button class="accordion-button collapsed p-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTech" aria-expanded="false" aria-controls="collapseTech">
                                    技术
                                </button>
                            </h2>
                            <div id="collapseTech" class="accordion-collapse collapse" aria-labelledby="headingTech" data-bs-parent="#categoryAccordion">
                                <div class="accordion-body p-2">
                                    <span class="badge bg-secondary me-1 mb-1">Java</span>
                                    <span class="badge bg-secondary me-1 mb-1">Python</span>
                                    <span class="badge bg-secondary me-1 mb-1">前端</span>
                                    <span class="badge bg-secondary me-1 mb-1">算法</span>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingEntertainment">
                                <button class="accordion-button collapsed p-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseEntertainment" aria-expanded="false" aria-controls="collapseEntertainment">
                                    娱乐
                                </button>
                            </h2>
                            <div id="collapseEntertainment" class="accordion-collapse collapse" aria-labelledby="headingEntertainment" data-bs-parent="#categoryAccordion">
                                <div class="accordion-body p-2">
                                    <span class="badge bg-secondary me-1 mb-1">电影</span>
                                    <span class="badge bg-secondary me-1 mb-1">音乐</span>
                                    <span class="badge bg-secondary me-1 mb-1">动漫</span>
                                    <span class="badge bg-secondary me-1 mb-1">游戏</span>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingSports">
                                <button class="accordion-button collapsed p-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSports" aria-expanded="false" aria-controls="collapseSports">
                                    体育
                                </button>
                            </h2>
                            <div id="collapseSports" class="accordion-collapse collapse" aria-labelledby="headingSports" data-bs-parent="#categoryAccordion">
                                <div class="accordion-body p-2">
                                    <span class="badge bg-secondary me-1 mb-1">足球</span>
                                    <span class="badge bg-secondary me-1 mb-1">篮球</span>
                                    <span class="badge bg-secondary me-1 mb-1">网球</span>
                                    <span class="badge bg-secondary me-1 mb-1">电竞</span>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingLife">
                                <button class="accordion-button collapsed p-2" type="button" data-bs-toggle="collapse" data-bs-target="#collapseLife" aria-expanded="false" aria-controls="collapseLife">
                                    生活
                                </button>
                            </h2>
                            <div id="collapseLife" class="accordion-collapse collapse" aria-labelledby="headingLife" data-bs-parent="#categoryAccordion">
                                <div class="accordion-body p-2">
                                    <span class="badge bg-secondary me-1 mb-1">美食</span>
                                    <span class="badge bg-secondary me-1 mb-1">旅行</span>
                                    <span class="badge bg-secondary me-1 mb-1">健身</span>
                                    <span class="badge bg-secondary me-1 mb-1">摄影</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <!-- 右侧主内容占位（保持原有示例） -->
        <div class="p-2 w-75">
            <section class="p-5">
                <div class="container">
                    <div class="d-flex">
                        <div>
                            <h1>there is <span class="text-warning">postbar</span></h1>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit...</p>
                        </div>
                        <img src="https://tse3.mm.bing.net/th/id/OIP.rii81IFcIMchHImhYWANmwHaKe?rs=1&pid=ImgDetMain&o=7&rm=3" class="w-25 h-auto">
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- JS -->
    <script src="JS/jquery-3.7.1.min.js"></script>
    <script src="JS/bootstrap5.js"></script>
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