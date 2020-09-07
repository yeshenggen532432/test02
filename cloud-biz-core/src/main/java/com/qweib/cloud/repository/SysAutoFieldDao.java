package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysAutoField;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysAutoFieldDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;

	public Page querySysAutoFieldPage(SysAutoField auto, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.*,c.type_name as cost_type_name,b.item_name as cost_item_name from "+database+".sys_auto_field a  left join " + database + ".fin_costitem b on a.cost_item_id=b.id left join " + database + ".fin_costtype c on a.cost_type_id=c.id where 1=1 ");
		if(auto!=null){
			if(!StrUtil.isNull(auto.getStatus())){
                sql.append(" and a.status= '").append(auto.getStatus()).append("'");
			}
		}
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysAutoField.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysAutoField> queryList(SysAutoField auto, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_auto_field a ");
        sql.append(" where 1=1 ");
        if (auto != null) {
            if (!StrUtil.isNull(auto.getStatus())) {
                sql.append(" and a.status='").append(auto.getStatus()).append("'");
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysAutoField.class);
    }


	public int addSysAutoField(SysAutoField auto, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_auto_field", auto);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}
	public SysAutoField findByName(String name, String database) {
		String sql = "select * from " + database + ".sys_auto_field where name=? ";
		try {
			return this.daoTemplate.queryForObj(sql, SysAutoField.class, name);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public SysAutoField querySysAutoFieldById(Integer autoId, String database) {
        String sql = "select * from " + database + ".sys_auto_field where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysAutoField.class, autoId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysAutoField queryAutoFieldByCode(String code, String database) {
        String sql = "select * from " + database + ".sys_auto_field where fd_code=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysAutoField.class, code);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateSysAutoField(SysAutoField auto, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", auto.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_auto_field", auto, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }
    public int updateAutoFieldStatus(String database){
        String sql = "update " + database + ".sys_auto_field set status=0 where fd_code like 'YWTC%'";
        try{
	        return  this.daoTemplate.update(sql);
        }catch (Exception e){
	        throw new DaoException(e);
        }
    }
    public int deleteSysAutoField(Integer id, String database) {
        String sql = " delete from " + database + ".sys_auto_field where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }



}
