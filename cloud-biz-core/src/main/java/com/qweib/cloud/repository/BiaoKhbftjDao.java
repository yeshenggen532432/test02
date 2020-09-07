package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BiaoKhbftj;
import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.domain.SysBfqdpz;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Map;

@Repository
public class BiaoKhbftjDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询客户拜访统计表
	 *@创建：作者:llp		创建时间：2016-7-6
	 *@修改历史：
	 *		[序号](llp	2016-7-6)<修改说明>
	 */
	public Page queryBiaoKhbftj(BiaoKhbftj Khbftj, String database, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit){
		StringBuffer sql = new StringBuffer("");
		try {
            sql.append("select a.id,a.kh_tp,a.kh_nm,a.khdj_nm,a.create_time,a.scbf_date,if(b.bfpl is null,0,b.bfpl) as bfpl,c.member_nm from "+database+".sys_customer a join (select cid,mid,count(id) as bfpl from "+database+".sys_bfqdpz where 1=1");
            if(!StrUtil.isNull(Khbftj.getStime())){
				sql.append(" and qddate >='").append(Khbftj.getStime()).append("'");
			}
			if(!StrUtil.isNull(Khbftj.getEtime())){
				sql.append(" and qddate <='").append(Khbftj.getEtime()).append("'");
			}
            sql.append(" group by cid,mid)");
            sql.append(" b on a.id =b.cid left join "+database+".sys_mem c on b.mid =c.member_id where a.is_db=2");
			if(null!=Khbftj){
				if(!StrUtil.isNull(Khbftj.getKhdjNm())){
					sql.append(" and a.khdj_nm ='").append(Khbftj.getKhdjNm()).append("'");
				}
				if(!StrUtil.isNull(Khbftj.getMemberNm())){
					sql.append(" and c.member_nm like '%").append(Khbftj.getMemberNm()).append("%'");
				}
				if(!StrUtil.isNull(Khbftj.getBfpl())){
					if(Khbftj.getBfpl()==0){
						sql.append(" and if(b.bfpl is null,0,b.bfpl)=").append(Khbftj.getBfpl()).append("");
					}else{
						sql.append(" and if(b.bfpl is null,0,b.bfpl)>=").append(Khbftj.getBfpl()).append("");
					}
				}
			}
			if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
				if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
					sql.append(" AND (c.branch_id IN ("+allDepts+") ");
					sql.append(" OR a.mem_id="+mId+")");
				} else {
					sql.append(" AND c.branch_id IN ("+allDepts+") ");
				}
			}else if (!StrUtil.isNull(mId)) {//个人
				sql.append(" AND a.mem_id="+mId);
			}
			if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
				sql.append(" AND c.branch_id NOT IN ("+invisibleDepts+") ");
			}
			//sql.append(" group by a.id");
			  if(null!=Khbftj){
	            	/*if(!StrUtil.isNull(Khbftj.getStime())){
						sql.append(" and a.scbf_date >='").append(Khbftj.getStime()).append("'");
					}
					if(!StrUtil.isNull(Khbftj.getEtime())){
						sql.append(" and a.scbf_date <='").append(Khbftj.getEtime()).append("'");
					}*/
	            }

			sql.append(" order by a.scbf_date desc");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoKhbftj.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询客户拜访统计表
	 *@创建：作者:llp		创建时间：2016-7-6
	 *@修改历史：
	 *		[序号](llp	2016-7-6)<修改说明>
	 */
	public Page queryBiaoKhbftjWeb(BiaoKhbftj Khbftj, String database, Map<String, Object> map, Integer page, Integer limit, String mids){
		try {
			StringBuilder sql = new StringBuilder();
            sql.append("select a.id,a.kh_tp,a.kh_nm,a.khdj_nm,a.create_time,a.scbf_date,if(b.bfpl is null,0,b.bfpl) as bfpl,c.member_nm from "+database+".sys_customer a left join (select *,count(id) as bfpl from "+database+".sys_bfqdpz where 1=1");
            if(null!=Khbftj){
            	if(!StrUtil.isNull(Khbftj.getStime())){
					sql.append(" and qddate >='").append(Khbftj.getStime()).append("'");
				}
				if(!StrUtil.isNull(Khbftj.getEtime())){
					sql.append(" and qddate <='").append(Khbftj.getEtime()).append("'");
				}
            }
            sql.append(" group by cid)");
            sql.append(" b on a.id =b.cid left join "+database+".sys_mem c on a.mem_id =c.member_id where a.is_db=2");
			if(null!=Khbftj){
				if(!StrUtil.isNull(Khbftj.getTp())){
					if(!Khbftj.getTp().equals("1")){
						sql.append(" and a.mem_id in ("+Khbftj.getStr()+")");
					}
				}
				if(!StrUtil.isNull(Khbftj.getKhdjNm())){
					sql.append(" and a.khdj_nm ='").append(Khbftj.getKhdjNm()).append("'");
				}
				if(!StrUtil.isNull(Khbftj.getMemberNm())){
					sql.append(" and c.member_nm like '%").append(Khbftj.getMemberNm()).append("%'");
				}
				if(!StrUtil.isNull(Khbftj.getBfpl())){
					if(Khbftj.getBfpl()==0){
						sql.append(" and if(b.bfpl is null,0,b.bfpl)=").append(Khbftj.getBfpl()).append("");
					}else{
						sql.append(" and if(b.bfpl is null,0,b.bfpl)>=").append(Khbftj.getBfpl()).append("");
					}
				}
			}
			if(!StrUtil.isNull(mids)){
				sql.append(" AND a.mem_id in ("+mids+")");
			}else{
				if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
					if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
						sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
						sql.append(" OR a.mem_id="+map.get("mId")+")");
					} else {
						sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
					}
				}else if (!StrUtil.isNull(map.get("mId"))) {//个人
					sql.append(" AND a.mem_id="+map.get("mId"));
				}
				if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
					sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
				}
			}
			sql.append(" group by a.id");
			sql.append(" order by b.bfpl desc");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoKhbftj.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public SysBfqdpz queryBfqdpzOne1(String database, Integer cid, String qddate){
		try{
			String sql = "select * from "+database+".sys_bfqdpz where cid=? and qddate=?";
			return this.daoTemplate.queryForObj(sql, SysBfqdpz.class,cid,qddate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public SysBfgzxc queryBfgzxcOne1(String database, Integer cid, String dqdate){
		try{
			String sql = "select * from "+database+".sys_bfgzxc where cid=? and dqdate=?";
			return this.daoTemplate.queryForObj(sql, SysBfgzxc.class,cid,dqdate);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
