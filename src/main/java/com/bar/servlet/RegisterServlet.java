
package com.bar.servlet;

import com.bar.beans.User;
import com.bar.service.UserService;

import com.bar.util.JsonResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.bar.mapper.UserMapper;
import com.bar.util.MybatisUtil;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Map;

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 解析JSON请求体
            Map<String, Object> params = gson.fromJson(request.getReader(), Map.class);

            System.out.println("=== 注册请求开始 ===");
            System.out.println("接收到的参数: " + params);

            String username = params.get("username") != null ?
                    ((String) params.get("username")).trim() : null;
            String email = params.get("email") != null ?
                    ((String) params.get("email")).trim() : null;
            String phone = params.get("phone") != null ?
                    ((String) params.get("phone")).trim() : null;
            String password = params.get("password") != null ?
                    ((String) params.get("password")).trim() : null;

            // 验证必填字段
            if (username == null || username.isEmpty()) {
                System.out.println("错误: 用户名为空");
                out.write(JsonResponse.error("用户名不能为空"));
                return;
            }

            if (password == null || password.isEmpty()) {
                System.out.println("错误: 密码为空");
                out.write(JsonResponse.error("密码不能为空"));
                return;
            }

            if (email == null || email.isEmpty()) {
                System.out.println("错误: 邮箱为空");
                out.write(JsonResponse.error("邮箱不能为空"));
                return;
            }

            System.out.println("验证通过: username=" + username + ", email=" + email);

            // 检查用户名、邮箱、手机号是否已存在
            try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
                UserMapper mapper = sqlSession.getMapper(UserMapper.class);

                System.out.println("检查用户名是否存在: " + username);
                User existingUser = mapper.findByUsername(username);
                if (existingUser != null) {
                    System.out.println("用户名已存在: " + username);
                    out.write(JsonResponse.error("用户名 \"" + username + "\" 已被使用"));
                    return;
                }

                System.out.println("检查邮箱是否存在: " + email);
                existingUser = mapper.findByEmail(email);
                if (existingUser != null) {
                    System.out.println("邮箱已存在: " + email);
                    out.write(JsonResponse.error("邮箱 \"" + email + "\" 已被使用"));
                    return;
                }

                // 检查手机号（如果提供了）
                if (phone != null && !phone.isEmpty()) {
                    System.out.println("检查手机号是否存在: " + phone);
                    existingUser = mapper.findByPhone(phone);
                    if (existingUser != null) {
                        System.out.println("手机号已存在: " + phone);
                        out.write(JsonResponse.error("手机号 \"" + phone + "\" 已被使用"));
                        return;
                    }
                }

                System.out.println("所有唯一性检查通过");
            } catch (Exception e) {
                System.out.println("检查唯一性时出错: " + e.getMessage());
                e.printStackTrace();
                out.write(JsonResponse.error("系统错误：" + e.getMessage()));
                return;
            }

            // 创建User对象
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);

            // 设置可选字段
            if (params.get("gender") != null) {
                String gender = ((String) params.get("gender")).trim();
                user.setGender(gender);
                System.out.println("设置性别: " + gender);
            }

            if (phone != null && !phone.isEmpty()) {
                user.setPhone(phone);
                System.out.println("设置手机号: " + phone);
            }

            if (params.get("resume") != null) {
                String resume = ((String) params.get("resume")).trim();
                user.setResume(resume);
                System.out.println("设置个人简介: " + resume);
            }

            // 设置默认值
            user.setRole("user");
            user.setStatus("active");
            user.setLoginCount(0);
            user.setCreateTime(new Date());
            user.setUpdateTime(new Date());

            System.out.println("准备调用 userService.register()");

            // 执行注册
            boolean success = userService.register(user);

            System.out.println("userService.register() 返回: " + success);

            if (success) {
                System.out.println("注册成功，用户ID: " + user.getId());

                // 注册成功，构建响应数据
                JsonObject userData = new JsonObject();
                userData.addProperty("id", user.getId());
                userData.addProperty("username", user.getUsername());
                userData.addProperty("email", user.getEmail());
                userData.addProperty("gender", user.getGender() != null ? user.getGender() : "");
                userData.addProperty("role", user.getRole());
                userData.addProperty("status", user.getStatus());

                System.out.println("返回成功响应");
                out.write(JsonResponse.success("注册成功", userData));
            } else {
                System.out.println("注册失败: userService.register() 返回 false");
                out.write(JsonResponse.error("注册失败，请稍后重试"));
            }

            System.out.println("=== 注册请求结束 ===");

        } catch (Exception e) {
            System.out.println("注册过程中出现异常:");
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
