package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Map;

@Repository
public class SysEmpgroupDao {
	@Resource(name = "daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	/*@Resource(name = "pdaoTemplate")
	private JdbcDaoTemplatePlud pdaoTemplate;*/


	public Page queryForPage(BscEmpgroup empgroup, Integer page, Integer rows,
                             String datasource) {
		try{
			StringBuffer sql = new StringBuffer();
			sql.append(" select *,(select count(*) from "+datasource+".bsc_empgroup_member em where em.group_id=bsc.group_id)as groupNum,(select mem.member_nm from "+datasource+".sys_mem mem where mem.member_id = bsc.member_id) member_nm");
			sql.append(" from "+datasource+".bsc_empgroup bsc where 1=1");
			if(!StrUtil.isNull(datasource)){
				sql.append(" and bsc.datasource='"+datasource+"'");
			}
			if(!StrUtil.isNull(empgroup.getGroupNm())){
				sql.append(" and bsc.group_nm like '%"+empgroup.getGroupNm()+"%'");
			}
			sql.append(" order by group_id desc");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, BscEmpgroup.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 根据ID删除
	 */
	public int[] deleteByIds(final Integer[] ids,String database) {
		String sql = " delete from "+database+".bsc_empgroup where group_id=? ";
		try {
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public int getBatchSize() {
					return ids.length;
				}

				public void setValues(PreparedStatement pre, int num)
						throws SQLException {
					pre.setInt(1, ids[num]);
				}
			};
			return daoTemplate.batchUpdate(sql.toUpperCase(), setter);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}
	/**
	 * 根据圈子获取话题
	 * @param id
	 * @param datasource
	 * @return
	 */
	public Map<String, Object> queryToPicListById(Integer id,String datasource) {
		String sql = " select GROUP_CONCAT(cast(topic_id as char(20))) ids from "+datasource+".bsc_topic where tp_type = 0 and tp_id ="+id;
		try {
			return daoTemplate.queryForMap(sql);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}

	/**
	 * 根据话题获取图片路径
	 * @param id
	 * @param datasource
	 * @return
	 */
	public Map<String, Object> queryPicListById(Integer groupId, String datasource) {
		String sql = "select GROUP_CONCAT(pic_mini) xt,GROUP_CONCAT(pic) dt from "+datasource+".bsc_topic_pic tp left join "+datasource+".bsc_topic t on tp.topic_id=t.topic_id left join "+datasource+".bsc_empgroup e on t.tp_id=e.group_id and tp_type=0 where group_id = "+groupId+" and e.datasource='"+datasource+"' ";
		try {
			return daoTemplate.queryForMap(sql);
		} catch (Exception ex) {
			throw new DaoException(ex);
		}
	}

}
