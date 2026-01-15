package com.bar.servlet;

import com.bar.beans.Bar;
import com.bar.service.BarService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * 贴吧管理 Servlet
 * URL: /api/bar/manage
 */
@WebServlet("/api/bar/manage")
public class BarManageServlet extends HttpServlet {

    private final BarService barService = new BarService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查登录
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
//                out.write(JsonResponse.error("请先登录"));
//                return;
            }

            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            String statusParam = request.getParameter("status");

            // 查询单个贴吧详情
            if ("detail".equals(action) && idParam != null) {
                Integer id = Integer.parseInt(idParam);
                Bar bar = barService.getBarById(id);
                if (bar != null) {
                    out.write(JsonResponse.success("查询成功", bar));
                } else {
                    out.write(JsonResponse.error("贴吧不存在"));
                }
                return;
            }

            // 查询贴吧列表
            List<Bar> bars;
            if ("active".equals(statusParam)) {
                bars = barService.getActiveBars();
            } else {
                bars = barService.getAllBars();
            }
            // 填充每个贴吧的标签信息
            com.bar.service.TagService tagService = new com.bar.service.TagService();
            for (Bar b : bars) {
                b.setTags(tagService.getTagsByBarId(b.getId()));
            }
            out.write(JsonResponse.success("查询成功", bars));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查登录
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
//                out.write(JsonResponse.error("请先登录"));
//                return;
            }

            // 解析请求体
            @SuppressWarnings("unchecked")
            Map<String, Object> params = (Map<String, Object>) gson.fromJson(request.getReader(), Map.class);
            String action = params.get("action") != null ? params.get("action").toString() : null;

            if ("update".equals(action)) {
                // 更新贴吧信息
                Integer id = getInteger(params, "id");
                String name = params.get("name") != null ? params.get("name").toString().trim() : null;
                String description = params.get("description") != null ? params.get("description").toString().trim() : null;
                String status = params.get("status") != null ? params.get("status").toString().toUpperCase() : null;

                if (id == null) {
                    out.write(JsonResponse.error("贴吧ID不能为空"));
                    return;
                }

                java.util.List<Integer> tagIds = null;
                if (params.get("tagIds") instanceof java.util.List) {
                    tagIds = new java.util.ArrayList<>();
                    for (Object o : (java.util.List<?>) params.get("tagIds")) {
                        if (o == null) continue;
                        if (o instanceof Number) tagIds.add(((Number) o).intValue());
                        else {
                            try { tagIds.add(Integer.parseInt(o.toString())); } catch (NumberFormatException ignore) {}
                        }
                    }
                }

                boolean success = barService.updateBar(id, name, description, status);
                if (success && tagIds != null) {
                    // 重新绑定标签
                    com.bar.service.TagService ts = new com.bar.service.TagService();
                    ts.removeAllTagsFromBar(id);
                    ts.addTagIdsToBar(id, tagIds);
                }
                out.write(JsonResponse.success("更新成功"));
            } else if ("delete".equals(action)) {
                // 删除贴吧
                Integer id = getInteger(params, "id");
                if (id == null) {
                    out.write(JsonResponse.error("贴吧ID不能为空"));
                    return;
                }

                boolean success = barService.deleteBar(id);
                if (success) {
                    out.write(JsonResponse.success("删除成功"));
                } else {
                    out.write(JsonResponse.error("删除失败"));
                }
            } else if ("changeStatus".equals(action)) {
                // 修改状态
                Integer id = getInteger(params, "id");
                String status = params.get("status") != null ? params.get("status").toString().toUpperCase() : null;

                if (id == null) {
                    out.write(JsonResponse.error("贴吧ID不能为空"));
                    return;
                }
                if (status == null) {
                    out.write(JsonResponse.error("状态值不能为空"));
                    return;
                }

                boolean success = barService.changeStatus(id, status);
                if (success) {
                    out.write(JsonResponse.success("状态更新成功"));
                } else {
                    out.write(JsonResponse.error("状态更新失败"));
                }
            } else {
                out.write(JsonResponse.error("无效的操作类型"));
            }
        } catch (IllegalStateException | IllegalArgumentException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }

    private Integer getInteger(Map<String, Object> params, String key) {
        Object value = params.get(key);
        if (value == null) return null;
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        try {
            return Integer.parseInt(value.toString());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
