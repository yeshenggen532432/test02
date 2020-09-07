package com.qweib.cloud.repository;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.SysZcusr;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


@Repository
public class SysZcusrDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 *
	 * 摘要：
	 * @说明：查询用户用于分配用户
	 * @创建：作者:llp 创建时间：2016-6-3
	 * @修改历史： [序号](llp 2016-6-3)<修改说明>
	 */
	public List<Map<String,Object>> queryUsrForRole(Integer zusrId,String database) {
		StringBuffer sql = new StringBuffer("select a.member_id,a.member_nm,(select count(1) from "+database+".sys_zcusr r");
		sql.append(" where a.member_id=r.cusr_id and r.zusr_id=?");
		sql.append(" ) as role_use from "+database+".sys_mem a where a.member_id!="+zusrId+" order by a.member_id desc");
		try {
			return daoTemplate.queryForList(sql.toString().toUpperCase(),zusrId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 * 摘要：
	 * @说明：批量添加人员分配人员
	 * @创建：作者:llp 创建时间：2016-6-3
	 * @修改历史： [序号](llp 2016-6-3)<修改说明>
	 */
	public int[] addZcUsr(final Integer[] cusrIds, final Integer zusrId,final String database) {
		String sql = " insert into "+database+".sys_zcusr(zusr_id,cusr_id) values(?,?) ";
		try {
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return cusrIds.length;
				}
                public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, zusrId);
					pre.setInt(2, cusrIds[num]);
				}
			};
			return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *
	 *摘要：
	 *@说明：删除人员分配人员
	 *@创建：作者:llp		创建时间：2016-6-3
	  *@修改历史：
	 *		[序号](llp	2016-6-3)<修改说明>
	 */
	public int deleteZcUsr(Integer zusrId,String database){
		String sql = " delete from "+database+".sys_zcusr where zusr_id=? ";
		try {
			return this.daoTemplate.update(sql,zusrId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取人员数组
	 *@创建：作者:llp		创建时间：2016-6-3
	 *@修改历史：
	 *		[序号](llp	2016-6-3)<修改说明>
	 */
	public SysZcusr querycusrIds(String database, Integer zusrId) {
		String sql = "select group_concat(CAST(cusr_id AS CHAR)) as cusrIds from "+database+".sys_zcusr where zusr_id=?";
		try{
			return this.daoTemplate.queryForObj(sql, SysZcusr.class,zusrId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 *说明：获取人员数组（总的）
	 *@创建：作者:llp		创建时间：2016-6-30
	 *@修改历史：
	 *		[序号](llp	2016-6-30)<修改说明>
	 */
	public SysZcusr querycusrIdsz(Integer mId, String allDepts, String invisibleDepts, String database) {
		StringBuffer sql = new StringBuffer("");
		sql.append(" SELECT GROUP_CONCAT(CAST(member_id AS CHAR)) AS cusrIds ");
		sql.append(" FROM "+database+".sys_mem WHERE 1=1 AND member_use=1");
		if (!StrUtil.isNull(allDepts)) {//要查询的部门和可见部门
			if (!StrUtil.isNull(mId)) {//个人和可见部门结合查询
				sql.append(" AND (branch_id IN ("+allDepts+") ");
				sql.append(" OR member_id="+mId+")");
			} else {
				sql.append(" AND branch_id IN ("+allDepts+") ");
			}
		}else if (!StrUtil.isNull(mId)) {//个人
			sql.append(" AND member_id="+mId);
		}
		if (!StrUtil.isNull(invisibleDepts)) {//不可见部门
			sql.append(" AND branch_id NOT IN ("+invisibleDepts+") ");
		}

		try{
			return this.daoTemplate.queryForObj(sql.toString(), SysZcusr.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
