package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysAutoCustomerPrice;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import com.qweib.cloud.utils.WareSqlUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysAutoCustomerPriceDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_auto_customer_price a");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysAutoCustomerPrice.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 查找启用状态公司产品的数据
	 *
	 * @param ware
	 * @param page
	 * @param rows
	 * @param database
	 * @return
	 */
	public Page queryCustomerAutoFieldWarePage(SysWare ware,int page, int rows,Integer customerId, String database) {
		StringBuffer sql = new StringBuffer(" select a.*,b.waretype_nm,b.waretype_path from " + database + ".sys_ware a");
		sql.append(" left join " + database + ".sys_waretype b on a.waretype=b.waretype_id ");
		sql.append("  where 1=1 ");
		sql.append(" and ").append(WareSqlUtil.getWareWhere("a"));
		sql.append(" and ").append(WareSqlUtil.getCompanyWareTypeAppendSql("b"));
//        sql.append(" and (a.status='1' or a.status='') ");
//        sql.append(" and (b.no_company =0 or b.no_company is null) ");
		if (null != ware) {
			if (!StrUtil.isNull(ware.getWareNm())) {
				if (StrUtil.isContainChinese(ware.getWareNm())) {
					ware.setWareNm(ware.getWareNm().replaceAll(" ", ""));
					for (int i = 0; i < ware.getWareNm().length(); i++) {
						sql.append(" and a.ware_nm like '%" + ware.getWareNm().substring(i, i + 1) + "%'");
					}
				} else {
					sql.append(" and (a.ware_nm like '%" + ware.getWareNm() + "%' or a.ware_code like '%" + ware.getWareNm() + "%' or a.be_bar_code like '%" + ware.getWareNm() + "%' or a.pack_bar_code like '%" + ware.getWareNm() + "%' or a.py like '%" + ware.getWareNm() + "%')");
				}
			}
			if (!StrUtil.isNull(ware.getStatus())) {
				sql.append(" and a.status=").append(ware.getStatus());
			}
			if (!StrUtil.isNull(ware.getBeBarCode())) {
				sql.append(" and a.be_bar_code like concat('%', '").append(ware.getBeBarCode()).append("' ,'%')");
			}
			if (!StrUtil.isNull(ware.getPackBarCode())) {
				sql.append(" and a.pack_bar_code like concat('%', '").append(ware.getPackBarCode()).append("' ,'%')");
			}
			if (!StrUtil.isNull(ware.getIsType())) {
				sql.append(" and b.is_type=").append(ware.getIsType());
			}

			if(!StrUtil.isNull(ware.getShowAllProducts())&&ware.getShowAllProducts()==0){
				sql.append(" and a.ware_id in( ").append("select z.ware_id from "+database+".sys_auto_customer_price z where z.price>0 and z.customer_id="+customerId+" ").append(")");
			}

		}
		if (null != ware.getWaretype() && ware.getWaretype() != 0) {
			sql.append(" and instr(b.waretype_path,'-").append(ware.getWaretype()).append("-')>0");
		}
		sql.append(" order by a.ware_id asc ");
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysWare.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


    public List<SysAutoCustomerPrice> queryList(SysAutoCustomerPrice autoCustomerPrice, String database){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_auto_customer_price a ");
    	sql.append(" where 1=1 ");
    	if(autoCustomerPrice!=null){
    		if(!StrUtil.isNull(autoCustomerPrice.getAutoId())){
    			sql.append(" and a.auto_Id = ").append(autoCustomerPrice.getAutoId());
    		}
    		if(!StrUtil.isNull(autoCustomerPrice.getCustomerId())){
    			sql.append(" and a.customer_id=").append(autoCustomerPrice.getCustomerId());
    		}
			if(!StrUtil.isNull(autoCustomerPrice.getCustomerIds())){
				sql.append(" and a.customer_id in ( ").append(autoCustomerPrice.getCustomerIds()).append(") ");
			}

			if(!StrUtil.isNull(autoCustomerPrice.getWareIds())){
				sql.append(" and a.ware_id in (").append(autoCustomerPrice.getWareIds()).append(")");
			}

    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysAutoCustomerPrice.class);
    }


	public int addAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_auto_customer_price", autoCustomerPrice);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysAutoCustomerPrice queryAutoCustomerPriceById(Integer autoCustomerPriceId, String database){
		String sql = "select * from "+database+".sys_auto_customer_price where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysAutoCustomerPrice.class, autoCustomerPriceId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateAutoCustomerPrice(SysAutoCustomerPrice autoCustomerPrice, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", autoCustomerPrice.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_auto_customer_price", autoCustomerPrice, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int deleteAutoCustomerPrice(Integer id,String database){
		String sql = " delete from "+database+".sys_auto_customer_price where id=? ";
		try {
			return this.daoTemplate.update(sql,id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public void deleteAutoCustomerPriceAll(String database){
		String sql = "delete from "+database+".sys_auto_customer_price";
		try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
