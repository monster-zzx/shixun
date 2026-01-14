package com.bar.service;

import com.bar.beans.Post;
import com.bar.mapper.PostMapper;
import com.bar.util.MybatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.sql.Timestamp;
import java.util.List;

public class PostService {

    public Post createPost(String title, String content, Integer userId, Integer barId) throws Exception {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("帖子标题不能为空");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("帖子内容不能为空");
        }
        if (userId == null) {
            throw new IllegalArgumentException("用户ID不能为空");
        }
        if (barId == null) {
            throw new IllegalArgumentException("贴吧ID不能为空");
        }

        title = title.trim();
        content = content.trim();

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);

            Post post = new Post();
            post.setTitle(title);
            post.setContent(content);
            post.setUserId(userId);
            post.setBarId(barId);
            post.setViewCount(0);
            post.setLikeCount(0);
            post.setCommentCount(0);
            post.setStatus("ACTIVE");
            Timestamp now = new Timestamp(System.currentTimeMillis());
            post.setPubtime(now);
            post.setUpdatedAt(now);

            boolean ok = mapper.insertPost(post);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("发帖失败");
            }
            sqlSession.commit();
            return post;
        } catch (Exception e) {
            throw e;
        }
    }

    public List<Post> getPostsByBarId(Integer barId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            return mapper.selectByBarId(barId);
        }
    }

    public List<Post> getPostsByUserId(Integer userId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            return mapper.selectByUserId(userId);
        }
    }

    public Post getPostById(Integer id) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            return mapper.selectById(id);
        }
    }

    public boolean deletePost(Integer id) throws Exception {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            
            Post post = mapper.selectById(id);
            if (post == null) {
                throw new IllegalStateException("帖子不存在");
            }

            boolean ok = mapper.deletePostById(id);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("删除帖子失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    public boolean updatePost(Integer id, String title, String content) throws Exception {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("帖子标题不能为空");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("帖子内容不能为空");
        }

        title = title.trim();
        content = content.trim();

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            
            Post post = mapper.selectById(id);
            if (post == null) {
                throw new IllegalStateException("帖子不存在");
            }

            post.setTitle(title);
            post.setContent(content);
            post.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

            boolean ok = mapper.updatePost(post);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("更新帖子失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    public List<Post> getAllPosts() {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            PostMapper mapper = sqlSession.getMapper(PostMapper.class);
            return mapper.selectAll();
        }
    }
}
