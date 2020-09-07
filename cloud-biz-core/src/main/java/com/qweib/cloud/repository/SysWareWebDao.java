package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;


@Repository
public class SysWareWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public List<SysWaretype> queryWaretypeLs1(SysWaretype type, String database){
		StringBuilder sql = new StringBuilder();
		sql.append("select waretype_id,waretype_nm,waretype_leaf from "+database+".sys_waretype where waretype_pid=0");
		if(type!=null){
			if(!StrUtil.isNull(type.getNoCompany())){//在实际业务中过滤非公司产品类别
				sql.append(" and (no_company = 0 or no_company is null)");
			}
		}
		sql.append(" order by waretype_id asc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysWaretype.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public List<SysWaretype> queryWaretypeLs2(SysWaretype type, String database, Integer waretypeId){
		StringBuilder sql = new StringBuilder();
		sql.append("select waretype_id,waretype_nm,waretype_leaf from "+database+".sys_waretype where 1=1");
		if(!StrUtil.isNull(waretypeId)){
			sql.append(" and waretype_pid="+waretypeId+"");
		}
		if(type!=null){
			if(!StrUtil.isNull(type.getNoCompany())){//在实际业务中过滤非公司产品类别
				sql.append(" and (no_company = 0 or no_company is null)");
			}
		}
		sql.append(" order by waretype_id asc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysWaretype.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public List<SysWare> queryWareLs(String database, Integer waretypeId){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_ware where is_cy=1 ");

		sql.append(" and (status='1' or status='')");

		if(!StrUtil.isNull(waretypeId)){
			sql.append(" and waretype="+waretypeId+"");
		}
		sql.append(" order by ware_id asc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysWare.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
