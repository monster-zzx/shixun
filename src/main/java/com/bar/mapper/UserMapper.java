package com.bar.mapper;
import com.bar.beans.User;
import com.bar.dto.LoginDTO;
import com.bar.dto.UserQueryDTO;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;
import java.util.Date;

public interface UserMapper {

    // 1. 动态SQL登录查询（支持用户名/邮箱/手机号登录）
    User findByLoginInfo(LoginDTO loginDTO);

    // 2. 根据用户名查询
    User findByUsername(String username);

    // 3. 根据邮箱查询
    User findByEmail(String email);

    // 4. 根据手机号查询
    User findByPhone(String phone);

    // 5. 动态条件查询用户列表
    List<User> findUsersByCondition(UserQueryDTO queryDTO);

    // 6. 动态条件统计用户数量
    Long countUsersByCondition(UserQueryDTO queryDTO);

    // 7. 更新登录信息
    int updateLoginInfo(@Param("userId") Integer userId,
                        @Param("loginCount") Integer loginCount,
                        @Param("lastLoginTime") Date lastLoginTime);

    // 8. 批量更新用户状态
    int batchUpdateStatus(@Param("ids") List<Integer> ids,
                          @Param("status") String status);

    // 9. 使用Map参数的动态查询
    List<User> findUsersByMap(Map<String, Object> params);

    // 10. 插入用户
    int insertUser(User user);

    // 11. 更新用户
    int updateUser(User user);

    // 12. 删除用户（逻辑删除）
    int deleteUser(Integer id);

    User selectUser(int i);
}

    // ================ 新增的用户管理方法 ================

    // 13. 分页查询用户（支持搜索、状态过滤、角色过滤）
    List<User> findUsersWithPaging(Map<String, Object> params);

    // 14. 统计符合条件的用户数量（用于分页）
    Long countUsersWithConditions(Map<String, Object> params);

    // 15. 更新用户状态（封禁/解封）
    int updateUserStatus(@Param("userId") int userId, @Param("status") String status);

    // 16. 记录封禁日志
    void insertBanLog(@Param("userId") int userId,
                      @Param("adminId") int adminId,
                      @Param("reason") String reason,
                      @Param("banTime") Date banTime);

    // 17. 记录解封日志
    void insertUnbanLog(@Param("userId") int userId,
                        @Param("adminId") int adminId,
                        @Param("unbanTime") Date unbanTime);



    // 19. 根据用户ID获取用户信息
    User getUserById(@Param("userId") int userId);

    // 20. 批量删除用户（逻辑删除）
    int batchDeleteUsers(@Param("ids") List<Integer> ids);

    // 21. 获取所有用户（不分页）
    List<User> findAllUsers();

    // 22. 更新用户角色
    int updateUserRole(@Param("userId") int userId, @Param("role") String role);

    // 23. 检查用户名是否存在（除当前用户外）
    int checkUsernameExists(@Param("username") String username,
                            @Param("excludeUserId") Integer excludeUserId);

    // 24. 检查邮箱是否存在（除当前用户外）
    int checkEmailExists(@Param("email") String email,
                         @Param("excludeUserId") Integer excludeUserId);

    // 25. 检查手机号是否存在（除当前用户外）
    int checkPhoneExists(@Param("phone") String phone,
                         @Param("excludeUserId") Integer excludeUserId);

    // 26. 根据角色获取用户列表
    List<User> findUsersByRole(@Param("role") String role);

    // 27. 根据状态获取用户列表
    List<User> findUsersByStatus(@Param("status") String status);

    // 28. 重置用户密码
    int resetPassword(@Param("userId") int userId,
                      @Param("newPassword") String newPassword,
                      @Param("updateTime") Date updateTime);



    // 30. 搜索用户（全文搜索）
    List<User> searchUsers(@Param("keyword") String keyword);
}