package com.bar.servlet;

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
import java.util.Map;

/**
 * 贴吧注册 Servlet
 * URL: /api/bar/BarMember
 */
@WebServlet("/api/bar/BarMember")
public class BarMemberServlet extends HttpServlet {

    private final BarService barService = new BarService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }
            Integer userId = (Integer) session.getAttribute("userId");

            String barIdParam = request.getParameter("barId");
            if (barIdParam == null || barIdParam.trim().isEmpty()) {
                out.write(JsonResponse.error("缺少贴吧ID参数"));
                return;
            }

            Integer barId = Integer.parseInt(barIdParam);
            boolean isMember = barService.checkIsMember(barId, userId);

            JsonObject data = new JsonObject();
            data.addProperty("isFavorite", isMember);
            out.write(JsonResponse.success("查询成功", data));
        } catch (NumberFormatException e) {
            out.write(JsonResponse.error("贴吧ID格式错误"));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }
            Integer userId = (Integer) session.getAttribute("userId");

            // 支持两种方式：URL参数或JSON请求体
            String action = request.getParameter("action");
            String barIdParam = request.getParameter("barId");

            // 如果没有URL参数，尝试从JSON请求体解析
            if (action == null || barIdParam == null) {
                try {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> params = (Map<String, Object>) gson.fromJson(request.getReader(), Map.class);
                    if (action == null) action = (String) params.get("action");
                    if (barIdParam == null) {
                        Object barIdObj = params.get("barId");
                        if (barIdObj != null) {
                            barIdParam = barIdObj.toString();
                        }
                    }
                } catch (Exception e) {
                    // JSON解析失败，继续使用URL参数
                }
            }

            if (action == null || barIdParam == null || barIdParam.trim().isEmpty()) {
                out.write(JsonResponse.error("缺少必要参数：action 和 barId"));
                return;
            }

            Integer barId = Integer.parseInt(barIdParam);
            boolean result = false;
            String message = "";

            if ("add".equals(action)) {
                result = barService.insertMember(barId, userId);
                message = result ? "收藏成功" : "收藏失败";
            } else if ("remove".equals(action)) {
                result = barService.removeMember(barId, userId);
                message = result ? "取消收藏成功" : "取消收藏失败";
            } else {
                out.write(JsonResponse.error("无效的操作类型，只能是 add 或 remove"));
                return;
            }

            JsonObject data = new JsonObject();
            data.addProperty("success", result);
            data.addProperty("isFavorite", "add".equals(action));
            out.write(JsonResponse.success(message, data));
        } catch (NumberFormatException e) {
            out.write(JsonResponse.error("贴吧ID格式错误"));
        } catch (IllegalStateException | IllegalArgumentException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
