// LoginDTO.java - 登录参数DTO
package com.bar.dto;

public class LoginDTO {
    private String account;      // 用户名/邮箱/手机号
    private String password;     // 密码
    private String loginType;    // 登录类型：username/email/phone
    private String captcha;      // 验证码
    private String rememberMe;   // 记住我


    // Getters and Setters
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getLoginType() { return loginType; }
    public void setLoginType(String loginType) { this.loginType = loginType; }

    public String getCaptcha() { return captcha; }
    public void setCaptcha(String captcha) { this.captcha = captcha; }

    public String getRememberMe() { return rememberMe; }
    public void setRememberMe(String rememberMe) { this.rememberMe = rememberMe; }

}