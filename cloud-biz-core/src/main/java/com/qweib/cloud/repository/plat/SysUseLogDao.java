package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysUseLog;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysUseLogDao {
	@Resource(name = "pdaoTemplate")
	private JdbcDaoTemplatePlud pdaoTemplate;

	@Resource(name = "daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public Page queryUseLog(SysUseLog uselog, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from sys_use_log a where 1=1 ");
		if(null!=uselog){
			if(!StrUtil.isNull(uselog.getSdate()))
			{
				sql.append( " and a.fd_create_time >='" + uselog.getSdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getEdate()))
			{
				sql.append( " and a.fd_create_time<'" + uselog.getEdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getFdCompanyNm())){
				sql.append(" and a.fd_company_nm like '%").append(uselog.getFdCompanyNm()).append("%'");
			}
			if(!StrUtil.isNull(uselog.getFdMemberNm())){
				sql.append(" and a.fd_member_nm like '%").append(uselog.getFdMemberNm()).append("%'");
			}
		}
		sql.append(" order by a.id desc ");
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysUseLog.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 分析企业使用频次　
	 * @param uselog
	 * @param page
	 * @param limit
	 * @return
	 */
	public Page queryCompanyUseLog(SysUseLog uselog, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.fd_company_id,a.fd_company_nm,");
		sql.append("count(DISTINCT(a.fd_member_id)) as renchi,");
		sql.append("count(a.id) as  zongchisu ");
		sql.append(" from sys_use_log a where 1=1 ");
		if(null!=uselog){
			if(!StrUtil.isNull(uselog.getSdate()))
			{
				sql.append( " and a.fd_create_time >='" + uselog.getSdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getEdate()))
			{
				sql.append( " and a.fd_create_time<'" + uselog.getEdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getFdCompanyNm())){
				sql.append(" and a.fd_company_nm like '%").append(uselog.getFdCompanyNm()).append("%'");
			}
		}
		sql.append(" group by a.fd_company_id,a.fd_company_nm");
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 分析企业用户使用频次　
	 * @param uselog
	 * @param page
	 * @param limit
	 * @return
	 */
	public Page queryMemberUseLog(SysUseLog uselog, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select a.fd_company_id,a.fd_company_nm,a.fd_member_id,a.fd_member_nm,");
		sql.append("count(a.id) as  zongchisu ");
		sql.append(" from sys_use_log a where 1=1 ");
		if(null!=uselog){
			if(!StrUtil.isNull(uselog.getSdate()))
			{
				sql.append( " and a.fd_create_time >='" + uselog.getSdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getEdate()))
			{
				sql.append( " and a.fd_create_time<'" + uselog.getEdate() + "'");
			}
			if(!StrUtil.isNull(uselog.getFdCompanyNm())){
				sql.append(" and a.fd_company_nm like '%").append(uselog.getFdCompanyNm()).append("%'");
			}
			if(!StrUtil.isNull(uselog.getFdMemberNm())){
				sql.append(" and a.fd_member_nm like '%").append(uselog.getFdMemberNm()).append("%'");
			}
		}
		sql.append(" group by a.fd_company_id,a.fd_company_nm,a.fd_member_id,a.fd_member_nm");
		try {
			return this.pdaoTemplate.queryForPageByMySql(sql.toString(), page, limit);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public SysUseLog queryUseLogById(Integer Id){
		try{
			String sql = "select * from sys_use_log where dept_id=? ";
			return this.pdaoTemplate.queryForObj(sql, SysUseLog.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}



	public Integer addUseLog(SysUseLog uselog) {
		try{
			return pdaoTemplate.addByObject("sys_use_log",uselog);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public Integer getAutoId() {
		try{
			return pdaoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}



}
