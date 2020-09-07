package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysCljccjMd;
import com.qweib.cloud.core.exception.DaoException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;


@Repository
public class SysCljccjMdDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *说明：列表查陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public List<SysCljccjMd> queryCljccjMdls(String database){
		String sql = "select * from "+database+".sys_cljccj_md order by id asc";
		try {
			return this.daoTemplate.queryForLists(sql, SysCljccjMd.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：批量修改陈列检查采集模板
	 *@创建：作者:llp		创建时间：2016-3-24
     *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public void updateCljccjMdLs(final List<SysCljccjMd> detail, final String database){
		String sql="update "+database+".sys_cljccj_md set md_nm=?,is_hjpms=?,is_djpms=?,is_sytwl=?,is_bds=? where id=?";
		try {
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter(){
				public int getBatchSize() {
					return detail.size();
				}
				public void setValues(PreparedStatement p, int i) throws SQLException{
					p.setString(1, detail.get(i).getMdNm());
					p.setInt(2,detail.get(i).getIsHjpms());
					p.setInt(3,detail.get(i).getIsDjpms());
					p.setInt(4,detail.get(i).getIsSytwl());
					p.setInt(5,detail.get(i).getIsBds());
					p.setInt(6,detail.get(i).getId());
				}
			};
			this.daoTemplate.batchUpdate(sql, setter);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
