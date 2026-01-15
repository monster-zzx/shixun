<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>修改个人信息 - 贴吧</title>
  <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <style>
    .edit-profile-container {
      max-width: 800px;
      margin: 0 auto;
    }
    .form-section {
      background: white;
      border-radius: 12px;
      padding: 2rem;
      margin-bottom: 2rem;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }
    .form-section h5 {
      color: #2575fc;
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 2px solid #e9ecef;
    }
    .form-label {
      font-weight: 500;
      color: #495057;
      margin-bottom: 0.5rem;
    }
    .form-control:focus {
      border-color: #2575fc;
      box-shadow: 0 0 0 0.2rem rgba(37, 117, 252, 0.25);
    }
    .btn-save {
      background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
      border: none;
      color: white;
      padding: 0.75rem 2rem;
      font-weight: 500;
      border-radius: 8px;
      transition: transform 0.2s;
    }
    .btn-save:hover {
      transform: translateY(-2px);
      color: white;
    }
    .btn-cancel {
      border: 2px solid #6c757d;
      color: #6c757d;
      padding: 0.75rem 2rem;
      font-weight: 500;
      border-radius: 8px;
    }
    .btn-cancel:hover {
      background-color: #6c757d;
      color: white;
    }
    .alert-custom {
      border-radius: 8px;
      border: none;
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
  <div class="p-3 w-75">
    <div class="edit-profile-container">
      <!-- 页面标题 -->
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h3><i class="bi bi-pencil-square me-2"></i>修改个人信息</h3>
        <a href="User.jsp" class="btn btn-outline-secondary">
          <i class="bi bi-arrow-left me-2"></i>返回个人中心
        </a>
      </div>

      <!-- 提示信息 -->
      <div id="alertContainer"></div>

      <!-- 基本信息 -->
      <div class="form-section">
        <h5><i class="bi bi-person me-2"></i>基本信息</h5>
        <form id="profileForm">
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="username" class="form-label">用户名</label>
              <input type="text" class="form-control" id="username" name="username" required>
              <div class="form-text">用户名将用于登录和显示</div>
            </div>
            <div class="col-md-6">
              <label for="email" class="form-label">邮箱</label>
              <input type="email" class="form-control" id="email" name="email" required>
              <div class="form-text">用于接收通知和找回密码</div>
            </div>
          </div>

          <div class="row mb-3">
            <div class="col-md-6">
              <label for="phone" class="form-label">手机号</label>
              <input type="tel" class="form-control" id="phone" name="phone" pattern="[0-9]{11}" maxlength="11">
              <div class="form-text">11位手机号码</div>
            </div>
            <div class="col-md-6">
              <label for="gender" class="form-label">性别</label>
              <select class="form-select" id="gender" name="gender">
                <option value="">请选择</option>
                <option value="male">男</option>
                <option value="female">女</option>
                <option value="other">其他</option>
              </select>
            </div>
          </div>

          <div class="mb-3">
            <label for="resume" class="form-label">个人简介</label>
            <textarea class="form-control" id="resume" name="resume" rows="4" maxlength="100" placeholder="介绍一下自己吧..."></textarea>
            <div class="form-text">
              <span id="resumeCount">0</span>/100 字
            </div>
          </div>

          <div class="d-flex justify-content-end gap-3 mt-4">
            <a href="User.jsp" class="btn btn-cancel">
              <i class="bi bi-x-circle me-2"></i>取消
            </a>
            <button type="submit" class="btn btn-save">
              <i class="bi bi-check-circle me-2"></i>保存修改
            </button>
          </div>
        </form>
      </div>

      <!-- 提示说明 -->
      <div class="form-section">
        <h5><i class="bi bi-info-circle me-2"></i>修改说明</h5>
        <ul class="list-unstyled mb-0">
          <li class="mb-2"><i class="bi bi-check-circle text-success me-2"></i>用户名和邮箱为必填项</li>
          <li class="mb-2"><i class="bi bi-check-circle text-success me-2"></i>修改用户名后需要重新登录</li>
          <li class="mb-2"><i class="bi bi-check-circle text-success me-2"></i>手机号和性别为选填项</li>
          <li class="mb-0"><i class="bi bi-check-circle text-success me-2"></i>个人简介最多100字</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
  // 获取应用程序的上下文路径
  const contextPath = '<%= request.getContextPath() %>';

  // 加载用户信息
  async function loadUserInfo() {
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
        showAlert('danger', '获取用户信息失败: ' + result.message);
        return;
      }

      const user = result.data.user;
      if (user) {
        // 填充表单
        document.getElementById('username').value = user.username || '';
        document.getElementById('email').value = user.email || '';
        document.getElementById('phone').value = user.phone || '';
        // 设置性别值（兼容旧数据）
        const genderValue = user.gender || '';
        if (genderValue === '男' || genderValue === 'male') {
          document.getElementById('gender').value = 'male';
        } else if (genderValue === '女' || genderValue === 'female') {
          document.getElementById('gender').value = 'female';
        } else if (genderValue === '其他' || genderValue === 'other') {
          document.getElementById('gender').value = 'other';
        } else {
          document.getElementById('gender').value = genderValue || '';
        }
        document.getElementById('resume').value = user.resume || '';
        
        // 更新字数统计
        updateResumeCount();
      }

    } catch (error) {
      console.error('加载用户信息失败:', error);
      showAlert('danger', '加载用户信息失败，请刷新页面重试');
    }
  }

  // 更新简介字数统计
  function updateResumeCount() {
    const resumeTextarea = document.getElementById('resume');
    const resumeCount = document.getElementById('resumeCount');
    if (resumeTextarea && resumeCount) {
      const length = resumeTextarea.value.length;
      resumeCount.textContent = length;
      if (length > 100) {
        resumeCount.classList.add('text-danger');
      } else {
        resumeCount.classList.remove('text-danger');
      }
    }
  }

  // 显示提示信息
  function showAlert(type, message) {
    const alertContainer = document.getElementById('alertContainer');
    if (!alertContainer) return;

    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show alert-custom`;
    alertDiv.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    alertContainer.innerHTML = '';
    alertContainer.appendChild(alertDiv);

    // 3秒后自动关闭
    setTimeout(() => {
      const bsAlert = new bootstrap.Alert(alertDiv);
      bsAlert.close();
    }, 3000);
  }

  // 表单提交
  document.getElementById('profileForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    // 获取表单数据
    const formData = {
      username: document.getElementById('username').value.trim(),
      email: document.getElementById('email').value.trim(),
      phone: document.getElementById('phone').value.trim(),
      gender: document.getElementById('gender').value,
      resume: document.getElementById('resume').value.trim()
    };

    // 验证
    if (!formData.username) {
      showAlert('danger', '用户名不能为空');
      return;
    }

    if (!formData.email) {
      showAlert('danger', '邮箱不能为空');
      return;
    }

    // 验证邮箱格式
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(formData.email)) {
      showAlert('danger', '邮箱格式不正确');
      return;
    }

    // 验证手机号格式（如果填写了）
    if (formData.phone && !/^1[3-9]\d{9}$/.test(formData.phone)) {
      showAlert('danger', '手机号格式不正确');
      return;
    }

    // 验证简介长度
    if (formData.resume.length > 100) {
      showAlert('danger', '个人简介不能超过100字');
      return;
    }

    try {
      // 禁用提交按钮
      const submitBtn = document.querySelector('button[type="submit"]');
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>保存中...';

      // 发送更新请求
      const response = await fetch(contextPath + '/api/user/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(formData),
        credentials: 'same-origin'
      });

      const result = await response.json();

      if (result.success) {
        showAlert('success', '修改成功！');
        
        // 延迟跳转，让用户看到成功提示
        setTimeout(() => {
          window.location.href = 'User.jsp';
        }, 1500);
      } else {
        showAlert('danger', '修改失败: ' + (result.message || '未知错误'));
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="bi bi-check-circle me-2"></i>保存修改';
      }

    } catch (error) {
      console.error('更新失败:', error);
      showAlert('danger', '网络错误，请稍后重试');
      const submitBtn = document.querySelector('button[type="submit"]');
      submitBtn.disabled = false;
      submitBtn.innerHTML = '<i class="bi bi-check-circle me-2"></i>保存修改';
    }
  });

  // 简介字数统计
  document.getElementById('resume').addEventListener('input', updateResumeCount);

  // 页面加载时获取用户信息
  document.addEventListener('DOMContentLoaded', function() {
    loadUserInfo();
  });
</script>
</body>
</html>
