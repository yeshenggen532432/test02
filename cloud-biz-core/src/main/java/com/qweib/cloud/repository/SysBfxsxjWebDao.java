package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysBfxsxjWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int addBfxsxj(SysBfxsxj bfxsxj, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_bfxsxj", bfxsxj);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：修改销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public int updateBfxsxj(SysBfxsxj bfxsxj, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", bfxsxj.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_bfxsxj", bfxsxj, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public List<SysBfxsxj> queryBfxsxjOne(String database, Integer mid, Integer cid, String xjdate) {
        try {
            String sql = "select a.*,b.ware_nm,b.ware_gg from " + database + ".sys_bfxsxj a left join " + database + ".sys_ware b on a.wid=b.ware_id where a.mid=? and a.cid=? and a.xjdate=?";
            return this.daoTemplate.queryForLists(sql, SysBfxsxj.class, mid, cid, xjdate);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：删除销售小结
     *
     * @创建：作者:llp 创建时间：2016-3-28
     * @修改历史： [序号](llp 2016 - 3 - 28)<修改说明>
     */
    public void deleteBfxsxj(String database, Integer mid, Integer cid) {
        String sql = "delete from " + database + ".sys_bfxsxj where mid=" + mid + " and cid=" + cid + " and xjdate='" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "'";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：判断有没有临期
     *
     * @创建：作者:llp 创建时间：2016-4-29
     * @修改历史： [序号](llp 2016 - 4 - 29)<修改说明>
     */
    public int queryBfxsxjByCount(String database, Integer mid, Integer cid, String dates) {
        String sql = " select IFNULL(SUM(xxd),0) from " + database + ".sys_bfxsxj where mid=" + mid + " and cid=" + cid + " and xjdate='" + dates + "'";
        try {
            return this.daoTemplate.queryForObject(sql, Integer.class);
        } catch (DaoException e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取销售小结上次信息
     *
     * @创建：作者:llp 创建时间：2016-4-29
     * @修改历史： [序号](llp 2016 - 4 - 29)<修改说明>
     */
    public SysBfxsxj queryBfxsxjOneSc(String database, Integer mid, Integer cid) {
        try {
            String sql = "select xxd from " + database + ".sys_bfxsxj where mid=? and cid=? order by xjdate desc limit 0,1";
            return this.daoTemplate.queryForObj(sql, SysBfxsxj.class, mid, cid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
