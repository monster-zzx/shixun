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
}
