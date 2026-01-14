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
 * 根据 barId 获取该贴吧的所有标签
 * URL: /api/tag/byBar?barId=123
 */
@WebServlet("/api/tag/byBar")
public class TagByBarServlet extends HttpServlet {

    private final TagService tagService = new TagService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String barIdParam = request.getParameter("barId");
            if (barIdParam == null || barIdParam.trim().isEmpty()) {
                out.write(JsonResponse.error("缺少 barId 参数"));
                return;
            }
            Integer barId = Integer.parseInt(barIdParam);
            List<Tag> tags = tagService.getTagsByBarId(barId);
            out.write(JsonResponse.success("获取成功", tags));
        } catch (NumberFormatException e) {
            out.write(JsonResponse.error("barId 格式错误"));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
