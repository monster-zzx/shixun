package com.bar.service;

import com.bar.beans.Comment;
import com.bar.mapper.CommentMapper;
import com.bar.util.MybatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.List;

public class CommentService {
    
    /**
     * 发表评论
     */
    public Comment createComment(Integer postId, Integer userId, String content) throws Exception {
        if (postId == null) {
            throw new IllegalArgumentException("帖子ID不能为空");
        }
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("评论内容不能为空");
        }
        
        content = content.trim();
        
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
            
            // 创建评论对象
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setContent(content);
            comment.setPubtime(new Timestamp(System.currentTimeMillis()));
            
            // 插入评论
            boolean ok = mapper.insertComment(comment);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("发表评论失败");
            }
            
            // 在同一事务中直接更新帖子的评论数，避免死锁
            // 使用原生SQL而不是调用PostService，避免嵌套事务
            Connection conn = sqlSession.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE post SET comment_count = COALESCE(comment_count, 0) + 1 WHERE id = ?")) {
                stmt.setInt(1, postId);
                stmt.executeUpdate();
            }
            
            sqlSession.commit();
            return comment;
        } catch (Exception e) {
            throw e;
        }
    }
    
    /**
     * 获取帖子的所有评论
     */
    public List<Comment> getCommentsByPostId(Integer postId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
            return mapper.selectByPostId(postId);
        }
    }
    
    /**
     * 根据ID获取评论
     */
    public Comment getCommentById(Integer id) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
            return mapper.selectById(id);
        }
    }
    
    /**
     * 删除评论
     */
    public boolean deleteComment(Integer id, Integer userId) throws Exception {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
            
            // 先获取评论信息验证权限
            Comment comment = mapper.selectById(id);
            if (comment == null) {
                throw new IllegalStateException("评论不存在");
            }
            
            // 检查是否是评论作者（这里简化处理，只允许作者删除）
            if (!comment.getUserId().equals(userId)) {
                throw new IllegalStateException("没有权限删除此评论");
            }
            
            // 执行删除
            boolean ok = mapper.deleteCommentById(id);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("删除评论失败");
            }
            
            // 在同一事务中直接更新帖子的评论数，避免死锁
            // 使用原生SQL而不是调用PostService，避免嵌套事务
            Connection conn = sqlSession.getConnection();
            try (PreparedStatement stmt = conn.prepareStatement("UPDATE post SET comment_count = GREATEST(COALESCE(comment_count, 0) - 1, 0) WHERE id = ?")) {
                stmt.setInt(1, comment.getPostId());
                stmt.executeUpdate();
            }
            
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            throw e;
        }
    }
    
    /**
     * 更新评论
     */
    public boolean updateComment(Integer id, String content, Integer userId) throws Exception {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("评论内容不能为空");
        }
        
        content = content.trim();
        
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            CommentMapper mapper = sqlSession.getMapper(CommentMapper.class);
            
            // 先获取评论信息验证权限
            Comment comment = mapper.selectById(id);
            if (comment == null) {
                throw new IllegalStateException("评论不存在");
            }
            
            // 检查是否是评论作者（这里简化处理，只允许作者编辑）
            if (!comment.getUserId().equals(userId)) {
                throw new IllegalStateException("没有权限编辑此评论");
            }
            
            // 更新评论
            comment.setContent(content);
            boolean ok = mapper.updateComment(comment);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("更新评论失败");
            }
            
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            throw e;
        }
    }
}