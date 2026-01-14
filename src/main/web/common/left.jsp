<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>

<div class="flex-shrink-1 w-25 sidebar-bg border-end" style="min-height:100vh;">
    <section class="p-2">
        <div class="container mt-4">
            <c:choose>
                <%-- 已登录状态 --%>
                <c:when test="${not empty sessionScope.user}">
                    <!-- 用户信息 -->
                    <div class="d-flex align-items-center mb-3">
                        <img src="images/faces/face2.jpg" alt="头像" class="rounded-circle me-2" style="width:48px;height:48px;object-fit:cover;">
                        <div>
                            <h5 class="mb-0">${sessionScope.user.username}</h5>
                                <%-- 去掉了 level 显示 --%>
                        </div>
                    </div>



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
                </c:when>

                <%-- 未登录状态 --%>
                <c:otherwise>
                    <!-- 登录提示区域 -->
                    <div class="text-center mb-4">
                        <i class="bi bi-person-circle" style="font-size: 4rem; color: #6c757d;"></i>
                        <h5 class="mt-3">欢迎来到贴吧</h5>
                        <p class="text-muted small">登录后可以收藏贴吧、发布帖子、参与讨论</p>
                        <div class="d-grid gap-2">
                            <a href="Login.jsp" class="btn btn-primary">登录</a>
                            <a href="Register.jsp" class="btn btn-outline-primary">注册新账号</a>
                        </div>
                    </div>

                    <!-- 贴吧分类（未登录用户也可以看） -->
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
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</div>