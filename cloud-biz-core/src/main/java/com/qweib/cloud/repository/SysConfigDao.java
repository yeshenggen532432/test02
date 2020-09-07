package com.qweib.cloud.repository;

import com.google.common.collect.Lists;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysConfig;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.commons.StringUtils;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysConfigDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page querySysConfigPage(SysConfig config, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_config a");

        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysConfig.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysConfig> queryList(SysConfig config, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_config a ");
        sql.append(" where 1=1 ");
        List<Object> values = Lists.newArrayList();
        if (config != null) {
    		if (StringUtils.isNotBlank(config.getSystemGroupCode())) {
    		    sql.append(" AND a.system_group_code = ?");
    		    values.add(config.getSystemGroupCode());
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysConfig.class, values.toArray(new Object[values.size()]));
    }

    public SysConfig querySysConfigByCode(String code, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_config a ");
        sql.append(" where 1=1 ");
        sql.append(" and code='").append(code).append("'");
        List<SysConfig> list = this.daoTemplate.queryForLists(sql.toString(), SysConfig.class);
        if (list != null && list.size() > 0) {
            return list.get(0);
        }
        return null;
    }


    public int addSysConfig(SysConfig config, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_config", config);
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

    public SysConfig querySysConfigById(Integer id, String database) {
        String sql = "select * from " + database + ".sys_config where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysConfig.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateSysConfig(SysConfig config, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", config.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_config", config, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteSysConfig(Integer id, String database) {
        String sql = " delete from " + database + ".sys_config where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
