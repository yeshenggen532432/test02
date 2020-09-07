package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BiaoXsddtj;
import com.qweib.cloud.core.domain.SysBforderDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class BiaoXsddtjDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询销售订单统计表
	 *@创建：作者:llp		创建时间：2016-7-7
	 *@修改历史：
	 *		[序号](llp	2016-7-7)<修改说明>
	 */
	public Page queryBiaoXsddtj(BiaoXsddtj Xsddtj, String database, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		StringBuilder sumSql=new StringBuilder();
		sql.append("select b.kh_nm,c.member_nm,group_concat(CAST(a.id AS CHAR)) as orderIds from "+database+".sys_bforder a left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1 ");
		sumSql.append("select sum(a.ware_num) as tolnum,sum(a.ware_zj) as tolprice from "+database+".sys_bforder_detail a ");
		sumSql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sumSql.append(" WHERE 1=1 ");

		sql.append(" and a.order_zt!='已作废'");
		sumSql.append(" and o.order_zt='已作废'");

		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
				sql.append(" AND (c.branch_id IN ("+allDepts+") ");
				sql.append(" OR a.mid="+mId+")");
				sumSql.append(" AND (m.branch_id IN ("+allDepts+") ");
				sumSql.append(" OR o.mid="+mId+")");
			} else {
				sql.append(" AND c.branch_id IN ("+allDepts+") ");
				sumSql.append(" AND m.branch_id IN ("+allDepts+") ");
			}
		}else if (!StrUtil.isNull(mId)) {//个人
			sql.append(" AND a.mid="+mId);
			sumSql.append(" AND o.mid="+mId);
		}
		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
			sql.append(" AND c.branch_id NOT IN ("+invisibleDepts+") ");
			sumSql.append(" AND m.branch_id NOT IN ("+invisibleDepts+") ");
		}
		sumSql.append(" AND a.order_id in (select b.id from "+database+".sys_bforder b left join "+database+".sys_mem c on b.mid=c.member_id left join "+database+".sys_customer d on b.cid=d.id where 1=1 ");
		if(null!=Xsddtj){
			if(!StrUtil.isNull(Xsddtj.getStime())){
				sql.append(" and a.oddate >='").append(Xsddtj.getStime()).append("'");
				sumSql.append(" and b.oddate >='").append(Xsddtj.getStime()).append("'");
			}
			if(!StrUtil.isNull(Xsddtj.getEtime())){
				sql.append(" and a.oddate <='").append(Xsddtj.getEtime()).append("'");
				sumSql.append(" and b.oddate <='").append(Xsddtj.getEtime()).append("'");
			}
			if(!StrUtil.isNull(Xsddtj.getKhNm())){
				sql.append(" and b.kh_nm like '%"+Xsddtj.getKhNm()+"%'");
				sumSql.append(" and d.kh_nm like '%"+Xsddtj.getKhNm()+"%'");
			}
			if(!StrUtil.isNull(Xsddtj.getMemberNm())){
				sql.append(" and c.member_nm like '%"+Xsddtj.getMemberNm()+"%'");
				sumSql.append(" and c.member_nm like '%"+Xsddtj.getMemberNm()+"%'");
			}
			if(!StrUtil.isNull(Xsddtj.getOrderZt())){
				sql.append(" and a.order_zt='"+Xsddtj.getOrderZt()+"'");
				sumSql.append(" and o.order_zt='"+Xsddtj.getOrderZt()+"'");
			}
			if(!StrUtil.isNull(Xsddtj.getPszd())){
				sql.append(" and a.pszd like '%"+Xsddtj.getPszd()+"%'");
				sumSql.append(" and b.pszd like '%"+Xsddtj.getPszd()+"%'");
			}
		}
		sumSql.append(")");
		sql.append(" group by a.cid,a.mid order by a.mid");
		try {
			Page p=this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoXsddtj.class);
			Map<String, Object> temp = this.daoTemplate.queryForMap(sumSql.toString());
			if(null!=temp && temp.size()==2){
				p.setTolnum(StrUtil.convertDbToInt(temp.get("tolnum")));
				p.setTolprice(StrUtil.convertDouble(temp.get("tolprice")));
			}
			return p;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询销售订单统计表Web
	 *@创建：作者:llp		创建时间：2016-7-7
	 *@修改历史：
	 *		[序号](llp	2016-7-7)<修改说明>
	 */
	public Page queryBiaoXsddtjWeb(BiaoXsddtj Xsddtj, String database, Map<String, Object> map, Integer page, Integer limit, String mids){
		StringBuilder sql = new StringBuilder();
		StringBuilder sumSql=new StringBuilder();
		sql.append("select b.kh_nm,c.member_nm,group_concat(CAST(a.id AS CHAR)) as orderIds from "+database+".sys_bforder a left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
		sumSql.append("select sum(a.ware_num) as tolnum,sum(a.ware_zj) as tolprice from "+database+".sys_bforder_detail a ");
		sumSql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sumSql.append(" WHERE 1=1 ");
		if(!StrUtil.isNull(mids)){
			sql.append(" AND a.mid in ("+mids+")");
			sumSql.append(" AND o.mid in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
					sql.append(" OR a.mid="+map.get("mId")+")");
					sumSql.append(" AND (m.branch_id IN ("+map.get("allDepts")+") ");
					sumSql.append(" OR o.mid="+map.get("mId")+")");
				} else {
					sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
					sumSql.append(" AND m.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sql.append(" AND a.mid="+map.get("mId"));
				sumSql.append(" AND o.mid="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
				sumSql.append(" AND m.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		sumSql.append(" AND a.order_id in (select b.id from "+database+".sys_bforder b left join "+database+".sys_mem c on b.mid=c.member_id left join "+database+".sys_customer d on b.cid=d.id WHERE 1=1 ");
		if(null!=Xsddtj){
//			if(!StrUtil.isNull(Xsddtj.getTp())){
//				if(!Xsddtj.getTp().equals("1")){
//					sql.append(" and a.mid in ("+Xsddtj.getStr()+")");
//					sumSql.append(" and b.mid in ("+Xsddtj.getStr()+")");
//				}
//			}
			if(!StrUtil.isNull(Xsddtj.getStime())){
				sql.append(" and a.oddate >='").append(Xsddtj.getStime()).append("'");
				sumSql.append(" and b.oddate >='").append(Xsddtj.getStime()).append("'");
			}
			if(!StrUtil.isNull(Xsddtj.getEtime())){
				sql.append(" and a.oddate <='").append(Xsddtj.getEtime()).append("'");
				sumSql.append(" and b.oddate <='").append(Xsddtj.getEtime()).append("'");
			}
			if(!StrUtil.isNull(Xsddtj.getKhNm())){
				sql.append(" and (b.kh_nm like '%"+Xsddtj.getKhNm()+"%' or c.member_nm like '%"+Xsddtj.getKhNm()+"%')");
				sumSql.append(" and (d.kh_nm like '%"+Xsddtj.getKhNm()+"%' or c.member_nm like '%"+Xsddtj.getKhNm()+"%')");
			}
			if(!StrUtil.isNull(Xsddtj.getOrderZt())){
				sql.append(" and a.order_zt='"+Xsddtj.getOrderZt()+"'");
				sumSql.append(" and b.order_zt='"+Xsddtj.getOrderZt()+"'");
			}
			if(!StrUtil.isNull(Xsddtj.getPszd())){
				sql.append(" and a.pszd like '%"+Xsddtj.getPszd()+"%'");
				sumSql.append(" and b.pszd like '%"+Xsddtj.getPszd()+"%'");
			}
			if(!StrUtil.isNull(Xsddtj.getCid())){
				sql.append(" and b.id="+Xsddtj.getCid()+"");
				sumSql.append(" and d.id="+Xsddtj.getCid()+"");
			}
		}
		sumSql.append(")");
		sql.append(" group by a.cid,a.mid ");
		sql.append(" order by a.mid ");

		try {
			Page p=this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoXsddtj.class);
			Map<String, Object> temp = this.daoTemplate.queryForMap(sumSql.toString());
			if(null!=temp && temp.size()==2){
				p.setTolnum(StrUtil.convertDbToInt(temp.get("tolnum")));
				p.setTolprice(StrUtil.convertDouble(temp.get("tolprice")));
			}
			return p;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public Map<String, Object> queryTolprice(BiaoXsddtj Xsddtj, Map<String, Object> map, String database, String mids){
		StringBuilder sumSql=new StringBuilder();
		sumSql.append("select sum(a.ware_num) as tolnum,sum(a.ware_zj) as tolprice from "+database+".sys_bforder_detail a where a.order_id in (select b.id from "+database+".sys_bforder b left join "+database+".sys_mem c on b.mid=c.member_id left join "+database+".sys_customer d on b.cid=d.id where 1=1");
		if(null!=Xsddtj){
//			if(!StrUtil.isNull(Xsddtj.getTp())){
//				if(!Xsddtj.getTp().equals("1")){
//					sumSql.append(" and b.mid in ("+Xsddtj.getStr()+")");
//				}
//			}
			if(!StrUtil.isNull(Xsddtj.getKhNm())){
				sumSql.append(" and d.kh_nm like '%"+Xsddtj.getKhNm()+"%'");
			}
			if(!StrUtil.isNull(Xsddtj.getCid())){
				sumSql.append(" and d.id="+Xsddtj.getCid()+"");
			}
			if(!StrUtil.isNull(Xsddtj.getStime())){
				sumSql.append(" and b.oddate >='").append(Xsddtj.getStime()).append("'");
			}
			if(!StrUtil.isNull(Xsddtj.getEtime())){
				sumSql.append(" and b.oddate <='").append(Xsddtj.getEtime()).append("'");
			}
		}
		if(!StrUtil.isNull(mids)){
			sumSql.append(" AND b.mid in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sumSql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
					sumSql.append(" OR b.mid="+map.get("mId")+")");
				} else {
					sumSql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sumSql.append(" AND b.mid="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sumSql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		sumSql.append(")");



		try {
			return this.daoTemplate.queryForMap(sumSql.toString());
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：商品信息集合
	 *@创建：作者:llp		创建时间：2016-7-7
	 *@修改历史：
	 *		[序号](llp	2016-7-7)<修改说明>
	 */
	public List<SysBforderDetail> queryOrderDetailS(String database, String orderIds){
		String sql = "select b.ware_nm,a.xs_tp,a.ware_dw,sum(a.ware_num) as wareNum,a.ware_dj,sum(a.ware_zj) as wareZj from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id where a.order_id in("+orderIds+") group by a.ware_id,a.xs_tp,a.ware_dw,a.ware_dj";
		try {
			return this.daoTemplate.queryForLists(sql, SysBforderDetail.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
