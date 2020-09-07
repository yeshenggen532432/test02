package com.qweib.cloud.repository;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.core.domain.SysWareGroup;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: yueji.hu
 * @time: 2019-09-05 11:36
 * @description:
 */
@Repository
public class SysWareGroupDao {
    @Resource(name="daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page wareGroupPage(SysWareGroup sysWareGroup, String database, Integer page, Integer limit){
        StringBuilder sql = new StringBuilder();
        sql.append("select * from "+database+".sys_warespec_group where 1=1");
        if(null!=sysWareGroup){
            if(!StrUtil.isNull(sysWareGroup.getGroupName())){
                sql.append(" and group_name like '%"+sysWareGroup.getGroupName()+"%' ");
            }
        }
        sql.append(" order by id desc");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysWareGroup.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addWareGroupName(SysWareGroup sysWareGroup, String database){
        try{
            return this.daoTemplate.addByObject(database+".sys_warespec_group", sysWareGroup);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareGroupName(SysWareGroup sysWareGroup, String database){
        try{
            Map<String,Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", sysWareGroup.getId());
            return this.daoTemplate.updateByObject(database+".sys_warespec_group", sysWareGroup, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteGroupById(Integer Id,String database){
        try{
            String sql = "delete  from "+database+".sys_warespec_group where id=? ";
            return this.daoTemplate.update(sql, Id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
