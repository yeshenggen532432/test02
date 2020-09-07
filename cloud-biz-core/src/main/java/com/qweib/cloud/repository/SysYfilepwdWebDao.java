package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysYfilepwd;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;

@Repository
public class SysYfilepwdWebDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：添加云文件密码
	 *@创建：作者:llp		创建时间：2016-11-18
	 *@修改历史：
	 *		[序号](llp	2016-11-18)<修改说明>
	 */
	public int addYfilepwd(SysYfilepwd Yfilepwd, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".sys_yfilepwd", Yfilepwd);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：修改云文件密码
	 *@创建：作者:llp		创建时间：：2016-11-18
	 *@修改历史：
	 *		[序号](llp	：2016-11-18)<修改说明>
	 */
	public void updateYfilepwd(String database,String yfPwd,Integer memberId) {
		String sql = "update "+database+".sys_yfilepwd set yf_pwd='"+yfPwd+"' where member_id="+memberId;
		try{
			this.daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取云文件密码
	 *@创建：作者:llp		创建时间：2016-11-18
	 *@修改历史：
	 *		[序号](llp	2016-11-18)<修改说明>
	 */
	public SysYfilepwd queryYfilepwd(String database, Integer memberId){
		try{
			String sql = "select * from "+database+".sys_yfilepwd where member_id="+memberId;
			return this.daoTemplate.queryForObj(sql, SysYfilepwd.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
