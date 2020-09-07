package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysXtcs;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysXtcsDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public Page queryXtcsPage(SysXtcs xtcs, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_xtcs where 1=1");
		if(null!=xtcs){
			if(!StrUtil.isNull(xtcs.getXtNm())){
				sql.append(" and xt_nm like '%"+xtcs.getXtNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysXtcs.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public int updateXtcs(SysXtcs xtcs, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", xtcs.getId());
			return this.daoTemplate.updateByObject(database+".sys_xtcs", xtcs, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取系统参数
	 *@创建：作者:llp		创建时间：2016-10-24
	 *@修改历史：
	 *		[序号](llp	2016-10-24)<修改说明>
	 */
	public SysXtcs queryXtcsById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_xtcs where id=? ";
			return this.daoTemplate.queryForObj(sql, SysXtcs.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
