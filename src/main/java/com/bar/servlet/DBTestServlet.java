package com.bar.servlet;

import com.bar.util.MybatisUtil;
import com.bar.util.BCryptUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/db/test")
public class DBTestServlet extends HttpServlet {
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            // 测试MyBatis连接
            SqlSession sqlSession = MybatisUtil.getSqlSession();
            Connection conn = sqlSession.getConnection();

            // 1. 测试数据库连接
            result.addProperty("dbConnected", true);
            result.addProperty("dbProduct", conn.getMetaData().getDatabaseProductName());
            result.addProperty("dbVersion", conn.getMetaData().getDatabaseProductVersion());
            result.addProperty("url", conn.getMetaData().getURL());
            result.addProperty("user", conn.getMetaData().getUserName());
            result.addProperty("autoCommit", conn.getAutoCommit());

            // 2. 检查表是否存在
            JsonObject tables = new JsonObject();
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet tableRs = metaData.getTables(null, null, "%", new String[]{"TABLE"});

            while (tableRs.next()) {
                String tableName = tableRs.getString("TABLE_NAME");
                tables.addProperty(tableName, true);
            }
            result.add("tables", tables);

            // 3. 检查user表结构
            JsonObject userTableInfo = new JsonObject();
            if (tables.has("user")) {
                userTableInfo.addProperty("exists", true);

                // 获取表结构
                ResultSet columns = metaData.getColumns(null, null, "user", "%");
                JsonObject columnsInfo = new JsonObject();
                while (columns.next()) {
                    String colName = columns.getString("COLUMN_NAME");
                    String colType = columns.getString("TYPE_NAME");
                    String colSize = columns.getString("COLUMN_SIZE");
                    columnsInfo.addProperty(colName, colType + "(" + colSize + ")");
                }
                userTableInfo.add("columns", columnsInfo);

                // 查询user表数据
                Statement stmt = conn.createStatement();
                ResultSet dataRs = stmt.executeQuery("SELECT COUNT(*) as count FROM user");
                if (dataRs.next()) {
                    userTableInfo.addProperty("rowCount", dataRs.getInt("count"));
                }

                // 查询前5条数据
                ResultSet sampleRs = stmt.executeQuery(
                        "SELECT id, username, email, role, status, " +
                                "LENGTH(password) as pwd_len, create_time " +
                                "FROM user ORDER BY id LIMIT 5"
                );

                JsonObject sampleData = new JsonObject();
                int index = 1;
                while (sampleRs.next()) {
                    JsonObject row = new JsonObject();
                    row.addProperty("id", sampleRs.getInt("id"));
                    row.addProperty("username", sampleRs.getString("username"));
                    row.addProperty("email", sampleRs.getString("email"));
                    row.addProperty("role", sampleRs.getString("role"));
                    row.addProperty("status", sampleRs.getString("status"));
                    row.addProperty("password_length", sampleRs.getInt("pwd_len"));
                    row.addProperty("create_time", sampleRs.getTimestamp("create_time").toString());
                    sampleData.add("row" + index, row);
                    index++;
                }
                userTableInfo.add("sampleData", sampleData);

            } else {
                userTableInfo.addProperty("exists", false);
                userTableInfo.addProperty("message", "user表不存在，请检查表名是否正确");
            }
            result.add("userTable", userTableInfo);

            // 4. 测试BCrypt功能
            JsonObject bcryptTest = new JsonObject();
            String testPassword = "test123";
            String hashedPassword = BCryptUtil.hashPassword(testPassword);
            boolean checkResult = BCryptUtil.checkPassword(testPassword, hashedPassword);

            bcryptTest.addProperty("testPassword", testPassword);
            bcryptTest.addProperty("hashedPassword", hashedPassword);
            bcryptTest.addProperty("checkResult", checkResult);
            bcryptTest.addProperty("isValidHash", BCryptUtil.isValidHash(hashedPassword));
            result.add("bcryptTest", bcryptTest);

            // 5. 测试SQL查询
            try {
                Statement testStmt = conn.createStatement();
                ResultSet testRs = testStmt.executeQuery("SELECT 1 as test_value, NOW() as current_time");
                if (testRs.next()) {
                    JsonObject sqlTest = new JsonObject();
                    sqlTest.addProperty("testValue", testRs.getInt("test_value"));
                    sqlTest.addProperty("currentTime", testRs.getTimestamp("current_time").toString());
                    result.add("sqlTest", sqlTest);
                }
            } catch (SQLException e) {
                result.addProperty("sqlTestError", e.getMessage());
            }

            sqlSession.close();

            result.addProperty("success", true);
            result.addProperty("message", "数据库连接测试成功");

        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "数据库连接测试失败");
            result.addProperty("error", e.getMessage());
            result.addProperty("errorType", e.getClass().getName());
        }

        out.write(gson.toJson(result));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            // 解析测试参数
            Map<String, String> params = gson.fromJson(request.getReader(), Map.class);
            String action = params.get("action");

            if ("createUserTable".equals(action)) {
                // 创建user表
                SqlSession sqlSession = MybatisUtil.getSqlSession();
                Connection conn = sqlSession.getConnection();
                Statement stmt = conn.createStatement();

                String sql = "CREATE TABLE IF NOT EXISTS user (" +
                        "id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "username VARCHAR(50) NOT NULL UNIQUE, " +
                        "password VARCHAR(100) NOT NULL, " +
                        "email VARCHAR(100) UNIQUE, " +
                        "nickname VARCHAR(50), " +
                        "phone VARCHAR(20) UNIQUE, " +
                        "gender VARCHAR(10) DEFAULT 'unknown', " +
                        "resume TEXT, " +
                        "role VARCHAR(20) DEFAULT 'user', " +
                        "status VARCHAR(20) DEFAULT 'active', " +
                        "login_count INT DEFAULT 0, " +
                        "last_login_time DATETIME, " +
                        "create_time DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                        "update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";

                stmt.execute(sql);

                // 创建索引
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_username ON user(username)");
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_email ON user(email)");
                stmt.execute("CREATE INDEX IF NOT EXISTS idx_phone ON user(phone)");

                result.addProperty("success", true);
                result.addProperty("message", "user表创建成功");
                sqlSession.commit();
                sqlSession.close();

            } else if ("addTestUser".equals(action)) {
                // 添加测试用户
                String username = params.get("username") != null ? params.get("username") : "testuser";
                String password = params.get("password") != null ? params.get("password") : "123456";
                String email = params.get("email") != null ? params.get("email") : "test@example.com";

                // 加密密码
                String hashedPassword = BCryptUtil.hashPassword(password);

                SqlSession sqlSession = MybatisUtil.getSqlSession();
                Connection conn = sqlSession.getConnection();

                String sql = "INSERT INTO user (username, password, email, role, status) " +
                        "VALUES (?, ?, ?, 'user', 'active')";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, hashedPassword);
                pstmt.setString(3, email);

                int rows = pstmt.executeUpdate();

                result.addProperty("success", true);
                result.addProperty("rowsAffected", rows);
                result.addProperty("message", "测试用户添加成功");
                result.addProperty("username", username);
                result.addProperty("hashedPassword", hashedPassword);

                sqlSession.commit();
                sqlSession.close();

            } else if ("createPostTable".equals(action)) {
                SqlSession sqlSession = MybatisUtil.getSqlSession();
                Connection conn = sqlSession.getConnection();
                Statement stmt = conn.createStatement();

                String sql = "CREATE TABLE IF NOT EXISTS post (" +
                        "id INT PRIMARY KEY AUTO_INCREMENT, " +
                        "title VARCHAR(200) NOT NULL, " +
                        "content TEXT NOT NULL, " +
                        "user_id INT NOT NULL, " +
                        "bar_id INT NOT NULL, " +
                        "view_count INT DEFAULT 0, " +
                        "like_count INT DEFAULT 0, " +
                        "comment_count INT DEFAULT 0, " +
                        "status VARCHAR(20) DEFAULT 'ACTIVE', " +
                        "pubtime DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                        "updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE, " +
                        "FOREIGN KEY (bar_id) REFERENCES bar(id) ON DELETE CASCADE, " +
                        "INDEX idx_user_id (user_id), " +
                        "INDEX idx_bar_id (bar_id), " +
                        "INDEX idx_status (status), " +
                        "INDEX idx_pubtime (pubtime)" +
                        ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";

                stmt.execute(sql);

                result.addProperty("success", true);
                result.addProperty("message", "post表创建成功");
                sqlSession.commit();
                sqlSession.close();

            } else if ("testQuery".equals(action)) {
                // 测试SQL查询
                String sql = params.get("sql") != null ? params.get("sql") :
                        "SELECT * FROM user LIMIT 10";

                SqlSession sqlSession = MybatisUtil.getSqlSession();
                Connection conn = sqlSession.getConnection();
                Statement stmt = conn.createStatement();

                if (sql.toUpperCase().startsWith("SELECT")) {
                    ResultSet rs = stmt.executeQuery(sql);
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();

                    JsonObject queryResult = new JsonObject();
                    JsonObject columns = new JsonObject();
                    JsonObject data = new JsonObject();

                    // 获取列信息
                    for (int i = 1; i <= columnCount; i++) {
                        JsonObject column = new JsonObject();
                        column.addProperty("name", metaData.getColumnName(i));
                        column.addProperty("type", metaData.getColumnTypeName(i));
                        column.addProperty("size", metaData.getColumnDisplaySize(i));
                        columns.add("column" + i, column);
                    }
                    queryResult.add("columns", columns);

                    // 获取数据
                    int rowIndex = 1;
                    while (rs.next()) {
                        JsonObject row = new JsonObject();
                        for (int i = 1; i <= columnCount; i++) {
                            row.addProperty(metaData.getColumnName(i), rs.getString(i));
                        }
                        data.add("row" + rowIndex, row);
                        rowIndex++;
                    }
                    queryResult.add("data", data);
                    queryResult.addProperty("rowCount", rowIndex - 1);

                    result.add("queryResult", queryResult);
                    result.addProperty("success", true);

                } else {
                    int rows = stmt.executeUpdate(sql);
                    result.addProperty("success", true);
                    result.addProperty("rowsAffected", rows);
                    result.addProperty("message", "执行成功");
                    sqlSession.commit();
                }

                sqlSession.close();

            } else {
                result.addProperty("success", false);
                result.addProperty("message", "未知的操作类型");
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "操作失败");
            result.addProperty("error", e.getMessage());
        }

        out.write(gson.toJson(result));
        out.flush();
    }
}
