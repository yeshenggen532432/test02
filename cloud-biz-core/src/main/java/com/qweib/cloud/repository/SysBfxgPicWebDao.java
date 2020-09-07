package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfxgPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysBfxgPicWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 说明：添加照片
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public int addBfxgPic(SysBfxgPic bfxgPic, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_bfxg_pic", bfxgPic);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：列表查照片
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public List<SysBfxgPic> queryBfxgPicls(String database, Integer ssId, Integer type, Integer xxId) {
        StringBuilder sql = new StringBuilder();
        sql.append("select * from " + database + ".sys_bfxg_pic where ss_id=" + ssId + " and type=" + type + "");
        if (!StrUtil.isNull(xxId)) {
            sql.append(" and xx_id=" + xxId + "");
        }
        sql.append(" order by id asc");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysBfxgPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取图片数量1
     *
     * @创建：作者:llp 创建时间：2016-7-5
     * @修改历史： [序号](llp 2016 - 7 - 5)<修改说明>
     */
    public int queryBfxgPicCount1(String database, Integer ssId, Integer type) {
        try {
            String sql = " select count(1) from " + database + ".sys_bfxg_pic where ss_id=? and type=?";
            return this.daoTemplate.queryForObject(sql, new Object[]{ssId, type}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明：获取图片数量2
     *
     * @创建：作者:llp 创建时间：2016-7-5
     * @修改历史： [序号](llp 2016 - 7 - 5)<修改说明>
     */
    public int queryBfxgPicCount2(String database, Integer ssId) {
        try {
            String sql = " select count(1) from " + database + ".sys_bfxg_pic where ss_id=? and (type=2 or type=3)";
            return this.daoTemplate.queryForObject(sql, new Object[]{ssId}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 说明： 删除照片
     *
     * @创建：作者:llp 创建时间：2016-3-24
     * @修改历史： [序号](llp 2016 - 3 - 24)<修改说明>
     */
    public void deleteBfxgPic(String database, Integer ssId, Integer type) {
        String sql = "delete from " + database + ".sys_bfxg_pic where ss_id=" + ssId + " and type=" + type;
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
