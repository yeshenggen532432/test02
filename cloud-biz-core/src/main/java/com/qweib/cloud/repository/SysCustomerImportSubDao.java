package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerImportSub;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysCustomerImportSubDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryPage(SysCustomerImportSub sub, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.*,c.member_nm,c.member_mobile,d.branch_name,region.region_nm   from "+database+".sys_customer_import_sub a  ");
		sql.append(" left join " + database+".sys_mem c on a.mem_id=c.member_id ");
		sql.append(	 "left join " + database + ".sys_depart d on a.branch_id=d.branch_id ");
		sql.append(" left join "+database+".sys_region region on a.region_id=region.region_id ");
		sql.append("  where 1=1 ");
		if(sub!=null){
			if(!StrUtil.isNull(sub.getMastId())){
				sql.append(" and a.mast_id=").append(sub.getMastId());
			}
			if (!StrUtil.isNull(sub.getKhNm())) {
				sql.append(" and a.kh_nm like '%" + sub.getKhNm() + "%' ");
			}
			if (!StrUtil.isNull(sub.getMemberNm())) {
				sql.append(" and c.member_nm like '%" + sub.getMemberNm() + "%' ");
			}
			if (!StrUtil.isNull(sub.getQdtpNm())) {
				sql.append(" and a.qdtp_nm='" + sub.getQdtpNm() + "' ");
			}
		}

		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysCustomerImportSub.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysCustomerImportSub> queryList(SysCustomerImportSub sub, String database){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_customer_import_sub a ");
    	sql.append(" where 1=1 ");
    	if(sub!=null){
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysCustomerImportSub.class);
    }


	public int add(SysCustomerImportSub sub, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_customer_import_sub", sub);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}



}
