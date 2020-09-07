package com.qweib.cloud.repository;

import com.qweib.cloud.core.domain.SysBforderXls;
import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysBforderXlsDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	/**
	 *说明：查询订单1
	 *@创建：作者:llp		创建时间：2016-5-26
	 *@修改历史：
	 *		[序号](llp	2016-5-26)<修改说明>
	 */
	public List<SysBforderXls> queryBforderXls1(String orderNo, String khNm,
												String memberNm, String sdate,String edate,String orderZt,String pszd,String datasource) {
		StringBuffer sql = new StringBuffer("select a.*,b.order_no,b.pszd,b.oddate,b.odtime,b.sh_time,b.zje,b.zdzk,b.cjje,b.order_zt,b.remo,c.ware_nm,c.ware_gg,d.kh_nm,e.member_nm,count(a.id) as counts from "+datasource+".sys_bforder_detail a");
		sql.append(" left join "+datasource+".sys_bforder b on a.order_id=b.id");
		sql.append(" left join "+datasource+".sys_ware c on a.ware_id=c.ware_id");
		sql.append(" left join "+datasource+".sys_customer d on b.cid=d.id");
		sql.append(" left join "+datasource+".sys_mem e on b.mid=e.member_id where 1=1");
		if(!StrUtil.isNull(khNm)){
			sql.append(" and d.kh_nm like '%"+khNm+"%'");
		}
		if(!StrUtil.isNull(memberNm)){
			sql.append(" and e.member_nm like '%"+memberNm+"%'");
		}
		if(!StrUtil.isNull(orderNo)){
			sql.append(" and b.order_no like '%"+orderNo+"%'");
		}
		if(!StrUtil.isNull(orderZt)){
			sql.append(" and b.order_zt='"+orderZt+"'");
		}
		if(!StrUtil.isNull(pszd)){
			sql.append(" and b.pszd='"+pszd+"'");
		}
		if(!StrUtil.isNull(sdate)){
			sql.append(" and b.oddate >='").append(sdate).append("'");
		}
		if(!StrUtil.isNull(edate)){
			sql.append(" and b.oddate <='").append(edate).append("'");
		}
		sql.append(" group by a.order_id order by a.id desc");
		try {
			return daoTemplate.queryForLists(sql.toString(),SysBforderXls.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：查询订单2
	 *@创建：作者:llp		创建时间：2016-5-26
	 *@修改历史：
	 *		[序号](llp	2016-5-26)<修改说明>
	 */
	public List<SysBforderXls> queryBforderXls2(Integer orderId,Integer count,String datasource) {
		StringBuffer sql = new StringBuffer("select a.*,b.order_no,b.pszd,b.oddate,b.odtime,b.sh_time,b.order_zt,b.remo,d.kh_nm,e.member_nm from "+datasource+".sys_bforder_detail a");
		sql.append(" left join "+datasource+".sys_bforder b on a.order_id=b.id left join "+datasource+".sys_ware c on a.ware_id=c.ware_id left join "+datasource+".sys_customer d on b.cid=d.id " +
				"left join "+datasource+".sys_mem e on b.mid=e.member_id where a.order_id="+orderId+"");
		sql.append(" order by a.id desc limit "+count+"");
		try {
			return daoTemplate.queryForLists(sql.toString(),SysBforderXls.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
