package com.bar.mapper;

import com.bar.beans.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CommentMapper {
    Boolean insertComment(Comment comment);
    
    List<Comment> selectByPostId(@Param("postId") Integer postId);
    
    Comment selectById(@Param("id") Integer id);
    
    Boolean deleteCommentById(@Param("id") Integer id);
    
    Boolean updateComment(Comment comment);
}