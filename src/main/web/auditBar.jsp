<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>贴吧审核</title>
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
                        <i class="bi bi-shield-check"></i> 贴吧审核
                    </h4>
                    <button id="btnRefresh" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-arrow-clockwise"></i> 刷新
                    </button>
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
                                            <th>创建时间</th>
                                            <th>状态</th>
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
                                <p class="mt-2">暂无待审核的贴吧</p>
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
    function showAlert(type, text) {
        const box = document.getElementById('alertBox');
        box.className = 'alert alert-' + type + ' alert-dismissible fade show';
        box.innerHTML = text + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        box.classList.remove('d-none');
        setTimeout(() => box.classList.add('d-none'), 5000);
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

    async function loadPendingBars() {
        const spinner = document.getElementById('loadingSpinner');
        const barList = document.getElementById('barList');
        const tableBody = document.getElementById('barTableBody');
        const emptyMessage = document.getElementById('emptyMessage');

        spinner.classList.remove('d-none');
        barList.classList.add('d-none');

        try {
            const resp = await fetch('api/bar/audit', {
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
                            '<td>' + formatDate(bar.pubtime) + '</td>' +
                            '<td>' + getStatusBadge(bar.status) + '</td>' +
                            '<td>' +
                                '<button class="btn btn-sm btn-success me-1" onclick="auditBar(' + bar.id + ', \'ACTIVE\')">' +
                                    '<i class="bi bi-check-circle"></i> 通过' +
                                '</button>' +
                                '<button class="btn btn-sm btn-danger" onclick="auditBar(' + bar.id + ', \'REJECTED\')">' +
                                    '<i class="bi bi-x-circle"></i> 拒绝' +
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

    async function auditBar(barId, status) {
        var confirmMsg = '确定要' + (status === 'ACTIVE' ? '通过' : '拒绝') + '该贴吧吗？';
        if (!confirm(confirmMsg)) {
            return;
        }

        try {
            const resp = await fetch('api/bar/audit', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify({ barId: barId, status: status })
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

            if (data && data.success) {
                showAlert('success', data.message || '操作成功');
                // 重新加载列表
                setTimeout(() => loadPendingBars(), 1000);
            } else {
                showAlert('danger', data.message || '操作失败');
            }
        } catch (err) {
            console.error('审核失败:', err);
            showAlert('danger', '操作失败: ' + err.message);
        }
    }

    // 页面加载时自动加载列表
    document.addEventListener('DOMContentLoaded', () => {
        loadPendingBars();
        document.getElementById('btnRefresh').addEventListener('click', loadPendingBars);
    });

    // 顶栏按钮交互（如果存在）
    const btnNotify = document.getElementById('btnNotify');
    if (btnNotify) btnNotify.addEventListener('click', () => alert('暂无新通知'));
    const btnMsg = document.getElementById('btnMsg');
    if (btnMsg) btnMsg.addEventListener('click', () => alert('暂无新私信'));
</script>
</body>
</html>
