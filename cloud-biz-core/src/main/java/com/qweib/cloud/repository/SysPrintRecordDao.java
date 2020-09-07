package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysPrintRecord;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysPrintRecordDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page querySysPrintRecordPage(SysPrintRecord print, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_print_record a");

        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysPrintRecord.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysPrintRecord> queryList(SysPrintRecord print, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_print_record a ");
        sql.append(" where 1=1 ");
        if (print != null) {
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysPrintRecord.class);
    }

    public Integer queryPrintCount(SysPrintRecord print, String database) {
        StringBuffer sql = new StringBuffer(" select count(a.id) from " + database + ".sys_print_record a ");
        sql.append(" where 1=1 ");
        if (print != null) {
            if (!StrUtil.isNull(print.getFdModel())) {
                sql.append(" and a.fd_model like '").append(print.getFdModel()).append("%'");
            }
            if (!StrUtil.isNull(print.getFdSourceId())) {
                sql.append(" and a.fd_source_id=").append(print.getFdSourceId());
            }
        }
        return this.daoTemplate.queryForObject(sql.toString(), Integer.class);
    }

    public List queryPrintCountList(SysPrintRecord print, String database) {
        StringBuffer sql = new StringBuffer(" select a.fd_source_id,a.fd_source_no,count(a.id) as count from " + database + ".sys_print_record a ");
        sql.append(" where 1=1 ");
        if (print != null) {
            if (!StrUtil.isNull(print.getFdModel())) {
                sql.append(" and a.fd_model like '").append(print.getFdModel()).append("%'");
            }
            if (!StrUtil.isNull(print.getFdSourceIds())) {
                sql.append(" and a.fd_source_id in (").append(print.getFdSourceIds()).append(")");
            }

        }
        sql.append("group by a.fd_source_id,a.fd_source_no ");
        return this.daoTemplate.queryForList(sql.toString());
    }


    public int addSysPrintRecord(SysPrintRecord print, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_print_record", print);
        } catch (Exception e) {
            e.printStackTrace();
            throw new DaoException(e);
        }
    }

    public SysPrintRecord querySysPrintRecordById(Integer id, String database) {
        String sql = "select * from " + database + ".sys_print_record where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysPrintRecord.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int updateSysPrintRecord(SysPrintRecord print, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", print.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_print_record", print, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteSysPrintRecord(Integer id, String database) {
        String sql = " delete from " + database + ".sys_print_record where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
