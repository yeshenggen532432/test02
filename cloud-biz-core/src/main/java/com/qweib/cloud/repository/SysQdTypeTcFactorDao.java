package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysQdTypeTcFactor;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysQdTypeTcFactorDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryQdTypeTcFactor(SysQdTypeTcFactor qdTypeTcFactor, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_qd_type_tc_factor a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysQdTypeTcFactor.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysQdTypeTcFactor> queryList(SysQdTypeTcFactor qdTypeTcFactor, String database){
    	StringBuffer sql = new StringBuffer(" select a.*,b.qdtp_nm from "+database+".sys_qd_type_tc_factor a left join "+database+".sys_qdtype b on a.rela_id = b.id ");
    	sql.append(" where 1=1 ");
    	if(qdTypeTcFactor!=null){
    		if(!StrUtil.isNull(qdTypeTcFactor.getRelaId())){
				sql.append(" and a.rela_Id = ").append(qdTypeTcFactor.getRelaId());
			}
			if(!StrUtil.isNull(qdTypeTcFactor.getWareId())){
				sql.append(" and a.ware_id = ").append(qdTypeTcFactor.getWareId());
			}
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysQdTypeTcFactor.class);
    }


	public int addQdTypeTcFactor(SysQdTypeTcFactor qdTypeTcFactor, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_qd_type_tc_factor", qdTypeTcFactor);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcFactor queryQdTypeTcFactorById(Integer qdTypeTcFactorId, String database){
		String sql = "select * from "+database+".sys_qd_type_tc_factor where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysQdTypeTcFactor.class, qdTypeTcFactorId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public List<SysQdTypeTcFactor> groupQdTypeTcFactorByWareId(String database, Integer wareId){
		StringBuilder sql = new StringBuilder();
		sql.append(" select a.ware_id,ifnull(a.price,0) as price,ifnull(a.ls_Price,0) as ls_Price,ifnull(a.fx_Price,0) as fx_Price,ifnull(a.cx_Price,0) as cx_Price,ifnull(a.sunit_Price,0) as sunit_Price,ifnull(a.min_Ls_Price,0) as min_Ls_Price,ifnull(a.min_Fx_Price,0) as min_Fx_Price,ifnull(a.min_Cx_Price,0) as min_Cx_Price from " + database + ".sys_customer_price where ware_id=").append(wareId);
		sql.append(" group by a.ware_id,ifnull(a.price,0),ifnull(a.ls_Price,0),ifnull(a.fx_Price,0),ifnull(a.cx_Price,0),ifnull(a.sunit_Price,0),ifnull(a.min_Ls_Price,0),ifnull(a.min_Fx_Price,0),ifnull(a.min_Cx_Price,0)  ");
		try {
			return this.daoTemplate.queryForLists(sql.toString(), SysQdTypeTcFactor.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int updateQdTypeTcFactor(SysQdTypeTcFactor qdTypeTcFactor, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", qdTypeTcFactor.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_qd_type_tc_factor", qdTypeTcFactor, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteQdTypeTcFactor(Integer id,String database){
		String sql = " delete from "+database+".sys_qd_type_tc_factor where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteQdTypeTcFactorAll(String database){
		String sql = "delete from "+database+".sys_qd_type_tc_factor";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcFactor queryQdTypeTcFactor(SysQdTypeTcFactor TypeTcFactor, String database){
		try{
			StringBuffer sb = new StringBuffer();
			sb.append(" select * from "+database+".sys_qd_type_tc_factor");
			sb.append(" where 1=1");
			if(null != TypeTcFactor){
				if(!StrUtil.isNull(TypeTcFactor.getRelaId())){
					sb.append(" and rela_id = " + TypeTcFactor.getRelaId());
				}
				if(!StrUtil.isNull(TypeTcFactor.getWareId())){
					sb.append(" and ware_id = " + TypeTcFactor.getWareId());
				}
			}
			return this.daoTemplate.queryForObj(sb.toString(), SysQdTypeTcFactor.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysQdTypeTcFactor queryQdTypeTcFactorByWareIdAndRelaId(Integer relaId, Integer wareId, String database){
		String sql = "select * from "+database+".sys_qd_type_tc_factor where ware_id=? and rela_id=?";
		try{
			List<SysQdTypeTcFactor> list = this.daoTemplate.queryForLists(sql, SysQdTypeTcFactor.class,wareId,relaId);
			if(list!=null&&list.size()>0){
				return list.get(0);
			}
			return null;
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
