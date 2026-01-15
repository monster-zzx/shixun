package com.bar.beans;

import java.sql.Timestamp;

public class Comment {
    private Integer id;
    private Integer postId;
    private Integer userId;
    private String content;
    private Timestamp pubtime;
    
    public Comment() {
    }
    
    public Comment(Integer postId, Integer userId, String content) {
        this.postId = postId;
        this.userId = userId;
        this.content = content;
        this.pubtime = new Timestamp(System.currentTimeMillis());
    }
    
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getPostId() {
        return postId;
    }
    
    public void setPostId(Integer postId) {
        this.postId = postId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Timestamp getPubtime() {
        return pubtime;
    }
    
    public void setPubtime(Timestamp pubtime) {
        this.pubtime = pubtime;
    }
}