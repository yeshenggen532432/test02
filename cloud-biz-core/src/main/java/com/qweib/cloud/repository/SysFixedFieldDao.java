package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysFixedField;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysFixedFieldDao {
    @Resource(name = "daoTemplate")
    private JdbcDaoTemplate daoTemplate;


	public Page querySysFixedFieldPage(SysFixedField auto, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.*,c.type_name as cost_type_name,b.item_name as cost_item_name from "+database+".sys_fixed_field a  left join " + database + ".fin_costitem b on a.cost_item_id=b.id left join " + database + ".fin_costtype c on a.cost_type_id=c.id where 1=1 ");

		if(auto!=null){
			if(!StrUtil.isNull(auto.getStatus())){
			    if(auto.getStatus().equals("1")){
			        sql.append(" and a.status is null or a.status=1 ");
                }else{
                    sql.append(" and a.status='").append(auto.getStatus()).append("'");
                }
			}
		}
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysFixedField.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysFixedField> queryList(SysFixedField auto, String database) {
        StringBuffer sql = new StringBuffer(" select a.* from " + database + ".sys_fixed_field a ");
        sql.append(" where 1=1 ");
        if (auto != null) {
            if (!StrUtil.isNull(auto.getStatus())) {
                sql.append(" and a.status='").append(auto.getStatus()).append("'");
            }
        }
        return this.daoTemplate.queryForLists(sql.toString(), SysFixedField.class);
    }


	public int addSysFixedField(SysFixedField auto, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_fixed_field", auto);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}
	public SysFixedField findByName(String name, String database) {
		String sql = "select * from " + database + ".sys_fixed_field where name=? ";
		try {
			return this.daoTemplate.queryForObj(sql, SysFixedField.class, name);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public SysFixedField querySysFixedFieldById(Integer autoId, String database) {
        String sql = "select * from " + database + ".sys_fixed_field where id=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysFixedField.class, autoId);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public SysFixedField queryFixedFieldByCode(String code, String database) {
        String sql = "select * from " + database + ".sys_fixed_field where fd_code=?";
        try {
            return this.daoTemplate.queryForObj(sql, SysFixedField.class, code);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int updateSysFixedField(SysFixedField auto, String database) {
        try {
            Map<String, Object> whereParam = new HashMap<String, Object>();
            whereParam.put("id", auto.getId());
            return this.daoTemplate.updateByObject("" + database + ".sys_fixed_field", auto, whereParam, null);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }

    public int deleteSysFixedField(Integer id, String database) {
        String sql = " delete from " + database + ".sys_fixed_field where id=? ";
        try {
            return this.daoTemplate.update(sql, id);
        } catch (Exception e) {
            throw new DaoException(e);
        }
    }



}
