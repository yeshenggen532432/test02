package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysBfgzxcWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加道谢并告知下次拜访
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public int addBfgzxc(SysBfgzxc bfgzxc, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_bfgzxc", bfgzxc);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改道谢并告知下次拜访
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public int updateBfgzxc(SysBfgzxc bfgzxc, String database) {
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bfgzxc.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_bfgzxc", bfgzxc, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：自增id
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public Integer getAutoId() {
		try{
			return this.daoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取道谢并告知下次拜访信息
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcOne(String database, Integer mid, Integer cid, String dqdate){
		try{
			String sql = "select * from "+database+".sys_bfgzxc where mid=? and cid=? and dqdate=?";
			return this.daoTemplate.queryForObj(sql, SysBfgzxc.class,mid,cid,dqdate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取道谢并告知下次拜访上次信息
	 *@创建：作者:llp		创建时间：2016-3-30
	 *@修改历史：
	 *		[序号](llp	2016-3-30)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcOneSc(String database, Integer mid, Integer cid){
		try{
			String sql = "select * from "+database+".sys_bfgzxc where mid=? and cid=? and dqdate!='"+new SimpleDateFormat("yyyy-MM-dd").format(new Date())+"' order by id desc limit 0,1";
			return this.daoTemplate.queryForObj(sql, SysBfgzxc.class,mid,cid);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 *说明：根据拜访id获取拜访签退拍照信息
	 */
	public SysBfgzxc queryBfgzxcById(String database, Integer id){
		try{
			String sql = "select * from "+database+".sys_bfgzxc where id=?";
			return this.daoTemplate.queryForObj(sql, SysBfgzxc.class,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
