<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 贴吧系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px;
        }
        .login-container {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
        }
        .login-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .login-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-weight: 600;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        .btn-login {
            width: 100%;
            padding: 10px;
            font-weight: 600;
            margin-top: 10px;
        }
        .login-footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }
        .account-type-btn {
            margin-bottom: 15px;
        }
        .alert {
            display: none;
        }
        .warning-info {
            background-color: #fff3cd;
            border: 1px solid #ffecb5;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            display: none;
            color: #856404;
            font-weight: 500;
        }
        .warning-info.show {
            display: block !important;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <h2 class="login-title">用户登录</h2>

        <!-- 登录类型选择 -->
        <div class="btn-group w-100 account-type-btn" role="group">
            <input type="radio" class="btn-check" name="loginType" id="typeUsername" value="username" checked>
            <label class="btn btn-outline-primary" for="typeUsername">用户名登录</label>

            <input type="radio" class="btn-check" name="loginType" id="typeEmail" value="email">
            <label class="btn btn-outline-primary" for="typeEmail">邮箱登录</label>

            <input type="radio" class="btn-check" name="loginType" id="typePhone" value="phone">
            <label class="btn btn-outline-primary" for="typePhone">手机登录</label>
        </div>

        <!-- 警告信息（用于封禁提示） -->
        <div class="warning-info" id="warningInfo">
            <span id="warningMessage"></span>
        </div>

        <!-- 错误提示 -->
        <div class="alert alert-danger alert-dismissible fade show" role="alert" id="errorAlert">
            <span id="errorMessage"></span>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>

        <!-- 成功提示 -->
        <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
            <span id="successMessage"></span>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>

        <!-- 登录表单 -->
        <form id="loginForm">
            <div class="mb-3">
                <label for="account" class="form-label" id="accountLabel">用户名</label>
                <input type="text" class="form-control" id="account" name="account"
                       placeholder="请输入用户名" required>
                <div class="form-text" id="accountHelp">
                    请输入您的用户名
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">密码</label>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="请输入密码" required>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                <label class="form-check-label" for="rememberMe">记住我（7天免登录）</label>
            </div>

            <button type="submit" class="btn btn-primary btn-login" id="loginBtn">
                <span id="loginText">登录</span>
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"
                      style="display: none;" id="loadingSpinner"></span>
            </button>
        </form>

        <div class="login-footer">
            <div class="mb-2">
                还没有账号？<a href="Register.jsp" class="text-decoration-none">立即注册</a>
            </div>
            <div>
                <a href="forgot-password.jsp" class="text-decoration-none text-muted">忘记密码？</a>
            </div>
        </div>
    </div>
</div>

<!-- jQuery 必须在 Bootstrap 之前 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS (包含 Popper.js) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    $(function() {
        // 根据登录类型切换标签和提示
        $('input[name="loginType"]').on('change', function() {
            const type = $(this).val();
            updateAccountLabel(type);
        });

        function updateAccountLabel(type) {
            const $accountLabel = $('#accountLabel');
            const $accountInput = $('#account');
            const $accountHelp = $('#accountHelp');

            switch(type) {
                case 'email':
                    $accountLabel.text('邮箱地址');
                    $accountInput.attr('placeholder', '请输入邮箱地址');
                    $accountInput.attr('type', 'email');
                    $accountHelp.text('请输入您的邮箱地址');
                    break;
                case 'phone':
                    $accountLabel.text('手机号码');
                    $accountInput.attr('placeholder', '请输入11位手机号码');
                    $accountInput.attr('type', 'tel');
                    $accountHelp.text('请输入您的11位手机号码');
                    break;
                default:
                    $accountLabel.text('用户名');
                    $accountInput.attr('placeholder', '请输入用户名');
                    $accountInput.attr('type', 'text');
                    $accountHelp.text('请输入您的用户名');
            }
        }

        // 显示警告信息（用于封禁提示）
        function showWarning(message) {
            console.log('showWarning 被调用，消息:', message);
            const $warningInfo = $('#warningInfo');
            const $warningMessage = $('#warningMessage');
            
            if ($warningInfo.length === 0) {
                console.error('警告信息元素未找到');
                return;
            }
            
            if ($warningMessage.length === 0) {
                console.error('警告消息元素未找到');
                return;
            }
            
            $warningMessage.text(message);
            // 使用多种方式确保显示
            $warningInfo.css('display', 'block')
                       .addClass('show')
                       .show()
                       .removeClass('d-none'); // 移除可能的 Bootstrap 隐藏类
            console.log('警告信息已显示，元素可见性:', $warningInfo.is(':visible'));
            console.log('警告信息元素:', $warningInfo[0]);
        }

        function hideWarning() {
            $('#warningInfo').css('display', 'none')
                            .removeClass('show')
                            .hide();
        }

        // 显示错误信息
        function showError(message) {
            $('#errorMessage').text(message);
            $('#errorAlert').show();
        }

        function hideError() {
            $('#errorAlert').hide();
        }

        // 显示成功信息
        function showSuccess(message) {
            $('#successMessage').text(message);
            $('#successAlert').show();
        }

        function hideSuccess() {
            $('#successAlert').hide();
        }

        // 重置按钮状态
        function resetButton() {
            $('#loginBtn').prop('disabled', false);
            $('#loginText').show();
            $('#loadingSpinner').hide();
        }

        // 表单提交处理
        $('#loginForm').on('submit', function(e) {
            e.preventDefault();

            // 显示加载状态
            const $loginBtn = $('#loginBtn');
            const $loginText = $('#loginText');
            const $loadingSpinner = $('#loadingSpinner');

            $loginBtn.prop('disabled', true);
            $loginText.hide();
            $loadingSpinner.show();

            // 隐藏之前的提示
            hideError();
            hideSuccess();
            hideWarning();

            // 获取表单数据
            const formData = {
                account: $('#account').val().trim(),
                password: $('#password').val().trim(),
                loginType: $('input[name="loginType"]:checked').val(),
                rememberMe: $('#rememberMe').is(':checked'),
                captcha: ''
            };

            // 验证输入
            if (!formData.account) {
                showError('请输入账号');
                resetButton();
                return false;
            }

            if (!formData.password) {
                showError('请输入密码');
                resetButton();
                return false;
            }

            // 特殊验证
            if (formData.loginType === 'phone') {
                if (!/^\d{11}$/.test(formData.account)) {
                    showError('请输入有效的11位手机号码');
                    resetButton();
                    return false;
                }
            }

            if (formData.loginType === 'email') {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(formData.account)) {
                    showError('请输入有效的邮箱地址');
                    resetButton();
                    return false;
                }
            }

            // 发送登录请求
            $.ajax({
                url: 'api/login',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                dataType: 'json',
                success: function(response) {
                    console.log('登录响应数据:', response);
                    
                    if (response && response.success) {
                        // 登录成功
                        // 如果用户被封禁，添加警告提示
                        if (response.data) {
                            console.log('用户数据:', response.data);
                            console.log('用户状态字段:', response.data.status);
                            
                            // 检查封禁状态的多种可能字段
                            const isBanned = response.data.status === 'banned' ||
                                response.data.status === 'BANNED' ||
                                response.data.banned === true ||
                                response.data.isBanned === true ||
                                response.data.userStatus === 'banned';
                            
                            console.log('是否被封禁:', isBanned);

                            // 保存用户信息到sessionStorage
                            sessionStorage.setItem('user', JSON.stringify(response.data));

                            if (isBanned) {
                                sessionStorage.setItem('user_banned', 'true');

                                // 显示封禁警告
                                let banMessage = '您的账号当前处于封禁状态，部分功能可能受限。';
                                if (response.data.banReason) {
                                    banMessage += ' 原因：' + response.data.banReason;
                                }
                                if (response.data.banUntil) {
                                    const banDate = new Date(response.data.banUntil);
                                    banMessage += ' 解封时间：' + banDate.toLocaleDateString();
                                }

                                console.log('显示封禁警告:', banMessage);
                                showWarning(banMessage);
                                showSuccess('登录成功！账号处于封禁状态，部分功能受限。正在跳转...');
                            } else {
                                sessionStorage.removeItem('user_banned');
                                showSuccess('登录成功！正在跳转...');
                            }
                        } else {
                            console.log('响应中没有用户数据');
                            showSuccess('登录成功！正在跳转...');
                        }

                        // 2秒后跳转到首页
                        setTimeout(function() {
                            window.location.href = 'index.jsp';
                        }, 2000);
                    } else {
                        // 登录失败
                        const errorMsg = response && response.message ? response.message : '登录失败';

                        // 检查是否为封禁相关错误
                        if (response && (response.code === 'USER_BANNED' ||
                            (response.message && response.message.includes('封禁')))) {
                            let banMessage = '账号已被封禁，无法登录';
                            if (response.data) {
                                if (response.data.banReason) {
                                    banMessage += '，原因：' + response.data.banReason;
                                }
                                if (response.data.banUntil) {
                                    const banDate = new Date(response.data.banUntil);
                                    banMessage += '，解封时间：' + banDate.toLocaleDateString();
                                }
                            }
                            showError(banMessage);
                        } else {
                            showError(errorMsg);
                        }

                        resetButton();
                    }
                },
                error: function(xhr, status, error) {
                    console.error("=== AJAX 错误详情 ===");
                    console.error("状态码:", xhr.status);
                    console.error("状态文本:", xhr.statusText);
                    console.error("错误信息:", error);
                    console.error("响应文本:", xhr.responseText);
                    console.error("请求URL:", xhr.responseURL);

                    let errorMsg = '登录请求失败，请稍后重试';

                    if (xhr.status === 403) {
                        // 权限拒绝，可能是被封禁
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            if (errorResponse.code === 'USER_BANNED' ||
                                (errorResponse.message && errorResponse.message.includes('封禁'))) {
                                let banMessage = '账号已被封禁，无法登录';
                                if (errorResponse.data) {
                                    if (errorResponse.data.banReason) {
                                        banMessage += '，原因：' + errorResponse.data.banReason;
                                    }
                                    if (errorResponse.data.banUntil) {
                                        const banDate = new Date(errorResponse.data.banUntil);
                                        banMessage += '，解封时间：' + banDate.toLocaleDateString();
                                    }
                                }
                                showError(banMessage);
                                resetButton();
                                return;
                            }
                        } catch (e) {
                            // 忽略解析错误
                        }
                    }

                    if (xhr.responseText) {
                        try {
                            const errorResponse = JSON.parse(xhr.responseText);
                            errorMsg = errorResponse.message || errorMsg;
                        } catch (e) {
                            if (xhr.responseText.length < 100) {
                                errorMsg = xhr.responseText;
                            }
                        }
                    }

                    showError(errorMsg);
                    resetButton();
                }
            });

            return false;
        });

        // 自动判断登录类型
        $('#account').on('input', function() {
            const value = $(this).val();
            const $typeEmail = $('#typeEmail');
            const $typePhone = $('#typePhone');
            const $typeUsername = $('#typeUsername');

            if (value.includes('@') && !$typeEmail.prop('checked')) {
                $typeEmail.prop('checked', true).trigger('change');
            } else if (/^\d{11}$/.test(value) && !$typePhone.prop('checked')) {
                $typePhone.prop('checked', true).trigger('change');
            } else if (!value.includes('@') && !/^\d{11}$/.test(value) && !$typeUsername.prop('checked')) {
                $typeUsername.prop('checked', true).trigger('change');
            }
        });

        // 处理 alert 关闭按钮
        $('.alert .btn-close').on('click', function() {
            $(this).closest('.alert').hide();
        });

        // 初始更新标签
        updateAccountLabel($('input[name="loginType"]:checked').val());

        // 页面加载时检查是否有错误信息需要显示（从其他页面传递过来）
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        if (error) {
            showError(decodeURIComponent(error));
        }

        const message = urlParams.get('message');
        if (message) {
            showSuccess(decodeURIComponent(message));
        }
    });
</script>
</body>
</html>