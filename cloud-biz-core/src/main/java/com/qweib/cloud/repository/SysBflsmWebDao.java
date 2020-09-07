package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.domain.SysBflsm;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysBflsmWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：根据用户id,日期获取签到信息
	 *@创建：作者:llp		创建时间：2016-11-21
	 *@修改历史：
	 *		[序号](llp	2016-11-21)<修改说明>
	 */
	public List<SysBflsm> queryBflsm(String database, Integer mid, String date){
		try{
			String sql = "select a.id,a.mid,a.cid,a.longitude,a.latitude,a.address,a.qddate as date,a.qdtime as time1,b.kh_nm from "+database+".sys_bfqdpz a left join "+database+".sys_customer b on a.cid=b.id where a.mid="+mid+" and a.qddate='"+date+"' order by a.id asc";
			return this.daoTemplate.queryForLists(sql, SysBflsm.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：根据用户id,客户id,日期获取签退到信息
	 *@创建：作者:llp		创建时间：2016-11-21
	 *@修改历史：
	 *		[序号](llp	2016-11-21)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcByMCD(String database, Integer mid, Integer cid, String date){
		try{
			String sql = "select * from "+database+".sys_bfgzxc where mid=? and cid=? and dqdate=?";
			return this.daoTemplate.queryForObj(sql, SysBfgzxc.class,mid,cid,date);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
