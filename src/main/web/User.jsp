<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>贴吧 - 个人中心</title>
  <link rel="stylesheet" type="text/css" href="CSS/style.css">
  <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
  <!-- 引入 Bootstrap Icons 用于图标 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <style>
    .profile-header {
      background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
      border-radius: 15px;
      color: white;
      padding: 2rem;
      margin-bottom: 2rem;
    }
    .avatar-lg {
      width: 120px;
      height: 120px;
      border: 5px solid white;
      box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .stats-card {
      background: white;
      border-radius: 12px;
      padding: 1.5rem;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: transform 0.3s;
    }
    .stats-card:hover {
      transform: translateY(-5px);
    }
    .stats-number {
      font-size: 2rem;
      font-weight: bold;
      color: #2575fc;
    }
    .stats-label {
      color: #666;
      font-size: 0.9rem;
    }
    .profile-nav .nav-link {
      border-radius: 8px;
      margin: 0 5px;
      font-weight: 500;
    }
    .profile-nav .nav-link.active {
      background-color: #2575fc;
      color: white;
    }
    .activity-item {
      border-left: 3px solid #2575fc;
      padding-left: 1rem;
      margin-bottom: 1.5rem;
    }
    .badge-points {
      background: linear-gradient(45deg, #FFD700, #FFA500);
      color: #333;
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
  <!-- 右侧主内容 - 个人中心 -->
  <div class="p-3 w-75">
    <div class="container-fluid">
      <!-- 个人资料头部 -->
      <div class="profile-header position-relative">
        <div class="d-flex align-items-center">
          <img src="https://randomuser.me/api/portraits/men/32.jpg"
               class="avatar-lg rounded-circle me-4"
               alt="用户头像">
          <div class="flex-grow-1">
            <h1 class="h2 mb-2" id="userName">加载中... <span class="badge badge-points px-3 py-2 ms-2" id="userRoleBadge"><i class="bi bi-trophy"></i> 普通用户</span></h1>
            <p class="mb-1" id="userLocation" style="display: none;"><i class="bi bi-geo-alt me-2"></i><span id="locationText"></span></p>
            <p class="mb-3" id="userResume"><i class="bi bi-quote me-2"></i><span id="resumeText">暂无简介</span></p>
            <div class="d-flex">
              <a href="informationManagee.jsp" class="btn btn-light btn-sm me-2"><i class="bi bi-pencil"></i> 编辑资料</a>
              <button class="btn btn-outline-light btn-sm"><i class="bi bi-gear"></i> 账户设置</button>
            </div>
          </div>
          <div class="text-end">
            <div class="display-6 mb-0" id="userPoints">0</div>
            <small>积分</small>
          </div>
        </div>
      </div>

      <!-- 数据统计 -->
      <div class="row mb-4">
        <div class="col-md-3 mb-3">
          <div class="stats-card text-center">
            <div class="stats-number" id="postCount">0</div>
            <div class="stats-label"><i class="bi bi-file-text"></i> 我的帖子</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="stats-card text-center">
            <div class="stats-number" id="replyCount">0</div>
            <div class="stats-label"><i class="bi bi-chat-dots"></i> 我的回复</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="stats-card text-center">
            <div class="stats-number" id="favoriteCount">0</div>
            <div class="stats-label"><i class="bi bi-bookmark"></i> 收藏内容</div>
          </div>
        </div>
        <div class="col-md-3 mb-3">
          <div class="stats-card text-center">
            <div class="stats-number" id="viewCount">0</div>
            <div class="stats-label"><i class="bi bi-eye"></i> 被浏览</div>
          </div>
        </div>
      </div>

      <!-- 个人中心导航 -->
    

      <div class="row">
        <!-- 最近动态 -->
        <div class="col-lg-8">
          <div class="card mb-4">
            <div class="card-header bg-white">
              <h5 class="mb-0"><i class="bi bi-activity me-2"></i>最近动态</h5>
            </div>
            <div class="card-body">
              <div class="activity-item">
                <div class="d-flex justify-content-between">
                  <h6 class="mb-1">发布了新帖子</h6>
                  <small class="text-muted">2小时前</small>
                </div>
                <p class="mb-1">「Java Spring Boot 实战经验分享」获得了15个赞</p>
                <a href="#" class="small">查看帖子 <i class="bi bi-arrow-right"></i></a>
              </div>
              <div class="activity-item">
                <div class="d-flex justify-content-between">
                  <h6 class="mb-1">回复了帖子</h6>
                  <small class="text-muted">昨天 14:30</small>
                </div>
                <p class="mb-1">在「前端框架选择指南」中发表了自己的见解</p>
                <a href="#" class="small">查看回复 <i class="bi bi-arrow-right"></i></a>
              </div>
              <div class="activity-item">
                <div class="d-flex justify-content-between">
                  <h6 class="mb-1">获得了成就</h6>
                  <small class="text-muted">3天前</small>
                </div>
                <p class="mb-1">"乐于助人"徽章 - 已帮助10位吧友解决问题</p>
                <span class="badge bg-warning text-dark"><i class="bi bi-award"></i> 新成就</span>
              </div>
              <div class="activity-item">
                <div class="d-flex justify-content-between">
                  <h6 class="mb-1">收藏了内容</h6>
                  <small class="text-muted">2024.05.20</small>
                </div>
                <p class="mb-1">「数据库优化最佳实践」已被收藏</p>
                <a href="#" class="small">查看收藏 <i class="bi bi-arrow-right"></i></a>
              </div>
            </div>
          </div>

          <!-- 活跃板块 -->
          <div class="card">
            <div class="card-header bg-white">
              <h5 class="mb-0"><i class="bi bi-hash me-2"></i>活跃板块</h5>
            </div>
            <div class="card-body">
              <div class="d-flex flex-wrap gap-2">
                <a href="#" class="btn btn-outline-primary btn-sm">编程技术</a>
                <a href="#" class="btn btn-outline-success btn-sm">生活分享</a>
                <a href="#" class="btn btn-outline-info btn-sm">学习交流</a>
                <a href="#" class="btn btn-outline-warning btn-sm">游戏动漫</a>
                <a href="#" class="btn btn-outline-danger btn-sm">影视音乐</a>
                <a href="#" class="btn btn-outline-secondary btn-sm">体育运动</a>
              </div>
            </div>
          </div>
        </div>

        <!-- 右侧信息栏 -->
        <div class="col-lg-4">
          <!-- 个人信息卡片 -->
          <div class="card mb-4">
            <div class="card-header bg-white">
              <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>个人信息</h5>
            </div>
            <div class="card-body">
              <ul class="list-unstyled mb-0">
                <li class="mb-2"><i class="bi bi-envelope me-2"></i> <span id="userEmail">加载中...</span></li>
                <li class="mb-2"><i class="bi bi-calendar me-2"></i> 注册于 <span id="createTime">加载中...</span></li>
                <li class="mb-2"><i class="bi bi-clock-history me-2"></i> 最后登录：<span id="lastLoginTime">加载中...</span></li>
                <li class="mb-2" id="userGenderItem" style="display: none;"><i class="bi bi-gender-ambiguous me-2"></i> <span id="userGender"></span></li>
                <li class="mb-2"><i class="bi bi-phone me-2"></i> <span id="userPhone">未设置</span></li>
              </ul>
            </div>
          </div>

          <!-- 最近访客 -->
          <div class="card">
            <div class="card-header bg-white">
              <h5 class="mb-0"><i class="bi bi-people me-2"></i>最近访客</h5>
            </div>
            <div class="card-body">
              <div class="d-flex flex-wrap gap-3">
                <div class="text-center">
                  <img src="https://randomuser.me/api/portraits/women/44.jpg"
                       class="rounded-circle" width="45" height="45" alt="访客">
                  <div class="small mt-1">李娜</div>
                </div>
                <div class="text-center">
                  <img src="https://randomuser.me/api/portraits/men/22.jpg"
                       class="rounded-circle" width="45" height="45" alt="访客">
                  <div class="small mt-1">王明</div>
                </div>
                <div class="text-center">
                  <img src="https://randomuser.me/api/portraits/women/33.jpg"
                       class="rounded-circle" width="45" height="45" alt="访客">
                  <div class="small mt-1">刘婷</div>
                </div>
                <div class="text-center">
                  <img src="https://randomuser.me/api/portraits/men/55.jpg"
                       class="rounded-circle" width="45" height="45" alt="访客">
                  <div class="small mt-1">陈浩</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
  // 获取应用程序的上下文路径
  const contextPath = '<%= request.getContextPath() %>';

  // 加载用户个人信息和统计
  async function loadUserProfile() {
    try {
      const response = await fetch(contextPath + '/api/user/profile', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin'
      });

      if (!response.ok) {
        throw new Error('获取用户信息失败');
      }

      const result = await response.json();
      
      if (!result.success) {
        console.error('获取用户信息失败:', result.message);
        return;
      }

      const data = result.data;
      const user = data.user;
      const statistics = data.statistics;

      // 更新用户基本信息
      if (user) {
        // 用户名
        const userNameEl = document.getElementById('userName');
        if (userNameEl) {
          userNameEl.innerHTML = user.username + ' <span class="badge badge-points px-3 py-2 ms-2" id="userRoleBadge"><i class="bi bi-trophy"></i> ' + 
            (user.role === 'admin' ? '管理员' : '普通用户') + '</span>';
        }

        // 邮箱
        const userEmailEl = document.getElementById('userEmail');
        if (userEmailEl) {
          userEmailEl.textContent = user.email || '未设置';
        }

        // 注册时间
        const createTimeEl = document.getElementById('createTime');
        if (createTimeEl && user.createTime) {
          const createDate = new Date(user.createTime);
          createTimeEl.textContent = createDate.toLocaleDateString('zh-CN', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
          });
        }

        // 最后登录时间
        const lastLoginTimeEl = document.getElementById('lastLoginTime');
        if (lastLoginTimeEl) {
          if (user.lastLoginTime) {
            const lastLoginDate = new Date(user.lastLoginTime);
            const now = new Date();
            const diff = now - lastLoginDate;
            const hours = Math.floor(diff / (1000 * 60 * 60));
            
            if (hours < 1) {
              lastLoginTimeEl.textContent = '刚刚';
            } else if (hours < 24) {
              lastLoginTimeEl.textContent = hours + '小时前';
            } else if (hours < 48) {
              lastLoginTimeEl.textContent = '昨天 ' + lastLoginDate.toLocaleTimeString('zh-CN', {
                hour: '2-digit',
                minute: '2-digit'
              });
            } else {
              lastLoginTimeEl.textContent = lastLoginDate.toLocaleString('zh-CN', {
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
              });
            }
          } else {
            lastLoginTimeEl.textContent = '从未登录';
          }
        }

        // 性别
        if (user.gender) {
          const userGenderItem = document.getElementById('userGenderItem');
          const userGender = document.getElementById('userGender');
          if (userGenderItem && userGender) {
            // 性别显示映射函数
            function getGenderDisplay(gender) {
              const genderMap = {
                'male': '男',
                'female': '女',
                'other': '其他',
                '男': '男',  // 兼容旧数据
                '女': '女',  // 兼容旧数据
                '其他': '其他'  // 兼容旧数据
              };
              return genderMap[gender] || gender;
            }
            userGender.textContent = getGenderDisplay(user.gender);
            userGenderItem.style.display = 'list-item';
          }
        }

        // 手机号
        const userPhoneEl = document.getElementById('userPhone');
        if (userPhoneEl) {
          userPhoneEl.textContent = user.phone || '未设置';
        }

        // 简介
        const resumeTextEl = document.getElementById('resumeText');
        if (resumeTextEl) {
          resumeTextEl.textContent = user.resume || '暂无简介';
        }

        // 积分（使用登录次数作为积分）
        const userPointsEl = document.getElementById('userPoints');
        if (userPointsEl) {
          userPointsEl.textContent = (user.loginCount || 0).toLocaleString();
        }
      }

      // 更新统计数据
      if (statistics) {
        const postCountEl = document.getElementById('postCount');
        if (postCountEl) {
          postCountEl.textContent = (statistics.postCount || 0).toLocaleString();
        }

        const replyCountEl = document.getElementById('replyCount');
        if (replyCountEl) {
          replyCountEl.textContent = (statistics.replyCount || 0).toLocaleString();
        }

        const favoriteCountEl = document.getElementById('favoriteCount');
        if (favoriteCountEl) {
          favoriteCountEl.textContent = (statistics.favoriteCount || 0).toLocaleString();
        }

        const viewCountEl = document.getElementById('viewCount');
        if (viewCountEl) {
          viewCountEl.textContent = (statistics.viewCount || 0).toLocaleString();
        }
      }

    } catch (error) {
      console.error('加载用户信息失败:', error);
      // 显示错误信息
      const userNameEl = document.getElementById('userName');
      if (userNameEl) {
        userNameEl.textContent = '加载失败';
      }
    }
  }

  // 页面加载时获取用户信息
  document.addEventListener('DOMContentLoaded', function() {
    loadUserProfile();
  });

  // 顶栏按钮交互
  if (document.getElementById('btnNotify')) {
    document.getElementById('btnNotify').addEventListener('click', function() {
      alert('暂无新通知');
    });
  }
  if (document.getElementById('btnMsg')) {
    document.getElementById('btnMsg').addEventListener('click', function() {
      alert('暂无新私信');
    });
  }

  // 收藏磁贴分页逻辑
  (function () {
    const pageSize = 4; // 每页显示 4 个磁贴
    const tiles = document.querySelectorAll('#favTiles .col');
    const pagination = document.getElementById('favPagination');
    const prevBtn = document.getElementById('prevPage');
    const nextBtn = document.getElementById('nextPage');

    if (tiles.length > 0 && pagination && prevBtn && nextBtn) {
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
        var pageItems = pagination.querySelectorAll('[data-page]');
        for (var i = 0; i < pageItems.length; i++) {
          pageItems[i].classList.remove('active');
        }
        const activeLi = pagination.querySelector('[data-page="' + page + '"]');
        if (activeLi) activeLi.classList.add('active');
        updateButtons();
      }

      // 创建页码按钮
      for (var i = 1; i <= totalPages; i++) {
        (function(pageNum) {
          const li = document.createElement('li');
          li.className = 'page-item';
          li.dataset.page = pageNum;
          li.innerHTML = '<a class="page-link" href="#">' + pageNum + '</a>';
          li.addEventListener('click', function(e) {
            e.preventDefault();
            renderPage(pageNum);
          });
          pagination.insertBefore(li, nextBtn);
        })(i);
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
    }
  })();

  // 个人中心导航切换
  var profileNavLinks = document.querySelectorAll('.profile-nav .nav-link');
  for (var i = 0; i < profileNavLinks.length; i++) {
    profileNavLinks[i].addEventListener('click', function(e) {
      e.preventDefault();
      var links = document.querySelectorAll('.profile-nav .nav-link');
      for (var j = 0; j < links.length; j++) {
        links[j].classList.remove('active');
      }
      this.classList.add('active');
      // 这里可以添加实际的内容切换逻辑
      alert('切换到 ' + this.textContent.trim());
    });
  }
</script>
</body>
</html>