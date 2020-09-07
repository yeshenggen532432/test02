package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.vo.SysUsrVO;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class SysDeptmempowerDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 查询部门成员权限树
     *
     * @param deptId
     * @param tp
     * @param datasource
     * @return
     */
    public List<SysUsrVO> queryMempowerForDept(Integer deptId,
                                               String tp, String datasource) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT m.member_id AS usrid,m.member_nm AS usrnm,");
        sql.append(" (SELECT COUNT(1) FROM " + datasource + ".sys_deptmempower dmp ");
        sql.append(" WHERE dmp.member_id=m.member_id AND dmp.dept_id=? AND dmp.tp=?) AS isuse ");
        sql.append(" FROM " + datasource + ".sys_mem m ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysUsrVO.class, deptId, tp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除部门成员权限关系
     *
     * @param deptId
     * @param powertp
     * @param datasource
     */
    public void deleteDeptmempower(Integer deptId, String powertp,
                                   String datasource) {
        String sql = " DELETE FROM " + datasource + ".sys_deptmempower WHERE dept_id=? AND tp=? ";
        try {
            daoTemplate.update(sql, deptId, powertp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量添加部门成员权限关系
     *
     * @param usrIds
     * @param deptId
     * @param powertp
     * @param datasource
     */
    public int[] saveDeptmempower(final Long[] usrIds, final Integer deptId, final String powertp,
                                  String datasource) {
        String sql = " insert into " + datasource + ".sys_deptmempower(dept_id,member_id,tp) values(?,?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return usrIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, deptId);
                    pre.setLong(2, usrIds[num]);
                    pre.setString(3, powertp);
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    /**
     * 根据成员id查询（不）可见部门
     */
    public Map<String, Object> queryPowerDeptsByMemberId(Integer memberId, String tp, String datasource) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT GROUP_CONCAT(d.branch_path) AS depts ");
        sql.append(" FROM " + datasource + ".sys_deptmempower dp," + datasource + ".sys_depart d ");
        sql.append(" WHERE dp.dept_id=d.branch_id ");
        sql.append(" AND dp.member_id=" + memberId + " AND dp.tp= '" + tp + "'");

        try {
            Map<String, Object> map = daoTemplate.queryForMap(sql.toString());
            return map;
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }


}
