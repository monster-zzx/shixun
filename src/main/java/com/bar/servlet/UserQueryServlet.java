// UserQueryServlet.java
package com.bar.servlet;

import com.bar.dto.UserQueryDTO;
import com.bar.service.UserService;
import com.bar.util.JsonResponse;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/users/query")
public class UserQueryServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 解析查询参数
            String json = request.getReader().readLine();
            Map<String, Object> params = gson.fromJson(json, Map.class);

            // 构建查询DTO
            UserQueryDTO queryDTO = new UserQueryDTO();

            // 设置查询条件
            if (params.containsKey("keyword")) {
                queryDTO.setKeyword((String) params.get("keyword"));
            }

            if (params.containsKey("status")) {
                Type listType = new TypeToken<List<String>>(){}.getType();
                List<String> statusList = gson.fromJson(gson.toJson(params.get("status")), listType);
                queryDTO.setStatusList(statusList);
            }

            if (params.containsKey("role")) {
                Type listType = new TypeToken<List<String>>(){}.getType();
                List<String> roleList = gson.fromJson(gson.toJson(params.get("role")), listType);
                queryDTO.setRoleList(roleList);
            }

            if (params.containsKey("startDate")) {
                String startDateStr = (String) params.get("startDate");
                queryDTO.setStartDate(dateFormat.parse(startDateStr));
            }

            if (params.containsKey("endDate")) {
                String endDateStr = (String) params.get("endDate");
                queryDTO.setEndDate(dateFormat.parse(endDateStr));
            }

            if (params.containsKey("pageNum")) {
                queryDTO.setPageNum(((Double) params.get("pageNum")).intValue());
            }

            if (params.containsKey("pageSize")) {
                queryDTO.setPageSize(((Double) params.get("pageSize")).intValue());
            }

            // 执行动态查询
            List<com.bar.beans.User> users = userService.getUsersByCondition(queryDTO);
            Long total = userService.countUsers(queryDTO);

            // 构建响应
            Map<String, Object> data = new HashMap<>();
            data.put("list", users);
            data.put("total", total);
            data.put("pageNum", queryDTO.getPageNum());
            data.put("pageSize", queryDTO.getPageSize());
            data.put("pages", (int) Math.ceil(total.doubleValue() / queryDTO.getPageSize()));

            out.write(JsonResponse.success("查询成功", data));

        } catch (Exception e) {
            e.printStackTrace();
            out.write(JsonResponse.error("查询失败：" + e.getMessage()));
        }
    }
}
