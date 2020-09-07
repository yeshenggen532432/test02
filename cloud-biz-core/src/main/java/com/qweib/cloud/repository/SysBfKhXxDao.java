package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBfKhXx;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysBfKhXxDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询业务员拜访明细
	 *@创建：作者:llp		创建时间：2016-4-18
	 *@修改历史：
	 *		[序号](llp	2016-4-18)<修改说明>
	 */
	public Page queryBfKhXx(SysBfKhXx bfKhXx, Integer mId, String allDepts, String invisibleDepts, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.mid,a.cid,a.qddate,c.member_nm,c.member_mobile,a.qdtime as bftime,b.kh_nm,b.qdtp_nm,b.khdj_nm,b.remo,a.address as qdaddress,b.address as khaddress,b.linkman,b.tel,b.mobile," +
				"(select branch_name from "+database+".sys_depart where branch_id=c.branch_id) as branch_name from "+database+".sys_bfqdpz a " +
				"left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id where 1=1");
		if(null!=bfKhXx){
			if(!StrUtil.isNull(bfKhXx.getKhNm())){
				sql.append(" and b.kh_nm like '%"+bfKhXx.getKhNm()+"%' ");
			}
			if(!StrUtil.isNull(bfKhXx.getMemberNm())){
				sql.append(" and c.member_nm like '%"+bfKhXx.getMemberNm()+"%' ");
			}
			if(!StrUtil.isNull(bfKhXx.getStime())){
				sql.append(" and a.qddate >='").append(bfKhXx.getStime()).append("'");
			}
			if(!StrUtil.isNull(bfKhXx.getEtime())){
				sql.append(" and a.qddate <='").append(bfKhXx.getEtime()).append("'");
			}
			if(!StrUtil.isNull(bfKhXx.getMemberIds())){
				sql.append(" and a.mem_id in("+bfKhXx.getMemberIds()+") ");
			}
			//qdtpNm
			//System.out.println("=======:"+bfKhXx.getQdtpNm());
			if(!StrUtil.isNull(bfKhXx.getQdtpNm())){
				//System.out.println("============2:"+bfKhXx.getQdtpNm());
				sql.append(" and b.qdtp_Nm like '%").append(bfKhXx.getQdtpNm()).append("%'");
			}

			if(!StrUtil.isNull(bfKhXx.getKhdjNm())){
				sql.append(" and b.khdj_nm='"+bfKhXx.getKhdjNm()+"'");
			}
			if(!StrUtil.isNull(bfKhXx.getBranchId())){
				sql.append(" and c.branch_id=").append(bfKhXx.getBranchId());
			}
		}
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
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfKhXx.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public Page queryBfKhXx1(SysBfKhXx bfKhXx, Integer mId, String allDepts, String invisibleDepts, String xxIds, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.mid,a.cid,a.qddate,c.member_nm,c.member_mobile,a.qdtime as bftime,b.kh_nm,b.qdtp_nm,b.khdj_nm,b.remo,a.address as qdaddress,b.address as khaddress,b.linkman,b.tel,b.mobile," +
				"(select branch_name from "+database+".sys_depart where branch_id=c.branch_id) as branch_name from "+database+".sys_bfqdpz a " +
				"left join "+database+".sys_customer b on a.cid=b.id left join "+database+".sys_mem c on a.mid=c.member_id ");
		if(!StrUtil.isNull(xxIds))
		{
			if(xxIds.indexOf("1")!= -1 )
			{
				sql.append(" join " + database + ".sys_bfqdpz pz on pz.mid=a.mid and pz.cid=a.cid and pz.qddate=a.qddate ");
			}

			if(xxIds.indexOf("2,3")!= -1 )
			{
				sql.append(" join " + database + ".sys_bfsdhjc jc on jc.mid=a.mid and jc.cid=a.cid and jc.sddate=a.qddate ");
			}
			if(xxIds.indexOf("4")!= -1)
			{
				//sys_bfcljccj
				sql.append(" join " + database + ".sys_bfcljccj ccj on ccj.mid=a.mid and ccj.cid=a.cid and ccj.cjdate=a.qddate ");
			}
			if(xxIds.indexOf("5")!= -1)
			{
				//sys_bfgzxc
				sql.append(" join " + database + ".sys_bfgzxc xc on xc.mid=a.mid and xc.cid=a.cid and xc.qddate=a.qddate ");
			}
		}
		sql.append(" where 1=1 ");
		if(null!=bfKhXx){
			if(!StrUtil.isNull(bfKhXx.getKhNm())){
				sql.append(" and b.kh_nm like '%"+bfKhXx.getKhNm()+"%' ");
			}
			if(!StrUtil.isNull(bfKhXx.getMemberNm())){
				sql.append(" and c.member_nm like '%"+bfKhXx.getMemberNm()+"%' ");
			}
			if(!StrUtil.isNull(bfKhXx.getStime())){
				sql.append(" and a.qddate >='").append(bfKhXx.getStime()).append("'");
			}
			if(!StrUtil.isNull(bfKhXx.getEtime())){
				sql.append(" and a.qddate <='").append(bfKhXx.getEtime()).append("'");
			}
			if(!StrUtil.isNull(bfKhXx.getMemberIds())){
				sql.append(" and a.mem_id in("+bfKhXx.getMemberIds()+") ");
			}
			//qdtpNm
			//System.out.println("=======:"+bfKhXx.getQdtpNm());
			if(!StrUtil.isNull(bfKhXx.getQdtpNm())){
				//System.out.println("============2:"+bfKhXx.getQdtpNm());
				sql.append(" and b.qdtp_Nm like '%").append(bfKhXx.getQdtpNm()).append("%'");
			}
			if(!StrUtil.isNull(xxIds))
			{
				if(xxIds.indexOf("1")!= -1 )
				{
				sql.append(" and pz.id in(select ss_id from " + database + ".sys_bfxg_pic where xx_id = 1 and xx_id is not null ) ");
				}
				if(xxIds.indexOf("2,3")!= -1 )
				{
				sql.append(" and jc.id in(select ss_id from " + database + ".sys_bfxg_pic where xx_id in(2,3) and xx_id is not null ) ");
				}
				if(xxIds.indexOf("4")!= -1 )
				{
				sql.append(" and ccj.id in(select ss_id from " + database + ".sys_bfxg_pic where xx_id =4 and xx_id is not null ) ");
				}
				if(xxIds.indexOf("5")!= -1 )
				{
				sql.append(" and xc.id in(select ss_id from " + database + ".sys_bfxg_pic where xx_id = 5 and xx_id is not null ) ");
				}
			}
		}
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
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBfKhXx.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
