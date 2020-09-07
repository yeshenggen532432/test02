package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysLogistics;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysLogisticsDao {
	@Resource(name="pdaoTemplate")
	private JdbcDaoTemplatePlud pdaoTemplate;

	/**
	 *说明：分页查询物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public Page queryLogistics(SysLogistics logistics, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from sys_logistics where 1=1");
		if(null!=logistics){
			if(!StrUtil.isNull(logistics.getWlNm())){
				sql.append(" and wl_nm like '%"+logistics.getWlNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysLogistics.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public int addLogistics(SysLogistics logistics){
		try{
			return this.pdaoTemplate.addByObject("sys_logistics", logistics);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public int updateLogistics(SysLogistics logistics){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", logistics.getId());
			return this.pdaoTemplate.updateByObject("sys_logistics", logistics, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取物流公司
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public SysLogistics queryLogisticsById(Integer Id){
		try{
			String sql = "select * from sys_logistics where id=? ";
			return this.pdaoTemplate.queryForObj(sql, SysLogistics.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
