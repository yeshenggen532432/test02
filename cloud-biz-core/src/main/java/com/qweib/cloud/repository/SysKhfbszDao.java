package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysKhfbsz;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;


@Repository
public class SysKhfbszDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *
	 *摘要：
	 *@说明：查询客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public List<SysKhfbsz> queryKhfbszLs(String database){
		try {
			String sql="select * from "+database+".sys_khfbsz where 1=1 order by id asc";
			return daoTemplate.queryForLists(sql, SysKhfbsz.class);
		} catch (Exception e) {
			throw new DaoException();
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：批量添加客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public void addKhfbszLs(final List<SysKhfbsz> KhfbszLs, String database){
		String sql="insert into "+database+".sys_khfbsz(snums,enums,ysz) values(?,?,?)";
		try {
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter(){
				public int getBatchSize() {
					return KhfbszLs.size();
				}
				public void setValues(PreparedStatement arg0, int arg1) throws SQLException{
					arg0.setInt(1, KhfbszLs.get(arg1).getSnums());
					arg0.setInt(2,KhfbszLs.get(arg1).getEnums());
					arg0.setString(3,KhfbszLs.get(arg1).getYsz());
				}
			};
			this.daoTemplate.batchUpdate(sql, setter);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：删除客户分布设置
	 *@创建：作者:llp		创建时间：2017-5-16
	 *@修改历史：
	 *		[序号](llp	2017-5-16)<修改说明>
	 */
	public void deleteKhfbsz(String database){
		String sql="delete from "+database+".sys_khfbsz";
	    try {
			this.daoTemplate.update(sql);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：根据分钟查数据
	 *@创建：作者:llp		创建时间：2017-5-17
	 *@修改历史：
	 *		[序号](llp	2017-5-17)<修改说明>
	 */
	public SysKhfbsz queryKhfbszByFz(Integer fz, String database){
		try{
			String sql = "select * from "+database+".sys_khfbsz where snums<="+fz+" and enums>="+fz+"";
			return this.daoTemplate.queryForObj(sql, SysKhfbsz.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
