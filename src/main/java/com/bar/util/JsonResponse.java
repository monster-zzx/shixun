package com.bar.util;

import com.google.gson.JsonObject;

/**
 * JSON响应工具类
 * 用于构建统一的JSON响应格式
 */
public class JsonResponse {

    /**
     * 成功响应
     */
    public static String success() {
        return success("操作成功");
    }

    /**
     * 成功响应（带消息）
     */
    public static String success(String message) {
        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("message", message);
        return json.toString();
    }

    /**
     * 成功响应（带消息和数据）
     */
    public static String success(String message, JsonObject data) {
        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("message", message);
        json.add("data", data);
        return json.toString();
    }

    /**
     * 成功响应（带消息和数据对象）
     */
    public static String success(String message, Object data) {
        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("message", message);

        // 使用Gson将对象转换为JsonElement
        com.google.gson.Gson gson = new com.google.gson.Gson();
        json.add("data", gson.toJsonTree(data));

        return json.toString();
    }

    /**
     * 错误响应
     */
    public static String error(String message) {
        return error(message, 0);
    }

    /**
     * 错误响应（带错误码）
     */
    public static String error(String message, int errorCode) {
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("errorCode", errorCode);
        json.addProperty("message", message);
        return json.toString();
    }

    /**
     * 错误响应（带详细错误信息）
     */
    public static String error(String message, int errorCode, JsonObject details) {
        JsonObject json = new JsonObject();
        json.addProperty("success", false);
        json.addProperty("errorCode", errorCode);
        json.addProperty("message", message);
        json.add("details", details);
        return json.toString();
    }

    /**
     * 创建通用响应
     */
    public static String create(boolean success, String message, Object data) {
        JsonObject json = new JsonObject();
        json.addProperty("success", success);
        json.addProperty("message", message);

        if (data != null) {
            com.google.gson.Gson gson = new com.google.gson.Gson();
            json.add("data", gson.toJsonTree(data));
        }

        return json.toString();
    }

    /**
     * 分页数据响应
     */
    public static String pageSuccess(String message, Object data, long total,
                                     int pageNum, int pageSize) {
        JsonObject json = new JsonObject();
        json.addProperty("success", true);
        json.addProperty("message", message);

        com.google.gson.Gson gson = new com.google.gson.Gson();
        json.add("data", gson.toJsonTree(data));

        // 分页信息
        JsonObject pageInfo = new JsonObject();
        pageInfo.addProperty("total", total);
        pageInfo.addProperty("pageNum", pageNum);
        pageInfo.addProperty("pageSize", pageSize);
        pageInfo.addProperty("pages", (int) Math.ceil((double) total / pageSize));

        json.add("pageInfo", pageInfo);

        return json.toString();
    }
}