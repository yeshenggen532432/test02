package com.qweib.cloud.repository.ws;


import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class BscTopicWebDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Integer addOrUpdaTp(BscTopic topic, Map<String, Object> params, String datasource) {
        int result = 0;
        try {
            if (null == topic.getTopicId()) {
                result = this.daoTemplate.addByObject(datasource + ".bsc_topic", topic);
            } else {
                result = this.daoTemplate.updateByObject(datasource + ".bsc_topic", topic, params, "topic_id");
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return result;
    }

    //自增长
    public int getIdentity() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param tpId
     * @param database
     * @param pageNo
     * @param pageSize
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 获取主题列表
     */
    public Page queryTopicPage(Integer tpId, Integer pageNo,
                               Integer pageSize, String datasource) {
        StringBuffer topicsql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.topic_id,t.topic_title,t.topi_content,t.topic_time,t.url,t.tp_type from " + datasource + ".bsc_topic t left join ")
                .append(datasource + ".sys_mem m on t.member_id=m.member_id where ")
                .append(" t.tp_id=");
        try {
            topicsql.append(tpId).append(" order by topic_time desc ");
            return this.daoTemplate.queryForPageByMySql(topicsql.toString(), pageNo, pageSize, BscTopicFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 查询主题图片
     */
    public List<BscTopicPic> queryTopicPic(Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer("select pic_mini,pic from " + datasource + ".bsc_topic_pic");
        sql.append(" where topic_id=").append(topicId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscTopicPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-3
     * @see 查询主题评论
     */
    public List<BscTopicComment> queryCommentList(Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_nm,m.member_id,tm.comment_id,tm.content from " + datasource + ".bsc_topic_comment tm ");
        sql.append(" left join " + datasource + ".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where topic_id=").append(topicId).append(" and belong_id='0' ");
        try {
            return daoTemplate.queryForLists(sql.toString(), BscTopicComment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 查询回复
     */
    public List<BscTopicComment> queryRcList(Integer commentId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,tm.content,tm.belong_id,tm.rc_nm,tm.comment_id from " + datasource + ".bsc_topic_comment tm ");
        sql.append(" left join " + datasource + ".sys_mem m on tm.member_id=m.member_id ");
        sql.append(" where belong_id=").append(commentId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscTopicComment.class);
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
    public List<BscTopicPraise> queryPraiseList(Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_head,m.member_nm from " + datasource + ".bsc_topic_praise tp ");
        sql.append(" left join " + datasource + ".sys_mem m on tp.member_id=m.member_id ");
        sql.append(" where topic_id=").append(topicId);
        try {
            return daoTemplate.queryForLists(sql.toString(), BscTopicPraise.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    /**
     * @param topicComment
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-5
     * @see 添加主题评论
     */
    public int addTopicComment(BscTopicComment topicComment, String datasource) {
        try {
            /*****用于更改id生成方式 by guojr******/
            return this.daoTemplate.addByObject(datasource + ".bsc_topic_comment", topicComment);
            //return daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-5
     * @see 查询主题发布人信息
     */
    public SysMemDTO findMemberByTopic(Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer(" select m.member_id,m.member_mobile from " + datasource + ".bsc_topic t left join ");
        sql.append(datasource + ".sys_mem m on t.member_id=m.member_id where t.topic_id=").append(topicId);
        try {
            return daoTemplate.queryForObj(sql.toString(), SysMemDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //添加主题赞
    public void addTopicPraise(BscTopicPraise topicPraise, String datasource) {
        try {
            this.daoTemplate.addByObject(datasource + ".bsc_topic_praise", topicPraise);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 查询赞
     */
    public long queryPraise(Integer memId, Integer topicId, String datasource) {
        StringBuffer sql = new StringBuffer("select count(1) from " + datasource + ".bsc_topic_praise where member_id=");
        sql.append(memId).append(" and topic_id=").append(topicId);
        try {
            return this.daoTemplate.queryForObject(sql.toString(), Long.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param memId
     * @param topicId
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 删除赞
     */
    public void deletePraise(Integer memId, Integer topicId, String datasource) {
        String sql = "delete from " + datasource + ".bsc_topic_praise where member_id=" + memId + " and topic_id=" + topicId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param string
     * @param database
     * @创建：作者:YYP 创建时间：2015-2-7
     * @see 修改主题赞数
     */
    public void updatePraiseNum(Integer topicId, String string, String datasource) {
        StringBuffer sql = new StringBuffer("update " + datasource + ".bsc_topic ");
        if ("-".equals(string)) {
            sql.append(" set praise_num=praise_num-1 ");
        } else if ("+".equals(string)) {
            sql.append(" set praise_num=praise_num+1 ");
        }
        sql.append(" where topic_id=").append(topicId);
        try {
            this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteComment(Integer commentId, String datasource) {
        String sql = "delete from " + datasource + ".bsc_topic_comment where comment_id=" + commentId + " or belong_id=" + commentId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void updateTopicNum(Integer topicId, String string, String datasource) {
        StringBuffer sql = new StringBuffer("update " + datasource + ".bsc_topic ");
        if ("-".equals(string)) {
            sql.append(" set topic_num=topic_num-1 ");
        } else if ("+".equals(string)) {
            sql.append(" set topic_num=topic_num+1 ");
        }
        sql.append(" where topic_id=").append(topicId);
        try {
            this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public BscTopicComment queryCommentById(Integer commentId, String datasource) {
        StringBuffer sql = new StringBuffer("select member_id,comment_id from " + datasource + ".bsc_topic_comment ");
        sql.append(" where comment_id=").append(commentId);
        try {
            return this.daoTemplate.queryForObj(sql.toString(), BscTopicComment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据会员ID查询(发表时间、点赞数、评论数、标题、内容、图片)
     */
    public Page page(Integer memberId, Integer pageNo, Integer pageSize, String datasource) {
        StringBuffer sql = new StringBuffer("select b.topic_id, b.praise_num,b.topic_num,b.topic_time,b.topic_title,b.topi_content,b.url,b.tp_type from " + datasource + ".bsc_topic b ");
        sql.append(" where b.member_id= '").append(memberId).append("'");
        sql.append(" order by b.topic_time desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscTopic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 查询话题评论
     */
    public List<BscTopicComment> queryCommentByTopicId(Integer topicId,
                                                       String database) {
        String sql = "select * from " + database + ".bsc_topic_comment where topic_id=" + topicId;
        try {
            return daoTemplate.queryForLists(sql, BscTopicComment.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param database
     * @return
     * @创建：作者:YYP 创建时间：2015-3-2
     * @see 查询赞
     */
    public List<BscTopicPraise> queryPraise(Integer topicId, String database) {
        String sql = "select * from " + database + ".bsc_topic_praise where topic_id=" + topicId;
        try {
            return daoTemplate.queryForLists(sql, BscTopicPraise.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Integer addPic(BscTopicPic bscTopicPic, String datasource) {
        try {
            return this.daoTemplate.addByObject(datasource + ".bsc_topic_pic", bscTopicPic);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public BscTopicFactoryDTO queryTopicById(Integer topicId, Integer memId, String datasource) {
        String info = datasource + ".bsc_topic a left join " + datasource + ".bsc_empgroup_member b on a.tp_id=b.group_id where a.topic_id=" + topicId + " and b.member_id=" + memId;
        StringBuffer topicsql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.topic_id,t.topic_title,t.topi_content,t.topic_time,t.url,t.tp_type,t.tp_id as groupId,e.group_nm, ");
        topicsql.append(" (case when (select count(1) from " + info + " )>0 then (select b.role from " + info + " ) else null end) role ")
                .append(" from " + datasource + ".bsc_topic t left join " + datasource + ".sys_mem m on t.member_id=m.member_id ")
                .append(" left join " + datasource + ".bsc_empgroup e on t.tp_id=e.group_id ")
//		.append(" left join bsc_empgroup_member em on t.tp_id=em.group_id ")
//		.append( " ")
                .append(" where t.topic_id=");
        topicsql.append(topicId);
        try {
            return this.daoTemplate.queryForObj(topicsql.toString(), BscTopicFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @return
     * @创建：作者:YYP 创建时间：2015-5-11
     * @see 根据id查询话题信息
     */
    public BscTopic queryTopicById2(Integer topicId, String datasource) {
        String sql = "select * from " + datasource + ".bsc_topic t where topic_id=" + topicId;
        try {
            return this.daoTemplate.queryForObj(sql, BscTopic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @创建：作者:YYP 创建时间：2015-5-15
     * @see 删除帖子
     */
    public void deleteTopic(Integer topicId, String datasource) {
        String sql = "delete from " + datasource + ".bsc_topic where topic_id=" + topicId;
        try {
            daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @param topicId
     * @param memId
     * @param datasource
     * @return
     * @创建：作者:YYP 创建时间：2015-5-22
     * @see 根据话题id查询圈成员信息
     */
    public BscEmpGroupMember queryEmpMember(Integer topicId, Integer memId,
                                            String datasource) {
        StringBuffer sql = new StringBuffer("select * from " + datasource + ".bsc_topic t left join ");
        sql.append(datasource + ".bsc_empgroup_member em on t.tp_id=em.group_id ");
        sql.append(" where t.topic_id=" + topicId).append(" and em.member_id=" + memId);
        try {
            return daoTemplate.queryForObj(sql.toString(), BscEmpGroupMember.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //创建公司修改帖子默认信息
    public void updateTopicMess(Integer mId, String nowTime, String datasource) {
        String sql = "update " + datasource + ".bsc_topic set member_id=" + mId + ",topic_time='" + nowTime + "' ";
        daoTemplate.update(sql);
    }
}
