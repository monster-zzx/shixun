package com.bar.mapper;

import com.bar.beans.Post;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface PostMapper {
    Boolean insertPost(Post post);

    List<Post> selectByBarId(@Param("barId") Integer barId);

    List<Post> selectByUserId(@Param("userId") Integer userId);

    Post selectById(@Param("id") Integer id);

    Boolean deletePostById(@Param("id") Integer id);

    Boolean updatePost(Post post);

    List<Post> selectAll();

    /** 获取最新的 ACTIVE 帖子，携带所属吧名称 */
    java.util.List<java.util.Map<String,Object>> selectLatestActive(@Param("limit") Integer limit);

    /** 搜索 ACTIVE 帖子（标题/内容匹配），携带所属吧名称 */
    java.util.List<java.util.Map<String,Object>> searchActivePosts(@Param("keyword") String keyword, @Param("limit") Integer limit);
}
