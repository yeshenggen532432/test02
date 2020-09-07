package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscCollect;
import com.qweib.cloud.core.domain.BscTopicFactoryDTO;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class BscCollectWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * @return
     * @说明：获取收藏列表
     * @创建者： 作者：llp  创建时间：2015-2-27
     */
    public Page queryBscCollectPage(String database, Integer pageNo, Integer pageSize, Integer mbId) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.topic_id,t.topic_title,t.topi_content,t.topic_time from ").append(database).append(".bsc_topic t left join ");
        sql.append(database).append(".sys_mem m on t.member_id=m.member_id left join ");
        sql.append(database).append(".bsc_collect c on c.topic_id=t.topic_id where 1=1");
        if (!StrUtil.isNull(mbId)) {
            sql.append(" and c.member_id=" + mbId + "");
        }
        sql.append(" order by topic_time desc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscTopicFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：获取收藏详情
     * @创建者： 作者：llp  创建时间：2015-2-27
     */
    public BscTopicFactoryDTO queryBscCollect(Integer topicId, String database) {
        StringBuffer sql = new StringBuffer("select m.member_id,m.member_nm,m.member_head,t.topic_id,t.topic_title,t.topi_content,t.topic_time from ").append(database).append(".bsc_topic t left join ");
        sql.append(database).append(".sys_mem m on t.member_id=m.member_id where 1=1");
        if (!StrUtil.isNull(topicId)) {
            sql.append(" and t.topic_id=" + topicId + "");
        }
        try {
            return this.daoTemplate.queryForObj(sql.toString(), BscTopicFactoryDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：添加收藏
     * @创建者： 作者：llp  创建时间：2015-2-27
     */
    public int addBscCollect(BscCollect bscCollect, String datasource) {
        try {
            return this.daoTemplate.addByObject("" + datasource + ".bsc_collect", bscCollect);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：删除收藏
     * @创建者： 作者：llp  创建时间：2015-2-27
     */
    public void deleteBscCollect(Integer mbId, Integer topicId, String database) {
        String sql = "delete from " + database + ".bsc_collect where member_id=" + mbId + " and topic_id=" + topicId;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * @return
     * @说明：判断是否收藏过
     * @创建者： 作者：llp  创建时间：2015-2-27
     */
    public int queryBscCollectByTpid(Integer mbId, Integer topicId, String database) {
        String sql = " select count(1) from " + database + ".bsc_collect where member_id=" + mbId + " and topic_id=" + topicId;
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
