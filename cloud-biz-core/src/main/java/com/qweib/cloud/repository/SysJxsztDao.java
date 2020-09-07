package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysJxszt;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysJxsztDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public Page queryJxsztPage(SysJxszt Jxszt, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_jxszt where 1=1");
		if(null!=Jxszt){
			if(!StrUtil.isNull(Jxszt.getZtNm())){
				sql.append(" and zt_nm like '%"+Jxszt.getZtNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysJxszt.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int addJxszt(SysJxszt Jxszt, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_jxszt", Jxszt);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int updateJxszt(SysJxszt Jxszt, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", Jxszt.getId());
			return this.daoTemplate.updateByObject(database+".sys_jxszt", Jxszt, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public SysJxszt queryJxsztById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_jxszt where id=? ";
			return this.daoTemplate.queryForObj(sql, SysJxszt.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除经销商状态
	 *@创建：作者:llp		创建时间：2016-7-26
	 *@修改历史：
	 *		[序号](llp	2016-7-26)<修改说明>
	 */
	public int deleteJxsztById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_jxszt where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
