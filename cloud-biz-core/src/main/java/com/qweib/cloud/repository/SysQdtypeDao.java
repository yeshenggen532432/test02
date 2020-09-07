package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQdtype;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQdtypeDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public Page queryQdtypePage(SysQdtype qdtype, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_qdtype where 1=1");
		if(null!=qdtype){
			if(!StrUtil.isNull(qdtype.getQdtpNm())){
				sql.append(" and qdtp_nm like '%"+qdtype.getQdtpNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysQdtype.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public List<SysQdtype> queryList(SysQdtype qdtype, String database){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_qdtype where 1=1");
		if(null!=qdtype){
			if(!StrUtil.isNull(qdtype.getQdtpNm())){
				sql.append(" and qdtp_nm like '%"+qdtype.getQdtpNm()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysQdtype.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 *说明：添加渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int addQdtype(SysQdtype qdtype, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_qdtype", qdtype);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int updateQdtype(SysQdtype qdtype, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", qdtype.getId());
			return this.daoTemplate.updateByObject(database+".sys_qdtype", qdtype, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public SysQdtype queryQdtypeById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_qdtype where id=? ";
			return this.daoTemplate.queryForObj(sql, SysQdtype.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取渠道类型列表
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public List<SysQdtype> queryQdtypels(String database){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_qdtype");
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysQdtype.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除渠道类型
	 *@创建：作者:llp		创建时间：2016-7-23
	 *@修改历史：
	 *		[序号](llp	2016-7-23)<修改说明>
	 */
	public int deleteQdtypeById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_qdtype where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 *根据type名称获取渠道类型
	 */
	public SysQdtype queryQdtypeByName(String name, String database){
		try{
			String sql = "select * from "+database+".sys_qdtype where qdtp_nm = ? ";
			return this.daoTemplate.queryForObj(sql, SysQdtype.class,name);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
