package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysKhlevel;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysKhlevelDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询客户等级
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public Page queryKhlevelPage(SysKhlevel khlevel, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.*,b.qdtp_nm from "+database+".sys_khlevel a left join "+database+".sys_qdtype b on a.qd_id=b.id  where 1=1");
		if(null!=khlevel){
			if(!StrUtil.isNull(khlevel.getKhdjNm())){
				sql.append(" and a.khdj_nm like '%"+khlevel.getKhdjNm()+"%' ");
			}
		}
		sql.append(" order by b.id desc,a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysKhlevel.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public List<SysKhlevel> queryList(SysKhlevel khlevel, String database){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.*,b.qdtp_nm from "+database+".sys_khlevel a left join "+database+".sys_qdtype b on a.qd_id=b.id  where 1=1");
		if(null!=khlevel){
			sql.append(" and a.khdj_Nm ='").append(khlevel.getKhdjNm()).append("'");
		}
		sql.append(" order by b.id desc,a.id desc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysKhlevel.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加客户等级
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int addkhlevel(SysKhlevel khlevel, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_khlevel", khlevel);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改客户等级
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int updatekhlevel(SysKhlevel khlevel, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", khlevel.getId());
			return this.daoTemplate.updateByObject(database+".sys_khlevel", khlevel, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取客户等级
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public SysKhlevel querykhlevelById(Integer Id, String database){
		try{
			String sql = "select a.*,b.qdtp_Nm from "+database+".sys_khlevel a left join "+database+".sys_qdtype b on a.qd_id=b.id where a.id=? ";
			return this.daoTemplate.queryForObj(sql, SysKhlevel.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除客户等级
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int deletekhlevelById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_khlevel where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 *说明：获取客户等级
	 */
	public SysKhlevel querykhlevelByName(String name, String database){
		try{
			String sql = "select * from "+database+".sys_khlevel where khdj_nm=? ";
			return this.daoTemplate.queryForObj(sql, SysKhlevel.class,name);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
