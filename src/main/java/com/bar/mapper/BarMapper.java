package com.bar.mapper;

import com.bar.beans.Bar;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface BarMapper {
    // 查询所有贴吧（测试用）
    List<Bar> testBar();
    
    // 根据ID查询贴吧
    List<Bar> selectById(@Param("id") Integer id);
    
    // 插入新的贴吧记录
    Boolean insertBar(Bar bar);
    
    // 根据ID删除贴吧
    Boolean deleteBarById(@Param("id") Integer id);

    // 根据名称查询贴吧（用于检查名称是否已存在）
    Bar findByName(@Param("name") String name);

    // 检查用户是否已经创建过贴吧
    Integer countByOwnerId(@Param("ownerId") Integer ownerId);
    
    // 根据状态查询贴吧列表（用于审核）
    List<Bar> findByStatus(@Param("status") String status);
    
    // 更新贴吧状态（审核通过/拒绝）
    Boolean updateStatus(@Param("id") Integer id, @Param("status") String status);
    
    // 更新贴吧信息
    Boolean updateBar(Bar bar);

    // 用户加入贴吧（成为某贴吧的成员）
    Boolean joinBar(@Param("barId") Integer barId, 
                     @Param("userId") Integer userId, 
                     @Param("role") String role);

    // 检查用户是否已经是某贴吧的成员
    Integer isMember(@Param("barId") Integer barId, @Param("userId") Integer userId);

    // 用户退出贴吧（取消收藏）
    Boolean leaveBar(@Param("barId") Integer barId, @Param("userId") Integer userId);

}