package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMemberImportSub;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysMemberImportSubDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryPage(SysMemberImportSub sub, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_member_import_sub a  ");
		sql.append("  where 1=1 ");
		if(sub!=null){
			if(!StrUtil.isNull(sub.getMastId())){
				sql.append(" and a.mast_id=").append(sub.getMastId());
			}
		}
		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysMemberImportSub.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysMemberImportSub> queryList(SysMemberImportSub sub, String database){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_member_import_sub a ");
    	sql.append(" where 1=1 ");
    	if(sub!=null){
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysMemberImportSub.class);
    }


	public int add(SysMemberImportSub sub, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_member_import_sub", sub);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}



}
