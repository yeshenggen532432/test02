package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfsdhjc;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysBfsdhjcDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加生动化检查
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public int addBfsdhjc(SysBfsdhjc bfsdhjc, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_bfsdhjc", bfsdhjc);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改生动化检查
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public int updateBfsdhjc(SysBfsdhjc bfsdhjc, String database) {
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bfsdhjc.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_bfsdhjc", bfsdhjc, whereParam, "id");
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
	 *说明：获取生动化检查信息
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public SysBfsdhjc queryBfsdhjcOne(String database, Integer mid, Integer cid, String sddate){
		try{
			String sql = "select * from "+database+".sys_bfsdhjc where mid=? and cid=? and sddate=?";
			return this.daoTemplate.queryForObj(sql, SysBfsdhjc.class,mid,cid,sddate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
