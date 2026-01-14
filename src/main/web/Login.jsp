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

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function() {
        // 根据登录类型切换标签和提示
        $('input[name="loginType"]').change(function() {
            const type = $(this).val();
            updateAccountLabel(type);
        });

        function updateAccountLabel(type) {
            const accountLabel = $('#accountLabel');
            const accountInput = $('#account');
            const accountHelp = $('#accountHelp');

            switch(type) {
                case 'email':
                    accountLabel.text('邮箱地址');
                    accountInput.attr('placeholder', '请输入邮箱地址');
                    accountInput.attr('type', 'email');
                    accountHelp.text('请输入您的邮箱地址');
                    break;
                case 'phone':
                    accountLabel.text('手机号码');
                    accountInput.attr('placeholder', '请输入11位手机号码');
                    accountInput.attr('type', 'tel');
                    accountHelp.text('请输入您的11位手机号码');
                    break;
                default:
                    accountLabel.text('用户名');
                    accountInput.attr('placeholder', '请输入用户名');
                    accountInput.attr('type', 'text');
                    accountHelp.text('请输入您的用户名');
            }
        }

        // 表单提交处理
        $('#loginForm').submit(function(e) {
            e.preventDefault();

            // 显示加载状态
            $('#loginBtn').prop('disabled', true);
            $('#loginText').hide();
            $('#loadingSpinner').show();

            // 隐藏之前的提示
            $('#errorAlert').hide();
            $('#successAlert').hide();

            // 获取表单数据
            const formData = {
                account: $('#account').val().trim(),
                password: $('#password').val().trim(),
                loginType: $('input[name="loginType"]:checked').val(),
                rememberMe: $('#rememberMe').is(':checked') ? 'true' : 'false',
                captcha: '' // 如果需要验证码可以添加
            };

            // 验证输入
            if (!formData.account) {
                showError('请输入账号');
                resetButton();
                return;
            }

            if (!formData.password) {
                showError('请输入密码');
                resetButton();
                return;
            }

            // 特殊验证
            if (formData.loginType === 'phone' && !/^\d{11}$/.test(formData.account)) {
                showError('请输入有效的11位手机号码');
                resetButton();
                return;
            }

            if (formData.loginType === 'email' && !/^\S+@\S+\.\S+$/.test(formData.account)) {
                showError('请输入有效的邮箱地址');
                resetButton();
                return;
            }

            // 发送登录请求
            $.ajax({
                url: 'api/login', // 对应 LoginServlet 的 @WebServlet("/api/login")
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        // 登录成功
                        showSuccess('登录成功！正在跳转...');

                        // 保存用户信息到sessionStorage（可选）
                        if (response.data) {
                            sessionStorage.setItem('user', JSON.stringify(response.data));
                        }

                        // 3秒后跳转到首页
                        setTimeout(function() {
                            window.location.href = 'index.jsp';
                        }, 2000);
                    } else {
                        // 登录失败
                        showError(response.message || '登录失败');
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

                    let errorMsg = '登录请求失败';
                    if (xhr.responseText) {
                        try {
                            // 尝试解析JSON错误响应
                            const errorResponse = JSON.parse(xhr.responseText);
                            errorMsg = errorResponse.message || errorMsg;
                        } catch (e) {
                            // 如果不是JSON，直接显示响应文本
                            if (xhr.responseText.length < 100) {
                                errorMsg = xhr.responseText;
                            }
                        }
                    }
                    showError(errorMsg);
                    resetButton();
                }
            });
        });

        function showError(message) {
            $('#errorMessage').text(message);
            $('#errorAlert').show();
        }

        function showSuccess(message) {
            $('#successMessage').text(message);
            $('#successAlert').show();
        }

        function resetButton() {
            $('#loginBtn').prop('disabled', false);
            $('#loginText').show();
            $('#loadingSpinner').hide();
        }

        // 自动判断登录类型
        $('#account').on('input', function() {
            const value = $(this).val();
            if (value.includes('@') && !$('#typeEmail').is(':checked')) {
                $('#typeEmail').prop('checked', true).trigger('change');
            } else if (/^\d{11}$/.test(value) && !$('#typePhone').is(':checked')) {
                $('#typePhone').prop('checked', true).trigger('change');
            } else if (!value.includes('@') && !/^\d{11}$/.test(value) && !$('#typeUsername').is(':checked')) {
                $('#typeUsername').prop('checked', true).trigger('change');
            }
        });

        // 初始更新标签
        updateAccountLabel($('input[name="loginType"]:checked').val());
    });
</script>
</body>
</html>