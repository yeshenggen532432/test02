package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWareImport;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysWareImportDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


    public Page queryWareImport(SysWareImport ware, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_ware_import a");

        sql.append(" order by a.ware_nm asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWareImport.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysWareImport> queryList(SysWareImport ware, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_ware_import a ");
        sql.append(" where 1=1 ");
        if (ware != null) {
            if (!StrUtil.isNull(ware.getStatus1())) {
                sql.append(" and a.status1=").append(ware.getStatus1());
            }
            if (!StrUtil.isNull(ware.getStatus2())) {
                sql.append(" and a.status2=").append(ware.getStatus2());
            }
            if (!StrUtil.isNull(ware.getStatus3())) {
                sql.append(" and a.status3=").append(ware.getStatus3());
            }
            if (!StrUtil.isNull(ware.getStatus4())) {
                sql.append(" and a.status4=").append(ware.getStatus4());
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysWareImport.class);
    }

    public Page queryWareImport2(SysWareImport ware, int page, int rows, String database) {
        StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm from " + database + ".sys_ware_import a");
        sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id where 1=1");
        if (null != ware) {
            if (!StrUtil.isNull(ware.getWareNm())) {
                sql.append(" and a.ware_nm like '%").append(ware.getWareNm()).append("%'");
            }
        }
        if (null != ware.getWaretype()) {
            sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
        }
        sql.append(" order by a.ware_id asc ");
        try {
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWareImport.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int addWareImport(SysWareImport ware, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_ware_import", ware);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysWareImport queryWareImportById(Integer wareId, String database) {
        String sql = "select * from " + database + ".sys_ware_import where ware_id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysWareImport.class, wareId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareImport(SysWareImport ware, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("ware_id", ware.getWareId());
            return this.daoTemplate.updateByObject("" + database + ".sys_ware_import", ware, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteWareImport(Integer wareId, String database) {
        String sql = " delete from " + database + ".sys_ware_import where ware_id=? ";
        try {
            return this.daoTemplate.update(sql, wareId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryWareImportNmCount(String wareNm, String database) {
        String sql = "select count(1) from " + database + ".sys_ware_import where ware_nm=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{wareNm}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int queryWareImportCodeCount(String wareCode, String database) {
        String sql = "select count(1) from " + database + ".sys_ware_import where ware_code=?";
        try {
            return this.daoTemplate.queryForObject(sql, new Object[]{wareCode}, Integer.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareImportIsCy(String database, Integer id, Integer isCy) {
        String sql = "update " + database + ".sys_ware_import set is_cy=? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, isCy, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareImportTranAmt(String database, Integer id, Double tranAmt) {
        String sql = "update " + database + ".sys_ware_import set tran_amt =? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, tranAmt, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateWareImportTcAmt(String database, Integer id, Double tcAmt) {
        String sql = "update " + database + ".sys_ware_import set tc_amt =? where ware_id=?";
        try {
            return this.daoTemplate.update(sql, tcAmt, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteWareImportAll(String database) {
        String sql = "delete from " + database + ".sys_ware_import";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @说明：删除所有商品分类
     * @创建：作者:llp 创建时间：2016-9-5
     * @修改历史： [序号](llp 2016 - 9 - 5)<修改说明>
     */
    public void deleteWareImportTpAll(String database) {
        String sql = "delete from " + database + ".sys_ware_type";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
