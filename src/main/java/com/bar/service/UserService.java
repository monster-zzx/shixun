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
        // 加密密码
        user.setPassword(BCryptUtil.hashPassword(user.getPassword()));
        user.setStatus("active");
        user.setRole("user");

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);

            // 检查用户名是否已存在
            if (mapper.findByUsername(user.getUsername()) != null) {
                return false;
            }

            // 检查邮箱是否已存在
            if (user.getEmail() != null && mapper.findByEmail(user.getEmail()) != null) {
                return false;
            }

            int result = mapper.insertUser(user);
            sqlSession.commit();
            return result > 0;
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
