package com.bar.servlet;

import com.bar.beans.Bar;

import com.bar.service.BarService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;

/**
 * 贴吧注册 Servlet
 * URL: /api/bar/BarRegister
 */
@WebServlet("/api/bar/BarRegister")
public class BarRegisterServlet extends HttpServlet {

    private final BarService barService = new BarService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查登录
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }
            Integer userId = (Integer) session.getAttribute("userId");

            // 解析请求体（JSON）
            Map<String, Object> params = gson.fromJson(request.getReader(), Map.class);
            String name = params.get("name") == null ? null : ((String) params.get("name")).trim();
            String description = params.get("description") == null ? null : ((String) params.get("description")).trim();
            java.util.List<Integer> tagIds = new java.util.ArrayList<>();
            if (params.get("tagIds") != null && params.get("tagIds") instanceof java.util.List) {
                java.util.List<?> arr = (java.util.List<?>) params.get("tagIds");
                for (Object o : arr) {
                    if (o == null) continue;
                    // Gson 会把数字解析为 Double
                    if (o instanceof Number) {
                        tagIds.add(((Number) o).intValue());
                    } else {
                        try { tagIds.add(Integer.parseInt(o.toString())); } catch (NumberFormatException ignore) {}
                    }
                }
            }
            if (name == null || name.isEmpty()) {
                out.write(JsonResponse.error("贴吧名称不能为空"));
                return;
            }

            // 调用 Service
            Bar bar = barService.createBar(name, description, userId, tagIds);


            // 构建成功响应
            JsonObject data = new JsonObject();
            data.addProperty("id", bar.getId());
            data.addProperty("name", bar.getName());
            data.addProperty("status", bar.getStatus());
            out.write(JsonResponse.success("创建成功", data));
        } catch (IllegalStateException | IllegalArgumentException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
