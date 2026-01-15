package com.bar.servlet;

import com.bar.beans.Post;
import com.bar.service.PostService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

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

@WebServlet("/api/post/*")
public class PostServlet extends HttpServlet {

    private final PostService postService = new PostService();
    private final Gson gson = new Gson();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String method = request.getMethod();
        String pathInfo = request.getPathInfo();
        
        if ("DELETE".equals(method) && pathInfo != null && pathInfo.matches("/\\d+")) {
            // 处理删除请求 /api/post/{id}
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
            
            // 从URL路径中获取帖子ID
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                out.write(JsonResponse.error("缺少帖子ID"));
                return;
            }
            
            // 提取帖子ID (例如 /api/post/123 -> 123)
            String postIdStr = pathInfo.substring(1);
            Integer postId;
            try {
                postId = Integer.parseInt(postIdStr);
            } catch (NumberFormatException e) {
                out.write(JsonResponse.error("无效的帖子ID"));
                return;
            }
            
            // 获取帖子信息验证权限
            Post post = postService.getPostById(postId);
            if (post == null) {
                out.write(JsonResponse.error("帖子不存在"));
                return;
            }
            
            // 检查是否是帖子作者或管理员（这里简化处理，只允许作者删除）
            if (!post.getUserId().equals(currentUserId)) {
                out.write(JsonResponse.error("没有权限删除此帖子"));
                return;
            }
            
            // 执行删除
            boolean success = postService.deletePost(postId);
            if (success) {
                out.write(JsonResponse.success("删除成功"));
            } else {
                out.write(JsonResponse.error("删除失败"));
            }
            
        } catch (IllegalStateException e) {
            System.err.println("删除帖子时发生业务异常: " + e.getMessage());
            e.printStackTrace();
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            System.err.println("删除帖子时发生系统异常: " + e.getMessage());
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String barIdParam = request.getParameter("barId");
            String userIdParam = request.getParameter("userId");

            if (barIdParam != null && !barIdParam.isEmpty()) {
                Integer barId = Integer.parseInt(barIdParam);
                List<Post> posts = postService.getPostsByBarId(barId);
                out.write(JsonResponse.success("查询成功", posts));
            } else if (userIdParam != null && !userIdParam.isEmpty()) {
                Integer userId = Integer.parseInt(userIdParam);
                List<Post> posts = postService.getPostsByUserId(userId);
                out.write(JsonResponse.success("查询成功", posts));
            } else {
                List<Post> posts = postService.getAllPosts();
                out.write(JsonResponse.success("查询成功", posts));
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
            System.out.println("当前用户ID: " + userId);

            // 读取请求体
            StringBuilder requestBody = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                requestBody.append(line);
            }

            String json = requestBody.toString();
            System.out.println("收到JSON数据: " + json);

            if (json == null || json.trim().isEmpty()) {
                out.write(JsonResponse.error("请求体为空"));
                return;
            }

            // 解析JSON - 使用更宽松的解析方式
            Map<String, Object> params;
            try {
                params = gson.fromJson(json, Map.class);
                System.out.println("解析后的参数: " + params);

                // 调试：打印所有参数类型
                for (Map.Entry<String, Object> entry : params.entrySet()) {
                    System.out.println("参数 " + entry.getKey() + ": 值=" + entry.getValue() +
                            ", 类型=" + (entry.getValue() != null ? entry.getValue().getClass().getName() : "null"));
                }
            } catch (JsonSyntaxException e) {
                System.err.println("JSON解析错误: " + e.getMessage());
                out.write(JsonResponse.error("JSON格式错误: " + e.getMessage()));
                return;
            }

            // 提取参数 - 处理不同类型的barId
            String title = null;
            String content = null;
            Integer barId = null;

            if (params.containsKey("title")) {
                Object titleObj = params.get("title");
                title = titleObj != null ? titleObj.toString().trim() : null;
            }

            if (params.containsKey("content")) {
                Object contentObj = params.get("content");
                content = contentObj != null ? contentObj.toString().trim() : null;
            }

            if (params.containsKey("barId")) {
                Object barIdObj = params.get("barId");
                System.out.println("barId原始对象: " + barIdObj + ", 类型: " +
                        (barIdObj != null ? barIdObj.getClass().getName() : "null"));

                try {
                    if (barIdObj instanceof Number) {
                        // 如果已经是数字类型
                        barId = ((Number) barIdObj).intValue();
                    } else if (barIdObj instanceof String) {
                        // 如果是字符串
                        barId = Integer.parseInt((String) barIdObj);
                    } else if (barIdObj != null) {
                        // 其他类型转换为字符串再解析
                        barId = Integer.parseInt(barIdObj.toString());
                    }
                    System.out.println("转换后的barId: " + barId);
                } catch (NumberFormatException e) {
                    System.err.println("barId转换失败: " + barIdObj);
                    out.write(JsonResponse.error("barId必须是有效的数字"));
                    return;
                }
            }

            System.out.println("提取参数 - title: '" + title + "', content: '" + content + "', barId: " + barId);

            // 参数验证
            if (title == null || title.isEmpty()) {
                out.write(JsonResponse.error("帖子标题不能为空"));
                return;
            }
            if (content == null || content.isEmpty()) {
                out.write(JsonResponse.error("帖子内容不能为空"));
                return;
            }
            if (barId == null) {
                out.write(JsonResponse.error("请选择贴吧"));
                return;
            }

            // 创建帖子
            System.out.println("开始创建帖子...");
            Post post = postService.createPost(title, content, userId, barId);
            System.out.println("帖子创建成功，ID: " + post.getId());

            // 构建响应
            JsonObject data = new JsonObject();
            data.addProperty("id", post.getId());
            data.addProperty("title", post.getTitle());
            data.addProperty("barId", post.getBarId());
            data.addProperty("pubtime", post.getPubtime() != null ? post.getPubtime().toString() : "");

            out.write(JsonResponse.success("发帖成功", data));

        } catch (NumberFormatException e) {
            System.err.println("数字格式错误: " + e.getMessage());
            out.write(JsonResponse.error("参数格式错误: " + e.getMessage()));
        } catch (IllegalStateException | IllegalArgumentException e) {
            System.err.println("业务逻辑错误: " + e.getMessage());
            out.write(JsonResponse.error(e.getMessage()));
        } catch (Exception e) {
            System.err.println("系统错误: ");
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}