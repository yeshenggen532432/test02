package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBforderMsg;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysBforderMsgDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加订单提示信息
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public int addBforderMsg(SysBforderMsg orderMsg, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_bforder_msg", orderMsg);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}
	/**
	 *说明：修改信息已读
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public void updateBforderMsgisRead(String database,Integer id) {
		String sql = "update "+database+".sys_bforder_msg set is_read=1 where id="+id;
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改信息已读2
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public void updateBforderMsgisRead2(String database,String orderNo) {
		String sql = "update "+database+".sys_bforder_msg set is_read=1 where order_no='"+orderNo+"'";
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：列表查订单提示信息
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	public List<SysBforderMsg> queryBforderMsgls(String database){
		String sql = "select a.*,b.kh_nm,c.member_nm from "+database+".sys_bforder_msg a left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id" +
				" where a.is_read=2 order by a.id asc";
		try {
			return this.daoTemplate.queryForLists(sql, SysBforderMsg.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
