package com.bar.beans;
public class User implements java.io.Serializable {
    private String username;
    private String id;
    private String password;
    private String gender;
    private String role;
    private String resume;

    public User() {
    }
    public User(String username, String password, String gender, String role,String resume) {
        this.username = username;
        this.password = password;
        this.gender = gender;
        this.role = role;
        this.resume = resume;
    }

    public String getId(){
        return this.id;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", gender='" + gender+ '\'' +
                ", resume='" + resume + '\''+
                ", role='" + role + '\''+
                '}';
    }

}

