package com.bar.servlet;

import com.bar.beans.Bar;
import com.bar.service.UserService;
import com.bar.util.JsonResponse;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 获取用户收藏的贴吧列表
 * URL: /api/user/favoriteBars
 */
@WebServlet("/api/user/favoriteBars")
public class FavoriteBarServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.write(JsonResponse.error("请先登录"));
                return;
            }

            // 从 session 中获取用户对象
            com.bar.beans.User user = (com.bar.beans.User) session.getAttribute("user");
            if (user == null || user.getId() == null) {
                out.write(JsonResponse.error("用户信息无效"));
                return;
            }

            // 获取收藏的贴吧列表
            List<Bar> favoriteBars = userService.getFavoriteBars(user.getId());
            
            if (favoriteBars == null) {
                out.write(JsonResponse.error("获取收藏列表失败"));
                return;
            }

            out.write(JsonResponse.success("获取成功", favoriteBars));
        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("系统错误：" + e.getMessage()));
        }
    }
}
