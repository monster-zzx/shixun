package com.bar.service;

import com.bar.beans.Bar;
import com.bar.mapper.BarMapper;
import com.bar.mapper.TagMapper;
import com.bar.util.MybatisUtil;
import org.apache.ibatis.session.SqlSession;

import java.sql.Timestamp;
import java.util.List;

public class BarService {
    public static void main(String[] args) throws Exception {
//        Bar b =createBar("hhhho","dff",1);
//        System.out.println(b);
    }
    /**
     * 创建贴吧，返回创建后的 Bar 对象（包含生成的 ID）；失败返回 null。
     */
    public Bar createBar(String name, String description, Integer ownerUserId, List<Integer> tagIds) throws Exception {
        // 参数基本校验
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("贴吧名称不能为空");
        }
        // 统一去除空格
        name = name.trim();

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);

            // 名称唯一性校验
            Bar exist = mapper.findByName(name);
            if (exist != null) {
                throw new IllegalStateException("贴吧名称已存在");
            }

            // （可选）每个用户最多创建 5 个贴吧
            Integer count = mapper.countByOwnerId(ownerUserId);
            if (count != null && count >= 5) {
                throw new IllegalStateException("您已达到创建贴吧数量上限");
            }

            // 构建实体
            Bar bar = new Bar();
            bar.setName(name);
            bar.setDescription(description);
            bar.setIconUrl(null); // 暂未实现上传
            bar.setOwnerUserId(ownerUserId);
            bar.setStatus("PENDING");
            Timestamp now = new Timestamp(System.currentTimeMillis());
            bar.setPubtime(now);
            bar.setUpdatedAt(now);

            // 插入
            boolean ok = mapper.insertBar(bar);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("创建贴吧失败");
            }

            // 处理标签绑定
            if (tagIds != null && !tagIds.isEmpty()) {
                TagMapper tagMapper = sqlSession.getMapper(TagMapper.class);
                for (Integer tagId : tagIds) {
                    if (tagId == null) continue;
                    tagMapper.addTagToBar(bar.getId(), tagId);
                }
            }
            sqlSession.commit();
            return bar;
        } catch (Exception e) {
            // 向上抛出由 Servlet 统一处理
            throw e;
        }
    }

    /* 以下旧方法保留 */
    public void testBar() {}

    public static List<Bar> selectById(Integer id){
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.selectById(id);
        }
    }

    public static boolean insertBar(Bar bar){
        if (bar.getPubtime() == null) {
            bar.setPubtime(new Timestamp(System.currentTimeMillis()));
        }
        try (SqlSession sqlSession = MybatisUtil.getSqlSession(true)) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.insertBar(bar);
        }
    }

    public static boolean deletBarById(Integer id){
        try (SqlSession sqlSession = MybatisUtil.getSqlSession(true)) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.deleteBarById(id);
        }
    }

    /**
     * 查询待审核的贴吧列表
     */
    public List<Bar> getPendingBars() {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.findByStatus("PENDING");
        }
    }

    /**
     * 审核贴吧（通过或拒绝）
     * @param barId 贴吧ID
     * @param status 新状态：ACTIVE（通过）或 REJECTED（拒绝）
     */
    public boolean auditBar(Integer barId, String status) throws Exception {
        if (!"ACTIVE".equals(status) && !"REJECTED".equals(status)) {
            throw new IllegalArgumentException("无效的状态值，只能是 ACTIVE 或 REJECTED");
        }

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            
            // 先检查贴吧是否存在
            List<Bar> bars = mapper.selectById(barId);
            if (bars == null || bars.isEmpty()) {
                throw new IllegalStateException("贴吧不存在");
            }

            // 更新状态
            boolean ok = mapper.updateStatus(barId, status);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("更新状态失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 查询所有贴吧
     */
    public List<Bar> getAllBars() {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.testBar();
        }
    }

    /**
     * 查询所有已激活的贴吧（用于发帖选择）
     */
    public List<Bar> getActiveBars() {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            return mapper.findByStatus("ACTIVE");
        }
    }

    /**
     * 根据ID查询贴吧详情
     */
    public Bar getBarById(Integer id) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            List<Bar> bars = mapper.selectById(id);
            return (bars != null && !bars.isEmpty()) ? bars.get(0) : null;
        }
    }

    /**
     * 更新贴吧信息
     */
    public boolean updateBar(Integer id, String name, String description, String status) throws Exception {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("贴吧名称不能为空");
        }
        name = name.trim();

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            
            // 检查贴吧是否存在
            List<Bar> bars = mapper.selectById(id);
            if (bars == null || bars.isEmpty()) {
                throw new IllegalStateException("贴吧不存在");
            }

            // 检查名称是否与其他贴吧重复（排除自己）
            Bar exist = mapper.findByName(name);
            if (exist != null && !exist.getId().equals(id)) {
                throw new IllegalStateException("贴吧名称已被使用");
            }

            // 构建更新对象
            Bar bar = new Bar();
            bar.setId(id);
            bar.setName(name);
            bar.setDescription(description);
            bar.setStatus(status);
            bar.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

            // 执行更新
            boolean ok = mapper.updateBar(bar);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("更新失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 删除贴吧
     */
    public boolean deleteBar(Integer id) throws Exception {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            
            // 检查贴吧是否存在
            List<Bar> bars = mapper.selectById(id);
            if (bars == null || bars.isEmpty()) {
                throw new IllegalStateException("贴吧不存在");
            }

            // 执行删除
            boolean ok = mapper.deleteBarById(id);
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("删除失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 修改贴吧状态
     */
    public boolean changeStatus(Integer id, String status) throws Exception {
        if (status == null || (!"PENDING".equals(status) && !"ACTIVE".equals(status) && !"REJECTED".equals(status))) {
            throw new IllegalArgumentException("无效的状态值");
        }

        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            // TagMapper tagMapper = sqlSession.getMapper(TagMapper.class);
            
            // 检查贴吧是否存在
            List<Bar> bars = mapper.selectById(id);
            if (bars == null || bars.isEmpty()) {
                throw new IllegalStateException("贴吧不存在");
            }

            // 更新状态
            boolean ok = mapper.updateStatus(id, status);
            // boolean ok_1 = tagMapper.addTagToBar()
            if (!ok) {
                sqlSession.rollback();
                throw new RuntimeException("更新状态失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 添加贴吧成员（收藏贴吧）
     */
    public boolean insertMember(Integer bar_id, Integer user_id) throws Exception {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            //检查是否已存在
            if(mapper.isMember(bar_id, user_id) != null) {
                // 已存在，直接返回成功（幂等性）
                return true;
            }
            //添加操作
            Boolean result = mapper.joinBar(bar_id, user_id, "MEMBER");
            if(result == null || !result) {
                sqlSession.rollback();
                throw new IllegalStateException("添加用户失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 移除贴吧成员（取消收藏）
     */
    public boolean removeMember(Integer bar_id, Integer user_id) throws Exception {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            Boolean result = mapper.leaveBar(bar_id, user_id);
            if(result == null || !result) {
                sqlSession.rollback();
                throw new IllegalStateException("移除用户失败");
            }
            sqlSession.commit();
            return true;
        }
    }

    /**
     * 检查用户是否是某贴吧的成员
     */
    public boolean checkIsMember(Integer bar_id, Integer user_id) {
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            BarMapper mapper = sqlSession.getMapper(BarMapper.class);
            Integer result = mapper.isMember(bar_id, user_id);
            return result != null;
        } catch (Exception e) {
            return false;
        }
    }


}
