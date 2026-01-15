<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Post</title>
    <link rel="stylesheet" type="text/css" href="CSS/style.css">
    <link rel="stylesheet" type="text/css" href="CSS/bootstrap5.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
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
    <div class="p-2 w-75">
        <section class="p-5">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">发布新帖</h2>
                    <button id="backBtn" class="btn btn-outline-secondary" style="display: none;">
                        <i class="bi bi-arrow-left"></i> 返回贴吧
                    </button>
                </div>

                <!-- 错误提示容器 -->
                <div id="errorAlert" class="alert alert-danger alert-dismissible fade show" style="display: none;">
                    <span id="errorMessage"></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>

                <!-- 成功提示容器 -->
                <div id="successAlert" class="alert alert-success alert-dismissible fade show" style="display: none;">
                    <span id="successMessage"></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>

                <div class="card">
                    <div class="card-body">
                        <form id="postForm">
                            <div class="mb-3">
                                <label for="barId" class="form-label">选择贴吧 <span class="text-danger">*</span></label>
                                <select class="form-select" id="barId" name="barId" required>
                                    <option value="">请选择贴吧...</option>
                                </select>
                                <div class="form-text">如果没有可用贴吧，请联系管理员创建</div>
                            </div>

                            <div class="mb-3">
                                <label for="title" class="form-label">帖子标题 <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="title" name="title"
                                       placeholder="请输入帖子标题（最多100字）" maxlength="100" required>
                                <div class="form-text" id="titleCounter">0/100</div>
                            </div>

                            <div class="mb-3">
                                <label for="content" class="form-label">帖子内容 <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="content" name="content" rows="10"
                                          placeholder="请输入帖子内容（支持Markdown格式）" required></textarea>
                                <div class="form-text" id="contentCounter">0/5000</div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="reset" class="btn btn-secondary">重置</button>
                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                    <i class="bi bi-send"></i> 发布帖子
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<%@ include file="common/bottom.txt" %>

<script>
    // ============ 路径配置 ============
    // 动态获取上下文路径
    const CONTEXT_PATH = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';
    const BASE_URL = window.location.origin + CONTEXT_PATH;
    const API_BASE = BASE_URL + '/api';

    console.log('配置信息:');
    console.log('上下文路径:', CONTEXT_PATH);
    console.log('基础URL:', BASE_URL);
    console.log('API基地址:', API_BASE);
    console.log('当前页面:', window.location.href);

    // ============ 工具函数 ============
    function getBarIdFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get('barId');
    }

    function showAlert(type, message) {
        // 先移除所有同类型的alert
        const existingAlerts = document.querySelectorAll(`.alert.alert-${type}`);
        existingAlerts.forEach(alert => alert.remove());

        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show mt-3`;
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        const container = document.querySelector('.container');
        if (container) {
            const firstChild = container.firstChild;
            container.insertBefore(alertDiv, firstChild);

            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }
    }

    // ============ 测试API连通性 ============
    async function testAPIConnectivity() {
        console.log('=== 测试API连通性 ===');

        const testEndpoints = [
            '/api/bar/manage?status=active',
            '/api/bar/list',
            '/api/bar',
            '/bar/manage?status=active'
        ];

        let availableEndpoint = null;

        for (const endpoint of testEndpoints) {
            try {
                const fullUrl = window.location.origin + CONTEXT_PATH + endpoint;
                console.log(`测试: ${fullUrl}`);

                const controller = new AbortController();
                const timeoutId = setTimeout(() => controller.abort(), 3000);

                const response = await fetch(fullUrl, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' },
                    signal: controller.signal
                });

                clearTimeout(timeoutId);

                console.log(`  状态: ${response.status} ${response.statusText}`);

                if (response.ok) {
                    const result = await response.json();
                    console.log(`  成功! 数据预览:`, result);

                    if (result && (result.success || Array.isArray(result))) {
                        console.log(`✅ 找到可用端点: ${endpoint}`);
                        availableEndpoint = fullUrl;
                        break;
                    }
                }

            } catch (error) {
                console.log(`  错误: ${error.name} - ${error.message}`);
            }
        }

        return availableEndpoint;
    }

    // ============ 加载贴吧列表 ============
    async function loadBars() {
        const select = document.getElementById('barId');
        const barIdParam = getBarIdFromUrl();

        console.log('=== 加载贴吧列表 ===');
        console.log('下拉框:', select);
        console.log('barId参数:', barIdParam);

        // 立即显示加载状态
        if (select) {
            select.disabled = true;
            select.innerHTML = '<option value="">加载中...</option>';
        }

        try {
            // 检查API是否可用（使用超时处理）
            let apiAvailable = false;
            const apiUrl = BASE_URL + '/api/bar/manage?status=active';

            console.log('测试API:', apiUrl);

            // 使用Promise.race实现超时
            const timeoutPromise = new Promise((_, reject) =>
                setTimeout(() => reject(new Error('请求超时')), 3000)
            );

            try {
                const fetchPromise = fetch(apiUrl, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' }
                });

                const response = await Promise.race([fetchPromise, timeoutPromise]);

                if (response && response.ok) {
                    apiAvailable = true;
                    console.log('API可用');
                } else {
                    console.log('API不可用，状态:', response.status);
                }
            } catch (apiError) {
                console.log('API请求失败:', apiError.message);
            }

            console.log('API可用状态:', apiAvailable);

            // 获取贴吧数据 - 只从数据库获取
            let bars = [];
            
            if (apiAvailable) {
                try {
                    const response = await fetch(apiUrl, {
                        method: 'GET',
                        headers: { 'Accept': 'application/json' }
                    });
                    
                    if (response.ok) {
                        const data = await response.json();
                        if (data && data.success && data.data) {
                            bars = data.data;
                            console.log('从数据库获取贴吧数据:', bars);
                        }
                    }
                } catch (fetchError) {
                    console.log('获取贴吧数据失败:', fetchError.message);
                    showAlert('danger', '获取贴吧数据失败，请刷新页面重试');
                    return;
                }
            }
            
            // 如果API不可用，显示错误信息
            if (bars.length === 0) {
                console.log('无法获取贴吧数据');
                showAlert('danger', '无法获取贴吧数据，请检查网络连接或稍后重试');
                return;
            }

            // 填充下拉框 - 使用最可靠的方式
            if (select) {
                // 清空并重新构建
                select.innerHTML = '';

                // 添加默认选项
                const defaultOption = document.createElement('option');
                defaultOption.value = '';
                defaultOption.textContent = '请选择贴吧...';
                select.appendChild(defaultOption);
                console.log('添加默认选项');

                // 添加贴吧选项
                bars.forEach(bar => {
                    const option = document.createElement('option');
                    option.value = bar.id;
                    option.textContent = bar.name;

                    // 自动选中URL参数指定的贴吧
                    if (barIdParam && bar.id.toString() === barIdParam) {
                        option.selected = true;
                        console.log('自动选中:', bar.name);
                    }

                    select.appendChild(option);
                    console.log('添加选项:', bar.name);
                });

                // 如果没有选中任何项，且数据不为空，选择第一个贴吧（跳过默认选项）
                if (!select.value && bars.length > 0 && select.options.length > 1) {
                    select.options[1].selected = true;
                    console.log('默认选择第一个贴吧:', select.options[1].text);
                }

                // 启用下拉框
                select.disabled = false;

                console.log('下拉框填充完成');
                console.log('选项数量:', select.options.length);
                console.log('当前值:', select.value);
                console.log('选中文本:', select.options[select.selectedIndex]?.text);

                // 显示所有选项
                for (let i = 0; i < select.options.length; i++) {
                    console.log(`选项 ${i}: ${select.options[i].value} - ${select.options[i].text}`);
                }
            } else {
                console.error('找不到下拉框元素!');
            }

            // 处理返回按钮
            const backBtn = document.getElementById('backBtn');
            if (backBtn && barIdParam) {
                backBtn.style.display = 'block';
                backBtn.onclick = function() {
                    window.location.href = BASE_URL + '/dispBar.jsp?id=' + barIdParam;
                };
                console.log('返回按钮已设置');
            }

            // 显示提示信息
            if (!apiAvailable) {
                showAlert('info', '已加载演示数据（API服务未连接）');
            }

        } catch (error) {
            console.error('加载贴吧列表时发生错误:', error);

            // 即使出错也要显示一些选项
            if (select) {
                select.innerHTML = '';

                const errorOption = document.createElement('option');
                errorOption.value = '';
                errorOption.textContent = '加载失败，请刷新页面重试';
                select.appendChild(errorOption);

                select.disabled = false;
            }

            showAlert('danger', '贴吧列表加载失败，请刷新页面重试');
        } finally {
            console.log('=== 加载贴吧列表结束 ===');
        }
    }


    // 获取来源页面信息
    function getReferrerPage() {
        // 优先使用URL参数中的referrer
        const urlParams = new URLSearchParams(window.location.search);
        const referrerParam = urlParams.get('referrer');
        
        if (referrerParam) {
            return decodeURIComponent(referrerParam);
        }
        
        // 其次使用document.referrer
        if (document.referrer) {
            return document.referrer;
        }
        
        // 最后默认为首页
        return CONTEXT_PATH + '/index.jsp';
    }
    
    // 根据来源页面决定发帖后的跳转目标
    function getRedirectTarget(barId) {
        const referrer = getReferrerPage();
        const barIdParam = getBarIdFromUrl();
        
        // 如果是从贴吧页面来的，返回原贴吧页面
        if (barIdParam) {
            return CONTEXT_PATH + '/dispBar.jsp?id=' + barIdParam;
        }
        
        // 如果是从个人帖子管理页面来的，返回个人帖子管理页面
        if (referrer.includes('mangePost.jsp')) {
            return CONTEXT_PATH + '/mangePost.jsp';
        }
        
        // 如果是从首页来的，返回首页
        if (referrer.includes('index.jsp')) {
            return CONTEXT_PATH + '/index.jsp';
        }
        
        // 其他情况，跳转到刚发帖的贴吧页面
        if (barId) {
            return CONTEXT_PATH + '/dispBar.jsp?id=' + barId;
        }
        
        // 最后默认返回首页
        return CONTEXT_PATH + '/index.jsp';
    }

    // ============ 处理表单提交 ============
    document.getElementById('postForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        console.log('=== 开始提交帖子 ===');

        // 获取表单数据
        const title = document.getElementById('title').value.trim();
        const content = document.getElementById('content').value.trim();
        const barId = document.getElementById('barId').value;

        console.log('表单数据:', { title, content, barId });

        // 验证
        if (!title) {
            showAlert('danger', '请输入帖子标题');
            document.getElementById('title').focus();
            return;
        }
        if (!content) {
            showAlert('danger', '请输入帖子内容');
            document.getElementById('content').focus();
            return;
        }
        if (!barId) {
            showAlert('danger', '请选择贴吧');
            document.getElementById('barId').focus();
            return;
        }

        // 禁用提交按钮
        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        const originalHTML = submitBtn.innerHTML;

        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>发布中...';

        try {
            // 使用API提交帖子
            const apiUrl = API_BASE + '/post/create';
            console.log('提交到API:', apiUrl);

            const postData = {
                title: title,
                content: content,
                barId: parseInt(barId)
            };

            console.log('提交数据:', postData);

            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(postData)
            });

            console.log('响应状态:', response.status, response.statusText);

            const responseText = await response.text();
            console.log('响应内容:', responseText);

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            let data;
            try {
                data = JSON.parse(responseText);
            } catch (parseError) {
                console.error('JSON解析错误:', responseText);
                throw new Error('服务器返回格式错误');
            }

            console.log('解析后的数据:', data);

            if (data && data.success) {
                showAlert('success', '帖子发布成功！');
                
                // 获取跳转目标
                const redirectTarget = getRedirectTarget(data.data ? data.data.barId : barId);
                console.log('准备跳转到:', redirectTarget);
                
                // 延迟跳转，让用户看到成功提示
                setTimeout(() => {
                    window.location.href = redirectTarget;
                }, 1500);
            } else {
                throw new Error(data?.message || '发布失败');
            }

        } catch (error) {
            console.error('发布失败:', error);

            let errorMsg = '发布失败: ';
            if (error.message.includes('404')) {
                errorMsg += 'API接口不存在';
            } else if (error.message.includes('Failed to fetch')) {
                errorMsg += '网络连接失败';
            } else {
                errorMsg += error.message;
            }

            showAlert('danger', errorMsg);

        } finally {
            // 恢复按钮
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
            submitBtn.innerHTML = originalHTML;
        }
    });

    // ============ 页面初始化 ============
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== 页面初始化开始 ===');

        // 检查DOM元素
        console.log('DOM元素检查:');
        console.log('- barId选择框:', document.getElementById('barId'));
        console.log('- 返回按钮:', document.getElementById('backBtn'));
        console.log('- 表单:', document.getElementById('postForm'));

        // 初始化字数统计
        const titleInput = document.getElementById('title');
        const contentTextarea = document.getElementById('content');

        if (titleInput && contentTextarea) {
            function updateCounter() {
                const titleCounter = document.getElementById('titleCounter');
                const contentCounter = document.getElementById('contentCounter');

                if (titleCounter) {
                    titleCounter.textContent = `${titleInput.value.length}/100`;
                }
                if (contentCounter) {
                    contentCounter.textContent = `${contentTextarea.value.length}/5000`;
                }
            }

            titleInput.addEventListener('input', updateCounter);
            contentTextarea.addEventListener('input', updateCounter);
            updateCounter();

            console.log('字数统计初始化完成');
        }

        // 加载贴吧列表
        console.log('开始加载贴吧列表...');
        loadBars();

        console.log('=== 页面初始化完成 ===');

    });

    // ============ 公开调试函数 ============
    window.debugInfo = function() {
        console.log('=== 调试信息 ===');
        console.log('当前URL:', window.location.href);
        console.log('上下文路径:', CONTEXT_PATH);
        console.log('API基地址:', API_BASE);
        console.log('贴吧列表URL:', API_BASE + '/bar/manage?status=active');
        console.log('发帖URL:', API_BASE + '/post/create');

        // 显示下拉框当前状态
        const select = document.getElementById('barId');
        console.log('下拉框状态:');
        console.log('- 值:', select.value);
        console.log('- 选中文本:', select.options[select.selectedIndex]?.text);
        console.log('- 选项数量:', select.options.length);
        console.log('- 所有选项:', Array.from(select.options).map(opt => ({value: opt.value, text: opt.text})));

        
    };
</script>
</body>
</html>