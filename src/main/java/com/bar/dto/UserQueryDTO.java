// UserQueryDTO.java - 用户查询DTO
package com.bar.dto;

import java.util.Date;
import java.util.List;

public class UserQueryDTO {
    private String keyword;
    private List<String> statusList;
    private List<String> roleList;
    private Date startDate;
    private Date endDate;
    private Integer pageNum = 1;
    private Integer pageSize = 10;

    // Getters and Setters
    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public List<String> getStatusList() { return statusList; }
    public void setStatusList(List<String> statusList) { this.statusList = statusList; }

    public List<String> getRoleList() { return roleList; }
    public void setRoleList(List<String> roleList) { this.roleList = roleList; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public Integer getPageNum() { return pageNum; }
    public void setPageNum(Integer pageNum) { this.pageNum = pageNum; }

    public Integer getPageSize() { return pageSize; }
    public void setPageSize(Integer pageSize) { this.pageSize = pageSize; }

    // 计算偏移量
    public Integer getOffset() {
        return (pageNum - 1) * pageSize;
    }
}