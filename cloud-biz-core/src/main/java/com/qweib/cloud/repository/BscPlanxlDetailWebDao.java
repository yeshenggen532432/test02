package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPlanxlDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscPlanxlDetailWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：分页查询计划线路详情
     *
     * @创建：作者:llp 创建时间：2016-8-15
     * @修改历史： [序号](llp 2016 - 8 - 15)<修改说明>
     */
    public Page queryBscPlanxlDetailWeb(String database, Integer page, Integer limit, Integer xlId) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*,c.kh_nm,c.scbf_date,c.latitude,c.longitude from " + database + ".bsc_planxl_detail a left join " + database + ".sys_customer c on a.cid=c.id where a.xl_id=" + xlId + "");
        sql.append(" order by a.id ASC");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlanxlDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：添加计划线路详情
     *
     * @创建：作者:llp 创建时间：2016-8-15
     * @修改历史： [序号](llp 2016 - 8 - 15)<修改说明>
     */
    public int addBscPlanxlDetailWeb(BscPlanxlDetail planxlDetail, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".bsc_planxl_detail", planxlDetail);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除计划线路详情
     *
     * @创建：作者:llp 创建时间：2016-8-15
     * @修改历史： [序号](llp 2016 - 8 - 15)<修改说明>
     */
    public void deleteBscPlanxlDetailWeb(String database, Integer xlId, String cids) {
        StringBuilder sql = new StringBuilder("delete from " + database + ".bsc_planxl_detail where xl_id=" + xlId + "");
        if (!StrUtil.isNull(cids)) {
            sql.append(" and cid in(" + cids + ")");
        }
        try {
            this.daoTemplate.update(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：查询计划线路详情ls
     *
     * @创建：作者:llp 创建时间：2016-8-16
     * @修改历史： [序号](llp 2016 - 8 - 16)<修改说明>
     */
    public List<BscPlanxlDetail> queryPlanxlDetaills(String database, Integer xlId) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select a.*, c.latitude, c.longitude from " + database + ".bsc_planxl_detail a ");
        sql.append(" left join " + database + ".sys_customer c on c.id = a.cid ");
        sql.append(" where xl_id=" + xlId + "");
        sql.append(" order by id desc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), BscPlanxlDetail.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
