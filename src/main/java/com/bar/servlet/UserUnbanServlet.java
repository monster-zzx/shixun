// UserUnbanServlet.java
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

@WebServlet("/api/user/unban")
public class UserUnbanServlet extends HttpServlet {
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
            int adminId = (int) request.getSession().getAttribute("userId");

            // 执行解封操作
            boolean success = userService.unbanUser(userId, adminId);

            if (success) {
                out.write(JsonResponse.success("用户解封成功"));
            } else {
                out.write(JsonResponse.error("用户解封失败"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
