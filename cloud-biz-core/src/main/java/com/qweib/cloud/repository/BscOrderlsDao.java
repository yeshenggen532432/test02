package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscOrderls;
import com.qweib.cloud.core.domain.BscOrderlsBb;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class BscOrderlsDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsPage1(BscOrderls order, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.*,b.kh_nm,c.member_nm from "+order.getDatabase()+".bsc_orderls a left join "+order.getDatabase()+".sys_customer b on a.cid=b.id left join "+order.getDatabase()+".sys_mem c on a.mid=c.member_id " +
				"where 1=1");
		if(null!=order){
			if(!StrUtil.isNull(order.getKhNm())){
				sql.append(" and b.kh_nm like '%"+order.getKhNm()+"%'");
			}
			if(!StrUtil.isNull(order.getMemberNm())){
				sql.append(" and c.member_nm like '%"+order.getMemberNm()+"%'");
			}
			if(!StrUtil.isNull(order.getOrderNo())){
				sql.append(" and a.order_no like '%"+order.getOrderNo()+"%'");
			}
			if(!StrUtil.isNull(order.getOrderZt())){
				sql.append(" and a.order_zt='"+order.getOrderZt()+"'");
			}
			if(!StrUtil.isNull(order.getSdate())){
				sql.append(" and a.oddate >='").append(order.getSdate()+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(order.getEdate())){
				sql.append(" and a.oddate <='").append(order.getEdate()+" 23:59:59").append("'");
			}
		}
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscOrderls.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsBbPage1(BscOrderlsBb orderlsBb, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		StringBuilder sumSql=new StringBuilder();
		sql.append("select a.*,b.kh_nm,c.member_nm from "+orderlsBb.getDatabase()+".bsc_orderls_bb a left join "+orderlsBb.getDatabase()+".sys_customer b on a.cid=b.id left join "+orderlsBb.getDatabase()+".sys_mem c on a.mid=c.member_id " +
				"where 1=1");
		sumSql.append("select sum(a.all_jg) as tolprice1,sum(a.zh_jg) as tolprice2 from "+orderlsBb.getDatabase()+".bsc_orderls_bb a left join "+orderlsBb.getDatabase()+".sys_customer b on a.cid=b.id left join "+orderlsBb.getDatabase()+".sys_mem c on a.mid=c.member_id " +
		"where 1=1");
		if(null!=orderlsBb){
			if(!StrUtil.isNull(orderlsBb.getKhNm())){
				sql.append(" and b.kh_nm like '%"+orderlsBb.getKhNm()+"%'");
				sumSql.append(" and b.kh_nm like '%"+orderlsBb.getKhNm()+"%'");
			}
			if(!StrUtil.isNull(orderlsBb.getMemberNm())){
				sql.append(" and c.member_nm like '%"+orderlsBb.getMemberNm()+"%'");
				sumSql.append(" and c.member_nm like '%"+orderlsBb.getMemberNm()+"%'");
			}
			if(!StrUtil.isNull(orderlsBb.getOrderNo())){
				sql.append(" and a.order_no like '%"+orderlsBb.getOrderNo()+"%'");
				sumSql.append(" and a.order_no like '%"+orderlsBb.getOrderNo()+"%'");
			}
			if(!StrUtil.isNull(orderlsBb.getSdate())){
				sql.append(" and a.odate >='").append(orderlsBb.getSdate()+" 00:00:00").append("'");
				sumSql.append(" and a.odate >='").append(orderlsBb.getSdate()+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(orderlsBb.getEdate())){
				sql.append(" and a.odate <='").append(orderlsBb.getEdate()+" 23:59:59").append("'");
				sumSql.append(" and a.odate <='").append(orderlsBb.getEdate()+" 23:59:59").append("'");
			}
			if(!StrUtil.isNull(orderlsBb.getIsJs())){
				sql.append(" and a.is_js='"+orderlsBb.getIsJs()+"'");
				sumSql.append(" and a.is_js='"+orderlsBb.getIsJs()+"'");
			}
		}
		sql.append(" order by a.id desc");
		try {
			Page p=this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscOrderlsBb.class);
			Map<String, Object> temp = this.daoTemplate.queryForMap(sumSql.toString());
			if(null!=temp && temp.size()==2){
				p.setTolprice1(StrUtil.convertDouble(temp.get("tolprice1")));
				p.setTolprice2(StrUtil.convertDouble(temp.get("tolprice2")));
			}
			return p;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *@说明：修改订单审核
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int updateOrderlsSh(String database,Integer id,String sh){
		String sql = "update "+database+".bsc_orderls set order_zt=? where id=?";
		try {
			return this.daoTemplate.update(sql,sh,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *@说明 修改结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int updateOrderBbJg(String database, BscOrderlsBb orderlsBb){
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", orderlsBb.getId());
			return this.daoTemplate.updateByObject(""+database+".bsc_orderls_bb", orderlsBb, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public BscOrderlsBb queryOrderlsBbOne(String database, Integer id){
		try{
			String sql = "select * from "+database+".bsc_orderls_bb where id=?";
			return this.daoTemplate.queryForObj(sql, BscOrderlsBb.class,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
