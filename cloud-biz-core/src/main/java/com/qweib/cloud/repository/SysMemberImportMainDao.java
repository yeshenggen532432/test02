package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysMemberImportMain;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysMemberImportMainDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;


	public Page queryPage(SysMemberImportMain main, int page, int rows, String database){
		StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_member_import_main a");

		sql.append(" order by a.id desc");

		try {
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, SysMemberImportMain.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

    public List<SysMemberImportMain> queryList(SysMemberImportMain main, String database){
    	StringBuffer sql = new StringBuffer(" select a.* from "+database+".sys_member_import_main a ");
    	sql.append(" where 1=1 ");
    	if(main!=null){
    	}
    	return this.daoTemplate.queryForLists(sql.toString(), SysMemberImportMain.class);
    }


	public int add(SysMemberImportMain main, String database){
		try{
			return this.daoTemplate.addByObject(""+database+".sys_member_import_main", main);
		} catch (Exception e) {
			e.printStackTrace();
			throw new DaoException(e);
		}
	}

	public SysMemberImportMain queryById(Integer id, String database){
		String sql = "select * from "+database+".sys_member_import_main where id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysMemberImportMain.class, id);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}


	public int update(SysMemberImportMain main, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", main.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_member_import_main", main, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}



}
