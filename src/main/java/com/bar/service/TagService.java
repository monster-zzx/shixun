// TagService.java
package com.bar.service;

import com.bar.beans.Tag;
import com.bar.mapper.TagMapper;
import com.bar.util.MybatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class TagService {

    /**
     * 为贴吧添加标签（如果标签不存在则创建）
     */
    // 根据标签名称列表添加（可以自动创建不存在的标签）
    /**
     * 根据标签名称列表添加（如果标签不存在则新建）
     */
    public boolean addTagsToBar(Integer barId, List<String> tagNames) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);

            for (String tagName : tagNames) {
                if (tagName == null || tagName.trim().isEmpty()) {
                    continue;
                }
                tagName = tagName.trim();

                // 查询标签是否存在
                Tag tag = mapper.selectByName(tagName);
                if (tag == null) {
                    // 创建新标签
                    tag = new Tag();
                    tag.setName(tagName);
                    tag.setColor("#6c757d"); // 默认颜色
                    mapper.insertTag(tag);
                }

                // 关联贴吧和标签
                mapper.addTagToBar(barId, tag.getId());
            }

            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 根据标签ID列表直接绑定
     */
    public boolean addTagIdsToBar(Integer barId, List<Integer> tagIds) {
        if (tagIds == null || tagIds.isEmpty()) return true;
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);
            for (Integer tagId : tagIds) {
                if (tagId == null) continue;
                mapper.addTagToBar(barId, tagId);
            }
            sqlSession.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取贴吧的所有标签
     */
    public List<Tag> getTagsByBarId(Integer barId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);
            return mapper.selectTagsByBarId(barId);
        }
    }

    /**
     * 移除贴吧的某个标签
     */
    public boolean removeTagFromBar(Integer barId, Integer tagId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);
            int result = mapper.removeTagFromBar(barId, tagId);
            sqlSession.commit();
            return result > 0;
        }
    }

    /**
     * 移除贴吧的所有标签
     */
    public boolean removeAllTagsFromBar(Integer barId) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);
            mapper.removeAllTagsFromBar(barId);
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 获取所有标签列表
     */
    public List<Tag> getAllTags() {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            TagMapper mapper = sqlSession.getMapper(TagMapper.class);
            return mapper.selectAll();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}