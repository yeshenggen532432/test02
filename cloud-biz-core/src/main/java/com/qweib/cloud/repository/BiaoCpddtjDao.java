package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BiaoCpddtj;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Map;

@Repository
public class BiaoCpddtjDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询产品订单统计表
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	public Page queryBiaoCpddtj(BiaoCpddtj Cpddtj, String database, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		StringBuilder sumSql=new StringBuilder();
		sql.append("select b.ware_nm,a.xs_tp,b.ware_dw,sum(a.ware_num) as nums,a.ware_dj,sum(a.ware_zj) as zjs from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id ");
		sumSql.append("select sum(a.ware_num) as tolnum,sum(a.ware_zj) as tolprice from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id ");
		sql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sumSql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sql.append(" where 1=1 ");
		sumSql.append(" where 1=1 ");

		sql.append(" and o.order_zt!='已作废'");
		sumSql.append(" and o.order_zt='已作废'");

		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
				sql.append(" AND (m.branch_id IN ("+allDepts+") ");
				sql.append(" OR o.mid="+mId+")");
				sumSql.append(" AND (m.branch_id IN ("+allDepts+") ");
				sumSql.append(" OR o.mid="+mId+")");
			} else {
				sql.append(" AND m.branch_id IN ("+allDepts+") ");
				sumSql.append(" AND m.branch_id IN ("+allDepts+") ");
			}
		}else if (!StrUtil.isNull(mId)) {//个人
			sql.append(" AND o.mid="+mId);
			sumSql.append(" AND o.mid="+mId);
		}
		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
			sql.append(" AND m.branch_id NOT IN ("+invisibleDepts+") ");
			sumSql.append(" AND m.branch_id NOT IN ("+invisibleDepts+") ");
		}
		if(!StrUtil.isNull(Cpddtj)){
				sql.append(" and a.order_id in (select x.id from "+database+".sys_bforder x left join "+database+".sys_customer y on x.cid=y.id left join "+database+".sys_mem z on x.mid=z.member_id where 1=1");
				sumSql.append(" and a.order_id in (select x.id from "+database+".sys_bforder x left join "+database+".sys_customer y on x.cid=y.id left join "+database+".sys_mem z on x.mid=z.member_id where 1=1");
				if(!StrUtil.isNull(Cpddtj.getStime())){
					sql.append(" and x.oddate >='").append(Cpddtj.getStime()).append("'");
					sumSql.append(" and x.oddate >='").append(Cpddtj.getStime()).append("'");
				}
				if(!StrUtil.isNull(Cpddtj.getEtime())){
					sql.append(" and x.oddate <='").append(Cpddtj.getEtime()).append("'");
					sumSql.append(" and x.oddate <='").append(Cpddtj.getEtime()).append("'");
				}
				if(!StrUtil.isNull(Cpddtj.getKhNm())){
					sql.append(" and y.kh_nm like '%"+Cpddtj.getKhNm()+"%'");
					sumSql.append(" and y.kh_nm like '%"+Cpddtj.getKhNm()+"%'");
				}
				if(!StrUtil.isNull(Cpddtj.getMemberNm())){
					sql.append(" and z.member_nm like '%"+Cpddtj.getMemberNm()+"%'");
					sumSql.append(" and z.member_nm like '%"+Cpddtj.getMemberNm()+"%'");
				}
				if(!StrUtil.isNull(Cpddtj.getPszd())){
					sql.append(" and x.pszd like '%"+Cpddtj.getPszd()+"%'");
					sumSql.append(" and x.pszd like '%"+Cpddtj.getPszd()+"%'");
				}
				sql.append(")");
				sumSql.append(")");
				if(!StrUtil.isNull(Cpddtj.getXsTp())){
					sql.append(" and a.xs_tp like '%"+Cpddtj.getXsTp()+"%'");
					sumSql.append(" and a.xs_tp like '%"+Cpddtj.getXsTp()+"%'");
				}
		}
	    sql.append(" group by a.ware_id,a.xs_tp,a.ware_dj ");
		try {
			Page p=this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoCpddtj.class);
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
	 *说明：分页查询产品订单统计表
	 *@创建：作者:llp		创建时间：2016-7-14
	 *@修改历史：
	 *		[序号](llp	2016-7-14)<修改说明>
	 */
	public Page queryBiaoCpddtjWeb(BiaoCpddtj Cpddtj, String database, Map<String, Object> map, Integer page, Integer limit, String mids, Integer jepx){
		StringBuilder sql = new StringBuilder();
		StringBuilder sumSql=new StringBuilder();
		sql.append("select b.ware_nm,a.xs_tp,sum(a.ware_num) as nums,a.ware_dj,sum(a.ware_zj) as zjs from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id ");
		sumSql.append("select sum(a.ware_num) as tolnum,sum(a.ware_zj) as tolprice from "+database+".sys_bforder_detail a left join "+database+".sys_ware b on a.ware_id=b.ware_id ");
		sql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sumSql.append(" left join "+database+".sys_bforder o on a.order_id=o.id left join "+database+".sys_mem m on o.mid=m.member_id ");
		sql.append(" where 1=1 ");
		sumSql.append(" where 1=1 ");
		if(!StrUtil.isNull(mids)){
			sql.append(" AND o.mid in ("+mids+")");
			sumSql.append(" AND o.mid in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sql.append(" AND (m.branch_id IN ("+map.get("allDepts")+") ");
					sql.append(" OR o.mid="+map.get("mId")+")");
					sumSql.append(" AND (m.branch_id IN ("+map.get("allDepts")+") ");
					sumSql.append(" OR o.mid="+map.get("mId")+")");
				} else {
					sql.append(" AND m.branch_id IN ("+map.get("allDepts")+") ");
					sumSql.append(" AND m.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sql.append(" AND o.mid="+map.get("mId"));
				sumSql.append(" AND o.mid="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sql.append(" AND m.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
				sumSql.append(" AND m.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		if(!StrUtil.isNull(Cpddtj)){
				sql.append(" and a.order_id in (select x.id from "+database+".sys_bforder x left join "+database+".sys_customer y on x.cid=y.id left join "+database+".sys_mem z on x.mid=z.member_id where 1=1");
				sumSql.append(" and a.order_id in (select x.id from "+database+".sys_bforder x left join "+database+".sys_customer y on x.cid=y.id left join "+database+".sys_mem z on x.mid=z.member_id where 1=1");
				if(!StrUtil.isNull(Cpddtj.getTp())){
					if(!Cpddtj.getTp().equals("1")){
						sql.append(" and z.member_id in ("+Cpddtj.getStr()+")");
						sumSql.append(" and z.member_id in ("+Cpddtj.getStr()+")");
					}
				}
				if(!StrUtil.isNull(Cpddtj.getStime())){
					sql.append(" and x.oddate >='").append(Cpddtj.getStime()).append("'");
					sumSql.append(" and x.oddate >='").append(Cpddtj.getStime()).append("'");
				}
				if(!StrUtil.isNull(Cpddtj.getEtime())){
					sql.append(" and x.oddate <='").append(Cpddtj.getEtime()).append("'");
					sumSql.append(" and x.oddate <='").append(Cpddtj.getEtime()).append("'");
				}
				if(!StrUtil.isNull(Cpddtj.getKhNm())){
					sql.append(" and (y.kh_nm like '%"+Cpddtj.getKhNm()+"%' or z.member_nm like '%"+Cpddtj.getKhNm()+"%')");
					sumSql.append(" and (y.kh_nm like '%"+Cpddtj.getKhNm()+"%' or z.member_nm like '%"+Cpddtj.getKhNm()+"%')");
				}
				if(!StrUtil.isNull(Cpddtj.getPszd())){
					sql.append(" and x.pszd like '%"+Cpddtj.getPszd()+"%'");
					sumSql.append(" and x.pszd like '%"+Cpddtj.getPszd()+"%'");
				}
				sql.append(")");
				sumSql.append(")");
				if(!StrUtil.isNull(Cpddtj.getXsTp())){
					sql.append(" and a.xs_tp like '%"+Cpddtj.getXsTp()+"%'");
					sumSql.append(" and a.xs_tp like '%"+Cpddtj.getXsTp()+"%'");
				}
		}
		sql.append(" group by a.ware_id,a.xs_tp,a.ware_dj");
		if(!StrUtil.isNull(jepx)){
			if(jepx==1){
				 sql.append(" order by zjs desc");
			}else if(jepx==2){
				 sql.append(" order by zjs asc");
			}else if(jepx==3){
				sql.append(" order by nums desc");
			}else if(jepx==4){
				sql.append(" order by nums asc");
			}else{
				 sql.append(" order by zjs asc");
				 }

		}
		try {
			Page p=this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoCpddtj.class);
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
}
