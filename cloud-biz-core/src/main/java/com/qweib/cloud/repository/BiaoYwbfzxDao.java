package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BiaoYwbfzx;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.Map;

//业务拜访执行表
@Repository
public class BiaoYwbfzxDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询业务拜访执行表
	 *@创建：作者:llp		创建时间：2016-7-5
	 *@修改历史：
	 *		[序号](llp	2016-7-5)<修改说明>
	 */
	public Page queryBiaoYwbfzx(BiaoYwbfzx Ywbfzx, String database, Integer mId, String allDepts, String invisibleDepts, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime as timed,b.kh_nm,c.member_nm,b.khdj_nm from "+database+".sys_bfqdpz a " +
				"left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
				sql.append(" AND (c.branch_id IN ("+allDepts+") ");
				sql.append(" OR a.mid="+mId+")");
			} else {
				sql.append(" AND c.branch_id IN ("+allDepts+") ");
			}
		}else if (!StrUtil.isNull(mId)) {//个人
			sql.append(" AND a.mid="+mId);
		}
		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
			sql.append(" AND c.branch_id NOT IN ("+invisibleDepts+") ");
		}
		if(null!=Ywbfzx){
			if(!StrUtil.isNull(Ywbfzx.getQddate())){
				sql.append(" and a.qddate='"+Ywbfzx.getQddate()+"'");
			}
			if(!StrUtil.isNull(Ywbfzx.getMemberNm())){
				sql.append(" and c.member_nm like '%"+Ywbfzx.getMemberNm()+"%'");
			}
			if(!StrUtil.isNull(Ywbfzx.getKhNm())){
				sql.append(" and b.kh_nm like '%"+Ywbfzx.getKhNm()+"%'");
			}
			if(!StrUtil.isNull(Ywbfzx.getKhdjNm())){
				sql.append(" and b.khdj_nm='"+Ywbfzx.getKhdjNm()+"'");
			}
		}
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoYwbfzx.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询业务拜访执行表
	 *@创建：作者:llp		创建时间：2016-7-14
	 *@修改历史：
	 *		[序号](llp	2016-7-14)<修改说明>
	 */
	public Page queryBiaoYwbfzxWeb(BiaoYwbfzx Ywbfzx, String database, Map<String, Object> map, Integer page, Integer limit, String mids){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.mid,a.cid,a.qddate,a.qdtime as timed,b.kh_nm,c.member_nm,b.khdj_nm from "+database+".sys_bfqdpz a " +
				"left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
		if(null!=Ywbfzx){
			if(!StrUtil.isNull(Ywbfzx.getTp())){
				if(!Ywbfzx.getTp().equals("1")){
					sql.append(" and c.member_id in ("+Ywbfzx.getStr()+")");
				}
			}
			if(!StrUtil.isNull(Ywbfzx.getQddate())){
				sql.append(" and a.qddate='"+Ywbfzx.getQddate()+"'");
			}
			if(!StrUtil.isNull(Ywbfzx.getMemberNm())){
				sql.append(" and (c.member_nm like '%"+Ywbfzx.getMemberNm()+"%' or b.kh_nm like '%"+Ywbfzx.getMemberNm()+"%')");
			}
			if(!StrUtil.isNull(Ywbfzx.getKhdjNm())){
				sql.append(" and b.khdj_nm='"+Ywbfzx.getKhdjNm()+"'");
			}
		}
		if(!StrUtil.isNull(mids)){
			sql.append(" AND a.mid in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
					sql.append(" OR a.mid="+map.get("mId")+")");
				} else {
					sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sql.append(" AND a.mid="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BiaoYwbfzx.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
