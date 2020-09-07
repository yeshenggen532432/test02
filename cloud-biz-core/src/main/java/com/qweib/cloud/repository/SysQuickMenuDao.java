package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQuickMenu;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQuickMenuDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

    public SysQuickMenu getById(Integer id, String database) {
        String sql = "select * from " + database + ".sys_quick_menu where id='" + id + "'";
        List<SysQuickMenu> list = this.daoTemplate.queryForLists(sql, SysQuickMenu.class);
        if (list.size() > 0) return list.get(0);
        return null;
    }

    public SysQuickMenu getByMenuId(SysQuickMenu vo, String database) {
        String sql = "select * from " + database + ".sys_quick_menu where menu_id='" + vo.getMenuId() + "' and member_Id=" + vo.getMemberId() + " ";
        List<SysQuickMenu> list = this.daoTemplate.queryForLists(sql, SysQuickMenu.class);
        if (list.size() > 0) return list.get(0);
        return null;
    }


    public int add(SysQuickMenu vo, String database) {
        try {

            return this.daoTemplate.addByObject("" + database + ".sys_quick_menu", vo);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysQuickMenu queryById(Integer id, String database) {
        String sql = "select * from " + database + ".sys_quick_menu where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysQuickMenu.class, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }

    }

    public int updateSort(SysQuickMenu sysQuickMenu, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id",sysQuickMenu.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_quick_menu", sysQuickMenu, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int delete(Integer id, String database) {
        String sql = "delete from " + database + ".sys_quick_menu where id=?";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int update(SysQuickMenu vo, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", vo.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_quick_menu", vo, whereParam, "id");
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public Page pages(SysQuickMenu vo, String menuIds, String database, Integer page, Integer limit) {
        String sql = "select a.*,b.apply_name as menu_name,b.apply_url from " + database + ".sys_quick_menu a left join " + database + ".sys_menu_apply b on a.menu_id= b.id  where 1=1 and b.tp=1 ";
        if (vo != null) {
            if (!StrUtil.isNull(vo.getMemberId())) {
                sql = sql + " and a.member_id=" + vo.getMemberId();
            }
        }
        if (!StrUtil.isNull(menuIds)) {
            sql = sql + " and b.id in (" + menuIds + ")";
        }
        sql = sql + " order by a.sort asc";
        return this.daoTemplate.queryForPageByMySql(sql, page, limit, SysQuickMenu.class);
    }
}
