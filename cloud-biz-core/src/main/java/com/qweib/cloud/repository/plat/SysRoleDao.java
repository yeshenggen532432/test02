package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * 说明：角色数据库操作类
 *
 * @创建：作者:yxy 创建时间：2012-3-19
 * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
 */
@Repository
public class SysRoleDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 摘要：
     *
     * @param role
     * @说明：添加角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public int addRole(SysRole role, String datasource) {
        try {
            if (!StrUtil.isNull(datasource)) {//公司角色
                return this.daoTemplate.addByObject(datasource + ".sys_role", role);
            } else {
                return this.pdaoTemplate.addByObject("sys_role", role);
            }
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：根据id获取角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @para0m idKey
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public SysRole queryRoleById(Integer idKey, String datasource) {
        try {
            StringBuffer sql = new StringBuffer();
            sql.append(" SELECT * FROM " + datasource + ".sys_role ");
            sql.append("  WHERE id_key=").append(idKey);
            return daoTemplate.queryForObj(sql.toString(), SysRole.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public SysRole queryByRoleCode(String roleCode, String datasource) {
        List<SysRole> roles = daoTemplate.queryForLists("SELECT * FROM " + datasource + ".sys_role WHERE role_cd = ?", SysRole.class, roleCode);
        return Collections3.isNotEmpty(roles) ? roles.get(0) : null;
    }

    /**
     * 摘要：
     *
     * @param role
     * @说明：修改角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public int updateRole(SysRole role, String datasource) {
        StringBuilder sql = new StringBuilder(32);
        sql.append("UPDATE ").append(datasource).append(".sys_role SET role_nm = ?, remo = ? WHERE id_key = ?");
        return this.daoTemplate.update(sql.toString(), role.getRoleNm(), role.getRemo(), role.getIdKey());
    }

//    /**
//     * 摘要：
//     *
//     * @param role
//     * @param page
//     * @return
//     * @说明：分页查询角色
//     * @创建：作者:yxy 创建时间：2012-3-19
//     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
//     */
//    public Page queryRole(SysRole role, int page, int limit) {
//        StringBuffer sql = new StringBuffer();
//        sql.append(" select * from sys_role where 1=1 ");
//        if (null != role) {
//            String roleNm = role.getRoleNm();
//            if (!StrUtil.isNull(roleNm)) {
//                sql.append(" and role_nm like '%").append(roleNm).append("%' ");
//            }
//        }
//        sql.append(" order by id_key desc ");
//        try {
//            return pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysRole.class);
//        } catch (Exception ex) {
//            throw new DaoException(ex);
//        }
//    }

    /**
     * 摘要：
     *
     * @param roleIds
     * @说明：批量删除角色
     * @创建：作者:yxy 创建时间：2012-3-19
     * @修改历史： [序号](yxy 2012 - 3 - 19)<修改说明>
     */
    public int[] deleteRoles(String datasource, final Integer... roleIds) {
        StringBuffer sql = new StringBuffer();
        //公司角色
        sql.append(" delete from " + datasource + ".sys_role ");
        sql.append(" where id_key=?  ");
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return roleIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleIds[num]);
                }
            };
            return pdaoTemplate.batchUpdate(sql.toString().toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @return
     * @说明：查询用户用于分配用户
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public List<Map<String, Object>> queryUsrForRole(Integer roleId, String datasource) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT m.member_id,m.member_nm,IFNULL(r.role_id, 0) AS owner")
                .append(" FROM ").append(datasource).append(".sys_mem m")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role_member r ON m.member_id = r.member_id AND r.role_id = ?")
                .append(" WHERE m.member_use = ?");
        try {
            return pdaoTemplate.queryForList(sql.toString(), roleId, 1);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @return
     * @说明：查询用户用于分配用户2
     * @创建：作者:llp 创建时间：2017-7-19
     * @修改历史： [序号](llp 2017 - 7 - 19)<修改说明>
     */
    public List<Map<String, Object>> queryUsrForRole2(Integer roleid, Integer cdid, String mids, String datasource) {
        if (StrUtil.isNull(mids)) {
            mids = "0";
        }
        StringBuffer sql = new StringBuffer();
        sql.append(" select mem.member_id,mem.member_nm,mem.branch_id, ");
        sql.append("(select count(1) from " + datasource + ".sys_role_menu r where mem.member_id in(" + mids + ") and r.role_id=" + roleid + " and r.menu_id=" + cdid + ")");
        sql.append(" as role_use from " + datasource + ".sys_mem mem");
        try {
            return pdaoTemplate.queryForList(sql.toString().toUpperCase());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @说明：批量删除角色分配用户表
     * @创建：作者:yxy 创建时间：2012-3-23
     * @修改历史： [序号](yxy 2012 - 3 - 23)<修改说明>
     */
    public int[] deleteRoleUsrs(String datasource, final Integer... roleIds) {
        StringBuffer sql = new StringBuffer();
        if (!StrUtil.isNull(datasource)) {//公司角色
            sql.append(" delete from " + datasource + ".sys_role_member ");
        } else {
            sql.append(" delete from sys_role_member ");
        }
        sql.append(" where role_id=? ");
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return roleIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleIds[num]);
                }
            };
            return pdaoTemplate.batchUpdate(sql.toString().toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param roleId
     * @说明：批量删除角色分配菜单
     * @创建：作者:yxy 创建时间：2012-3-23
     * @修改历史： [序号](yxy 2012 - 3 - 23)<修改说明>
     */
    public void deleteRoleMenus(String datasource, final Integer... roleIds) {
        StringBuffer sql = new StringBuffer();
        if (!StrUtil.isNull(datasource)) {//公司角色
            sql.append(" delete from " + datasource + ".sys_role_menu ");
        } else {
            sql.append(" delete from sys_role_menu ");
        }
        sql.append(" where role_id=? ");
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return roleIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleIds[num]);
                }
            };
            pdaoTemplate.batchUpdate(sql.toString().toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param usrIds
     * @param roleId
     * @说明：批量添加角色分配人员表
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public int[] saveRoleUsr(final Long[] usrIds, final Integer roleId) {
        String sql = " insert into sys_role_member(role_id,member_id) values(?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return usrIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleId);
                    pre.setLong(2, usrIds[num]);
                }
            };
            return pdaoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @param @param  usrId
     * @param @param  roleId
     * @param @return
     * @说明：添加权限
     * @创建：作者:yxy 创建时间：2013-9-16
     * @修改历史： [序号](yxy 2013 - 9 - 16)<修改说明>
     */
    public int addRoleUsr(long usrId, int roleId) {
        String sql = " insert into sys_role_usr(role_id,usr_id) values(?,?) ";
        try {
            return this.pdaoTemplate.update(sql, roleId, usrId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 摘要：
     *
     * @param usrIds
     * @param roleId
     * @说明：批量添加角色分配人员表
     * @创建：作者:yxy 创建时间：2012-3-22
     * @修改历史： [序号](yxy 2012 - 3 - 22)<修改说明>
     */
    public int[] saveRoleMenu(final Integer[] menuIds, final Integer roleId) {
        String sql = " insert into sys_role_menu(role_id,menu_id) values(?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return menuIds.length;
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleId);
                    pre.setInt(2, menuIds[num]);
                }
            };
            return pdaoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 摘要：
     *
     * @return
     * @说明：查询所有角色
     * @创建：作者:yxy 创建时间：2012-3-24
     * @修改历史： [序号](yxy 2012 - 3 - 24)<修改说明>
     */
    public List<SysRole> queryRoleAll() {
        String sql = " select id_key,role_nm from sys_role order by id_key ";
        try {
            return pdaoTemplate.queryForLists(sql, SysRole.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }
}
