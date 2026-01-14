<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册贴吧</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .tag-item {
            display: inline-flex;
            align-items: center;
            padding: 0.375rem 0.75rem;
            margin: 0.25rem;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            background-color: #ffffff;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
        }
        .tag-item:hover {
            background-color: #e9ecef;
            border-color: #adb5bd;
        }
        .tag-item.selected {
            background-color: #0d6efd;
            color: #ffffff;
            border-color: #0d6efd;
        }
        .tag-item.selected:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }
    </style>
</head>
<body>
<jsp:include page="common/top.jsp"/>

<div class="d-flex justify-content-start" style="padding-top: 56px;">
    <jsp:include page="common/left.jsp"/>

    <div class="p-2 w-75">
        <section class="p-4">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-8">
                        <div class="card shadow-sm">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <h4 class="mb-0">创建贴吧</h4>
                                    <span class="text-muted small">创建后可能需要审核</span>
                                </div>

                                <div id="alertBox" class="alert d-none" role="alert"></div>

                                <form id="barForm" class="needs-validation" novalidate>
                                    <div class="mb-3">
                                        <label for="barName" class="form-label">贴吧名称</label>
                                        <input type="text" class="form-control" id="barName" name="name" maxlength="100" required>
                                        <div class="invalid-feedback">请输入贴吧名称（最多 100 字）</div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="barDesc" class="form-label">贴吧简介（可选）</label>
                                        <textarea class="form-control" id="barDesc" name="description" rows="4" maxlength="500" placeholder="介绍一下你的贴吧吧（最多 500 字）"></textarea>
                                        <div class="form-text">支持普通文本，不要输入敏感信息。</div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">标签（可选）</label>
                                        <div id="tagContainer" class="border rounded p-3" style="min-height: 80px; background-color: #f8f9fa;">
                                            <div id="tagLoading" class="text-center text-muted small">
                                                <div class="spinner-border spinner-border-sm" role="status">
                                                    <span class="visually-hidden">加载中...</span>
                                                </div>
                                                <span class="ms-2">加载标签中...</span>
                                            </div>
                                            <div id="tagList" class="d-flex flex-wrap gap-2" style="display: none;">
                                                <!-- 标签将动态插入这里 -->
                                            </div>
                                            <div id="tagEmpty" class="text-center text-muted small" style="display: none;">
                                                暂无可用标签
                                            </div>
                                        </div>
                                        <div class="form-text">选择相关标签，帮助其他用户更好地发现你的贴吧（可多选）</div>
                                        <input type="hidden" id="selectedTags" name="tags" value="">
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button id="btnSubmit" type="submit" class="btn btn-primary">
                                            <i class="bi bi-plus-circle"></i>
                                            创建
                                        </button>
                                        <a href="index.jsp" class="btn btn-outline-secondary">返回</a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="mt-3 text-muted small">
                            创建说明：贴吧名称需唯一；如提示“请先登录”，请先完成登录。
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // 顶栏按钮交互（如果页面不存在按钮则跳过，避免报错）
    const btnNotify = document.getElementById('btnNotify');
    if (btnNotify) btnNotify.addEventListener('click', () => alert('暂无新通知'));
    const btnMsg = document.getElementById('btnMsg');
    if (btnMsg) btnMsg.addEventListener('click', () => alert('暂无新私信'));

    // 标签选择功能
    let selectedTags = new Set(); // 存储选中的标签ID

    // 加载标签列表
    async function loadTags() {
        const tagLoading = document.getElementById('tagLoading');
        const tagList = document.getElementById('tagList');
        const tagEmpty = document.getElementById('tagEmpty');

        try {
            // 尝试从 API 获取标签列表（如果后端已实现）
            // 如果 API 不存在，使用示例标签数据
            let tags = [];
            try {
                const resp = await fetch('api/tag/list', {
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' }
                });
                if (resp.ok) {
                    const data = await resp.json();
                    if (data && data.success && data.data) {
                        tags = data.data;
                    }
                }
            } catch (e) {
                // API 不存在时使用示例标签
                console.log('标签API未实现，使用示例标签');
                tags = [
                    { id: 1, name: '技术', color: '#0d6efd' },
                    { id: 2, name: '编程', color: '#198754' },
                    { id: 3, name: 'Java', color: '#dc3545' },
                    { id: 4, name: 'Python', color: '#ffc107' },
                    { id: 5, name: '前端', color: '#0dcaf0' },
                    { id: 6, name: '算法', color: '#6f42c1' },
                    { id: 7, name: '娱乐', color: '#fd7e14' },
                    { id: 8, name: '电影', color: '#e83e8c' },
                    { id: 9, name: '音乐', color: '#20c997' },
                    { id: 10, name: '动漫', color: '#6610f2' },
                    { id: 11, name: '游戏', color: '#d63384' },
                    { id: 12, name: '体育', color: '#198754' },
                    { id: 13, name: '足球', color: '#0dcaf0' },
                    { id: 14, name: '篮球', color: '#ffc107' },
                    { id: 15, name: '生活', color: '#6c757d' },
                    { id: 16, name: '美食', color: '#fd7e14' },
                    { id: 17, name: '旅行', color: '#20c997' },
                    { id: 18, name: '健身', color: '#dc3545' }
                ];
            }

            tagLoading.style.display = 'none';
            
            if (tags.length > 0) {
                tagList.style.display = 'flex';
                tagEmpty.style.display = 'none';
                renderTags(tags);
            } else {
                tagList.style.display = 'none';
                tagEmpty.style.display = 'block';
            }
        } catch (err) {
            console.error('加载标签失败:', err);
            tagLoading.style.display = 'none';
            tagEmpty.style.display = 'block';
        }
    }

    // 渲染标签列表
    function renderTags(tags) {
        const tagList = document.getElementById('tagList');
        tagList.innerHTML = '';

        tags.forEach(tag => {
            const tagItem = document.createElement('span');
            tagItem.className = 'tag-item';
            tagItem.dataset.tagId = tag.id;
            tagItem.textContent = tag.name;
            if (tag.color) {
                tagItem.style.borderColor = tag.color;
            }

            tagItem.addEventListener('click', function() {
                toggleTag(tag.id, this);
            });

            tagList.appendChild(tagItem);
        });
    }

    // 切换标签选中状态
    function toggleTag(tagId, element) {
        if (selectedTags.has(tagId.toString())) {
            selectedTags.delete(tagId.toString());
            element.classList.remove('selected');
        } else {
            selectedTags.add(tagId.toString());
            element.classList.add('selected');
        }
        
        // 更新隐藏字段
        document.getElementById('selectedTags').value = Array.from(selectedTags).join(',');
    }

    // 页面加载时加载标签
    document.addEventListener('DOMContentLoaded', function() {
        loadTags();
    });

    function showAlert(type, text) {
        const box = document.getElementById('alertBox');
        box.className = 'alert alert-' + type;
        box.textContent = text;
        box.classList.remove('d-none');
    }

    document.getElementById('barForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const form = e.currentTarget;
        form.classList.add('was-validated');
        if (!form.checkValidity()) return;

        const btn = document.getElementById('btnSubmit');
        btn.disabled = true;

        // 获取选中的标签ID数组
        const selectedTagIds = Array.from(document.querySelectorAll('.tag-item.selected'))
            .map(item => item.dataset.tagId)
            .filter(id => id);

        const payload = {
            name: document.getElementById('barName').value.trim(),
            description: document.getElementById('barDesc').value.trim(),
            tagIds: selectedTagIds
        };

        try {
            const resp = await fetch('api/bar/BarRegister', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify(payload)
            });
            const data = await resp.json();

            if (data && data.success) {
                const barId = data.data ? data.data.id : null;
                const barStatus = data.data ? data.data.status : null;
                
                if (barId) {
                    if (barStatus === 'PENDING') {
                        showAlert('warning', '创建成功！贴吧需要审核通过后才能发帖，即将跳转到贴吧详情页...');
                    } else if (barStatus === 'ACTIVE') {
                        showAlert('success', '创建成功！即将跳转到贴吧详情页...');
                    } else {
                        showAlert('success', '创建成功！即将跳转到贴吧详情页...');
                    }
                    setTimeout(() => {
                        window.location.href = 'dispBar.jsp?id=' + barId;
                    }, 1500);
                } else {
                    showAlert('success', data.message || '创建成功');
                    form.reset();
                    form.classList.remove('was-validated');
                }
            } else {
                showAlert('danger', (data && data.message) ? data.message : '创建失败');
            }
        } catch (err) {
            console.error('请求失败:', err);
            showAlert('danger', '请求失败: ' + (err.message || '未知错误'));
            // 尝试解析响应为文本（可能是 HTML 错误页）
            if (err.response) {
                err.response.text().then(html => {
                    console.error('服务器返回:', html.substring(0, 200) + '...'); // 只打印前200字符
                });
            }
        } finally {
            btn.disabled = false;
        }
    });
</script>
</body>
</html>
