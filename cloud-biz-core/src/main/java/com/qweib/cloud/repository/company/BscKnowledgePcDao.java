package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.core.domain.BscKnowledge;
import com.qweib.cloud.core.domain.BscSort;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscKnowledgePcDao {
	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	public List<BscEmpgroup> queryAllKnowledgeList(String datasource) {
		String sql = "select group_id,group_nm from "+datasource+".bsc_empgroup order by creatime desc";
		try{
			return daoTemplate.queryForLists(sql, BscEmpgroup.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public List<BscEmpgroup> queryMyKnowledges(Integer memId, String datasource) {
		StringBuffer sql = new StringBuffer("select distinct e.group_id,e.group_nm");
		sql.append(" from "+datasource+".bsc_empgroup_member em,"+datasource+".bsc_empgroup e ");
		sql.append(" where em.group_id=e.group_id and em.member_id="+memId);
		sql.append(" order by e.creatime desc ");
		try{
			return daoTemplate.queryForLists(sql.toString(), BscEmpgroup.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 查询分类
	  *@param kid
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	public List<BscSort> querySortList(Integer gid, String datasource) {
		String sql = "select sort_id,sort_nm from "+datasource+".bsc_sort where group_id="+gid+" order by create_time desc ";
		try{
			return daoTemplate.queryForLists(sql, BscSort.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 分页查询分类
	  *@param groupId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	public Page querysortForPage(Integer groupId, Integer memId, String sortNm, String datasource, Integer pageNo, Integer pageSize) {
 		StringBuffer sql = new StringBuffer("select m.member_nm,s.sort_id,s.sort_nm,s.create_time ");
		sql.append(" from "+datasource+".bsc_sort s,"+datasource+".sys_mem m ");
		sql.append(" where s.member_id=m.member_id ");
		if(!StrUtil.isNull(sortNm)){
			sql.append(" and s.sort_nm like '%"+sortNm+"%' ");
		}
//		if(StrUtil.isNull(groupId)){
//			sql.append("and s.group_id=(select e.group_id");
//			sql.append(" from "+datasource+".bsc_empgroup_member em,"+datasource+".bsc_empgroup e ");
//			sql.append(" where em.group_id=e.group_id and em.member_id="+memId);
//			sql.append(" order by e.creatime limit 1 )");
//		}else{
			sql.append(" and s.group_id="+groupId);
//		}
		sql.append(" order by s.create_time desc");
		try{
			return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscSort.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 分页查询知识点
	  *@param sortId
	  *@param memId
	  *@param topicTitle
	  *@param datasource
	  *@param pageNo
	  *@param pageSize
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 25, 2015
	 */
	public Page queryPointForPage(Integer sortId, String topicTitle, String datasource, Integer pageNo,
                                  Integer pageSize) {
		StringBuffer sql = new StringBuffer("select k.knowledge_id,k.topic_title,k.topic_time,k.tp,k.topi_content,m.member_nm, ");
		sql.append("(select member_nm from "+datasource+".sys_mem where member_id=k.operate_id ) as operate_nm ");
		sql.append(" from "+datasource+".bsc_knowledge k left join "+datasource+".sys_mem m ");
		sql.append(" on k.member_id=m.member_id where k.sort_id="+sortId);
		sql.append(" order by topic_time desc ");
		try{
			return daoTemplate.queryForPageByMySql(sql.toString(), pageNo, pageSize, BscKnowledge.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 查询第一个员工圈信息
	  *@param memId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public BscEmpgroup queryFirstGroup(Integer memId, String datasource) {
		StringBuffer sql = new StringBuffer();
		sql.append("select e.group_id from "+datasource+".bsc_empgroup_member em,"+datasource+".bsc_empgroup e ");
		sql.append(" where em.group_id=e.group_id and em.member_id="+memId);
		sql.append(" order by e.creatime desc limit 1 ");
		try{
			return daoTemplate.queryForObj(sql.toString(), BscEmpgroup.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 批量删除知识库分类
	  *@param ids
	  *@param datasource
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public void deleteSorts(String ids, String datasource) {
		String sql = "delete from "+datasource+".bsc_sort where sort_id in ("+ids+") ";
		try{
			daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	  *@see 批量删除知识点
	  *@param ids
	  *@param datasource
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public void deleteknowledges(String ids, String datasource) {
		String sql = "delete from "+datasource+".bsc_knowledge where knowledge_id in ("+ids+") ";
		try{
			daoTemplate.update(sql);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
