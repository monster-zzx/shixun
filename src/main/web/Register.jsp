<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 贴吧系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px;
        }
        .register-container {
            max-width: 500px;
            width: 100%;
            margin: 0 auto;
        }
        .register-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .register-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-weight: 600;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        .btn-register {
            width: 100%;
            padding: 10px;
            font-weight: 600;
            margin-top: 10px;
        }
        .register-footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        .alert {
            display: none;
        }
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 3px;
            transition: all 0.3s;
        }
        .strength-weak { background-color: #dc3545; width: 25%; }
        .strength-medium { background-color: #ffc107; width: 50%; }
        .strength-strong { background-color: #28a745; width: 100%; }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <h2 class="register-title">用户注册</h2>

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

        <!-- 注册表单 -->
        <form id="registerForm">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="username" class="form-label">用户名 *</label>
                    <input type="text" class="form-control" id="username" name="username"
                           placeholder="请输入用户名" required minlength="3" maxlength="20">
                    <div class="form-text">3-20个字符，可使用字母、数字、下划线</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">邮箱 *</label>
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="请输入邮箱地址" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">密码 *</label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="请输入密码" required minlength="6">
                    <div class="password-strength" id="passwordStrength"></div>
                    <div class="form-text">至少6个字符，建议包含字母和数字</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">确认密码 *</label>
                    <input type="password" class="form-control" id="confirmPassword"
                           placeholder="请再次输入密码" required>
                    <div class="form-text" id="passwordMatchText"></div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="gender" class="form-label">性别</label>
                    <select class="form-select" id="gender" name="gender">
                        <option value="unknown" selected>请选择</option>
                        <option value="male">男</option>
                        <option value="female">女</option>
                    </select>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">手机号</label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           placeholder="请输入手机号" pattern="\d{11}">
                    <div class="form-text">请输入11位手机号码</div>
                </div>
            </div>

            <div class="mb-3">
                <label for="resume" class="form-label">个人简介</label>
                <textarea class="form-control" id="resume" name="resume"
                          rows="3" placeholder="介绍一下自己吧..." maxlength="500"></textarea>
                <div class="form-text">不超过500个字符</div>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                <label class="form-check-label" for="agreeTerms">
                    我已阅读并同意 <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">《用户协议》</a>
                </label>
            </div>

            <button type="submit" class="btn btn-primary btn-register" id="registerBtn">
                <span id="registerText">立即注册</span>
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"
                      style="display: none;" id="loadingSpinner"></span>
            </button>
        </form>

        <div class="register-footer">
            已有账号？<a href="login.jsp" class="text-decoration-none">立即登录</a>
        </div>
    </div>
</div>

<!-- 用户协议模态框 -->
<div class="modal fade" id="termsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">用户协议</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6>1. 接受条款</h6>
                <p>通过注册本系统，您表示同意遵守本协议的所有条款和条件。</p>

                <h6>2. 用户义务</h6>
                <p>您承诺：提供真实、准确、完整的注册信息；维护并及时更新注册信息；对账户安全负全部责任。</p>

                <h6>3. 隐私保护</h6>
                <p>我们将依法保护您的个人信息，不会泄露给第三方。</p>

                <h6>4. 使用规则</h6>
                <p>禁止发布违法、违规内容；禁止侵犯他人权益；遵守社区规范。</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
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
        // 密码强度检测
        $('#password').on('input', function() {
            const password = $(this).val();
            const strengthBar = $('#passwordStrength');

            if (password.length === 0) {
                strengthBar.removeClass('strength-weak strength-medium strength-strong').css('width', '0');
                return;
            }

            let strength = 0;
            if (password.length >= 6) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            strengthBar.removeClass('strength-weak strength-medium strength-strong');
            if (strength <= 2) {
                strengthBar.addClass('strength-weak');
            } else if (strength <= 4) {
                strengthBar.addClass('strength-medium');
            } else {
                strengthBar.addClass('strength-strong');
            }
        });

        // 密码确认验证
        $('#confirmPassword').on('input', function() {
            const password = $('#password').val();
            const confirmPassword = $(this).val();
            const matchText = $('#passwordMatchText');

            if (confirmPassword.length === 0) {
                matchText.text('');
                return;
            }

            if (password === confirmPassword) {
                matchText.text('✓ 密码匹配').css('color', 'green');
            } else {
                matchText.text('✗ 密码不匹配').css('color', 'red');
            }
        });

        // 手机号格式验证
        $('#phone').on('blur', function() {
            const phone = $(this).val();
            if (phone && !/^\d{11}$/.test(phone)) {
                $(this).addClass('is-invalid');
                $(this).next('.form-text').text('请输入有效的11位手机号码').css('color', 'red');
            } else {
                $(this).removeClass('is-invalid');
                $(this).next('.form-text').text('请输入11位手机号码').css('color', '');
            }
        });

        // 表单提交处理
        $('#registerForm').submit(function(e) {
            e.preventDefault();

            // 验证表单
            if (!validateForm()) {
                return;
            }

            // 显示加载状态
            $('#registerBtn').prop('disabled', true);
            $('#registerText').hide();
            $('#loadingSpinner').show();

            // 隐藏之前的提示
            $('#errorAlert').hide();
            $('#successAlert').hide();

            // 获取表单数据
            const formData = {
                username: $('#username').val().trim(),
                password: $('#password').val().trim(),
                email: $('#email').val().trim(),
                gender: $('#gender').val(),
                phone: $('#phone').val().trim(),
                resume: $('#resume').val().trim()
            };

            // 发送注册请求
            $.ajax({
                url: 'api/register', // 需要创建对应的RegisterServlet
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        // 注册成功
                        showSuccess(response.message || '注册成功！3秒后跳转到登录页面...');

                        // 3秒后跳转到登录页面
                        setTimeout(function() {
                            window.location.href = 'login.jsp';
                        }, 3000);
                    } else {
                        // 注册失败
                        showError(response.message || '注册失败');
                        resetButton();
                    }
                },
                error: function(xhr, status, error) {
                    let errorMsg = '注册请求失败';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }
                    showError(errorMsg);
                    resetButton();
                }
            });
        });

        function validateForm() {
            // 验证用户名
            const username = $('#username').val().trim();
            if (username.length < 3 || username.length > 20) {
                showError('用户名长度应为3-20个字符');
                return false;
            }
            if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                showError('用户名只能包含字母、数字和下划线');
                return false;
            }

            // 验证邮箱
            const email = $('#email').val().trim();
            if (!/^\S+@\S+\.\S+$/.test(email)) {
                showError('请输入有效的邮箱地址');
                return false;
            }

            // 验证密码
            const password = $('#password').val();
            if (password.length < 6) {
                showError('密码长度至少6个字符');
                return false;
            }

            // 验证确认密码
            const confirmPassword = $('#confirmPassword').val();
            if (password !== confirmPassword) {
                showError('两次输入的密码不一致');
                return false;
            }

            // 验证手机号（可选）
            const phone = $('#phone').val().trim();
            if (phone && !/^\d{11}$/.test(phone)) {
                showError('请输入有效的11位手机号码');
                return false;
            }

            // 验证协议
            if (!$('#agreeTerms').is(':checked')) {
                showError('请阅读并同意用户协议');
                return false;
            }

            return true;
        }

        function showError(message) {
            $('#errorMessage').text(message);
            $('#errorAlert').show();
            $('html, body').animate({ scrollTop: 0 }, 500);
        }

        function showSuccess(message) {
            $('#successMessage').text(message);
            $('#successAlert').show();
            $('html, body').animate({ scrollTop: 0 }, 500);
        }

        function resetButton() {
            $('#registerBtn').prop('disabled', false);
            $('#registerText').show();
            $('#loadingSpinner').hide();
        }
    });
</script>
</body>
</html>