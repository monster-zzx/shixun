<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>贴吧管理</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<jsp:include page="common/top.jsp"/>

<div class="d-flex justify-content-start" style="padding-top: 56px;">
    <jsp:include page="common/left.jsp"/>

    <div class="p-2 w-75">
        <section class="p-4">
            <div class="container-fluid">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h4 class="mb-0">
                        <i class="bi bi-gear"></i> 贴吧管理
                    </h4>
                    <div>
                        <button id="btnRefresh" class="btn btn-outline-primary btn-sm me-2">
                            <i class="bi bi-arrow-clockwise"></i> 刷新
                        </button>
                        <a href="RegisterBar.jsp" class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-circle"></i> 创建贴吧
                        </a>
                    </div>
                </div>

                <div id="alertBox" class="alert d-none" role="alert"></div>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <div id="loadingSpinner" class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">加载中...</span>
                            </div>
                        </div>

                        <div id="barList" class="d-none">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>贴吧名称</th>
                                            <th>简介</th>
                                            <th>创建者ID</th>
                                            <th>状态</th>
                                            <th>创建时间</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                    <tbody id="barTableBody">
                                        <!-- 动态填充 -->
                                    </tbody>
                                </table>
                            </div>

                            <div id="emptyMessage" class="text-center py-4 text-muted d-none">
                                <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                <p class="mt-2">暂无贴吧数据</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<!-- 编辑模态框 -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">编辑贴吧</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editForm">
                    <input type="hidden" id="editBarId">
                    <div class="mb-3">
                        <label for="editName" class="form-label">贴吧名称</label>
                        <input type="text" class="form-control" id="editName" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label for="editDescription" class="form-label">简介</label>
                        <textarea class="form-control" id="editDescription" rows="4" maxlength="500"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="editStatus" class="form-label">状态</label>
                        <select class="form-select" id="editStatus" required>
                            <option value="PENDING">待审核</option>
                            <option value="ACTIVE">已通过</option>
                            <option value="REJECTED">已拒绝</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="saveEdit()">保存</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    var editModal = null;

    function showAlert(type, text) {
        const box = document.getElementById('alertBox');
        box.className = 'alert alert-' + type + ' alert-dismissible fade show';
        box.innerHTML = text + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        box.classList.remove('d-none');
        setTimeout(function() { box.classList.add('d-none'); }, 5000);
    }

    function formatDate(timestamp) {
        if (!timestamp) return '-';
        const date = new Date(timestamp);
        return date.toLocaleString('zh-CN');
    }

    function getStatusBadge(status) {
        const badges = {
            'PENDING': '<span class="badge bg-warning">待审核</span>',
            'ACTIVE': '<span class="badge bg-success">已通过</span>',
            'REJECTED': '<span class="badge bg-danger">已拒绝</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">' + status + '</span>';
    }

    function getStatusSelectOptions(currentStatus) {
        const options = [
            { value: 'PENDING', text: '待审核' },
            { value: 'ACTIVE', text: '已通过' },
            { value: 'REJECTED', text: '已拒绝' }
        ];
        var html = '';
        for (var i = 0; i < options.length; i++) {
            var selected = options[i].value === currentStatus ? ' selected' : '';
            html += '<option value="' + options[i].value + '"' + selected + '>' + options[i].text + '</option>';
        }
        return html;
    }

    async function loadBars() {
        const spinner = document.getElementById('loadingSpinner');
        const barList = document.getElementById('barList');
        const tableBody = document.getElementById('barTableBody');
        const emptyMessage = document.getElementById('emptyMessage');

        spinner.classList.remove('d-none');
        barList.classList.add('d-none');

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
                showAlert('danger', '服务器返回格式错误');
                return;
            }

            spinner.classList.add('d-none');
            barList.classList.remove('d-none');

            if (data && data.success && data.data) {
                const bars = data.data;
                if (bars.length === 0) {
                    emptyMessage.classList.remove('d-none');
                    tableBody.innerHTML = '';
                } else {
                    emptyMessage.classList.add('d-none');
                    tableBody.innerHTML = bars.map(function(bar) {
                        return '<tr>' +
                            '<td>' + (bar.id || '-') + '</td>' +
                            '<td><strong>' + (bar.name || '-') + '</strong></td>' +
                            '<td class="text-truncate" style="max-width: 200px;" title="' + (bar.description || '') + '">' +
                                (bar.description || '-') +
                            '</td>' +
                            '<td>' + (bar.ownerUserId || '-') + '</td>' +
                            '<td>' + getStatusBadge(bar.status) + '</td>' +
                            '<td>' + formatDate(bar.pubtime) + '</td>' +
                            '<td>' +
                                '<button class="btn btn-sm btn-primary me-1" onclick="openEdit(' + bar.id + ')">' +
                                    '<i class="bi bi-pencil"></i> 编辑' +
                                '</button>' +
                                '<button class="btn btn-sm btn-info me-1" onclick="quickChangeStatus(' + bar.id + ', \'' + bar.status + '\')">' +
                                    '<i class="bi bi-arrow-repeat"></i> 改状态' +
                                '</button>' +
                                '<button class="btn btn-sm btn-danger" onclick="deleteBar(' + bar.id + ', \'' + (bar.name || '') + '\')">' +
                                    '<i class="bi bi-trash"></i> 删除' +
                                '</button>' +
                            '</td>' +
                        '</tr>';
                    }).join('');
                }
            } else {
                showAlert('warning', data.message || '查询失败');
            }
        } catch (err) {
            spinner.classList.add('d-none');
            console.error('加载失败:', err);
            showAlert('danger', '加载失败: ' + err.message);
        }
    }

    async function openEdit(barId) {
        try {
            const resp = await fetch('api/bar/manage?action=detail&id=' + barId, {
                method: 'GET',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' }
            });

            const text = await resp.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                showAlert('danger', '获取贴吧信息失败');
                return;
            }

            if (data && data.success && data.data) {
                const bar = data.data;
                document.getElementById('editBarId').value = bar.id;
                document.getElementById('editName').value = bar.name || '';
                document.getElementById('editDescription').value = bar.description || '';
                document.getElementById('editStatus').innerHTML = getStatusSelectOptions(bar.status);

                if (!editModal) {
                    editModal = new bootstrap.Modal(document.getElementById('editModal'));
                }
                editModal.show();
            } else {
                showAlert('danger', data.message || '获取贴吧信息失败');
            }
        } catch (err) {
            console.error('获取贴吧信息失败:', err);
            showAlert('danger', '获取贴吧信息失败: ' + err.message);
        }
    }

    async function saveEdit() {
        const id = document.getElementById('editBarId').value;
        const name = document.getElementById('editName').value.trim();
        const description = document.getElementById('editDescription').value.trim();
        const status = document.getElementById('editStatus').value;

        if (!name) {
            showAlert('warning', '贴吧名称不能为空');
            return;
        }

        try {
            const resp = await fetch('api/bar/manage', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify({
                    action: 'update',
                    id: parseInt(id),
                    name: name,
                    description: description,
                    status: status
                })
            });

            const text = await resp.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                showAlert('danger', '服务器返回格式错误');
                return;
            }

            if (data && data.success) {
                showAlert('success', data.message || '更新成功');
                if (editModal) {
                    editModal.hide();
                }
                setTimeout(function() { loadBars(); }, 1000);
            } else {
                showAlert('danger', data.message || '更新失败');
            }
        } catch (err) {
            console.error('更新失败:', err);
            showAlert('danger', '更新失败: ' + err.message);
        }
    }

    function quickChangeStatus(barId, currentStatus) {
        const statuses = ['PENDING', 'ACTIVE', 'REJECTED'];
        const statusNames = { 'PENDING': '待审核', 'ACTIVE': '已通过', 'REJECTED': '已拒绝' };
        var nextIndex = (statuses.indexOf(currentStatus) + 1) % statuses.length;
        var nextStatus = statuses[nextIndex];
        var confirmMsg = '确定要将状态改为"' + statusNames[nextStatus] + '"吗？';
        
        if (confirm(confirmMsg)) {
            changeStatus(barId, nextStatus);
        }
    }

    async function changeStatus(barId, status) {
        try {
            const resp = await fetch('api/bar/manage', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify({
                    action: 'changeStatus',
                    id: barId,
                    status: status
                })
            });

            const text = await resp.text();
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                showAlert('danger', '服务器返回格式错误');
                return;
            }

            if (data && data.success) {
                showAlert('success', data.message || '状态更新成功');
                setTimeout(function() { loadBars(); }, 1000);
            } else {
                showAlert('danger', data.message || '状态更新失败');
            }
        } catch (err) {
            console.error('状态更新失败:', err);
            showAlert('danger', '状态更新失败: ' + err.message);
        }
    }

    function deleteBar(barId, barName) {
        var confirmMsg = '确定要删除贴吧"' + (barName || '') + '"吗？此操作不可恢复！';
        if (!confirm(confirmMsg)) {
            return;
        }

        fetch('api/bar/manage', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json;charset=UTF-8' },
            body: JSON.stringify({
                action: 'delete',
                id: barId
            })
        })
        .then(function(resp) { return resp.text(); })
        .then(function(text) {
            let data;
            try {
                data = JSON.parse(text);
            } catch (e) {
                showAlert('danger', '服务器返回格式错误');
                return;
            }

            if (data && data.success) {
                showAlert('success', data.message || '删除成功');
                setTimeout(function() { loadBars(); }, 1000);
            } else {
                showAlert('danger', data.message || '删除失败');
            }
        })
        .catch(function(err) {
            console.error('删除失败:', err);
            showAlert('danger', '删除失败: ' + err.message);
        });
    }

    // 页面加载时自动加载列表
    document.addEventListener('DOMContentLoaded', function() {
        loadBars();
        document.getElementById('btnRefresh').addEventListener('click', loadBars);
    });

    // 顶栏按钮交互（如果存在）
    const btnNotify = document.getElementById('btnNotify');
    if (btnNotify) btnNotify.addEventListener('click', function() { alert('暂无新通知'); });
    const btnMsg = document.getElementById('btnMsg');
    if (btnMsg) btnMsg.addEventListener('click', function() { alert('暂无新私信'); });
</script>
</body>
</html>
