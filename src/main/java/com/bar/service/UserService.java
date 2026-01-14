package com.bar.service;
import com.bar.beans.User;
import com.bar.dto.LoginDTO;
import com.bar.dto.UserQueryDTO;
import com.bar.mapper.UserMapper;
import com.bar.util.MybatisUtil;
import com.bar.util.BCryptUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserService {

    /**
     * 用户登录（使用动态SQL）
     */
    public User login(LoginDTO loginDTO) {
        // 首先查询用户（不验证密码）
        User user = findUserByAccount(loginDTO.getAccount(), loginDTO.getLoginType());

        if (user == null) {
            return null;
        }

        // 验证密码（使用BCrypt）
        if (!BCryptUtil.checkPassword(loginDTO.getPassword(), user.getPassword())) {
            return null;
        }

        // 检查账户状态
        if (!"active".equals(user.getStatus())) {
            return null;
        }

        // 更新登录信息
        updateLoginInfo(user.getId());

        return user;
    }

    /**
     * 根据账号查找用户（动态判断账号类型）
     */
    private User findUserByAccount(String account, String loginType) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);

            // 动态构建查询条件
            Map<String, Object> params = new HashMap<>();

            // 自动判断账号类型
            if (loginType == null || "auto".equals(loginType)) {
                if (account.contains("@")) {
                    params.put("email", account);
                } else if (account.matches("\\d{11}")) {
                    params.put("phone", account);
                } else {
                    params.put("username", account);
                }
            } else {
                switch (loginType) {
                    case "email":
                        params.put("email", account);
                        break;
                    case "phone":
                        params.put("phone", account);
                        break;
                    default:
                        params.put("username", account);
                        break;
                }
            }

            // 执行动态查询
            List<User> users = mapper.findUsersByMap(params);
            return users.isEmpty() ? null : users.get(0);
        }
    }

    /**
     * 更新登录信息
     */
    private void updateLoginInfo(Integer userId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);

            // 获取当前登录次数
            Map<String, Object> params = new HashMap<>();
            params.put("id", userId);
            List<User> users = mapper.findUsersByMap(params);

            if (!users.isEmpty()) {
                User user = users.get(0);
                Integer loginCount = user.getLoginCount() != null ? user.getLoginCount() : 0;

                // 更新登录信息
                mapper.updateLoginInfo(userId, loginCount, new Date());
                sqlSession.commit();
            }
        }
    }

    /**
     * 注册用户
     */
    public boolean register(User user) {
        System.out.println("UserService.register() 开始");
        System.out.println("用户信息: " + user);

        // 加密密码
        String hashedPassword = BCryptUtil.hashPassword(user.getPassword());
        System.out.println("密码加密完成，原密码长度: " + user.getPassword().length() +
                ", 加密后长度: " + hashedPassword.length());

        user.setPassword(hashedPassword);
        user.setStatus("active");
        user.setRole("user");
        user.setLoginCount(0);
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);

            System.out.println("开始执行 insertUser");

            int result = mapper.insertUser(user);

            System.out.println("insertUser 执行结果: " + result);

            if (result > 0) {
                sqlSession.commit();
                System.out.println("事务提交成功");
                return true;
            } else {
                sqlSession.rollback();
                System.out.println("插入失败，执行回滚");
                return false;
            }

        } catch (Exception e) {
            System.out.println("UserService.register() 出现异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 动态条件查询用户列表
     */
    public List<User> getUsersByCondition(UserQueryDTO queryDTO) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findUsersByCondition(queryDTO);
        }
    }

    /**
     * 获取用户总数（带条件）
     */
    public Long countUsers(UserQueryDTO queryDTO) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.countUsersByCondition(queryDTO);
        }
    }

    /**
     * 复杂动态查询示例
     */
    public List<User> searchUsers(Map<String, Object> searchParams) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findUsersByMap(searchParams);
        }
    }


}
