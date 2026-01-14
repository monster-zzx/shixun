// TagMapper.java
package com.bar.mapper;

import com.bar.beans.Tag;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface TagMapper {
    // 插入标签
    int insertTag(Tag tag);

    // 根据ID查询标签
    Tag selectById(Integer id);

    // 根据名称查询标签
    Tag selectByName(String name);

    // 查询所有标签
    List<Tag> selectAll();

    // 根据贴吧ID查询该贴吧的所有标签
    List<Tag> selectTagsByBarId(Integer barId);

    // 根据标签ID查询使用该标签的所有贴吧ID
    List<Integer> selectBarIdsByTagId(Integer tagId);

    // 为贴吧添加标签
    int addTagToBar(@Param("barId") Integer barId, @Param("tagId") Integer tagId);

    // 移除贴吧的某个标签
    int removeTagFromBar(@Param("barId") Integer barId, @Param("tagId") Integer tagId);

    // 移除贴吧的所有标签
    int removeAllTagsFromBar(Integer barId);

    // 更新标签信息
    int updateTag(Tag tag);

    // 删除标签
    int deleteTag(Integer id);

    // 统计标签使用次数
    int countBarsByTagId(Integer tagId);
}