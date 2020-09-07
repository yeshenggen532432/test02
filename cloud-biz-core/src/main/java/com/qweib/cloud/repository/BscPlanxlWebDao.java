package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPlanSub;
import com.qweib.cloud.core.domain.BscPlanxl;
import com.qweib.cloud.core.domain.BscPlanxlDetail;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscPlanxlWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：分页查询计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public Page queryBscPlanxlWeb(String database, Integer mid, Integer page, Integer limit, String xlNm){
		StringBuilder sql = new StringBuilder();
		sql.append(" select a.*,(select count(1) from "+database+".bsc_planxl_detail where xl_id=a.id) as num from "+database+".bsc_planxl a where a.mid="+mid+"");

		if(!StrUtil.isNull(xlNm)){
			sql.append(" and a.xl_nm like '%"+xlNm+"%'");
		}
		sql.append(" order by a.id desc");
	    try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, limit, BscPlanxl.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 说明：分页查询计划（我的拜访明细）(新的)
	 */
	public List<BscPlanxlDetail> queryBscPlanxlDetailWeb(String database, Integer xlId) {
		try {
			StringBuilder sql = new StringBuilder();
			sql.append(" select a.*,c.kh_nm,c.address,c.linkman,c.tel,c.scbf_date,c.latitude,c.longitude from " + database + ".bsc_planxl_detail a ");
			sql.append(" left join " + database + ".sys_customer c on a.cid = c.id");
			sql.append(" where a.xl_id = " + xlId + "");
			sql.append(" order by a.id ASC");
			return this.daoTemplate.queryForLists(sql.toString(), BscPlanxlDetail.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：添加计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public int addBscPlanxlWeb(BscPlanxl planxl, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".bsc_planxl", planxl);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：获取自增id
	 *@创建：作者:yxy		创建时间：2013-4-13
	 *@return
	 *@修改历史：
	 *		[序号](yxy	2013-4-13)<修改说明>
	 */
	public int queryAutoId(){
		try {
			return this.daoTemplate.getAutoIdForIntByMySql();
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public void updateBscPlanxlWeb(String database,Integer id,String xlNm) {
		String sql = "update "+database+".bsc_planxl set xl_nm='"+xlNm+"' where id="+id+"";
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除计划线路
	 *@创建：作者:llp		创建时间：2016-8-15
	 *@修改历史：
	 *		[序号](llp	2016-8-15)<修改说明>
	 */
	public void deleteBscPlanxlWeb(String database,Integer id) {
		String sql = "delete from "+database+".bsc_planxl where id="+id;
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：删除计划线路(详情)
	 */
	public void deleteBscPlanxlDetail(String database,Integer id) {
		String sql = "delete from " + database + ".bsc_planxl_detail where xl_id = " + id;
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
