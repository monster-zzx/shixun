package com.bar.servlet;

import com.bar.beans.Comment;
import com.bar.service.CommentService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@WebServlet("/api/comment/*")
public class CommentServlet extends HttpServlet {

    private final CommentService commentService = new CommentService();
    private final Gson gson = new Gson();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String method = request.getMethod();
        String pathInfo = request.getPathInfo();
        
        if ("DELETE".equals(method) && pathInfo != null && pathInfo.matches("/\\d+")) {
            // 处理删除请求 /api/comment/{id}
            doDelete(request, response);
        } else if ("GET".equals(method)) {
            doGet(request, response);
        } else if ("POST".equals(method)) {
            doPost(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.getWriter().write(JsonResponse.error("不支持的请求方法"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String postIdParam = request.getParameter("postId");
            if (postIdParam != null && !postIdParam.isEmpty()) {
                Integer postId = Integer.parseInt(postIdParam);
                List<Comment> comments = commentService.getCommentsByPostId(postId);
                out.write(JsonResponse.success("查询成功", comments));
            } else {
                out.write(JsonResponse.error("缺少帖子ID参数"));
            }
        } catch (NumberFormatException e) {
            out.write(JsonResponse.error("参数格式错误"));
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
            // 检查登录状态
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }

            Integer userId = (Integer) session.getAttribute("userId");

            // 读取请求体
            StringBuilder requestBody = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }

            String json = requestBody.toString();

            if (json == null || json.trim().isEmpty()) {
                out.write(JsonResponse.error("请求体为空"));
                return;
            }

            // 解析JSON
            Map<String, Object> params = gson.fromJson(json, Map.class);

            // 提取参数
            String content = null;
            Integer postId = null;

            if (params.containsKey("content")) {
                Object contentObj = params.get("content");
                content = contentObj != null ? contentObj.toString().trim() : null;
            }

            if (params.containsKey("postId")) {
                Object postIdObj = params.get("postId");
                try {
                    if (postIdObj instanceof Number) {
                        postId = ((Number) postIdObj).intValue();
                    } else if (postIdObj instanceof String) {
                        postId = Integer.parseInt((String) postIdObj);
                    } else if (postIdObj != null) {
                        postId = Integer.parseInt(postIdObj.toString());
                    }
                } catch (NumberFormatException e) {
                    out.write(JsonResponse.error("postId必须是有效的数字"));
                    return;
                }
            }

            // 参数验证
            if (content == null || content.isEmpty()) {
                out.write(JsonResponse.error("评论内容不能为空"));
                return;
            }
            if (postId == null) {
                out.write(JsonResponse.error("帖子ID不能为空"));
                return;
            }

            // 创建评论
            Comment comment = commentService.createComment(postId, userId, content);

            // 构建响应
            out.write(JsonResponse.success("评论发表成功", comment));

        } catch (NumberFormatException e) {
            out.write(JsonResponse.error("参数格式错误: " + e.getMessage()));
        } catch (IllegalStateException | IllegalArgumentException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 检查登录状态
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }

            Integer currentUserId = (Integer) session.getAttribute("userId");
            
            // 从URL路径中获取评论ID
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                out.write(JsonResponse.error("缺少评论ID"));
                return;
            }
            
            // 提取评论ID (例如 /api/comment/123 -> 123)
            String commentIdStr = pathInfo.substring(1);
            Integer commentId;
            try {
                commentId = Integer.parseInt(commentIdStr);
            } catch (NumberFormatException e) {
                out.write(JsonResponse.error("无效的评论ID"));
                return;
            }
            
            // 执行删除
            boolean success = commentService.deleteComment(commentId, currentUserId);
            if (success) {
                out.write(JsonResponse.success("删除成功"));
            } else {
                out.write(JsonResponse.error("删除失败"));
            }
            
        } catch (IllegalStateException e) {
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}