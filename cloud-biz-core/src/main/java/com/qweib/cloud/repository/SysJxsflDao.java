package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysJxsfl;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysJxsflDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsflPage(SysJxsfl Jxsfl, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_jxsfl where 1=1");
		if(null!=Jxsfl){
			if(!StrUtil.isNull(Jxsfl.getFlNm())){
				sql.append(" and fl_nm like '%"+Jxsfl.getFlNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxsfl.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxsfl(SysJxsfl Jxsfl, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_jxsfl", Jxsfl);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxsfl(SysJxsfl Jxsfl, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", Jxsfl.getId());
			return this.daoTemplate.updateByObject(database+".sys_jxsfl", Jxsfl, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxsfl queryJxsflById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_jxsfl where id=? ";
			return this.daoTemplate.queryForObj(sql, SysJxsfl.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除经销商分类
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsflById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_jxsfl where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
