package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCustomerHzfs;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class SysCustomerHzfsDao {

	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public int addHzfs(SysCustomerHzfs bo, String database)
	{
		try {
			return this.daoTemplate.addByObject(""+database+".sys_customer_hzfs", bo);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public int updateHzfs(SysCustomerHzfs bo, String database)
	{
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", bo.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_customer_hzfs", bo, whereParam, "id");
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public SysCustomerHzfs getByName(String hzfsNm, String database)
	{
		String sql = "select * from " + database + ".sys_customer_hzfs where hzfs_nm='" + hzfsNm + "'";
		List<SysCustomerHzfs> list = this.daoTemplate.queryForLists(sql, SysCustomerHzfs.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

	public SysCustomerHzfs getById(Integer id, String database)
	{
		String sql = "select * from " + database + ".sys_customer_hzfs where id=" + id.toString();
		List<SysCustomerHzfs> list = this.daoTemplate.queryForLists(sql, SysCustomerHzfs.class);
		if(list.size() > 0)return list.get(0);
		return null;
	}

	public List<SysCustomerHzfs> queryHzfsList(String database)
	{
		String sql = "select * from " + database + ".sys_customer_hzfs ";
		return this.daoTemplate.queryForLists(sql, SysCustomerHzfs.class);
	}

	public int deleteHzfs(String ids,String database)
	{
		String sql = "delete from " + database + ".sys_customer_hzfs where id in(" + ids + ")";
		return this.daoTemplate.update(sql);
	}

}
