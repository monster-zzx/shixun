package com.bar.servlet;

import com.bar.service.UserService;
import com.bar.util.JsonResponse;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/user/profile")
public class UserProfileServlet extends HttpServlet {
    private UserService userService = new UserService();
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

            // 获取要查询的用户ID（如果提供了userId参数，则查询该用户；否则查询当前登录用户）
            String userIdParam = request.getParameter("userId");
            Integer targetUserId = userId;
            if (userIdParam != null && !userIdParam.trim().isEmpty()) {
                try {
                    targetUserId = Integer.parseInt(userIdParam);
                } catch (NumberFormatException e) {
                    out.write(JsonResponse.error("用户ID格式错误"));
                    return;
                }
            }

            // 获取用户信息和统计
            Map<String, Object> profileData = userService.getUserProfile(targetUserId);
            if (profileData == null) {
                out.write(JsonResponse.error("用户不存在"));
                return;
            }

            // 格式化用户信息，移除敏感信息
            Object userObj = profileData.get("user");
            Map<String, Object> userInfo = new HashMap<>();
            if (userObj != null && userObj instanceof com.bar.beans.User) {
                com.bar.beans.User userBean = (com.bar.beans.User) userObj;
                userInfo.put("id", userBean.getId());
                userInfo.put("username", userBean.getUsername());
                userInfo.put("email", userBean.getEmail());
                userInfo.put("phone", userBean.getPhone());
                userInfo.put("gender", userBean.getGender());
                userInfo.put("resume", userBean.getResume());
                userInfo.put("role", userBean.getRole());
                userInfo.put("status", userBean.getStatus());
                userInfo.put("loginCount", userBean.getLoginCount());
                
                // 格式化日期
                if (userBean.getLastLoginTime() != null) {
                    userInfo.put("lastLoginTime", dateFormat.format(userBean.getLastLoginTime()));
                } else {
                    userInfo.put("lastLoginTime", null);
                }
                
                if (userBean.getCreateTime() != null) {
                    userInfo.put("createTime", dateFormat.format(userBean.getCreateTime()));
                } else {
                    userInfo.put("createTime", null);
                }
            }

            // 获取统计信息
            Object statisticsObj = profileData.get("statistics");
            Map<String, Object> statistics = null;
            if (statisticsObj instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> statsMap = (Map<String, Object>) statisticsObj;
                statistics = statsMap;
            }
            
            // 构建返回数据
            Map<String, Object> data = new HashMap<>();
            data.put("user", userInfo);
            data.put("statistics", statistics);

            out.write(JsonResponse.success("获取用户信息成功", data));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
