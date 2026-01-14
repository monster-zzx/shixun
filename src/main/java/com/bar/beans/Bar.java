package com.bar.beans;

import java.sql.Timestamp;
import java.util.List;

public class Bar {
    private Integer id;
    private String name;
    private String description;
    private String iconUrl;
    private Integer ownerUserId;
    private String status;
    private Timestamp pubtime; // Can be renamed to createdAt
    private Timestamp updatedAt;
    private List<Tag> tags;

    public Bar() {}

    // Getters and Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public Integer getOwnerUserId() {
        return ownerUserId;
    }

    public void setOwnerUserId(Integer ownerUserId) {
        this.ownerUserId = ownerUserId;
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

    public List<Tag> getTags() {
        return tags;
    }
    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }
}
