package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysJxsjb;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysJxsjbDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsjbPage(SysJxsjb Jxsjb, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_jxsjb where 1=1");
		if(null!=Jxsjb){
			if(!StrUtil.isNull(Jxsjb.getJbNm())){
				sql.append(" and jb_nm like '%"+Jxsjb.getJbNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxsjb.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxsjb(SysJxsjb Jxsjb, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_jxsjb", Jxsjb);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxsjb(SysJxsjb Jxsjb, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", Jxsjb.getId());
			return this.daoTemplate.updateByObject(database+".sys_jxsjb", Jxsjb, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxsjb queryJxsjbById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_jxsjb where id=? ";
			return this.daoTemplate.queryForObj(sql, SysJxsjb.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除经销商级别
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsjbById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_jxsjb where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
