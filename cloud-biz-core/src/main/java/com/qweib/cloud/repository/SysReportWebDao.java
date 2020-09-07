package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysReport;
import com.qweib.cloud.core.domain.SysReportFile;
import com.qweib.cloud.core.domain.SysReportPl;
import com.qweib.cloud.core.domain.SysReportYh;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class SysReportWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加报
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public int addReport(SysReport report, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_report", report);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：报自增id
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public int queryAutoId(){
		try {
			return this.daoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询报(表)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage1(SysReport report, String database, Map<String, Object> map, Integer page, Integer limit, String mids){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.gz_nr,a.gz_zj,a.gz_jh,a.gz_bz,a.remo,a.fb_time,a.tp,c.member_nm from "+database+".sys_report a " +
				"left join "+database+".sys_mem c on a.member_id=c.member_id where 1=1");
		if(!StrUtil.isNull(report)){
			if(!StrUtil.isNull(report.getTp2())){
				if(!report.getTp2().equals("1")){
					sql.append(" and a.member_id in ("+report.getStr()+")");
				}
			}
			if(!StrUtil.isNull(report.getTp())){
				sql.append(" and a.tp="+report.getTp()+"");
			}
			if(!StrUtil.isNull(report.getMemberNm())){
				sql.append(" and c.member_nm like '%"+report.getMemberNm()+"%'");
			}
			if(!StrUtil.isNull(report.getSdate())){
				sql.append(" and a.fb_time >='").append(report.getSdate()+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(report.getEdate())){
				sql.append(" and a.fb_time <='").append(report.getEdate()+" 23:59:59").append("'");
			}
			if(!StrUtil.isNull(report.getFsMids())){
				sql.append(" and a.member_id in ("+report.getFsMids()+")");
			}
		}
		if(!StrUtil.isNull(mids)){
			sql.append(" AND a.member_id in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
					sql.append(" OR a.member_id="+map.get("mId")+")");
				} else {
					sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sql.append(" AND a.member_id="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysReport.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询报(表)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage11(SysReport report, String database, Map<String, Object> map, Integer page, Integer limit, String mids){
		StringBuilder sql = new StringBuilder();
		sql.append("select c.member_nm,(select count(1) from "+database+".sys_report where member_id=c.member_id ");
		if(!StrUtil.isNull(report)){
			if(!StrUtil.isNull(report.getTp())){
				sql.append(" and tp="+report.getTp()+"");
			}
			if(!StrUtil.isNull(report.getSdate())){
				sql.append(" and fb_time >='").append(report.getSdate()+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(report.getEdate())){
				sql.append(" and fb_time <='").append(report.getEdate()+" 23:59:59").append("'");
			}
			sql.append(" ) as counts from "+database+".sys_mem c where 1=1");
			if(!StrUtil.isNull(report.getTp2())){
				if(!report.getTp2().equals("1")){
					sql.append(" and c.member_id in ("+report.getStr()+")");
				}
			}
			if(!StrUtil.isNull(report.getFsMids())){
				sql.append(" and c.member_id in ("+report.getFsMids()+")");
			}
			if(!StrUtil.isNull(report.getMemberNm())){
				sql.append(" and c.member_nm like '%"+report.getMemberNm()+"%'");
			}
		}
		if(!StrUtil.isNull(mids)){
			sql.append(" AND c.member_id in ("+mids+")");
		}else{
			if (!StrUtil.isNull(map.get("allDepts"))) {//要查询的部门和可见部门
				if (!StrUtil.isNull(map.get("mId"))) {//个人和可见部门结合查询
					sql.append(" AND (c.branch_id IN ("+map.get("allDepts")+") ");
					sql.append(" OR c.member_id="+map.get("mId")+")");
				} else {
					sql.append(" AND c.branch_id IN ("+map.get("allDepts")+") ");
				}
			}else if (!StrUtil.isNull(map.get("mId"))) {//个人
				sql.append(" AND c.member_id="+map.get("mId"));
			}
			if (!StrUtil.isNull(map.get("invisibleDepts"))) {//不可见部门
				sql.append(" AND c.branch_id NOT IN ("+map.get("invisibleDepts")+") ");
			}
		}
		sql.append(" having counts=0 ");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysReport.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询报(我发出的)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage2(SysReport report, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.id,a.gz_nr,a.gz_zj,a.gz_jh,a.gz_bz,a.fb_time,a.tp,c.member_nm from "+database+".sys_report a " +
				"left join "+database+".sys_mem c on a.member_id=c.member_id where 1=1");
		if(!StrUtil.isNull(report)){
			if(!StrUtil.isNull(report.getMemberId())){
				sql.append(" and a.member_id="+report.getMemberId()+"");
			}
			if(!StrUtil.isNull(report.getTp())){
				sql.append(" and a.tp="+report.getTp()+"");
			}
		}
		sql.append(" order by a.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysReport.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询报(我收到的)
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public Page queryReportWebPage3(SysReport report, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select b.id,b.gz_nr,b.gz_zj,b.gz_jh,b.gz_bz,b.fb_time,b.tp,c.member_nm from "+database+".sys_report_yh a left join "+database+".sys_report b on b.id=a.bid" +
				" left join "+database+".sys_mem c on a.fs_mid=c.member_id where 1=1");
		if(!StrUtil.isNull(report)){
			if(!StrUtil.isNull(report.getMemberId())){
				sql.append(" and a.js_mid="+report.getMemberId()+"");
			}
			if(!StrUtil.isNull(report.getTp())){
				sql.append(" and b.tp="+report.getTp()+"");
			}
			if(!StrUtil.isNull(report.getSdate())){
				sql.append(" and b.fb_time >='").append(report.getSdate()+" 00:00:00").append("'");
			}
			if(!StrUtil.isNull(report.getEdate())){
				sql.append(" and b.fb_time <='").append(report.getEdate()+" 23:59:59").append("'");
			}
			if(!StrUtil.isNull(report.getFsMids())){
				sql.append(" and a.fs_mid in ("+report.getFsMids()+")");
			}
		}
		sql.append(" order by b.id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysReport.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：根据报的id查询信息
	 *@创建：作者:llp		创建时间：2016-12-19
	 *@修改历史：
	 *		[序号](llp	2016-12-19)<修改说明>
	 */
	public SysReport queryReportById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_report where id=? ";
			return this.daoTemplate.queryForObj(sql, SysReport.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//---------------------------------报用户关系---------------------------
	/**
	 *说明：添加报用户关系
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public int addReportYh(SysReportYh reportYh, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_report_yh", reportYh);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：根据报id获取报用户关系信息
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public List<SysReportYh> queryReportYh(Integer bid, String database){
		String sql="select a.js_mid,c.member_nm,c.member_head from "+database+".sys_report_yh a left join "+database+".sys_mem c on a.js_mid=c.member_id where a.bid=? ";
		try {
			return this.daoTemplate.queryForLists(sql, SysReportYh.class, bid);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
   //---------------------------------报文件---------------------------
	/**
	 *说明：添加报文件
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public int addReportFile(SysReportFile reportFile, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_report_file", reportFile);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：根据报id,tp获取报文件信息
	 *@创建：作者:llp		创建时间：2016-12-16
	 *@修改历史：
	 *		[序号](llp	2016-12-16)<修改说明>
	 */
	public List<SysReportFile> queryReportFile(Integer bid, Integer tp, String database){
		String sql="";
		if(tp==1){
			sql="select bid,pic_mini,pic from "+database+".sys_report_file where bid=? and tp=?";
		}else if(tp==2){
			sql="select bid,wj from "+database+".sys_report_file where bid=? and tp=?";
		}
		try {
			return this.daoTemplate.queryForLists(sql, SysReportFile.class, bid,tp);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	//-----------------------------------------评论---------------------------------
	/**
	 *说明：添加报评论
	 *@创建：作者:llp		创建时间：2016-12-30
	 *@修改历史：
	 *		[序号](llp	2016-12-30)<修改说明>
	 */
	public int addReportPl(SysReportPl reportPl, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_report_pl", reportPl);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：分页查询报评论
	 *@创建：作者:llp		创建时间：2016-12-30
	 *@修改历史：
	 *		[序号](llp	2016-12-30)<修改说明>
	 */
	public Page queryReportPlWebPage(Integer bid, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.*,b.member_nm from "+database+".sys_report_pl a left join "+database+".sys_mem b on a.member_id=b.member_id where 1=1");
		if(!StrUtil.isNull(bid)){
			sql.append(" and a.bid="+bid+"");
		}
		sql.append(" order by a.id asc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysReportPl.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
