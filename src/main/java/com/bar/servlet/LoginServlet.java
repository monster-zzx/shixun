// LoginServlet.java
package com.bar.servlet;

import com.bar.beans.User;
import com.bar.dto.LoginDTO;
import com.bar.service.UserService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 解析JSON请求体
            LoginDTO loginDTO = gson.fromJson(request.getReader(), LoginDTO.class);

            // 参数验证
            if (loginDTO.getAccount() == null || loginDTO.getAccount().trim().isEmpty()) {
                out.write(JsonResponse.error("账号不能为空"));
                return;
            }

            if (loginDTO.getPassword() == null || loginDTO.getPassword().trim().isEmpty()) {
                out.write(JsonResponse.error("密码不能为空"));
                return;
            }

            // 执行登录
            User user = userService.login(loginDTO);

            if (user == null) {
                out.write(JsonResponse.error("账号或密码错误"));
                return;
            }

            // 创建Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("userStatus", user.getStatus()); // 添加用户状态，用于判断封禁和禁言

            // 设置Session过期时间（默认30分钟，记住我则为7天）
            if ("true".equals(loginDTO.getRememberMe())) {
                session.setMaxInactiveInterval(7 * 24 * 60 * 60); // 7天
            } else {
                session.setMaxInactiveInterval(30 * 60); // 30分钟
            }

            // 构建响应数据
            Map<String, Object> data = new HashMap<>();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("email", user.getEmail());
            data.put("role", user.getRole());
            data.put("status", user.getStatus()); // 添加状态字段，用于判断封禁状态
            data.put("lastLoginTime", user.getLastLoginTime());

            out.write(JsonResponse.success("登录成功", data));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
