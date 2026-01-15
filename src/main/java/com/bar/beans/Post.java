package com.bar.beans;

import java.sql.Timestamp;

public class Post {
    private Integer id;
    private String title;
    private String content;
    private Integer userId;
    private Integer barId;
    private String barname;
    private Integer viewCount;
    private Integer likeCount;
    private Integer commentCount;
    private String status;
    private Timestamp pubtime;
    private Timestamp updatedAt;

    public Post() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getBarId() {
        return barId;
    }

    public void setBarId(Integer barId) {
        this.barId = barId;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getPubtime() {
        return pubtime;
    }

    public void setPubtime(Timestamp pubtime) {
        this.pubtime = pubtime;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    public  String getBarname() {
        return barname;
    }
    public void setBarname(String barname) {
        this.barname = barname;
    }
}
