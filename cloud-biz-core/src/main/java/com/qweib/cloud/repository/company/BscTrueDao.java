package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscTrue;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@Repository
public class BscTrueDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	/**
	 * 真心话分页查询
	 */
	public Page page(BscTrue bsctrue, Integer page, Integer rows, String database) {
		StringBuffer sql = new StringBuffer("SELECT t.true_id,t.member_id,t.true_time,t.true_count, ");
		sql.append("(select member_nm from "+database+".sys_mem m where m.member_id=t.member_id)as memberNm,");
		sql.append("(case when LENGTH(t.title)>10 then concat(substring(t.title,1,10),'...')else t.title end) as title,");
		sql.append("(case when length(t.content)>10 then concat(substring(t.content,1,10),'...')else t.content end)as content");
		sql.append(" from "+database+".bsc_true t where 1=1");
		if(null!=bsctrue){
			if(!StrUtil.isNull(bsctrue.getMemberId())){
				sql.append(" and t.member_id ='").append(bsctrue.getMemberId()).append("'");
			}
			if(!StrUtil.isNull(bsctrue.getTitle())){
				sql.append(" and t.title like '%").append(bsctrue.getTitle()).append("%'");
			}
			if(!StrUtil.isNull(bsctrue.getStartTime())){
				sql.append(" and t.true_time >=").append("'"+bsctrue.getStartTime()+" 00:00:00"+"'");
			}
			if(!StrUtil.isNull(bsctrue.getEndTime())){
				sql.append(" and t.true_time <= '").append(bsctrue.getEndTime()+" 23:59:59").append("'");
			}
			sql.append(" order by t.true_id desc");
		}
		try{
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, BscTrue.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 通过ID获取真心话信息
	 */
	public BscTrue queryTrueById(Integer id, String database) {
		String sql =" select * from "+database+".bsc_true where true_id=?";
		try {
			return daoTemplate.queryForObj(sql.toString(), BscTrue.class,id);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}
	/**
	 * 添加
	 */
	public int addTrue(BscTrue bsctrue, String database) {
		try {
			return this.daoTemplate.addByObject(""+database+".bsc_true", bsctrue);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}
	/**
	 * 修改
	 */
	public int updateTrue(BscTrue bsctrue, String database) {
		try {
			Map<String,Object> whereParam = new HashMap<String, Object>();
			whereParam.put("true_id", bsctrue.getTrueId());
			return this.daoTemplate.updateByObject(""+database+".bsc_true", bsctrue, whereParam, "true_id");
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}
	/**
	 * 删除
	 */
	public int[] deletetrue(final Integer[] ids,String database) {
		try{
			String sql = "delete from "+database+".bsc_true where true_id=?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return ids.length;
				}

				public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, ids[num]);
				}
			};
			return this.daoTemplate.batchUpdate(sql, setter);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
