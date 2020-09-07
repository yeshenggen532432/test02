package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.*;


@Repository
public class SysWaretypeDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Integer queryOneWaretype(SysWaretype type, String database) {
        StringBuilder sql = new StringBuilder(" select waretype_id from " + database + ".sys_waretype where waretype_pid=0");
        if (null == type) {
            type = new SysWaretype();
        }
        try {
            List<Map<String, Object>> maps = this.daoTemplate.queryForList(sql.toString());
            if (null != maps && maps.size() > 0) {
                return StrUtil.convertInt(maps.get(0).get("waretype_id"));
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public String queryWarePath(Integer waretype, String database) {
        String sql = " select waretype_path from " + database + ".sys_waretype where waretype_id=? ";
        try {
            Map<String, Object> map = this.daoTemplate.queryForMap(sql, waretype);
            if (null != map && map.size() > 0) {
                return StrUtil.convertStr(map.get("waretype_path"));
            }
            return null;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<Map<String,Object>> queryWarePathMapList(String ids, String database) {
        if(StrUtil.isNull(ids)){
          return null;
        }
        String sql = " select waretype_id,waretype_path from " + database + ".sys_waretype where waretype_id in ("+ids+") ";
        try {
            return this.daoTemplate.queryForList(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWaretype> queryList(SysWaretype type, String database) {
        StringBuffer sb = new StringBuffer("select * from " + database + ".sys_waretype order by waretype_id asc");
        return this.daoTemplate.queryForLists(sb.toString(), SysWaretype.class);
    }

    public List<SysWaretype> queryWaretype(SysWaretype type, String database) {
        StringBuilder sql = new StringBuilder("select waretype_id,waretype_pid,waretype_nm,waretype_path,waretype_leaf from ")
                .append(database).append(".sys_waretype");
        sql.append(" where 1=1");
        List<Object> values = new ArrayList<Object>();
        if (type != null) {
            if (!StrUtil.isNull(type.getWaretypeId())) {
                sql.append(" and waretype_pid = ?");
                values.add(type.getWaretypeId());
            }
            if(!StrUtil.isNull(type.getIsType())){
                sql.append(" and is_type=").append(type.getIsType());
            }
            if (Objects.nonNull(type.getNoCompany())) {
                if (Objects.equals(type.getNoCompany(), 0)) {
                    sql.append(" and (no_company = ? OR no_company IS NULL)");
                    values.add(0);
                } else {
                    sql.append(" and no_company = ?");
                    values.add(type.getNoCompany());
                }
            }
        }
        //sql.append(" and " + WareSqlUtil.getCompanyStockWareTypeAppendSql("swt"));
        sql.append(" order by sort,waretype_id ");
        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWaretype.class, values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addWaretype(SysWaretype waretype, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_waretype", waretype);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWaretype queryWaretypeById(Integer waretypeId, String database) {
        try {
            return this.daoTemplate.queryForObj(" select a.*,b.waretype_nm as up_waretype_nm from " + database + ".sys_waretype a left join " + database + ".sys_waretype b on a.waretype_pid=b.waretype_id where a.waretype_id=? ", SysWaretype.class, waretypeId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWaretype queryWareTypeByName(String waretypeNm,String database)
    {
        String sql = "select * from " + database + ".sys_waretype where waretype_nm ='" + waretypeNm + "'";
        List<SysWaretype> list = this.daoTemplate.queryForLists(sql,SysWaretype.class);
        if(list.size() > 0)return list.get(0);
        return null;
    }


    public int updateWaretype(SysWaretype waretype, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("waretype_id", waretype.getWaretypeId());
            return this.daoTemplate.updateByObject("" + database + ".sys_waretype", waretype, whereParam, "waretype_id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateWareLeaf(Integer id, String leaf, String database) {
        try {
            return this.daoTemplate.update(" update " + database + ".sys_waretype set waretype_leaf=? where waretype_id=? ", leaf, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareType(Integer id, Integer isType,Integer noCompany, String database) {
        try {
            String sql = " update " + database + ".sys_waretype set is_type=?,no_company=? where waretype_path like '%-"+id+"-%' ";
            int k = this.daoTemplate.update(sql, isType,noCompany);
            String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=?,a.no_company=?,a.waretype_path=b.waretype_path  WHERE b.waretype_id=a.waretype and b.waretype_path like '%-"+id+"-%' ";
            this.daoTemplate.update(wareSql,isType,noCompany);
            return k;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateWarePath(Integer id, String path, String database) {
        try {
            return this.daoTemplate.update(" update " + database + ".sys_waretype set waretype_path=? where waretype_id=? ", path, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public void deleteWaretype(Integer ids, String database) {
        String sql = " delete from " + database + ".sys_waretype where waretype_id=? ";
        try {
            this.daoTemplate.deletes(sql, ids);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWaretypePid(Integer typeId, Integer id,Integer isType, String path, String database) {

        String sql = "update " + database + ".sys_waretype set waretype_pid=?, is_type=?, waretype_path=?  where waretype_id=? ";
        try {
            return this.daoTemplate.update(sql,typeId,isType, path, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    public int updateIsType(Integer pid,Integer isType, String pPath, String database){
        String sql="update " + database + ".sys_waretype set is_type=?, waretype_path = concat('"+pPath+"', waretype_id, '-') where waretype_pid = ?" ;
        String wareSql = "update "+database+".sys_ware a,"+database+".sys_waretype b set a.is_type=?,a.waretype_path = b.waretype_path  WHERE b.waretype_id=a.waretype and b.waretype_pid=? ";
        try{
            this.daoTemplate.update(wareSql,isType,pid);
            return this.daoTemplate.update(sql,isType, pid);
        }catch (Exception e){
            throw new DaoException(e);
        }
    }

    public int queryWaretypeInt(Integer pid, String database) {
        String sql = "select count(1) from " + database + ".sys_waretype where waretype_pid=? ";
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


    public boolean existWareInType(Integer waretype, String database) {
        String sql = " select count(1) from " + database + ".sys_ware where waretype=? ";
        try {
            int count = this.daoTemplate.queryForObject(sql, new Object[]{waretype}, Integer.class);
            if (count == 0) {
                return false;
            } else {
                return true;
            }
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int queryWaretypeNmCount(String waretypeNm, String database) {
        String sql = "select count(1) from " + database + ".sys_waretype where waretype_nm=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{waretypeNm}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWaretype getWareTypeByName(String waretypeNm, String database) {
        String sql = "select * from " + database + ".sys_waretype where waretype_nm='" + waretypeNm + "'";
        List<SysWaretype> list = this.daoTemplate.queryForLists(sql, SysWaretype.class);
        if (list.size() > 0) return list.get(0);
        return null;
    }

    //=====================================================================================================================

    /**
     * 查询公司类商品类别
     * @param type
     * @param database
     * @return
     */
    public List<SysWaretype> queryCompanyWaretypeList(SysWaretype type, String database) {
        StringBuilder sql = new StringBuilder("select waretype_id,waretype_pid,waretype_nm,waretype_path,waretype_leaf from ")
                .append(database).append(".sys_waretype");
        sql.append(" where 1=1");
        sql.append(" and (no_company = 0 or no_company is null)");//公司商品分类
        List<Object> values = new ArrayList<>();
        if (type != null) {
            if (!StrUtil.isNull(type.getWaretypeId())) {
                sql.append(" and waretype_pid = ?");
                values.add(type.getWaretypeId());
            }
            if(!StrUtil.isNull(type.getIsType())){
                sql.append(" and is_type=").append(type.getIsType());
            }
        }

        try {
            return this.daoTemplate.queryForLists(sql.toString(), SysWaretype.class, values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public String getWareTypeIds(SysWaretype type,String database){
        StringBuilder sb = new StringBuilder();
        sb.append(" select w.waretype_id from " + database + ".sys_waretype w where 1=1 and  (w.no_company = 0 OR w.no_company IS NULL) ");
        if (!StrUtil.isNull(type.getWaretypeId())||!StrUtil.isNull(type.getIsType())) {
            if(!StrUtil.isNull(type.getWaretypeId())&&type.getWaretypeId().intValue()>0){
                sb.append("  and w.waretype_path like '%-" + type.getWaretypeId() + "-%'");
            }
            if(!StrUtil.isNull(type.getIsType())){
                sb.append("  and w.is_type = '" + type.getIsType() + "'");
            }
        }
        List<Map<String,Object>>  typeList =  this.daoTemplate.queryForList(sb.toString());
        String ids = "";
        if(typeList!=null){
            for(int i=0;i<typeList.size();i++){
                Map<String,Object> map = typeList.get(i);
                Object waretypId = map.get("waretype_id");
                if(ids!=""){
                    ids = ids +",";
                }
                ids = ids + waretypId;
            }
        }
        return ids;
    }

}
