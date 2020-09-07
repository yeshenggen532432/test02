package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysImportTemp;
import com.qweib.cloud.core.domain.SysImportTempItem;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.commons.StringUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;


/**
 * 导入数据临时表
 */
@Repository
public class SysInportTempItemDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    @Resource
    private SysInportTempDao sysInportTempDao;

    public Page queryItemPage(SysImportTempItem sysImportTempItem, String queryStr, Integer page, Integer rows, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select * from " + database + ".sys_import_temp_item where import_id= " + sysImportTempItem.getImportId());
            if (sysImportTempItem.getImportStatus() != null)
                sql.append(" and import_status=" + sysImportTempItem.getImportStatus());

            //增加过滤条件,暂时只有客户价格导入使用
            if (StringUtils.isNotBlank(queryStr)) {
                String[] ss = queryStr.split(",");
                for (String s : ss) {
                    if (StringUtils.isEmpty(s)) continue;
                    String[] kv = s.split(":");
                    if (kv == null || kv.length != 2 || StringUtils.isEmpty(kv[1])) continue;
                    sql.append(" and context_json like '%\"" + kv[0] + "\":\"" + kv[1] + "%'");
                }
            }
            return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysImportTempItem.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public List<SysImportTempItem> queryItemList(Integer importId, String ids, Integer status, String database) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" select * from " + database + ".sys_import_temp_item where import_id= " + importId);
            if (status != null)
                sql.append(" and import_status=" + status);
            if (!StrUtil.isNull(ids) && !"0".equals(ids))
                sql.append(" and id in(" + ids + ")");
            return this.daoTemplate.queryForLists(sql.toString(), SysImportTempItem.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


    public int add(SysImportTempItem sysImportTempItem, String database) {
        try {
            return this.daoTemplate.addByObject("" + database + ".sys_import_temp_item", sysImportTempItem);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    //一次批量导入数据
    public static final int BATCH_SIZE = 1000;

    public void batchUpdate(List<SysImportTempItem> batchArgs, String database) {
        String sql = "INSERT INTO " + database + ".SYS_IMPORT_TEMP_ITEM(IMPORT_ID,CONTEXT_JSON,IMPORT_STATUS) VALUES(?,?,?)";
        int fromIndex = 0;
        int toIndex = BATCH_SIZE;
        while (fromIndex != batchArgs.size()) {
            if (toIndex > batchArgs.size()) {
                toIndex = batchArgs.size();
            }
            int batchSize = toIndex - fromIndex;
            List<SysImportTempItem> temp = batchArgs.subList(fromIndex, toIndex);
            this.daoTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
                @Override
                public void setValues(PreparedStatement ps, int i) throws SQLException {
                    SysImportTempItem tempItem = temp.get(i);
                    ps.setInt(1, tempItem.getImportId());
                    ps.setString(2, tempItem.getContextJson());
                    ps.setInt(3, tempItem.getImportStatus());
                }

                @Override
                public int getBatchSize() {
                    return temp.size();
                }
            });
            fromIndex = toIndex;
            toIndex += BATCH_SIZE;
            if (toIndex > batchArgs.size())
                toIndex = batchArgs.size();
        }
    }

    public int update(SysImportTempItem sysImportTempItem, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", sysImportTempItem.getId());
            return this.daoTemplate.updateByObject(database + ".sys_import_temp_item", sysImportTempItem, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void batchUpdate(String ids, int state, String database) {
        String sql = " update " + database + ".sys_import_temp_item set import_status=" + state;
        if (state == SysImportTemp.StateEnum.state_import_success.getCode())
            sql += ",import_success_date='" + DateTimeUtil.getDateToStr() + "'";
        sql += " where id in(" + ids + ")";
        try {
            this.daoTemplate.update(sql);

            if (state == SysImportTemp.StateEnum.state_import_success.getCode()) {
                //查同一批次,还有多少未导入
                String sql1 = "SELECT count(1) count FROM " + database + ".sys_import_temp_item t WHERE t.import_id=(";
                sql1 += "SELECT t1.import_id FROM  " + database + ".sys_import_temp_item t1 WHERE t1.id IN (" + ids + ") LIMIT 1";
                sql1 += ") and t.import_status =" + SysImportTemp.StateEnum.state_save.getCode();
                Integer count = this.daoTemplate.queryForInt(sql1);
                if (Objects.equals(count, 0)) {
                    StringBuffer isql = new StringBuffer();
                    isql.append("SELECT * FROM " + database + ".sys_import_temp t WHERE  1=1 ");
                    isql.append("AND t.id = (SELECT t1.import_id FROM " + database + ".sys_import_temp_item t1 WHERE t1.id IN (" + ids + ") LIMIT 1)");
                    SysImportTemp sysImportTemp = daoTemplate.queryForObj(isql.toString(), SysImportTemp.class);
                    sysImportTemp.setStatus(SysImportTemp.StateEnum.state_import_success.getCode());
                    sysImportTemp.setSuccessDate(new Date());
                    sysInportTempDao.update(sysImportTemp, database);
                }
            }

        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void delete(String ids, String database) {
        String sql = " delete from " + database + ".sys_import_temp_item where import_status !=1 and id in(" + ids + ")";
        try {
            this.daoTemplate.update(sql);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
