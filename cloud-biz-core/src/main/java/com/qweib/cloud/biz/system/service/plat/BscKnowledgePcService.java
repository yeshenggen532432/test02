package com.qweib.cloud.biz.system.service.plat;

import com.qweib.cloud.core.domain.BscEmpgroup;
import com.qweib.cloud.core.domain.BscSort;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.company.BscKnowledgePcDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BscKnowledgePcService {
	@Resource
	private BscKnowledgePcDao knowledgePcDao;

	public List<BscEmpgroup> queryKnowledges(SysLoginInfo info) {
		List<BscEmpgroup> knowledgeList = null;
		try{
			String datasource = info.getDatasource();
			if(null!=info.getUsrRoleIds() && info.getUsrRoleIds().contains(8)){//公司管理员
				knowledgeList = knowledgePcDao.queryAllKnowledgeList(datasource);
			}else {
				knowledgeList = knowledgePcDao.queryMyKnowledges(info.getIdKey(),datasource);
			}
			return knowledgeList;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询分类
	  *@param id
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	public List<BscSort> querySortList(Integer gid, String datasource) {
		try{
			return knowledgePcDao.querySortList(gid,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 分页查询分类
	  *@param groupId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 24, 2015
	 */
	public Page querysortForPage(Integer groupId,Integer memId,String sortNm, String datasource,Integer pageNo,Integer pageSize) {
		try{
			return knowledgePcDao.querysortForPage(groupId,memId,sortNm,datasource,pageNo,pageSize);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public Page queryPointForPage(Integer sortId,String topicTitle, String datasource, Integer pageNo, Integer pageSize) {
		try{
			return knowledgePcDao.queryPointForPage(sortId,topicTitle,datasource,pageNo,pageSize);
		}catch (Exception e) {
			throw new ServiceException(e);
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
		try{
			return knowledgePcDao.queryFirstGroup(memId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}


	/**
	  *@see 批量删除知识库分类
	  *@param ids
	  *@param datasource
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public void deleteSorts(String ids, String datasource) {
		try{
			knowledgePcDao.deleteSorts(ids,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 批量删除知识点
	  *@param ids
	  *@param datasource
	  *@创建：作者:YYP		创建时间：Aug 26, 2015
	 */
	public void deleteknowledges(String ids, String datasource) {
		try{
			knowledgePcDao.deleteknowledges(ids,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
