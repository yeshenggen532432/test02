package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscOrderls;
import com.qweib.cloud.core.domain.BscOrderlsBb;
import com.qweib.cloud.core.domain.BscOrderlsDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BscOrderlsWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsPage(String database, Integer memId, Integer branchId, Integer zt, Integer page, Integer limit, String kmNm, String sdate, String edate){
		try {
			StringBuilder sql = new StringBuilder();
			sql.append("select a.*,b.kh_nm,c.member_nm from "+database+".bsc_orderls a");
			sql.append(" left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
//			if(!StrUtil.isNull(zt)){
//				if(zt==2){
//					sql.append(" and a.mid in(select y.member_id from "+database+".sys_mem y left join "+database+".sys_depart z on y.branch_id=z.branch_id where " +
//							"(z.branch_path like '%-"+branchId+"-%' or y.member_id="+memId+"))");
//				}else{
//					sql.append(" and a.mid="+memId+"");
//				}
//			}
			if(!StrUtil.isNull(kmNm)){
				sql.append(" and (b.kh_nm like '%"+kmNm+"%' or c.member_nm like '%"+kmNm+"%')");
			}
		    if(!StrUtil.isNull(sdate)){
				sql.append(" and a.oddate >='").append(sdate+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(edate)){
				sql.append(" and a.oddate <='").append(edate+" 23:59:59").append("'");
			}
			sql.append(" order by a.id desc");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscOrderls.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int addOrderls(BscOrderls order, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".bsc_orderls", order);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int updateOrderls(BscOrderls order, String database) {
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", order.getId());
			return this.daoTemplate.updateByObject(""+database+".bsc_orderls", order, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取订单信息
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public BscOrderls queryOrderlsOne(String database, Integer id){
		try{
			String sql = "select * from "+database+".bsc_orderls where id=?";
			return this.daoTemplate.queryForObj(sql, BscOrderls.class,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取订单信息2
	 *@创建：作者:llp		创建时间：2016-9-1
	 *@修改历史：
	 *		[序号](llp	2016-9-1)<修改说明>
	 */
	public BscOrderls queryOrderlsOne2(String database, Integer cid){
		try{
			String sql = "select * from "+database+".bsc_orderls where cid=?";
			return this.daoTemplate.queryForObj(sql, BscOrderls.class,cid);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：自增id
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Integer getAutoId() {
		try{
			return this.daoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
//	--------------------------------订单详情------------------------------
	/**
	 *说明：添加订单详情
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int addOrderlsDetail(BscOrderlsDetail orderlsDetail, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".bsc_orderls_detail", orderlsDetail);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取订单详情
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public List<BscOrderlsDetail> queryOrderlsDetail(String database, Integer orderId){
		try{
			String sql = "select a.*,b.ware_nm from "+database+".bsc_orderls_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id where a.order_id="+orderId+" order by a.ware_id asc";
			return this.daoTemplate.queryForLists(sql, BscOrderlsDetail.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除订单详情
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public void deleteOrderlsDetail(String database,Integer orderId) {
		String sql = "delete from "+database+".bsc_orderls_detail where order_id="+orderId;
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//----------------------------结算订单-----------------------------------------
	/**
	 *说明：分页查询结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public Page queryOrderlsBbPage(String database, Integer memId, Integer branchId, Integer zt, Integer page, Integer limit, String kmNm, String sdate, String edate, Integer cid){
		try {
			StringBuilder sql = new StringBuilder();
			StringBuilder sumSql=new StringBuilder();
			sql.append("select a.*,b.kh_nm,c.member_nm from "+database+".bsc_orderls_bb a");
			sql.append(" left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
			sumSql.append("select sum(a.all_jg) as tolprice1,sum(a.zh_jg) as tolprice2 from "+database+".bsc_orderls_bb a");
			sumSql.append(" left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
			if(cid!=0){
				sql.append(" and a.cid="+cid+"");
				sumSql.append(" and a.cid="+cid+"");
			}else{
				if(!StrUtil.isNull(zt)){
					if(zt==2){
						sql.append(" and a.mid in(select y.member_id from "+database+".sys_mem y left join "+database+".sys_depart z on y.branch_id=z.branch_id where " +
								"(z.branch_path like '%-"+branchId+"-%' or y.member_id="+memId+"))");
						sumSql.append(" and a.mid in(select y.member_id from "+database+".sys_mem y left join "+database+".sys_depart z on y.branch_id=z.branch_id where " +
								"(z.branch_path like '%-"+branchId+"-%' or y.member_id="+memId+"))");
					}else{
						sql.append(" and a.mid="+memId+"");
						sumSql.append(" and a.mid="+memId+"");
					}
				}
			}
			if(!StrUtil.isNull(kmNm)){
				sql.append(" and (b.kh_nm like '%"+kmNm+"%' or c.member_nm like '%"+kmNm+"%')");
				sumSql.append(" and (b.kh_nm like '%"+kmNm+"%' or c.member_nm like '%"+kmNm+"%')");
			}
		    if(!StrUtil.isNull(sdate)){
				sql.append(" and a.odate >='").append(sdate+" 00:00:00").append("'");
				sumSql.append(" and a.odate >='").append(sdate+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(edate)){
				sql.append(" and a.odate <='").append(edate+" 23:59:59").append("'");
				sumSql.append(" and a.odate <='").append(edate+" 23:59:59").append("'");
			}
			sql.append(" order by a.id desc");
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
	 *说明：添加结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public int addOrderlsBb(BscOrderlsBb orderlsBb, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".bsc_orderls_bb", orderlsBb);
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
	public BscOrderlsBb queryOrderlsBbById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".bsc_orderls_bb where order_id=? ";
			return this.daoTemplate.queryForObj(sql, BscOrderlsBb.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
