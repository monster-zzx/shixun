package com.bar.mapper;
import com.bar.beans.User;
import com.bar.dto.LoginDTO;
import com.bar.dto.UserQueryDTO;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

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
                        @Param("lastLoginTime") java.util.Date lastLoginTime);

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

