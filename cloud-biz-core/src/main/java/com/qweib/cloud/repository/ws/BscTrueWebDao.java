package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscTrue;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class BscTrueWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 真心话分页查询
     */
    public Page page(BscTrue bactrue, Integer page, Integer rows, String database) {
        StringBuffer sql = new StringBuffer("select true_id,title,content,true_count from " + database + ".bsc_true where 1=1 order by true_id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, BscTrue.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 通过trueId获取真心话(标题，内容)
     */
    public BscTrue queryTrueByTid(Integer trueId, String database) {
        String sql = "select t.true_id,t.title,t.content from " + database + ".bsc_true t where true_id=?";
        try {
            return daoTemplate.queryForObj(sql.toString(), BscTrue.class, trueId);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }
}
