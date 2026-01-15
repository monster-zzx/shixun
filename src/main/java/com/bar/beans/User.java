package com.bar.beans;
import java.util.Date;

public class User implements java.io.Serializable {
    private String username;
    private Integer id;
    private String password;
    private String gender;
    private String phone;
    private String email;
    private String role;
    private String resume;
    private String status;
    private Integer loginCount;
    private Date lastLoginTime;
    private Date createTime;
    private Date updateTime;

    public User() {
    }
    public User(String username, String password, String gender, String phone, String email ,String role, String resume) {
        this.username = username;
        this.password = password;
        this.gender = gender;
        this.phone = phone;
        this.email = email;
        this.role = role;
        this.resume = resume;
    }

    public Integer getId(){
        return this.id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }


    public String getResume() {
        return resume;
    }
    public void setResume(String resume) {
        this.resume = resume;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getLoginCount() { return loginCount; }
    public void setLoginCount(Integer loginCount) { this.loginCount = loginCount; }

    public Date getLastLoginTime() { return lastLoginTime; }
    public void setLastLoginTime(Date lastLoginTime) { this.lastLoginTime = lastLoginTime; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }

    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", gender='" + gender+ '\'' +
                ", phone='" + phone+ '\'' +
                ", email='" + email+ '\'' +
                ", resume='" + resume + '\''+
                ", role='" + role + '\''+
                '}';
    }

}

