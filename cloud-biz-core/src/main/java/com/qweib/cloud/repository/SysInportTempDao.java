package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysImportTemp;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


/**
 * 导入数据临时表
 */
@Repository
public class SysInportTempDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public SysImportTemp queryById(Integer id, String database) {
        try {
            return this.daoTemplate.queryForObj(" select * from " + database + ".sys_import_temp where id=? ", SysImportTemp.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page queryPage(SysImportTemp sysImportTemp, Integer page, Integer rows, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select * from " + database + ".sys_import_temp where 1=1 ");
            if (sysImportTemp.getType() != null)
                sql.append(" and type=" + sysImportTemp.getType());
            sql.append(" order by id desc");
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysImportTemp.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int add(SysImportTemp sysImportTemp, String database) {
        try {
            sysImportTemp.setSaveDate(new Date());
            sysImportTemp.setStatus(SysImportTemp.StateEnum.state_save.getCode());
            return this.daoTemplate.addByObject("" + database + ".sys_import_temp", sysImportTemp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int update(SysImportTemp sysImportTemp, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", sysImportTemp.getId());
            return this.daoTemplate.updateByObject(database + ".sys_import_temp", sysImportTemp, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public void delete(Integer id, String database) {
        String sql = " delete from " + database + ".sys_import_temp where id=? ";
        try {
            this.daoTemplate.deletes(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
