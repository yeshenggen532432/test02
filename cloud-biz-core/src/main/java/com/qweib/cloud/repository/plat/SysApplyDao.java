package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysApplyDTO;
import com.qweib.cloud.core.domain.SysApplyShowDTO;
import com.qweib.cloud.core.domain.SysMenu;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.service.basedata.common.FuncSpecificTagEnum;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.TreeMode;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysApplyDao {
    @Resource(name = "pdaoTemplate")
    private JdbcDaoTemplatePlud pdaoTemplate;
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    /**
     * 根据id查询应用信息
     *
     * @param idKey
     * @return
     */
    public SysApplyDTO queryApplyById(Integer idKey) {
        StringBuffer sql = new StringBuffer();
        if (null != idKey) {
            sql.append(" select * from sys_apply where id=").append(idKey);
        } else {
            sql.append(" select * from sys_apply where p_id=0 order by apply_no asc limit 0,1 ");
        }
        try {
            return pdaoTemplate.queryForObj(sql.toString(), SysApplyDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 添加移动端应用
     *
     * @param applyDTO
     * @return
     */
    public int addApply(SysApplyDTO applyDTO) {
        try {
            return pdaoTemplate.addByObject("sys_apply", applyDTO);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据父级id查询子应用个数
     *
     * @param pid
     * @return
     */
    public Integer getApplySizeByPid(Integer pid) {
        StringBuffer sql = new StringBuffer(" select count(1) from sys_apply where p_id=").append(pid);
        try {
            return pdaoTemplate.queryForObject(sql.toString(), Integer.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 更新应用
     *
     * @param applyDTO
     * @return
     */
    public int updateApply(SysApplyDTO applyDTO) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", applyDTO.getId());
            return this.pdaoTemplate.updateByObject("sys_apply", applyDTO, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 查询功能应用(x)
     *
     * @param leftId
     * @return
     */
    public List<TreeMode> querySysApply(Integer leftId) {
        StringBuffer sql = new StringBuffer();
        sql.append(" select id as tree_id,apply_name as tree_nm,menu_tp as tree_leaf,apply_url as tree_url,p_id from sys_apply where 1=1 ");
        if (null != leftId) {
            sql.append(" and p_id=").append(leftId);
        }
        sql.append(" order by apply_no asc ");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), TreeMode.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<SysMenu> queryApplyListForCor(String applys) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT m.id as id_key,m.apply_name as menu_nm,m.menu_tp,m.p_id, ");
        if (StrUtil.isNull(applys)) {//为空
            sql.append(" 0 AS menu_seq ");
        } else {
            sql.append("(CASE WHEN id IN (" + applys + ") THEN 1 ELSE 0 END ) AS menu_seq ");
        }
        sql.append(" FROM sys_apply m WHERE m.is_use='1' order by m.apply_no asc ");
        try {
            return pdaoTemplate.queryForLists(sql.toString(), SysMenu.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 根据成员角色查询菜单信息
     *
     * @param memId
     * @param applyCode
     * @param database
     * @return
     */
    public List<SysApplyDTO> queryApplyByMemberRole(Integer memId,
                                                    String applyCode, String database) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT ma.*,rmu.data_tp,rmu.sgtjz,rmu.mids,'").append(applyCode).append("' AS menu_nm FROM ")
                .append(database).append(".sys_menu_apply ma");
        sql.append(" LEFT JOIN ").append(database).append(".sys_role_menu rmu ON ma.id = rmu.menu_id AND ma.tp = rmu.tp");
        sql.append(" LEFT JOIN ").append(database).append(".sys_role_member rm ON rmu.role_id = rm.role_id");
        sql.append(" WHERE ma.p_id = ( SELECT id FROM ").append(database).append(".sys_menu_apply WHERE apply_code=? AND is_use='1' )");
        sql.append(" AND rm.member_id=?");
        sql.append(" AND ma.tp='2' AND ma.is_use='1' ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, applyCode, memId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<SysApplyShowDTO> queryApplyByMemberRole(Integer memId, String database) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT ma.*,rmu.data_tp,rmu.sgtjz,rmu.mids FROM ")
                .append(database).append(".sys_menu_apply ma");
        sql.append(" LEFT JOIN ").append(database).append(".sys_role_menu rmu ON ma.id = rmu.menu_id AND ma.tp = rmu.tp");
        sql.append(" LEFT JOIN ").append(database).append(".sys_role_member rm ON rmu.role_id = rm.role_id");
        sql.append(" WHERE rm.member_id = ?");
        sql.append(" AND rmu.tp='2' AND ma.is_use='1' ")
                .append(" ORDER BY  ma.p_id,ma.id ASC");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyShowDTO.class, memId);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<SysApplyShowDTO> querySpecificApply(Integer memberId, FuncSpecificTagEnum specificTag, String database, String type) {
        StringBuilder sql = new StringBuilder(128);
        sql.append("SELECT DISTINCT ma.*,ifnull(mm.authority_type,1) AS data_tp, mm.if_checked FROM ")
                .append(database).append(".sys_menu_apply ma");
        sql.append(" LEFT JOIN ").append(database).append(".sys_member_menu_authority mm ON mm.menu_id = ma.id AND ma.tp = mm.menu_type AND mm.member_id = ? ");
        sql.append(" WHERE ma.tp=? AND ma.is_use='1' AND ma.specific_tag = ? AND (mm.if_checked IS NULL OR mm.if_checked = 1)")
                .append(" ORDER BY ma.apply_no ASC, ma.id ASC");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyShowDTO.class, memberId, type, specificTag.getTag());
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    //根据成员角色查询菜单信息(公司管理员)
    public List<SysApplyDTO> queryApplyForCreator(String applyCode,
                                                  String database) {
        StringBuffer sql = new StringBuffer();
        sql.append(" SELECT ma.*,'1' AS data_tp,'" + applyCode + "' AS menu_nm FROM " + database + ".sys_menu_apply ma ");
        sql.append(" WHERE ma.p_id=(SELECT id FROM " + database + ".sys_menu_apply WHERE apply_code=? AND is_use='1' ) ");
        sql.append(" AND ma.tp='2' AND ma.is_use='1' ");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, applyCode);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    public List<SysApplyShowDTO> queryApplyForCreator(String database) {
        StringBuilder sql = new StringBuilder(32);
        sql.append(" SELECT ma.*,'1' AS data_tp FROM ").append(database).append(".sys_menu_apply ma ");
        sql.append(" WHERE 1=1 AND ma.tp='2' AND ma.is_use='1'")
        .append(" ORDER BY ma.id ASC");
        try {
            return daoTemplate.queryForLists(sql.toString(), SysApplyShowDTO.class);
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 删除应用
     *
     * @param idKey
     * @return
     */
    public int deleteApply(Integer idKey) {
        String sql = " delete from sys_apply where id=? ";
        try {
            return this.pdaoTemplate.update(sql, idKey);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 根据id获取应用(删除操作)
     *
     * @param pid
     * @return
     */
    public SysApplyDTO queryApplyForDel(Integer pid) {
        StringBuffer sql = new StringBuffer();
        try {
            SysApplyDTO apply = null;
            if (pid != 0) {
                //查找父菜单下的第条记录
                sql.append(" select * from sys_apply where p_id=").append(pid).append(" order by apply_no asc limit 0,1 ");
                apply = pdaoTemplate.queryForObj(sql.toString(), SysApplyDTO.class);
                if (null == apply) {
                    sql.setLength(0);
                    //父菜单下没有子菜单显示父菜单
                    sql.append(" select * from sys_apply where id=").append(pid);
                    apply = pdaoTemplate.queryForObj(sql.toString(), SysApplyDTO.class);
                }
            } else {
                //查询第一级别的菜单
                sql.append(" select * from sys_apply where p_id=0 order by apply_no asc limit 0,1 ");
                apply = pdaoTemplate.queryForObj(sql.toString(), SysApplyDTO.class);
            }
            return apply;
        } catch (Exception ex) {
            throw new DaoException(ex);
        }
    }

    /**
     * 查询默认公司配置菜单
     *
     * @return
     */
    public List<SysApplyDTO> queryApplyForCompany(Integer roleId) {
        StringBuffer sql = new StringBuffer("");
        sql.append(" SELECT m.id_key AS id,m.menu_nm AS apply_name,m.menu_cd AS apply_code,m.menu_url AS apply_url,m.menu_cls AS apply_icon, ");
        sql.append(" m.p_id,m.menu_tp, m.menu_seq AS apply_no,m.is_use, m.menu_leaf, m.menu_remo AS apply_desc , '1' as tp, ");
        sql.append(" (select id from sys_apply where menu_id=id_key ) as menu_id,NULL AS apply_ifwap,NULL AS create_by,NULL AS create_date ");
        sql.append(" FROM sys_menu m ,sys_role_menu rm WHERE m.id_key=rm.menu_id AND rm.role_id=? AND m.is_use='1'");
        sql.append(" UNION ALL ");
        sql.append(" SELECT id,apply_name,apply_code,apply_url,apply_icon,p_id,menu_tp,apply_no,is_use,menu_leaf,apply_desc,'2' as tp,   menu_id, ");
        sql.append(" apply_ifwap,create_by,create_date FROM sys_apply ");
        try {
            return this.pdaoTemplate.queryForLists(sql.toString(), SysApplyDTO.class, roleId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    /**
     * 调用存储过程更新子库中的菜单应用信息
     */
    public void updateApplyToProcedure(SysApplyDTO applyDTO) {
        String sql = " {call easymobapplyupdate(?,?,?,?,?,?,?,?,?,?,?,?,?,?)} ";
        try {
            String applyIcon = StrUtil.isNull(applyDTO.getApplyIcon()) ? "" : applyDTO.getApplyIcon();
            String applyDesc = StrUtil.isNull(applyDTO.getApplyDesc()) ? "" : applyDTO.getApplyDesc();
            String applyIfwap = StrUtil.isNull(applyDTO.getApplyIfwap()) ? "" : applyDTO.getApplyIfwap();
            String applyUrl = StrUtil.isNull(applyDTO.getApplyUrl()) ? "" : applyDTO.getApplyUrl();
            Integer menuId = StrUtil.isNull(applyDTO.getMenuId()) ? 0 : applyDTO.getMenuId();
            this.pdaoTemplate.update(sql, applyDTO.getId(), applyDTO.getApplyName(), applyDTO.getApplyCode(),
                    applyIcon, applyDesc, applyIfwap, applyUrl, applyDTO.getApplyNo(), applyDTO.getPId(), applyDTO.getMenuTp(),
                    applyDTO.getMenuLeaf(), applyDTO.getIsUse(), "2", menuId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
}
