package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBforderPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

/**
 * 商品订单详情图片
 *
 * @author zzx
 */
@Repository
public class SysBforderPicDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addWarePic(List<SysBforderPic> list, Integer orderId, String database) {
        try {
            if (Collections3.isEmpty(list))
                return 1;
            for (SysBforderPic warePic : list) {
                warePic.setId(null);
                warePic.setOrderId(orderId);
                this.daoTemplate.addByObject("" + database + ".sys_bforder_pic", warePic);
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
        return 1;
    }

    public List<SysBforderPic> queryWarePic(String database, SysBforderPic warePic) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + database + ".sys_bforder_pic where 1=1 ");
        if (warePic != null) {
            sql.append(" and order_id=").append(warePic.getOrderId());
            if (!StrUtil.isNull(warePic.getWareId())) {
                sql.append(" and ware_id=").append(warePic.getWareId());
            }
        }
        sql.append(" ORDER BY type desc");//默认主图排前面,方便页面使用zzx 05-16
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysBforderPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据商品ids获取商品图片集合
    public List<SysBforderPic> queryWarePicByIds(String database, String wids, String oids) {
        try {
            if (StrUtil.isNull(wids) || StrUtil.isNull(oids)) return null;
            String sql = "select * from " + database + ".sys_bforder_pic where ware_id in (" + wids + ") and order_id in (" + oids + ")";
            return this.daoTemplate.queryForLists(sql.toString(), SysBforderPic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

}
