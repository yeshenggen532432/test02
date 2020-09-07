package com.qweib.cloud.repository.plat;

import com.qweib.cloud.core.dao.JdbcDaoTemplatePlud;
import com.qweib.cloud.core.domain.SysCorporationtp;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class SysCorporationtpDao {
	@Resource(name = "pdaoTemplate")
	private JdbcDaoTemplatePlud daoTemplate1;

	/**
	 *说明：获取公司类型列表
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	public List<SysCorporationtp> queryGsTpLs(){
		try{
			String sql = "select tp_nm from sys_corporationtp";
			return this.daoTemplate1.queryForLists(sql, SysCorporationtp.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
