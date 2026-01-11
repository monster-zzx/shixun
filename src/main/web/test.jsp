<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>数据库连接测试</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      padding: 20px;
      background-color: #f8f9fa;
    }
    .card {
      margin-bottom: 20px;
    }
    pre {
      background-color: #f8f9fa;
      padding: 10px;
      border-radius: 5px;
      max-height: 400px;
      overflow-y: auto;
    }
    .test-btn {
      margin: 5px;
    }
    .status-success {
      color: #28a745;
      font-weight: bold;
    }
    .status-error {
      color: #dc3545;
      font-weight: bold;
    }
    .status-warning {
      color: #ffc107;
      font-weight: bold;
    }
  </style>
</head>
<body>
<div class="container">
  <h1 class="mb-4">数据库连接测试</h1>

  <!-- 测试控制面板 -->
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">测试控制面板</h5>
    </div>
    <div class="card-body">
      <div class="mb-3">
        <button class="btn btn-primary test-btn" onclick="runDBTest()">
          运行完整数据库测试
        </button>
        <button class="btn btn-success test-btn" onclick="createUserTable()">
          创建User表
        </button>
        <button class="btn btn-info test-btn" onclick="addTestUser()">
          添加测试用户
        </button>
      </div>

      <div class="mb-3">
        <label for="sqlQuery" class="form-label">自定义SQL查询：</label>
        <div class="input-group">
          <input type="text" class="form-control" id="sqlQuery"
                 value="SELECT * FROM user LIMIT 5">
          <button class="btn btn-secondary" onclick="runCustomQuery()">执行查询</button>
        </div>
        <div class="form-text">支持SELECT、INSERT、UPDATE等SQL语句</div>
      </div>
    </div>
  </div>

  <!-- 测试结果 -->
  <div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h5 class="mb-0">测试结果</h5>
      <button class="btn btn-sm btn-outline-secondary" onclick="clearResults()">清空结果</button>
    </div>
    <div class="card-body">
      <div class="mb-3">
        <div class="spinner-border spinner-border-sm text-primary"
             role="status" style="display: none;" id="loadingSpinner">
          <span class="visually-hidden">Loading...</span>
        </div>
        <span id="testStatus"></span>
      </div>
      <pre id="testResult"></pre>
    </div>
  </div>

  <!-- 快速命令 -->
  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">常用SQL命令</h5>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6 mb-2">
          <button class="btn btn-sm btn-outline-secondary w-100"
                  onclick="setSQL('SELECT * FROM user')">
            查看所有用户
          </button>
        </div>
        <div class="col-md-6 mb-2">
          <button class="btn btn-sm btn-outline-secondary w-100"
                  onclick="setSQL('DESCRIBE user')">
            查看表结构
          </button>
        </div>
        <div class="col-md-6 mb-2">
          <button class="btn btn-sm btn-outline-secondary w-100"
                  onclick="setSQL('SELECT COUNT(*) as user_count FROM user')">
            统计用户数
          </button>
        </div>
        <div class="col-md-6 mb-2">
          <button class="btn btn-sm btn-outline-secondary w-100"
                  onclick="setSQL('SHOW TABLES')">
            查看所有表
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
  function showLoading(show) {
    if (show) {
      $('#loadingSpinner').show();
      $('#testStatus').html('<span class="status-warning">测试中...</span>');
    } else {
      $('#loadingSpinner').hide();
    }
  }

  function clearResults() {
    $('#testResult').text('');
    $('#testStatus').text('');
  }

  function setSQL(sql) {
    $('#sqlQuery').val(sql);
  }

  function runDBTest() {
    showLoading(true);
    $.ajax({
      url: 'api/db/test',
      type: 'GET',
      success: function(response) {
        showLoading(false);
        $('#testResult').text(JSON.stringify(response, null, 2));
        if (response.success) {
          $('#testStatus').html('<span class="status-success">✓ 测试成功</span>');
        } else {
          $('#testStatus').html('<span class="status-error">✗ 测试失败</span>');
        }
      },
      error: function(xhr, status, error) {
        showLoading(false);
        $('#testResult').text('请求失败: ' + error + '\n' + xhr.responseText);
        $('#testStatus').html('<span class="status-error">✗ 请求失败</span>');
      }
    });
  }

  function createUserTable() {
    if (!confirm('确定要创建user表吗？如果表已存在，将会跳过创建。')) {
      return;
    }

    showLoading(true);
    $.ajax({
      url: 'api/db/test',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ action: 'createUserTable' }),
      success: function(response) {
        showLoading(false);
        $('#testResult').text(JSON.stringify(response, null, 2));
        if (response.success) {
          $('#testStatus').html('<span class="status-success">✓ ' + response.message + '</span>');
        } else {
          $('#testStatus').html('<span class="status-error">✗ ' + (response.message || '操作失败') + '</span>');
        }
      },
      error: function(xhr, status, error) {
        showLoading(false);
        $('#testResult').text('请求失败: ' + error + '\n' + xhr.responseText);
        $('#testStatus').html('<span class="status-error">✗ 请求失败</span>');
      }
    });
  }

  function addTestUser() {
    const username = prompt('请输入用户名（默认：testuser）', 'testuser');
    if (username === null) return;

    const password = prompt('请输入密码（默认：123456）', '123456');
    if (password === null) return;

    const email = prompt('请输入邮箱（默认：test@example.com）', 'test@example.com');
    if (email === null) return;

    showLoading(true);
    $.ajax({
      url: 'api/db/test',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        action: 'addTestUser',
        username: username,
        password: password,
        email: email
      }),
      success: function(response) {
        showLoading(false);
        $('#testResult').text(JSON.stringify(response, null, 2));
        if (response.success) {
          $('#testStatus').html('<span class="status-success">✓ 测试用户添加成功</span>');
        } else {
          $('#testStatus').html('<span class="status-error">✗ ' + (response.message || '添加失败') + '</span>');
        }
      },
      error: function(xhr, status, error) {
        showLoading(false);
        $('#testResult').text('请求失败: ' + error + '\n' + xhr.responseText);
        $('#testStatus').html('<span class="status-error">✗ 请求失败</span>');
      }
    });
  }

  function runCustomQuery() {
    const sql = $('#sqlQuery').val().trim();
    if (!sql) {
      alert('请输入SQL语句');
      return;
    }

    showLoading(true);
    $.ajax({
      url: 'api/db/test',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        action: 'testQuery',
        sql: sql
      }),
      success: function(response) {
        showLoading(false);
        $('#testResult').text(JSON.stringify(response, null, 2));
        if (response.success) {
          $('#testStatus').html('<span class="status-success">✓ SQL执行成功</span>');
        } else {
          $('#testStatus').html('<span class="status-error">✗ ' + (response.message || '执行失败') + '</span>');
        }
      },
      error: function(xhr, status, error) {
        showLoading(false);
        $('#testResult').text('请求失败: ' + error + '\n' + xhr.responseText);
        $('#testStatus').html('<span class="status-error">✗ 请求失败</span>');
      }
    });
  }

  // 页面加载后自动运行基础测试
  $(document).ready(function() {
    // 可以取消注释下面的行来自动测试
    // runDBTest();
  });
</script>
</body>
</html>
