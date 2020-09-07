package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@Repository
public class BscKnowledgeDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * @param groupId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 根据员工圈id查询分类
     */
    public Page querySortByGroupId(Integer groupId, String searchContent, String database, Integer pageNo, Integer pageSize) {
        StringBuffer sql = new StringBuffer("select s.sort_id,s.sort_nm from ").append(database);
        sql.append(".bsc_sort s where s.group_id=").append(groupId);
        if (null != searchContent) {
            sql.append(" and s.sort_nm like '%").append(searchContent).append("%' ");
        }
        sql.append(" order by s.create_time desc ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscSort.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param knowledge
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 添加知识库
     */
    public Integer addKnowledge(BscKnowledge knowledge, String database) {
        /*****用于更改id生成方式 by guojr******/
        return daoTemplate.addByObject(database + ".bsc_knowledge", knowledge);
        //return daoTemplate.getAutoIdForIntByMySql();
    }

    public int getIdentity() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param pics
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 批量添加图片
     */
    public int[] addKpic(final List<BscKnowledgePic> pics, String database) {
        String sql = " insert into " + database + ".bsc_knowledge_pic(knowledge_id,pic_mini,pic) values(?,?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public void setValues(PreparedStatement pre, int num) throws SQLException {
                    pre.setInt(1, pics.get(num).getKnowledgeId());
                    pre.setString(2, pics.get(num).getPicMini());
                    pre.setString(3, pics.get(num).getPic());
                }

                public int getBatchSize() {
                    return pics.size();
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    /**
     * @param comments
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 批量添加评论
     */
    public int[] addKcomment(final List<BscKnowledgeComment> comments, String database) {
        String sql = "insert into " + database + ".bsc_knowledge_comment(knowledge_id,member_id,comment_time,content,belong_id,rc_id,rc_nm) values(?,?,?,?,?,?,?) ";
        BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
            public void setValues(PreparedStatement pre, int num) throws SQLException {
                pre.setInt(1, comments.get(num).getKnowledgeId());
                pre.setInt(2, comments.get(num).getMemberId());
                pre.setString(3, comments.get(num).getCommentTime());
                pre.setString(4, comments.get(num).getContent());
                pre.setInt(5, comments.get(num).getBelongId());
                if (null != comments.get(num).getRcId()) {
                    pre.setInt(6, comments.get(num).getRcId());
                } else {
                    pre.setInt(6, 0);
                }
                if (null != comments.get(num).getContent()) {
                    pre.setString(7, comments.get(num).getContent());
                } else {
                    pre.setString(7, null);
                }
            }

            public int getBatchSize() {
                return comments.size();
            }
        };
        return daoTemplate.batchUpdate(sql, setter);
    }

    /**
     * @param praises
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 批量添加赞
     */
    public int[] addKpraise(final List<BscKnowledgePraise> praises, String database) {
        String sql = "insert into " + database + ".bsc_knowledge_praise(knowledge_id,member_id) values(?,?) ";
        BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
            public void setValues(PreparedStatement pre, int num) throws SQLException {
                pre.setInt(1, praises.get(num).getKnowledgeId());
                pre.setInt(2, praises.get(num).getMemberId());
            }

            public int getBatchSize() {
                return praises.size();
            }
        };
        return daoTemplate.batchUpdate(sql, setter);
    }

    /**
     * @param groupId
     * @param sortId
     * @param database
     * @param pageNo
     * @param pageSize
     * @return
     * @创建：作者:YYP 创建时间：2015-3-3
     * @see 查询知识库列表
     */
    public Page querykpage(Integer sortId, String searchContent, Integer groupId, String database, Integer pageNo, Integer pageSize) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.knowledge_id,t.topic_title,t.topi_content,t.topic_time,t.tp from ");
        sql.append(database).append(".bsc_knowledge t left join ").append(database).append(".sys_mem m on t.member_id=m.member_id ");
        if (null == sortId) {
            sql.append(" left join " + database).append(".bsc_sort s on t.sort_id=s.sort_id where s.group_id=" + groupId);
        }
        if (null == groupId) {
            sql.append(" where t.sort_id=").append(sortId);

        }
        if (!StrUtil.isNull(searchContent)) {
            sql.append(" and t.topic_title like '%" + searchContent + "%' ");
        }
        sql.append(" order by topic_time desc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscKnowledgeFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<BscKnowledgePic> querykPic(Integer knowledgeId, String database) {
        StringBuffer sql = new StringBuffer("select pic_mini,pic from ").append(database).append(".bsc_knowledge_pic");
        sql.append(" where knowledge_id=").append(knowledgeId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscKnowledgePic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<BscKnowledgeComment> queryCommentList(Integer knowledgeId,
                                                      String database) {
        StringBuffer sql = new StringBuffer("select m.member_nm,m.member_id,tm.comment_id,tm.content from ").append(database).append(".bsc_knowledge_comment tm ");
        sql.append(" left join ").append(database).append(".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where knowledge_id=").append(knowledgeId).append(" and belong_id='0' ");
        try {
            return daoTemplate.queryForLists(sql.toString(), BscKnowledgeComment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<BscKnowledgeComment> queryRcList(Integer commentId, String database) {
        StringBuffer sql = new StringBuffer("select m.member_nm,tm.content,tm.belong_id,tm.rc_nm,tm.comment_id from ").append(database).append(".bsc_Knowledge_comment tm ");
        sql.append(" left join ").append(database).append(".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where belong_id=").append(commentId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscKnowledgeComment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 查询赞
     */
    public List<BscKnowledgePraise> queryPraiseList(Integer knowledgeId, String database) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,m.member_nm from ").append(database).append(".bsc_knowledge_praise tp ");
        sql.append(" left join ").append(database).append(".sys_mem m on tp.member_id=m.member_id ");
        sql.append(" where knowledge_id=").append(knowledgeId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscKnowledgePraise.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param sort
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-3
     * @see 添加分类
     */
    public void addSort(BscSort sort, String database) {
        try {
            daoTemplate.addByObject(database + ".bsc_sort", sort);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param sortId
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-4
     * @see 删除分类
     */
    public void deleteSort(Integer sortId, String database) {
        String sql = "delete from " + database + ".bsc_sort where sort_id=" + sortId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param sortId
     * @param sortNm
     * @param database
     * @创建：作者:YYP 创建时间：2015-3-4
     * @see 修改分类
     */
    public void updateSort(Integer sortId, String sortNm, String database) {
        String sql = "update " + database + ".bsc_sort set sort_nm='" + sortNm + "' where sort_id=" + sortId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Integer addOutKnowledge(BscKnowledge knowledge, String database) {
        return daoTemplate.addByObject(database + ".bsc_knowledge", knowledge);
    }

    /**
     * @param sortNm
     * @param groupId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 判断分类名是否已存在
     */
    public Integer querySortNmAppear(String sortNm, Integer groupId,
                                     String datasource) {
        String sql = "select count(1) from " + datasource + ".bsc_sort where sort_nm='" + sortNm + "' and group_id=" + groupId;
        try {
            return daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public BscSort querySortById(Integer sortId, String datasource) {
        String sql = "select * from " + datasource + ".bsc_sort where sort_id=" + sortId;
        try {
            return daoTemplate.queryForObj(sql, BscSort.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param knowledgeId
     * @param database
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 删除知识点
     */
    public void deleteKnowledge(Integer knowledgeId, String database) {
        String sql = "delete from " + database + ".bsc_knowledge where knowledge_id=" + knowledgeId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param sortId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-21
     * @see 判断该主题是否已存在于该分类中
     */
    public Integer queryIsExit(Integer topicId, Integer sortId,
                               String datasource) {
        String sql = "select count(1) from " + datasource + ".bsc_knowledge where topic_id=" + topicId + " and sort_id=" + sortId;
        try {
            return daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param knowledgeId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-22
     * @see 查询知识库详情
     */
    public BscKnowledgeFactoryDTO queryKnowledgeDetail(Integer knowledgeId,
                                                       String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.knowledge_id,t.topic_title,t.topi_content,t.topic_time,t.tp, ");
        sql.append(" (select member_nm from " + datasource + ".sys_mem where member_id=t.operate_id) as operate_nm ");
        sql.append(" from " + datasource).append(".bsc_knowledge t left join ").append(datasource).append(".sys_mem m on t.member_id=m.member_id where 1=1 ");
        sql.append(" and t.knowledge_id=").append(knowledgeId);
        sql.append(" order by topic_time desc ");
        try {
            return daoTemplate.queryForObj(sql.toString(), BscKnowledgeFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateKnowledgeMess(Integer mId, String nowTime, String datasource) {
        String sql = "update " + datasource + ".bsc_knowledge set member_id=" + mId + ",topic_time='" + nowTime + "' ";
        daoTemplate.update(sql);
    }

    public void updateSortMess(Integer mId, String nowTime, String datasource) {
        String sql = "update " + datasource + ".bsc_sort set member_id=" + mId + ",create_time='" + nowTime + "' ";
        daoTemplate.update(sql);
    }
}
