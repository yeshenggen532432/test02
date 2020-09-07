package com.qweib.cloud.repository.company;


import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.qweib.cloud.biz.system.MenuConverter;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.domain.SysRole;
import com.qweib.cloud.core.domain.SysRoleMember;
import com.qweib.cloud.core.domain.SysRoleMenu;
import com.qweib.cloud.core.domain.dto.SysMenuDTO;
import com.qweib.cloud.core.domain.dto.SysRoleMemberDTO;
import com.qweib.cloud.core.domain.vo.SysRoleVO;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import com.qweib.cloud.service.member.common.RoleValueEnum;
import com.qweib.cloud.utils.Collections3;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweibframework.commons.MathUtils;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Repository
public class SysCompanyRoleDao {

    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 查询公司角色信息
     *
     * @param role
     * @param page
     * @param limit
     * @return
     */
    public Page queryRole(SysRole role, Integer page, Integer limit,
                          String datasource) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT r.*, ");
        sql.append(" (SELECT GROUP_CONCAT(m.member_nm) FROM " + datasource + ".sys_role_member rm LEFT JOIN " + datasource + ".sys_mem m ON rm.member_id=m.member_id AND rm.role_id=1) AS nms ");
        sql.append(" FROM " + datasource + ".sys_role r WHERE 1=1 ");
        if (null != role) {
            String roleNm = role.getRoleNm();
            if (!StrUtil.isNull(roleNm)) {
                sql.append(" AND r.role_nm LIKE '%").append(roleNm).append("%' ");
            }
            if (role.getStatus() != null) {
                if (role.getStatus().equals(1)) {
                    sql.append(" and (r.status is null or r.status= '").append(role.getStatus()).append("')");
                } else {
                    sql.append(" and r.status= '").append(role.getStatus()).append("'");
                }
            }
        }
        sql.append(" ORDER BY r.id_key DESC ");
        try {
            return daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysRoleVO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public int updateRoleStatus(Integer idKey, Integer status, String database) {
        String sql = "update " + database + ".sys_role set status=? where id_key=?";
        try {
            return this.daoTemplate.update(sql, status, idKey);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteMemberByRole(Integer idkey, String database) {
        String sql = "delete from " + database + ".sys_role_member where role_id =?";
        try {
            return this.daoTemplate.update(sql, idkey);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysApplyDTO> queryAllMenuApply(String database, final String roleValue, String tp) {
        StringBuilder sql = new StringBuilder(128);
        sql.append(" SELECT DISTINCT ma.apply_no,ma.id, ma.apply_name, ma.menu_tp, ma.p_id, ma.tp, '' AS sgtjz, '' AS mids, ");
        // 是否被选中
        switch (roleValue) {
            case "company_admin": {
                sql.append("1 AS apply_no, ");
                break;
            }
            case "company_creator": {
                sql.append("0 AS apply_no, ");
                break;
            }
        }
        //数据查询类型
        sql.append("1 AS menu_leaf, ");
        //绑定菜单或应用id
        sql.append("(CASE WHEN ma.menu_id IS NULL THEN '0' ELSE ma.menu_id END) AS menu_id ");
        sql.append("FROM ").append(database).append(".sys_menu_apply ma ");
        sql.append("WHERE ma.tp=? AND ma.is_use=? ORDER BY ma.apply_no ASC, ma.id ASC");

        return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, new Object[]{tp, "1"});
    }

    /**
     * 查询菜单应用树
     *
     * @param roleId
     * @param tp
     * @param datasource
     * @return
     */
    public List<SysApplyDTO> queryMenuAopplyForRole(Integer roleId, String tp,
                                                    String datasource) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT DISTINCT ma.apply_no,ma.id,ma.apply_name,ma.menu_tp,ma.p_id,ma.tp,ma.specific_tag,rm.sgtjz,rm.mids, ");
        sql.append(" (CASE WHEN rm.id_key IS NOT NULL THEN 1 ELSE 0 END) AS apply_no, ");//是否被选中
        sql.append(" (CASE WHEN rm.data_tp IS NOT NULL THEN rm.data_tp ELSE 1 END) AS menu_leaf, ");//数据查询类型
        sql.append(" (CASE WHEN ma.menu_id IS NULL THEN '0' ELSE ma.menu_id END) AS menu_id ");//绑定菜单或应用id
        sql.append(" FROM " + datasource + ".sys_menu_apply ma  ");
        sql.append(" LEFT JOIN " + datasource + ".sys_role_menu rm ON rm.menu_id=ma.id AND rm.role_id=?  AND ma.tp=rm.tp ");
        sql.append(" WHERE ma.tp=? AND ma.is_use ='1' ORDER BY ma.apply_no ASC,ma.id ASC");
        return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, roleId, tp);
    }

    /**
     * 删除角色的菜单应用关系
     *
     * @param datasource
     * @param menuapplytype
     * @param ids
     */
    public void deleteRoleMenuApplys(String datasource, Integer companyroleId, String menuapplytype,
                                     String ids) {
        String tp = "";
        if ("1".equals(menuapplytype)) {//菜单
            tp = "2";
        } else {//应用
            tp = "1";
        }
        StringBuffer sql = new StringBuffer("");
        sql.append(" DELETE FROM " + datasource + ".sys_role_menu ");
        sql.append(" WHERE (role_id=?  and tp=?) ");
        if (!StrUtil.isNull(ids)) {//绑定菜单或应用不为空
            sql.append(" OR (role_id=" + companyroleId + " AND tp=" + tp + " AND menu_id IN (" + ids + ")) ");
        }
        try {
            daoTemplate.update(sql.toString(), companyroleId, menuapplytype);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除角色的对应成员关系
     *
     * @param roleid
     * @param datasource
     */
    public void deleteCompanyRoleUsr(Integer roleid, String datasource) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" delete from " + datasource + ".sys_role_member where role_id=?");
        try {
            daoTemplate.update(sql.toString(), roleid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public void deleteCompanyRoleMember(Integer roleId, Integer memberId, String datasource) {
        daoTemplate.update("DELETE FROM " + datasource + ".sys_role_member WHERE role_id=? AND member_id=?", new Object[]{roleId, memberId});
    }

    /**
     * 批量添加公司的角色成员关系
     *
     * @param usrIds
     * @param roleId
     * @param datasource
     * @return
     */
    public int[] addCompanyRoleUsr(final Integer[] usrIds, final Integer roleId,
                                   String datasource) {
        String sql = " insert into " + datasource + ".sys_role_member(role_id,member_id) values(?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return usrIds.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, roleId);
                    pre.setLong(2, usrIds[num]);
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    public SysRoleMember queryByRoleIdAndMemberId(Integer roleId, Integer memberId, String datasource) {
        List<SysRoleMember> roleMembers = this.daoTemplate.queryForLists("select * from " + datasource + ".sys_role_member where role_id = ? and member_id = ?", SysRoleMember.class, roleId, memberId);
        return Collections3.isNotEmpty(roleMembers) ? roleMembers.get(0) : null;
    }

    public List<SysRoleMember> queryByRoleId(Integer roleId, String datasource) {
        return this.daoTemplate.queryForLists("SELECT DISTINCT * from " + datasource + ".sys_role_member where role_id = ?", SysRoleMember.class, roleId);
    }

    public Long countMemberRoles(Integer memberId, String datasource) {
        StringBuilder sql = new StringBuilder(64)
                .append("SELECT COUNT(DISTINCT m.role_id) FROM ").append(datasource).append(".sys_role_member m")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role r ON m.role_id = r.id_key")
                .append(" WHERE m.member_id = ? AND (r.`status` IS NULL OR r.`status` = ?)");
        return this.daoTemplate.queryForLong(sql.toString(), memberId, 1);
    }

    /**
     * 查询角色的菜单或者应用关联的应用或者菜单ids
     *
     * @param datasource
     * @param companyroleId
     * @param menuapplytype
     * @return
     */
    public Map<String, Object> queryRoleBindIds(String datasource,
                                                Integer companyroleId, String menuapplytype) {
        StringBuffer sql = new StringBuffer();
//		sql.append(" SELECT GROUP_CONCAT(CAST(ma.menu_id AS CHAR)) AS ids FROM "+datasource+".sys_menu_apply ma ");
//		sql.append(" WHERE ma.id in (SELECT GROUP_CONCAT(CAST(rm.menu_id AS CHAR)) FROM "+datasource+".sys_role_menu rm ");
//		sql.append(" WHERE rm.role_id=? and tp=?) ");
        sql.append(" SELECT GROUP_CONCAT(CAST(ma.menu_id AS CHAR)) AS ids ");
        sql.append(" FROM " + datasource + ".sys_role_menu rm, " + datasource + ".sys_menu_apply ma ");
        sql.append(" WHERE rm.menu_id=ma.id AND rm.role_id=? and rm.tp=? AND ma.is_use='1' ");
        try {
            return daoTemplate.queryForMap(sql.toString(), companyroleId, menuapplytype);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量添加角色的菜单或应用信息
     *
     * @param checkedRolemenuList
     * @param datasource
     */
    public int[] saveRoleMenuApply(final Integer companyroleId, final List<SysRoleMenu> checkedRolemenuList,
                                   String datasource) {
        String sql = " insert into " + datasource + ".sys_role_menu(role_id,menu_id,data_tp,tp,sgtjz,mids) values(?,?,?,?,?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return checkedRolemenuList.size();
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, companyroleId);
                    pre.setObject(2, checkedRolemenuList.get(num).getMenuId() == 0 ? null : checkedRolemenuList.get(num).getMenuId());
                    pre.setString(3, StrUtil.isNull(checkedRolemenuList.get(num).getDataTp()) ? null : checkedRolemenuList.get(num).getDataTp());
                    pre.setString(4, checkedRolemenuList.get(num).getTp());
                    pre.setString(5, checkedRolemenuList.get(num).getSgtjz());
                    pre.setString(6, checkedRolemenuList.get(num).getMids());
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }

    }

    /**
     * 根据多个角色查询对应的菜单信息
     *
     * @param datasource
     * @param memberId
     * @return
     */
    public List<Map<String, Object>> queryRoleMenus(String datasource, Integer memberId, Integer pId, FuncSpecificTagEnum specificTag) {
        StringBuilder sql = new StringBuilder(256);
        sql.append("SELECT DISTINCT ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url,");
        sql.append("ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls, menu_tp,ifnull(rm.data_tp,1) as data_tp,ma.apply_no");
        sql.append(" FROM ").append(datasource).append(".sys_menu_apply ma")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role_menu rm ON ma.id=rm.menu_id AND ma.tp=rm.tp")
                .append(" LEFT JOIN ").append(datasource).append(".sys_role_member m ON rm.role_id=m.role_id");
        sql.append(" WHERE ma.is_use = ? AND ma.tp = ? AND m.member_id = ?");
        List<Object> values = Lists.newArrayList();
        values.add("1");
        values.add("1");
        values.add(memberId);
        if (pId != null) {
            //查询下级
            sql.append(" AND ma.p_id = ?");
            values.add(pId);
        }
        if (Objects.nonNull(specificTag)) {
            sql.append(" AND ma.specific_tag = ?");
            values.add(specificTag.getTag());
        } else {
            sql.append(" AND ma.specific_tag IS NULL");
        }
        sql.append(" ORDER BY apply_no ASC, id_key ASC");
        try {
            return daoTemplate.queryForList(sql.toString(), values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysMenuDTO getMenu(String database, Integer menuId, String type) {
        StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT * FROM ").append(database).append(".sys_menu_apply")
                .append(" WHERE id = ? AND tp = ?");
        List<Object> values = Lists.newArrayList();
        values.add(menuId);
        values.add(type);

        List<SysMenuDTO> list = daoTemplate.query(sql.toString(), new Object[]{menuId, type}, (rs, rowNum) -> {
            SysMenuDTO menuDTO = new SysMenuDTO();
            menuDTO.setId(rs.getInt("id"));
            menuDTO.setParentId(rs.getInt("p_id"));
            menuDTO.setType(rs.getString("tp"));
            menuDTO.setName(rs.getString("apply_name"));
            menuDTO.setCode(rs.getString("apply_code"));
            menuDTO.setIcon(rs.getString("apply_icon"));
            menuDTO.setDescription(rs.getString("apply_desc"));
            menuDTO.setMenuType(rs.getString("menu_tp"));
            menuDTO.setAppType(rs.getString("apply_ifwap"));
            menuDTO.setLink(rs.getString("apply_url"));
            menuDTO.setSort(rs.getInt("apply_no"));
            menuDTO.setSpecificTag(FuncSpecificTagEnum.createByTag(rs.getString("specific_tag")));

            return menuDTO;
        });

        return Collections3.isNotEmpty(list) ? list.get(0) : null;
    }

    public List<Map<String, Object>> querySpecificMenus(String database, Integer memberId, Integer parentId, String type, FuncSpecificTagEnum specificTag) {
        StringBuilder sql = new StringBuilder(256);
        sql.append("SELECT DISTINCT ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url,mm.id AS authority_id,ma.specific_tag,");
        sql.append("ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls, menu_tp,ifnull(mm.authority_type,1) as data_tp,ma.apply_no, mm.if_checked, ma.apply_code");
        sql.append(" FROM ").append(database).append(".sys_menu_apply ma")
                .append(" LEFT JOIN ").append(database)
                .append(".sys_member_menu_authority mm ON mm.menu_id = ma.id AND ma.tp = mm.menu_type AND mm.member_id = ?");
        sql.append(" WHERE ma.is_use = ? AND ma.tp = ? AND ma.specific_tag = ?");
        List<Object> values = Lists.newArrayList();
        values.add(memberId);
        values.add("1");
        values.add(type);
        values.add(specificTag.getTag());
        if (parentId != null) {
            //查询下级
            sql.append(" AND ma.p_id = ?");
            values.add(parentId);
        }
        sql.append(" ORDER BY ma.apply_no ASC, ma.id ASC");
        try {
            return daoTemplate.queryForList(sql.toString(), values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<SysApplyDTO> queryAdminRoleMenus(String database, String menuType) {
        StringBuilder sql = new StringBuilder(256);
        sql.append(" SELECT DISTINCT ma.id,ma.apply_name,ma.menu_tp,ma.apply_url,ma.p_id,ma.tp,");
        sql.append(" 1 AS apply_no");//是否被选中

        sql.append(" FROM ").append(database).append(".sys_menu_apply ma")
                .append(" WHERE ma.is_use = ? AND ma.tp = ?");
        List<Object> values = Lists.newArrayList();
        values.add("1");
        values.add(menuType);
        sql.append(" ORDER BY id ASC");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询管理员角色配置
     *
     * @param database
     * @param roleId
     * @param menuType
     * @return
     */
    public List<SysRoleMenu> queryAdminRoleMenuRelative(String database, Integer roleId, String menuType) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT rm.menu_id,rm.sgtjz,rm.mids,rm.data_tp FROM ")
                .append(database).append(".sys_role_menu rm")
                .append(" WHERE rm.role_id = ? AND rm.tp = ?");

        return daoTemplate.queryForLists(sql.toString(), SysRoleMenu.class, new Object[]{roleId, menuType});
    }

    public List<SysApplyDTO> queryRoleMenus(String database, Integer memberId, String menuType) {
        StringBuilder sql = new StringBuilder(256);
        sql.append(" SELECT DISTINCT ma.id,ma.apply_name,ma.menu_tp,ma.apply_url,ma.p_id,ma.tp,rm.sgtjz,rm.mids, ");
        sql.append(" (CASE WHEN rm.id_key IS NOT NULL THEN 1 ELSE 0 END) AS apply_no, ");//是否被选中
        sql.append(" (CASE WHEN rm.data_tp IS NOT NULL THEN rm.data_tp ELSE 1 END) AS menu_leaf, ");//数据查询类型
        sql.append(" (CASE WHEN ma.menu_id IS NULL THEN '0' ELSE ma.menu_id END) AS menu_id ");//绑定菜单或应用id

        sql.append(" FROM ").append(database).append(".sys_menu_apply ma")
                .append(" LEFT JOIN ").append(database).append(".sys_role_menu rm ON ma.id=rm.menu_id AND ma.tp=rm.tp")
                .append(" LEFT JOIN ").append(database).append(".sys_role_member m ON rm.role_id=m.role_id");
        sql.append(" WHERE ma.is_use = ? AND ma.tp = ? AND m.member_id = ?");
        List<Object> values = Lists.newArrayList();
        values.add("1");
        values.add(menuType);
        values.add(memberId);
        sql.append(" ORDER BY ma.apply_name ASC, ma.id ASC");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, values.toArray(new Object[values.size()]));
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<Map<String, Object>> queryRoleMenusByNms(String datasource, String roleIds, String nms) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp,rm.data_tp ");
        sql.append(" FROM " + datasource + ".sys_menu_apply ma," + datasource + ".sys_role_menu rm ");
        sql.append(" WHERE ma.id=rm.menu_id AND ma.is_use='1' AND rm.tp='1' AND rm.role_id IN (" + roleIds + ") ");
        sql.append(" and ma.apply_name in(" + nms + ")");
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<Map<String, Object>> queryAdminMenuByCodes(String datasource, String menuCodes, String menuType) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
        sql.append(" FROM " + datasource + ".sys_menu_apply ma ");
        sql.append(" WHERE ma.is_use='1' and ma.menu_tp='" + menuType + "' AND ma.tp='1'");
        if (!StrUtil.isNull(menuCodes)) {
            sql.append(" AND ma.apply_code in ('" + menuCodes + "')");
        }
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<Map<String, Object>> queryAdminAppByCodes(String datasource, String menuCodes, String menuType) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
        sql.append(" FROM " + datasource + ".sys_menu_apply ma ");
        sql.append(" WHERE ma.is_use='1' and ma.menu_tp='" + menuType + "' AND ma.tp='2'");
        if (!StrUtil.isNull(menuCodes)) {
            sql.append(" AND ma.apply_code in ('" + menuCodes + "')");
        }
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

//    public List<Map<String, Object>> queryRoleButtonByCodes(String datasource, String roleIds, String btnCodes) {
//        StringBuffer sql = new StringBuffer("");
//        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
//        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
//        sql.append(" FROM " + datasource + ".sys_menu_apply ma," + datasource + ".sys_role_menu rm ");
//        sql.append(" WHERE ma.id=rm.menu_id AND ma.is_use='1' and ma.menu_tp='1' AND ma.tp='1'  ");
//        if (!StrUtil.isNull(roleIds)) {//非创建人角色
//            sql.append(" AND rm.role_id IN (" + roleIds + ") ");
//        } else {//创建人角色
//            sql = new StringBuffer("");
//            sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
//            sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
//            sql.append(" FROM " + datasource + ".sys_menu_apply ma ");
//            sql.append(" WHERE ma.is_use='1' and ma.menu_tp='1' AND ma.tp='1'  ");
//        }
//        if (!StrUtil.isNull(btnCodes)) {
//            sql.append(" and ma.apply_code in ('" + btnCodes + "')");
//        }
//        try {
//            return daoTemplate.queryForList(sql.toString());
//        } catch (Exception e) {
//            throw new DaoException(e);
//        }
//    }

    /**
     * @param datasource
     * @param roleIds
     * @param menuCodes
     * @param menuType   0-菜单，1-按钮
     * @return
     */
    public List<Map<String, Object>> queryRoleMenuByCodes(String datasource, String roleIds, String menuCodes, String menuType) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
        sql.append(" FROM " + datasource + ".sys_menu_apply ma," + datasource + ".sys_role_menu rm ");
        sql.append(" WHERE ma.id=rm.menu_id AND ma.is_use='1' and ma.menu_tp='" + menuType + "' AND ma.tp='1'");
        sql.append(" AND rm.role_id IN (" + roleIds + ") ");
        if (!StrUtil.isNull(menuCodes)) {
            sql.append(" AND ma.apply_code in ('" + menuCodes + "')");
        }
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public List<Map<String, Object>> queryRoleAppByCodes(String datasource, String roleIds, String menuCodes, String menuType) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT distinct ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url, ");
        sql.append(" ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp ");
        sql.append(" FROM " + datasource + ".sys_menu_apply ma," + datasource + ".sys_role_menu rm ");
        sql.append(" WHERE ma.id=rm.menu_id AND ma.is_use='1' and ma.menu_tp='" + menuType + "' AND ma.tp='2'");
        sql.append(" AND rm.role_id IN (" + roleIds + ") ");
        if (!StrUtil.isNull(menuCodes)) {
            sql.append(" AND ma.apply_code in ('" + menuCodes + "')");
        }
        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据父菜单查询子菜单
     *
     * @param datasource
     * @param pId
     * @return
     */
    public List<Map<String, Object>> queryRoleMenusForCreator(
            String datasource, Integer pId) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT ma.id AS id_key,ma.apply_name AS menu_nm,ma.menu_leaf,ma.apply_url AS menu_url,");
        sql.append("ma.p_id,ma.apply_code AS menu_cd,ma.apply_icon AS menu_cls,ma.menu_tp,'1' AS data_tp,ma.apply_no");
        sql.append(" FROM ").append(datasource).append(".sys_menu_apply ma ");
        sql.append(" WHERE ma.is_use='1' AND ma.tp='1' ");
        if (!StrUtil.isNull(pId)) {//查询下级
            sql.append(" and ma.p_id=" + pId);
        }

        sql.append(" ORDER BY apply_no ASC, id_key ASC");

        try {
            return daoTemplate.queryForList(sql.toString());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询公司角色列表
     *
     * @param datasource
     * @return
     */
    public List<SysRole> queryRoleList(String datasource) {
        StringBuffer sql = new StringBuffer("");
        sql.append("SELECT * FROM " + datasource + ".sys_role where status is null or status =1 ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysRole.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量添加成员角色
     *
     * @param roleArray
     * @param memId
     * @param datasource
     */
    public int[] addUsrRoles(final String[] roleArray, final Integer memId, String datasource) {
        String sql = " insert into " + datasource + ".sys_role_member(role_id,member_id) values(?,?) ";
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                @Override
                public int getBatchSize() {
                    return roleArray.length;
                }

                @Override
                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, Integer.parseInt(roleArray[num]));
                    pre.setLong(2, memId);
                }
            };
            return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new DaoException(ex);
        }
    }

    /**
     * 根据成员删除角色关系
     *
     * @param memberId
     * @param datasource
     */
    public void deleteRoleByMem(Integer memberId, String datasource) {
        String sql = "DELETE FROM " + datasource + ".sys_role_member WHERE member_id=? AND NOT EXISTS ("
                + "SELECT 1 FROM " + datasource + ".sys_role WHERE sys_role_member.role_id = sys_role.id_key AND role_cd IN (?,?)" +
                ")";
        try {
            daoTemplate.update(sql, memberId, RoleValueEnum.COMPANY_CREATOR.getCode(), RoleValueEnum.COMPANY_ADMIN.getCode());
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 删除指定角色的会员
     *
     * @param database
     * @param roleId   角色 id
     * @param memberId 会员 id
     * @return
     */
    public Integer deleteCustomRoleByMemberId(String database, Integer roleId, Integer memberId) {
        final StringBuilder sql = new StringBuilder(32);
        sql.append("DELETE FROM ").append(database).append(".sys_role_member WHERE role_id=? AND member_id=?");
        return daoTemplate.update(sql.toString(), new Object[]{roleId, memberId});
    }

    /**
     * 根据成员查询角色
     *
     * @param memId
     * @param datasource
     * @return
     */
    public Map<String, Object> queryRoleByMemid(Integer memId, String datasource) {
        String sql = "SELECT GROUP_CONCAT(CAST(role_id AS CHAR)) AS roleIds FROM " + datasource + ".sys_role_member WHERE member_id=?";
        try {
            return daoTemplate.queryForMap(sql, memId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据成员查询角色,以最小id最为角色值
     *
     * @param memId
     * @param datasource
     * @return
     */
    public Map<String, Object> queryRoleByMemidForMin(Integer memId, String datasource) {
        String sql = "SELECT MIN(role_id) AS roleId FROM " + datasource + ".sys_role_member WHERE member_id=?";
        try {
            return daoTemplate.queryForMap(sql, memId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据角色编号查询角色
     *
     * @param roleCd
     * @param datasource
     * @return
     */
    public SysRole queryRoleByRolecd(String roleCd, String datasource) {
        String sql = "SELECT * FROM " + datasource + ".sys_role WHERE role_cd=?";
        try {
            return daoTemplate.queryForObj(sql, SysRole.class, roleCd);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysRole queryRoleById(final String database, Integer id) {
        return daoTemplate.queryForObj("SELECT * FROM " + database + ".sys_role WHERE id_key = ?", SysRole.class, id);
    }

    /**
     * 添加成员角色
     *
     * @param roleMember
     * @param datasource
     */
    public int addCompanyRolemember(SysRoleMember roleMember, String datasource) {
        try {
            return this.daoTemplate.addByObject(datasource + ".sys_role_member", roleMember);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 查询公司创建者的菜单权限（全部menu菜单）
     *
     * @param datasource
     */
    public List<Map<String, Object>> queryRoleForCompanyAdmin(String datasource) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT id AS id_key,apply_name AS menu_nm,menu_leaf,apply_url AS menu_url,");
        sql.append("p_id,apply_code AS menu_cd,apply_icon AS menu_cls,menu_tp,'1' AS data_tp,apply_no");
        sql.append(" FROM ").append(datasource).append(".sys_menu_apply WHERE is_use='1' AND tp='1'");
        sql.append(" ORDER BY apply_no ASC, id_key ASC");
        try {
            return this.daoTemplate.queryForList(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<Map<String, Object>> queryRoleForCompanyAdminByNms(String datasource, String nms) {
        StringBuffer sql = new StringBuffer(128);
        sql.append(" SELECT DISTINCT id AS id_key,apply_name AS menu_nm,menu_leaf,apply_url AS menu_url, ");
        sql.append(" p_id,apply_code AS menu_cd,apply_icon AS menu_cls,menu_tp,'1' AS data_tp ");
        sql.append("  FROM " + datasource + ".sys_menu_apply WHERE is_use='1' AND tp='1' ").append(" and apply_name in (" + nms + ")");
        try {
            return this.daoTemplate.queryForList(sql.toString());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 查询成员是否为某个角色
     *
     * @param roleCd
     * @param memId
     * @param database
     * @return
     */
    public SysRole queryMemberRoleByRolecd(String roleCd, Integer memId,
                                           String database) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT r.* FROM ").append(database).append(".sys_role_member rm, ")
                .append(database).append(".sys_role r ");
        sql.append(" WHERE rm.role_id=r.id_key AND rm.member_id=? AND r.role_cd=? ");
        try {
            return this.daoTemplate.queryForObj(sql.toString(), SysRole.class, memId, roleCd);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据角色，菜单修改用户
     *
     * @param roleid
     * @param datasource
     */
    public void updateUsrByjc(Integer roleid, Integer cdid, String mids, String datasource) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" update " + datasource + ".sys_role_menu set data_tp=4,mids=? where role_id=? and menu_id=?");
        try {
            daoTemplate.update(sql.toString(), mids, roleid, cdid);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询指定角色会员
     *
     * @param database
     * @param roleId   角色 id
     * @return
     */
    public List<SysRoleMemberDTO> queryRoleMemberByRoleId(String database, Integer roleId) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT m.*,r.role_cd FROM ").append(database).append(".sys_role_member m")
                .append(" LEFT JOIN ").append(database).append(".sys_role r ON m.role_id = r.id_key")
                .append(" WHERE m.role_id=?");
        return this.daoTemplate.query(sql.toString(), new Object[]{roleId}, new SysRoleMemberRowMapper());
    }

    /**
     * 查询会员所有角色
     *
     * @param database
     * @param memberId
     * @return
     */
    public List<SysRoleMemberDTO> queryRoleMemberByMemberId(String database, Integer memberId) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT m.*,r.role_cd,r.role_nm FROM ").append(database).append(".sys_role_member m")
                .append(" LEFT JOIN ").append(database).append(".sys_role r ON m.role_id = r.id_key")
                .append(" WHERE m.member_id=?");
        return this.daoTemplate.query(sql.toString(), new Object[]{memberId}, new SysRoleMemberRowMapper());
    }

    private static class SysRoleMemberRowMapper implements RowMapper<SysRoleMemberDTO> {

        @Override
        public SysRoleMemberDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            SysRoleMemberDTO roleMember = new SysRoleMemberDTO();
            roleMember.setRoleId(rs.getInt("role_id"));
            roleMember.setMemberId(rs.getInt("member_id"));
            roleMember.setRoleCode(rs.getString("role_cd"));
            roleMember.setRoleName(rs.getString("role_nm"));
            return roleMember;
        }
    }

    /**
     * 检查是否有设置过管理员
     *
     * @param database
     * @param roleCode
     * @return
     */
    public Boolean hasSettingAdmin(String database, String roleCode) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT COUNT(1) FROM ").append(database).append(".sys_role_member m")
                .append(" LEFT JOIN ").append(database).append(".sys_role r ON m.role_id=r.id_key")
                .append(" WHERE r.role_cd = ?");
        Integer count = this.daoTemplate.queryForInt(sql.toString(), new Object[]{roleCode});
        return count > 0;
    }

    /**
     * 当前员工是否拥有指定角色
     *
     * @param database
     * @param roleId   指定角色 id
     * @param memberId 员工 id
     * @return
     */
    public Boolean hasCustomRoleByMemberId(String database, Integer roleId, Integer memberId) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT COUNT(1) FROM ").append(database).append(".sys_role_member WHERE role_id=? AND member_id=?");
        Integer count = this.daoTemplate.queryForInt(sql.toString(), new Object[]{roleId, memberId});
        return count > 0;
    }

    /**
     * 统计指定角色数量
     *
     * @param database
     * @param roleId
     * @return
     */
    public Integer countCustomRole(String database, Integer roleId) {
        final StringBuilder sql = new StringBuilder(64);
        sql.append("SELECT COUNT(1) FROM ").append(database).append(".sys_role_member WHERE role_id=?");

        return this.daoTemplate.queryForInt(sql.toString(), new Object[]{roleId});
    }

    public void updateMemberAuthority(Integer authorityId, Integer memberId, Integer menuType, Integer menuId, Integer authorityType,String ifChecked,
                                      String database) {
        if (Objects.nonNull(authorityId)) {
            Integer check;
            if("false".equals(ifChecked)){
                check = 0;
            }else{
                check = 1;
            }
            this.daoTemplate.update("update " + database + ".sys_member_menu_authority set authority_type = ?, if_checked = ? where id = ?",
                    new Object[]{authorityType,check, authorityId, });
        } else {
            Map<String, Object> valueMap = Maps.newHashMap();
            valueMap.put("member_id", memberId);
            valueMap.put("menu_id", menuId);
            valueMap.put("menu_type", menuType);
            valueMap.put("authority_type", authorityType);
            if("false".equals(ifChecked)){
                valueMap.put("if_checked", 0);
            }else{
                valueMap.put("if_checked", 1);
            }

            this.daoTemplate.saveEntityAndGetKey(database, "sys_member_menu_authority", valueMap);
        }
    }

    public static final byte[] TAG = new byte[0];

    public <E> void getParentMenu(String database, Integer menuId, String type, Map<String, byte[]> menuIdCache, List<E> originList,
                                  MenuConverter<E> converter) {
        while (MathUtils.valid(menuId)) {
            byte[] tag = menuIdCache.get(menuId.toString());
            if (Objects.nonNull(tag)) {
                return;
            }
            menuIdCache.put(menuId.toString(), TAG);
            SysMenuDTO menuDTO = getMenu(database, menuId, type);
            if (Objects.nonNull(menuDTO)) {
                originList.add(converter.convertMenu(menuDTO));

                menuId = menuDTO.getParentId();
            } else {
                return;
            }
        }
    }

    /**
     * 查询企业端口数会员 id
     *
     * @param database
     * @return
     */
    public List<Integer> queryCompanyPortMember(final String database) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT rm.member_id FROM ").append(database).append(".sys_role_member rm")
                .append(" LEFT JOIN ").append(database).append(".sys_mem m ON rm.member_id = m.member_id");

        sql.append(" WHERE m.member_use = ?")
                .append(" AND NOT EXISTS (")
                .append("SELECT 1 FROM ").append(database).append(".sys_role r WHERE rm.role_id = r.id_key")
                .append(" AND r.role_cd IN (?,?,?,?,?)")
                .append(") ORDER BY rm.member_id ASC");

        List<Object> values = Lists.newArrayListWithCapacity(6);
        values.add(1);
        values.add(RoleValueEnum.COMPANY_CREATOR.getCode()); // 创建者
        values.add(RoleValueEnum.COMPANY_ADMIN.getCode()); // 管理员
        values.add(RoleValueEnum.GENERAL_STAFF.getCode()); // 普通员工
        values.add(RoleValueEnum.EXECUTIVE_STAFF.getCode()); // 行政职员
        values.add(RoleValueEnum.BUSINESS_PEOPLE.getCode()); // 外勤人员

        return daoTemplate.query(sql.toString(), values.toArray(new Object[values.size()]), new RowMapper<Integer>() {
            @Override
            public Integer mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getInt("member_id");
            }
        });
    }
}
