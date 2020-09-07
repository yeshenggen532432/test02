package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWarePic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.*;

@Repository
public class SysWarePicWebDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public int addWarePic(SysWarePic warePic, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_ware_pic", warePic);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWarePic> queryWarePic(String database, SysWarePic warePic) {
        StringBuilder sql = new StringBuilder();
        sql.append(" select * from " + database + ".sys_ware_pic where 1=1 ");
        if (warePic != null) {
            if (!StrUtil.isNull(warePic.getWareId())) {
                sql.append(" and ware_id=").append(warePic.getWareId());
            }
        }
        sql.append(" ORDER BY type desc");//默认主图排前面,方便页面使用zzx 05-16
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWarePic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //根据商品ids获取商品图片集合
    public List<SysWarePic> queryWarePicByIds(String database, String ids) {
        try {
            String sql = "";
            if (!StrUtil.isNull(ids)) {
                sql = "select * from " + database + ".sys_ware_pic where 1=1 and ware_id in (" + ids + ") order by type desc";
            }
            return this.daoTemplate.queryForLists(sql.toString(), SysWarePic.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    //根据商品ids获取商品图片集合
    public void queryWarePic(String database, List<? extends SysWare> wares) {
        try {
            if (wares == null || wares.isEmpty()) return;
            Set<String> idSet = new HashSet<>();
            wares.forEach(ware -> {
                idSet.add(ware.getWareId() + "");
            });
            if (Collections3.isEmpty(idSet)) return;
            String ids = String.join(",", idSet);
            Map<Integer, List<SysWarePic>> picMap = queryWarePicMap(ids, database);
            for (SysWare sysWare : wares) {
                sysWare.setWarePicList(picMap.get(sysWare.getWareId()));
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据商品ID获取商品对应的图片列表
     *
     * @param wareIds
     * @param database
     * @return
     */
    public Map<Integer, List<SysWarePic>> queryWarePicMap(String wareIds, String database) {
        Map<Integer, List<SysWarePic>> map = new HashMap<>();
        if (StringUtils.isEmpty(wareIds)) return map;
        List<SysWarePic> picList = queryWarePicByIds(database, wareIds);
        if (Collections3.isEmpty(picList)) return map;

        List<SysWarePic> pics = null;
        for (SysWarePic sysWarePic : picList) {
            pics = map.get(sysWarePic.getWareId());
            if (pics == null) pics = new ArrayList<>();
            pics.add(sysWarePic);
            map.put(sysWarePic.getWareId(), pics);
        }
        return map;
    }


    public int queryWarePicCount1(String database, SysWarePic warePic) {
        try {
            String sql = " select count(1) from " + database + ".sys_ware_pic where ware_id=?";
            return this.daoTemplate.queryForObject(sql, new Object[]{warePic.getId()}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteWarePic(String database, SysWarePic warePice) {
        String sql = "delete from " + database + ".sys_ware_pic where id=" + warePice.getId();
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareMainPic(String database, Integer wareId, Integer picId) {
        String sql = "update " + database + ".sys_ware_pic set type=0 where ware_id=" + wareId;
        try {
            this.daoTemplate.update(sql);
            sql = "update " + database + ".sys_ware_pic set type=1 where id=" + picId;
            return this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updatePic(SysWarePic warePic, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", warePic.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_ware_pic", warePic, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

}
