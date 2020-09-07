package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfcljccj;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysBfcljccjWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public int addBfcljccj(SysBfcljccj bfcljccj, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_bfcljccj", bfcljccj);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public int updateBfcljccj(SysBfcljccj bfcljccj, String database) {
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bfcljccj.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_bfcljccj", bfcljccj, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：自增id
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public Integer getAutoId() {
		try{
			return this.daoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public List<SysBfcljccj> queryBfcljccjOne(String database, Integer mid, Integer cid, String cjdate){
		try{
			String sql = "select a.id,a.mdid,a.hjpms,a.djpms,a.sytwl,a.bds,a.remo,b.md_nm from "+database+".sys_bfcljccj a left join "+database+".sys_cljccj_md b on a.mdid=b.id where a.mid=? and a.cid=? and a.cjdate=?";
			return this.daoTemplate.queryForLists(sql, SysBfcljccj.class,mid,cid,cjdate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
