package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysReportCd;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Repository
public class SysReportCdDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *
	 *摘要：
	 *@说明：获取日报文字长度设置信息
	 *@创建：作者:llp		创建时间：2017-5-19
	  *@修改历史：
	 *		[序号](llp	2017-5-19)<修改说明>
	 */
	public SysReportCd queryReportCd(String database, Integer id){
		String sql = "select * from "+database+".sys_report_cd where id="+id+"";
		try{
			return this.daoTemplate.queryForObj(sql, SysReportCd.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：修改日报文字长度设置信息
	 *@创建：作者:llp		创建时间：2017-5-19
	  *@修改历史：
	 *		[序号](llp	2017-5-19)<修改说明>
	 */
	public int updateReportCd(SysReportCd reportCd, String database){
		try {
			Map<String, Object> whereParam = new HashMap<String, Object>();
			whereParam.put("id", reportCd.getId());
			return this.daoTemplate.updateByObject(""+database+".sys_report_cd", reportCd, whereParam,null);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
