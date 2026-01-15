package com.bar.servlet;

import com.bar.service.PostService;
import com.bar.util.JsonResponse;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet("/api/post/search")
public class PostSearchServlet extends HttpServlet {

    private final PostService postService = new PostService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = URLDecoder.decode(keyword, StandardCharsets.UTF_8.name()).trim();
            }

            // 添加 limit 参数，默认为 20
            int limit = 20;
            String limitParam = request.getParameter("limit");
            if (limitParam != null && !limitParam.isEmpty()) {
                try {
                    limit = Integer.parseInt(limitParam);
                } catch (NumberFormatException e) {
                    // 忽略无效的 limit 参数
                }
            }

            List<Map<String, Object>> result = postService.searchActivePosts(keyword, limit);
            out.write(JsonResponse.success("查询成功", result));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
