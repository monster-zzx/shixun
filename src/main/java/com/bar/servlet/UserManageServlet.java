// UserManageServlet.java
package com.bar.servlet;

import com.bar.service.UserService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/user/manage")
public class UserManageServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

            // 获取查询参数
            String search = request.getParameter("search");
            String status = request.getParameter("status");
            String roleFilter = request.getParameter("role");

            int page = 1;
            int size = 10;

            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception e) {
                // 使用默认值
            }

            try {
                size = Integer.parseInt(request.getParameter("size"));
            } catch (Exception e) {
                // 使用默认值
            }

            // 获取用户列表
            Map<String, Object> result = userService.getUserList(search, status, roleFilter, page, size);

            out.write(JsonResponse.success("获取用户列表成功", result));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
