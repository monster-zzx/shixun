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

        const payload = {
            name: document.getElementById('barName').value.trim(),
            description: document.getElementById('barDesc').value.trim()
        };

        try {
            const resp = await fetch('api/bar/BarRegister', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify(payload)
            });
            const data = await resp.json();

            if (data && data.success) {
                showAlert('success', data.message || '创建成功');
                // 这里没有现成的贴吧详情页路由，先停留并清空表单
                form.reset();
                form.classList.remove('was-validated');
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
