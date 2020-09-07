package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysRegion;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
public class SysRegionDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Integer queryOneRegion(SysRegion type, String database) {
        StringBuilder sql = new StringBuilder(" select region_id from " + database + ".sys_region where region_pid=0");
        if (null == type) {
            type = new SysRegion();
        }
        try {
            List<Map<String, Object>> maps = this.daoTemplate.queryForList(sql.toString());
            if (null != maps && maps.size() > 0) {
                return StrUtil.convertInt(maps.get(0).get("region_id"));
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public String queryWarePath(Integer Region, String database) {
        String sql = " select region_path from " + database + ".sys_region where region_id=? ";
        try {
            Map<String, Object> map = this.daoTemplate.queryForMap(sql, Region);
            if (null != map && map.size() > 0) {
                return StrUtil.convertStr(map.get("region_path"));
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysRegion> queryList(SysRegion type, String database) {
        StringBuffer sb = new StringBuffer("select * from " + database + ".sys_region order by region_id asc");
        return this.daoTemplate.queryForLists(sb.toString(), SysRegion.class);
    }


    public List<SysRegion> queryRegion(SysRegion type, String database) {
        StringBuilder sql = new StringBuilder("select region_id,region_pid,Region_nm,region_path,Region_leaf from ")
                .append(database).append(".sys_region");
        sql.append(" where region_pid=?");
        List<Object> values = new ArrayList<Object>();
        values.add(type.getRegionId());
        if (type != null) {

            if (!StrUtil.isNull(type.getRegionNm())) {
                sql.append(" and Region_nm like ?");
                values.add("%" + type.getRegionNm() + "%");
            }
        }
        
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysRegion.class, values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int addRegion(SysRegion Region, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_region", Region);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public SysRegion queryRegionById(Integer RegionId, String database) {
        try {
            return this.daoTemplate.queryForObj(" select a.*,b.Region_nm as up_Region_nm from " + database + ".sys_region a left join " + database + ".sys_region b on a.region_pid=b.region_id where a.region_id=? ", SysRegion.class, RegionId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateRegion(SysRegion Region, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("region_id", Region.getRegionId());
            return this.daoTemplate.updateByObject("" + database + ".sys_region", Region, whereParam, "region_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateRegionLeaf(Integer id, String leaf, String database) {
        try {
            return this.daoTemplate.update(" update " + database + ".sys_region set Region_leaf=? where region_id=? ", leaf, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateRegionPath(Integer id, String path, String database) {
        try {
            return this.daoTemplate.update(" update " + database + ".sys_region set region_path=? where region_id=? ", path, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public void deleteRegion(Integer ids, String database) {
        String sql = " delete from " + database + ".sys_region where region_id=? ";
        try {
            this.daoTemplate.deletes(sql, ids);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int queryRegionInt(Integer pid, String database) {
        String sql = "select count(1) from " + database + ".sys_region where region_pid=? ";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{pid}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int queryAutoId() {
        try {
            return this.daoTemplate.getAutoIdForIntByMySql();
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }



  
    public int queryRegionNmCount(String RegionNm, String database) {
        String sql = "select count(1) from " + database + ".sys_region where Region_nm=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{RegionNm}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysRegion getRegionByName(String RegionNm, String database) {
        String sql = "select * from " + database + ".sys_region where Region_nm='" + RegionNm + "'";
        List<SysRegion> list = this.daoTemplate.queryForLists(sql, SysRegion.class);
        if (list.size() > 0) return list.get(0);
        return null;
    }
}
