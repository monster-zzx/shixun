package com.bar.servlet;

import com.bar.beans.Tag;
import com.bar.service.TagService;
import com.bar.util.JsonResponse;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 标签管理 Servlet
 * URL: /api/tag/list - 获取所有标签列表
 */
@WebServlet("/api/tag/list")
public class TagServlet extends HttpServlet {

    private final TagService tagService = new TagService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取所有标签列表
            List<Tag> tags = tagService.getAllTags();
            
            if (tags == null) {
                out.write(JsonResponse.error("获取标签列表失败"));
                return;
            }

            // 返回标签列表
            out.write(JsonResponse.success("获取成功", tags));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
