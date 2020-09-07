package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.SysQuestionnaire;
import com.qweib.cloud.core.domain.SysQuestionnaireDetail;
import com.qweib.cloud.core.domain.SysQuestionnaireVote;
import com.qweib.cloud.repository.ws.SysQuestionnaireWebDao;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysQuestionnaireWebService {
	
	@Resource
	private SysQuestionnaireWebDao sysQuestionnaireWebDao;

	/**
	 * 查询最新问卷
	 * @param database
	 * @param memId
	 * @return
	 */
	public SysQuestionnaire queryNewQuestionnaire(String database) {
		try{
			return this.sysQuestionnaireWebDao.queryNewQuestionnaire(database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	
	/**
	 * 根据用户ID查询选项
	 * @param integer 
	 * @param database
	 * @param memId
	 * @return
	 */
	public List<SysQuestionnaireDetail> queryByQuestId(Integer mid,Integer qid,String database) {
		try{
			return this.sysQuestionnaireWebDao.queryByQuestId(mid,qid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * 根据用户ID 以及问卷ID 获取已选择答案
	 * @param qid
	 * @param memId
	 * @param database
	 * @return
	 */
	public Map<String, Object> queryByVoteId(Integer qid,Integer memId,
			String database) {
		try{
			return this.sysQuestionnaireWebDao.queryByVoteId(qid,memId,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 批量添加答案成功
	 * @param database
	 * @param vote
	 * @return
	 */
	public void addVote(String database, List<SysQuestionnaireVote> vote) {
		try{
			 this.sysQuestionnaireWebDao.addVote(database,vote);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据问卷ID获取比率
	 * @param database
	 * @param vote
	 * @return
	 */
	public List<SysQuestionnaireDetail> queryByRatio(Integer qid,
			String database) {
		try{
			return this.sysQuestionnaireWebDao.queryByRatio(qid,database);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 分页查询问卷
	 * @param database
	 * @param memId
	 * @return
	 */
	public Page queryAllPage(Integer pageNo, Integer pageSize, String database,Integer branchId,Integer memId) {
		try{
			Page p =this.sysQuestionnaireWebDao.queryAllPage(pageNo,pageSize,database,branchId,memId);
			for (int i=0;i<p.getRows().size();i++) {
				SysQuestionnaire ques = (SysQuestionnaire) p.getRows().get(i);
				List<SysQuestionnaireDetail> list=this.sysQuestionnaireWebDao.queryByQuestId(memId,ques.getQid(),database);
				ques.setDetailList(list);
			}
			return p;
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据问卷ID及用户ID删除已选的选项
	 * @param database
	 * @param problemId
	 */
	public void deleteByQid(String database, Integer problemId,Integer mid) {
		try{
			this.sysQuestionnaireWebDao.deleteByQid(database,problemId,mid);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * 根据用户删除选项ID
	 * @param database
	 * @param problemId
	 * @param memId
	 * @param id
	 */
	public void deleteById(String database, Integer problemId, Integer memId,
			Integer uid) {
		try{
			this.sysQuestionnaireWebDao.deleteById(database,problemId,memId,uid);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	public Map<String, Object> queryCheckAll(String database, Integer memId,Integer problemId) {
		try{
			return this.sysQuestionnaireWebDao.queryCheckAll(database,memId,problemId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

	//结果列表页面
	public Page queryResultList(Integer pageNo, Integer pageSize,
			String database, Integer branchId,Integer memId) {
		try{
			return  this.sysQuestionnaireWebDao.queryResultPage(pageNo,pageSize,database,branchId,memId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
//查询是否投过票
	public List<Map<String, Object>> queryCountByMemId(Integer memId,Integer branchId, String datasource) {
		try{
			return  this.sysQuestionnaireWebDao.queryCountByMemId(memId,branchId,datasource);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}

}
