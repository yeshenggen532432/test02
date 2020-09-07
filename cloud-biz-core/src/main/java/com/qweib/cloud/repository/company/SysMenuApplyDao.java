package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Repository
public class SysMenuApplyDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;
    @Resource
    private JdbcDaoTemplatePlud pdaoTemplate;

    /**
     * 查询公司的菜单
     *
     * @param datasource
     * @return
     */
    public Map<String, Object> queryMenuApplyByTp(String datasource, String tp) {
        String sql = " SELECT GROUP_CONCAT(CAST(id AS char(20))) menuApplys from " + datasource + ".sys_menu_apply where tp =? AND is_use='1' ";
        try {
            return daoTemplate.queryForMap(sql, tp);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 删除菜单
     *
     * @param datasource
     */
    public void deleteMenuApplys(String datasource, String tp, String ids) {
        StringBuffer sql = new StringBuffer("");
        sql.append("DELETE FROM " + datasource + ".sys_menu_apply WHERE tp=? AND is_use='1' ");
        if (!StrUtil.isNull(ids)) {//不为空
            sql.append(" or id in (" + ids + ") ");
        }
        try {
            daoTemplate.update(sql.toString(), tp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id查询菜单信息
     *
     * @param ids
     * @return
     */
    public List<SysApplyDTO> queryMenuByIds(String ids) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" SELECT id_key AS id,menu_nm AS apply_name,menu_cd AS apply_code,menu_url AS apply_url,menu_cls AS apply_icon, ");
        sql.append("  p_id,menu_tp, menu_seq AS apply_no,is_use, menu_leaf, menu_remo AS apply_desc , '1' as tp,  ");
        sql.append(" (select id from sys_apply where menu_id=id_key AND is_use='1') as menu_id ");
        sql.append(" FROM sys_menu WHERE id_key IN (" + ids + ") ");
        try {
            return pdaoTemplate.queryForLists(sql.
                    toString(), SysApplyDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id查询应用信息
     *
     * @param ids
     * @return
     */
    public List<SysApplyDTO> queryApplyByIds(String ids) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" SELECT id,apply_name,apply_code,apply_icon,apply_desc,apply_ifwap,apply_url, ");
        sql.append("  apply_no,p_id,menu_tp, menu_leaf, create_by, create_date, is_use, '2' as tp, menu_id ");
        sql.append(" FROM sys_apply WHERE id IN (" + ids + ") AND is_use='1' ");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SysApplyDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 批量添加公司菜单
     *
     * @param menuList
     */
    public int[] saveCorporationMenuApply(final List<SysApplyDTO> menuList, String datasource) {
        StringBuffer sql = new StringBuffer(" INSERT INTO " + datasource);
        sql.append(" .sys_menu_apply(id, apply_name,apply_code,apply_icon,apply_desc,apply_ifwap,apply_url, ");
        sql.append(" apply_no,p_id,menu_tp,menu_leaf,create_by,create_date,is_use,tp,menu_id) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ");
        try {
            BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
                public int getBatchSize() {
                    return menuList.size();
                }

                public void setValues(PreparedStatement pre, int num)
                        throws SQLException {
                    pre.setInt(1, menuList.get(num).getId());
                    pre.setString(2, menuList.get(num).getApplyName());
                    pre.setString(3, menuList.get(num).getApplyCode());
                    if (!StrUtil.isNull(menuList.get(num).getApplyIcon())) {
                        pre.setString(4, menuList.get(num).getApplyIcon());
                    } else {
                        pre.setString(4, null);
                    }
                    pre.setString(5, menuList.get(num).getApplyDesc());
                    if (!StrUtil.isNull(menuList.get(num).getApplyIfwap())) {
                        pre.setString(6, menuList.get(num).getApplyIfwap());
                    } else {
                        pre.setString(6, null);
                    }
                    pre.setString(7, menuList.get(num).getApplyUrl());
                    pre.setInt(8, menuList.get(num).getApplyNo());
                    pre.setInt(9, menuList.get(num).getPId());
                    pre.setString(10, menuList.get(num).getMenuTp());
                    pre.setString(11, menuList.get(num).getMenuLeaf());
                    if (!StrUtil.isNull(menuList.get(num).getCreateBy())) {
                        pre.setString(12, menuList.get(num).getCreateBy());
                    } else {
                        pre.setString(12, null);
                    }
                    if (!StrUtil.isNull(menuList.get(num).getCreateDate())) {
                        pre.setString(13, menuList.get(num).getCreateDate());
                    } else {
                        pre.setString(13, null);
                    }
                    pre.setString(14, menuList.get(num).getIsUse());
                    pre.setString(15, menuList.get(num).getTp());
                    pre.setObject(16, menuList.get(num).getMenuId() == null ? null : menuList.get(num).getMenuId());
                }
            };
            return daoTemplate.batchUpdate(sql.toString().toUpperCase(), setter);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 查询绑定的应用信息
     *
     * @param ids
     * @return
     */
    public List<SysApplyDTO> queryBindApply(String ids) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" select id,apply_name,apply_code,apply_icon,apply_desc,apply_ifwap,apply_url, ");
        sql.append("  apply_no,p_id,menu_tp, menu_leaf, create_by, create_date, is_use, '2' as tp, menu_id ");
        sql.append("  from sys_apply where menu_id in (" + ids + ") AND is_use='1'");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SysApplyDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询绑定的菜单信息
     *
     * @param ids
     * @return
     */
    public List<SysApplyDTO> queryBindMenu(String ids) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" SELECT m.id_key AS id,m.menu_nm AS apply_name,m.menu_cd AS apply_code,m.menu_url AS apply_url,m.menu_cls AS apply_icon, ");
        sql.append("  m.p_id,m.menu_tp, m.menu_seq AS apply_no,m.is_use, m.menu_leaf, m.menu_remo AS apply_desc , '1' as tp,a.id as menu_id  ");
        sql.append(" FROM sys_apply a , sys_menu m WHERE a.menu_id=m.id_key ");
        sql.append(" AND a.id IN (" + ids + ") AND m.is_use='1'");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SysApplyDTO.class);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询绑定的菜单或应用
     *
     * @param datasource
     * @param tp
     * @return
     */
    public Map<String, Object> queryBindIds(String datasource, String tp) {
        StringBuffer sql = new StringBuffer("");
        sql.append("select GROUP_CONCAT(CAST(menu_id as char(20))) as ids FROM " + datasource + ".sys_menu_apply ");
        sql.append(" WHERE menu_id  IS NOT NULL AND tp = ? AND is_use='1' ");
        try {
            return daoTemplate.queryForMap(sql.toString(), tp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id查询信息
     *
     * @param id
     * @return
     */
    public SysApplyDTO queryMenuapplyById(Integer id, String tp, String datasource) {
        String sql = "SELECT * FROM " + datasource + ".sys_menu_apply WHERE id=? AND tp=? AND is_use='1' ";
        try {
            return daoTemplate.queryForObj(sql, SysApplyDTO.class, id, tp);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
