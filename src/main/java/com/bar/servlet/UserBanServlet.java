// UserBanServlet.java
package com.bar.servlet;

import com.bar.service.UserService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/user/ban")
public class UserBanServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查是否是管理员
            String role = (String) request.getSession().getAttribute("role");
            if (!"admin".equals(role)) {
                out.write(JsonResponse.error("权限不足，需要管理员权限"));
                return;
            }

            // 解析JSON请求体
            JsonObject json = gson.fromJson(request.getReader(), JsonObject.class);
            int userId = json.get("userId").getAsInt();
            String reason = json.get("reason").getAsString();

            // 获取当前管理员ID
            Integer adminId = (Integer) request.getSession().getAttribute("userId");
            if (adminId == null) {
                out.write(JsonResponse.error("管理员未登录"));
                return;
            }

            // 验证参数
            if (reason == null || reason.trim().isEmpty()) {
                out.write(JsonResponse.error("封禁原因不能为空"));
                return;
            }

            // 执行封禁操作
            boolean success = userService.banUser(userId, reason, adminId);

            if (success) {
                out.write(JsonResponse.success("用户封禁成功"));
            } else {
                out.write(JsonResponse.error("用户封禁失败"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
