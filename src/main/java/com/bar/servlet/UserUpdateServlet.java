package com.bar.servlet;

import com.bar.beans.User;
import com.bar.service.UserService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/user/update")
public class UserUpdateServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查用户是否登录
            Integer userId = (Integer) request.getSession().getAttribute("userId");
            if (userId == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }

            // 读取请求体
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                json.append(line);
            }

            if (json.length() == 0) {
                out.write(JsonResponse.error("请求体为空"));
                return;
            }

            // 解析JSON
            @SuppressWarnings("unchecked")
            java.util.Map<String, Object> params = gson.fromJson(json.toString(), java.util.Map.class);

            // 创建User对象并设置ID
            User user = new User();
            user.setId(userId);

            // 设置可更新的字段
            if (params.containsKey("username")) {
                user.setUsername((String) params.get("username"));
            }
            if (params.containsKey("email")) {
                user.setEmail((String) params.get("email"));
            }
            if (params.containsKey("phone")) {
                user.setPhone((String) params.get("phone"));
            }
            if (params.containsKey("gender")) {
                user.setGender((String) params.get("gender"));
            }
            if (params.containsKey("resume")) {
                user.setResume((String) params.get("resume"));
            }

            // 更新用户信息
            boolean success = userService.updateUser(user);

            if (success) {
                // 更新session中的用户信息
                java.util.Map<String, Object> profileData = userService.getUserProfile(userId);
                Object userObj = profileData.get("user");
                if (userObj instanceof User) {
                    User updatedUser = (User) userObj;
                    request.getSession().setAttribute("user", updatedUser);
                    request.getSession().setAttribute("username", updatedUser.getUsername());
                }

                out.write(JsonResponse.success("更新成功"));
            } else {
                out.write(JsonResponse.error("更新失败"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
