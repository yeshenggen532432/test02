package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysAutoPrice;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysAutoPriceDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryAutoPrice(SysAutoPrice autoPrice, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_auto_price a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysAutoPrice.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysAutoPrice> queryList(SysAutoPrice autoPrice, String database,String wareIds){
    	StringBuffer sql = new StringBuffer(" select a.*,b.name as auto_name,b.fd_code as auto_code from "+database+".sys_auto_price a left join  "+database+".sys_auto_field b on a.auto_id=b.id ");
    	sql.append(" where 1=1 ");
    	if(autoPrice!=null){
    		if(!StrUtil.isNull(autoPrice.getAutoId())){
				sql.append(" and a.auto_Id = ").append(autoPrice.getAutoId());
			}
    		if(!StrUtil.isNull(autoPrice.getWareId())){
				sql.append(" and a.ware_id = ").append(autoPrice.getWareId());
			}
			if (!StrUtil.isNull(autoPrice.getStatus())) {
				sql.append(" and b.status='").append(autoPrice.getStatus()).append("'");
			}
    	}
    	if(!StrUtil.isNull(wareIds)){
			sql.append(" and a.ware_id in (").append(wareIds).append(")");
		}
    	return this.daoTemplate.queryForLists(sql.toString(), SysAutoPrice.class);
    }


	public int addAutoPrice(SysAutoPrice autoPrice, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_auto_price", autoPrice);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysAutoPrice queryAutoPriceById(Integer autoPriceId, String database){
		String sql = "select * from "+database+".sys_auto_price where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysAutoPrice.class, autoPriceId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateAutoPrice(SysAutoPrice autoPrice, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", autoPrice.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_auto_price", autoPrice, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteAutoPrice(Integer id,String database){
		String sql = " delete from "+database+".sys_auto_price where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteAutoPriceAll(String database){
		String sql = "delete from "+database+".sys_auto_price";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
