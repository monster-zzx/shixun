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
 * 贴吧审核 Servlet
 * URL: /api/bar/audit
 */
@WebServlet("/api/bar/audit")
public class BarAuditServlet extends HttpServlet {

    private final BarService barService = new BarService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查管理员权限（这里简化处理，实际应该检查 role）
//            HttpSession session = request.getSession(false);
//            if (session == null || session.getAttribute("userId") == null) {
//                out.write(JsonResponse.error("请先登录"));
//                return;
//            }

            // 查询待审核列表
            List<Bar> pendingBars = barService.getPendingBars();
            out.write(JsonResponse.success("查询成功", pendingBars));
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
            // 检查管理员权限
//            HttpSession session = request.getSession(false);
//            if (session == null || session.getAttribute("userId") == null) {
//                out.write(JsonResponse.error("请先登录"));
//                return;
//            }

            // 解析请求体（JSON）
            @SuppressWarnings("unchecked")
            Map<String, Object> params = (Map<String, Object>) gson.fromJson(request.getReader(), Map.class);
            Integer barId = null;
            String status = null;

            if (params.get("barId") != null) {
                if (params.get("barId") instanceof Number) {
                    barId = ((Number) params.get("barId")).intValue();
                } else {
                    barId = Integer.parseInt(params.get("barId").toString());
                }
            }

            if (params.get("status") != null) {
                status = params.get("status").toString().toUpperCase();
            }

            if (barId == null) {
                out.write(JsonResponse.error("贴吧ID不能为空"));
                return;
            }

            if (status == null || (!"ACTIVE".equals(status) && !"REJECTED".equals(status))) {
                out.write(JsonResponse.error("状态值无效，必须是 ACTIVE 或 REJECTED"));
                return;
            }

            // 执行审核
            boolean success = barService.auditBar(barId, status);
            if (success) {
                String message = "ACTIVE".equals(status) ? "审核通过" : "审核拒绝";
                out.write(JsonResponse.success(message));
            } else {
                out.write(JsonResponse.error("审核失败"));
            }
        } catch (IllegalStateException | IllegalArgumentException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
