package com.bar.servlet;

import com.bar.beans.Bar;
import com.bar.service.BarService;
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

/**
 * 贴吧搜索接口
 * GET /api/bar/search?keyword=xxx
 */
@WebServlet("/api/bar/search")
public class BarSearchServlet extends HttpServlet {

    private final BarService barService = new BarService();

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
            List<Bar> result = barService.searchActiveBars(keyword);
            out.write(JsonResponse.success("查询成功", result));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
