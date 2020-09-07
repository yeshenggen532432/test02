package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysBrand;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysBrandDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryBrandPage(SysBrand brand, String database, Integer page, Integer limit){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_brand where 1=1");
		if(null!=brand){
			if(!StrUtil.isNull(brand.getName())){
				sql.append(" and name like '%"+brand.getName()+"%' ");
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, SysBrand.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	public List<SysBrand> queryList(SysBrand brand, String database){
		StringBuilder sql = new StringBuilder();
		sql.append("select * from "+database+".sys_brand where 1=1");
		if(null!=brand){
			if(!StrUtil.isNull(brand.getName())){
				sql.append(" and name like '%"+brand.getName()+"%' ");
			}
			if(!StrUtil.isNull(brand.getStatus())){
				sql.append(" and status=").append(brand.getStatus());
			}
		}
		sql.append(" order by id desc");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysBrand.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int addBrand(SysBrand brand, String database){
		try{
			return this.daoTemplate.addByObject(database+".sys_brand", brand);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateBrand(SysBrand brand, String database){
		try{
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", brand.getId());
			return this.daoTemplate.updateByObject(database+".sys_brand", brand, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysBrand queryBrandById(Integer Id, String database){
		try{
			String sql = "select * from "+database+".sys_brand where id=? ";
			return this.daoTemplate.queryForObj(sql, SysBrand.class,Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int deleteBrandById(Integer Id,String database){
		try{
			String sql = "delete  from "+database+".sys_brand where id=? ";
			return this.daoTemplate.update(sql, Id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
