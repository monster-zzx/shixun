<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理</title>
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .user-table th {
            background-color: #f8f9fa;
        }
        .status-active { color: #28a745; }
        .status-banned { color: #dc3545; }
        .action-btn { margin: 0 2px; }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<jsp:include page="common/top.jsp"/>

<!-- 检查是否为管理员 -->
<c:if test="${sessionScope.role != 'admin'}">
    <div class="container mt-5">
        <div class="alert alert-danger" role="alert">
            <h4 class="alert-heading"><i class="bi bi-shield-exclamation"></i> 权限不足</h4>
            <p>您没有权限访问用户管理页面。</p>
            <hr>
            <a href="index.jsp" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</c:if>

<c:if test="${sessionScope.role == 'admin'}">
    <div class="d-flex justify-content-start" style="padding-top: 56px;">
        <!-- 左侧用户信息栏 -->
        <jsp:include page="common/left.jsp"/>

        <!-- 右侧主内容 -->
        <div class="p-2 w-75">
            <section class="p-4">
                <div class="container-fluid">
                    <div class="card shadow-sm">
                        <div class="card-header bg-danger text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="bi bi-people-fill me-2"></i> 用户管理
                            </h5>
                            <div>
                                <button id="btnRefreshUsers" class="btn btn-light btn-sm">
                                    <i class="bi bi-arrow-clockwise"></i> 刷新
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- 搜索和过滤区域 -->
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <input type="text" id="searchUser" class="form-control" placeholder="搜索用户名或邮箱...">
                                        <button class="btn btn-outline-secondary" type="button" id="btnSearch">
                                            <i class="bi bi-search"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <select id="filterStatus" class="form-select">
                                        <option value="">所有状态</option>
                                        <option value="active">正常</option>
                                        <option value="banned">已封禁</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <select id="filterRole" class="form-select">
                                        <option value="">所有角色</option>
                                        <option value="user">普通用户</option>
                                        <option value="admin">管理员</option>
                                    </select>
                                </div>
                            </div>

                            <!-- 用户列表表格 -->
                            <div class="table-responsive">
                                <table class="table table-hover user-table">
                                    <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>用户名</th>
                                        <th>邮箱</th>
                                        <th>角色</th>
                                        <th>状态</th>
                                        <th>注册时间</th>
                                        <th>最后登录</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody id="userTableBody">
                                    <tr id="loadingRow">
                                        <td colspan="8" class="text-center">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">加载中...</span>
                                            </div>
                                            <p class="mt-2 text-muted">正在加载用户列表...</p>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- 分页控件 -->
                            <nav aria-label="用户分页">
                                <ul id="userPagination" class="pagination justify-content-center">
                                    <!-- 分页按钮将通过JavaScript动态生成 -->
                                </ul>
                            </nav>
                        </div>
                    </div>

                    <!-- 操作说明 -->
                    <div class="card shadow-sm mt-4">
                        <div class="card-header bg-info text-white">
                            <h6 class="mb-0"><i class="bi bi-info-circle me-2"></i> 操作说明</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <h6>封禁操作：</h6>
                                    <ul>
                                        <li>封禁用户将无法登录和使用任何功能</li>
                                        <li>只能浏览内容，不能进行任何交互操作</li>
                                        <li>封禁通常是永久性的，需要管理员手动解封</li>
                                        <li>普通用户可以封禁和解封，管理员账户不能被封禁</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="alert alert-warning mt-3" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <strong>注意：</strong> 请谨慎使用管理权限，所有操作都会被记录。
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</c:if>

<%@ include file="common/bottom.txt" %>

<!-- 用户操作模态框 -->
<div class="modal fade" id="userActionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">用户操作</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="modalContent">
                    <!-- 动态内容 -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="modalConfirmBtn">确认</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 用户管理相关变量
    let currentPage = 1;
    const pageSize = 10;
    let totalUsers = 0;
    let allUsers = [];
    let filteredUsers = [];

    // 获取当前登录的管理员ID
    const currentAdminId = ${sessionScope.userId};

    // 页面加载时初始化
    document.addEventListener('DOMContentLoaded', function() {
        loadUsers();

        // 绑定事件
        document.getElementById('btnRefreshUsers').addEventListener('click', loadUsers);
        document.getElementById('btnSearch').addEventListener('click', filterUsers);
        document.getElementById('searchUser').addEventListener('keyup', function(e) {
            if (e.key === 'Enter') filterUsers();
        });
        document.getElementById('filterStatus').addEventListener('change', filterUsers);
        document.getElementById('filterRole').addEventListener('change', filterUsers);
    });

    // 加载用户列表
    async function loadUsers() {
        const loadingRow = document.getElementById('loadingRow');
        const tableBody = document.getElementById('userTableBody');

        loadingRow.style.display = 'table-row';
        tableBody.innerHTML = '';

        try {
            // 构建查询参数
            const params = new URLSearchParams();
            params.append('page', currentPage);
            params.append('size', pageSize);

            const search = document.getElementById('searchUser').value;
            const status = document.getElementById('filterStatus').value;
            const role = document.getElementById('filterRole').value;

            if (search) params.append('search', search);
            if (status) params.append('status', status);
            if (role) params.append('role', role);

            // 调用API获取用户列表
            const response = await fetch('api/user/manage?' + params.toString(), {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error('网络响应错误: ' + response.status);
            }

            const data = await response.json();

            if (!data.success) {
                throw new Error(data.message || '加载用户列表失败');
            }

            // 解析返回的数据
            const result = data.data;
            allUsers = result.users || [];
            totalUsers = result.total || 0;

            // 更新当前分页信息
            currentPage = result.page || 1;

            // 渲染表格和分页
            renderUserTable();
            renderPagination();

        } catch (error) {
            console.error('加载用户失败:', error);
            tableBody.innerHTML = '<tr><td colspan="8" class="text-danger text-center">加载失败: ' + error.message + '</td></tr>';
        } finally {
            loadingRow.style.display = 'none';
        }
    }

    // 过滤用户（现在直接调用API）
    function filterUsers() {
        currentPage = 1;
        loadUsers();
    }

    // 渲染用户表格
    function renderUserTable() {
        const tableBody = document.getElementById('userTableBody');

        if (allUsers.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">暂无符合条件的用户</td></tr>';
            return;
        }

        let html = '';
        allUsers.forEach(user => {
            const statusClass = user.status === 'active' ? 'status-active' : 'status-banned';
            const statusText = user.status === 'active' ? '正常' : '已封禁';

            let actionButtons = '';
            if (user.role !== 'admin') {
                if (user.status !== 'banned') {
                    actionButtons = '<button class="btn btn-danger btn-sm action-btn" onclick="showBanModal(' + user.id + ', \'' + user.username + '\')">封禁</button>';
                } else {
                    actionButtons = '<button class="btn btn-success btn-sm action-btn" onclick="unbanUser(' + user.id + ', \'' + user.username + '\')">解封</button>';
                }
            } else {
                actionButtons = '<span class="text-muted">管理员</span>';
            }

            const roleBadge = user.role === 'admin' ?
                '<span class="badge bg-warning">管理员</span>' :
                '<span class="badge bg-secondary">普通用户</span>';

            // 格式化日期
            const createTime = formatDate(user.createTime);
            const lastLoginTime = formatDate(user.lastLoginTime);

            html += '<tr>' +
                '<td>' + user.id + '</td>' +
                '<td>' + user.username + '</td>' +
                '<td>' + (user.email || '-') + '</td>' +
                '<td>' + roleBadge + '</td>' +
                '<td class="' + statusClass + '">' + statusText + '</td>' +
                '<td>' + createTime + '</td>' +
                '<td>' + lastLoginTime + '</td>' +
                '<td>' + actionButtons + '</td>' +
                '</tr>';
        });

        tableBody.innerHTML = html;
    }

    // 格式化日期
    function formatDate(dateString) {
        if (!dateString) return '-';
        try {
            const date = new Date(dateString);
            return date.toLocaleString('zh-CN', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        } catch (e) {
            return dateString;
        }
    }

    // 渲染分页控件
    function renderPagination() {
        const pagination = document.getElementById('userPagination');
        const totalPages = Math.ceil(totalUsers / pageSize);

        if (totalPages <= 1) {
            pagination.innerHTML = '';
            return;
        }

        let html = '';

        // 上一页按钮
        html += '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" onclick="changePage(' + (currentPage - 1) + ')">&laquo;</a>' +
            '</li>';

        // 页码按钮
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                html += '<li class="page-item ' + (currentPage === i ? 'active' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changePage(' + i + ')">' + i + '</a>' +
                    '</li>';
            } else if (i === currentPage - 3 || i === currentPage + 3) {
                html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
            }
        }

        // 下一页按钮
        html += '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">' +
            '<a class="page-link" href="#" onclick="changePage(' + (currentPage + 1) + ')">&raquo;</a>' +
            '</li>';

        pagination.innerHTML = html;
    }

    // 切换页码
    function changePage(page) {
        currentPage = page;
        loadUsers();
    }

    // 显示封禁模态框
    function showBanModal(userId, username) {
        document.getElementById('modalTitle').textContent = '封禁用户: ' + username;
        document.getElementById('modalContent').innerHTML =
            '<div class="mb-3">' +
            '<label class="form-label">封禁原因:</label>' +
            '<textarea id="banReason" class="form-control" rows="3" placeholder="请输入封禁原因..."></textarea>' +
            '</div>' +
            '<div class="alert alert-danger">' +
            '<i class="bi bi-exclamation-triangle-fill me-2"></i>' +
            '<strong>警告：</strong> 封禁后用户将无法登录和使用任何功能，只能浏览内容。' +
            '</div>';

        document.getElementById('modalConfirmBtn').onclick = function() {
            const reason = document.getElementById('banReason').value;

            if (!reason.trim()) {
                alert('请填写封禁原因');
                return;
            }

            // 调用API封禁用户
            banUser(userId, reason);
        };

        new bootstrap.Modal(document.getElementById('userActionModal')).show();
    }

    // 封禁用户
    async function banUser(userId, reason) {
        try {
            const response = await fetch('api/user/ban', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userId: userId,
                    reason: reason
                })
            });

            const data = await response.json();

            if (data.success) {
                alert('用户封禁成功');
                // 关闭模态框
                const modal = bootstrap.Modal.getInstance(document.getElementById('userActionModal'));
                if (modal) modal.hide();
                // 刷新用户列表
                loadUsers();
            } else {
                alert('封禁失败: ' + data.message);
            }
        } catch (error) {
            console.error('封禁用户失败:', error);
            alert('封禁失败: ' + error.message);
        }
    }

    // 解封用户
    async function unbanUser(userId, username) {
        if (!confirm('确定要解封 ' + username + ' 吗？')) {
            return;
        }

        try {
            const response = await fetch('api/user/unban', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    userId: userId
                })
            });

            const data = await response.json();

            if (data.success) {
                alert('用户解封成功');
                // 刷新用户列表
                loadUsers();
            } else {
                alert('解封失败: ' + data.message);
            }
        } catch (error) {
            console.error('解封用户失败:', error);
            alert('解封失败: ' + error.message);
        }
    }

    // 获取CSRF令牌（如果需要的话）
    function getCsrfToken() {
        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
        return { token: csrfToken, header: csrfHeader };
    }
</script>
</body>
</html>