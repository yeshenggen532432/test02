package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.repository.company.SysTaskAttachmentDao;
import com.qweib.cloud.repository.ws.BscKnowledgeDao;
import com.qweib.cloud.repository.ws.BscTopicWebDao;
import com.qweib.cloud.core.domain.BscKnowledgeFactoryDTO;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class BscKnowledgeService {
	@Resource
	private BscKnowledgeDao knowledgeDao;
	@Resource
	private BscTopicWebDao topicDao;
	@Resource
	private SysTaskAttachmentDao taskAttachmentDao;

	/**
	  *@see 查询知识库分类列表
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-2-11
	 */
	public Page querySortPage(Integer groupId,String searchContent,String database,Integer pageNo,Integer pageSize) {
		try{
			return knowledgeDao.querySortByGroupId(groupId,searchContent,database,pageNo,pageSize);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 设置成知识点
	  *@param topicId
	  *@param sortId
	  *@创建：作者:YYP		创建时间：2015-2-12
	 */
	public void addKnowledge(Integer topicId, Integer sortId,String database,Integer memId) {
		try{
			BscTopic topic = topicDao.queryTopicById2(topicId,database);//查询主题
			if(2==topic.getTpType()){//外部链接分享
				BscKnowledge knowledge = new BscKnowledge(topic,sortId,"2","",memId);
				knowledgeDao.addKnowledge(knowledge,database);
			}else{//帖子分享
				List<BscKnowledgePic> pics = new ArrayList<BscKnowledgePic>();
				List<BscKnowledgeComment> comments = new ArrayList<BscKnowledgeComment>();
				List<BscKnowledgePraise> praises = new ArrayList<BscKnowledgePraise>();
				List<BscTopicPic> picList = topicDao.queryTopicPic(topicId, database);//查询图片列表
				List<BscTopicComment> commentList = topicDao.queryCommentByTopicId(topicId, database);//查询评论
				List<BscTopicPraise>praiseList = topicDao.queryPraise(topicId,database);//查询赞
				BscKnowledge knowledge = new BscKnowledge(topic,sortId,"1",memId);
				Integer kid =knowledgeDao.addKnowledge(knowledge,database);
				if(null!=picList){//复制图片未添加进去*********
					for (BscTopicPic pic : picList) {
						BscKnowledgePic kpic = new BscKnowledgePic(kid,pic.getPicMini(),pic.getPic());
						pics.add(kpic);
					}
					knowledgeDao.addKpic(pics,database);//批量添加图片
				}
				if(null!=commentList){
					for (BscTopicComment comment : commentList) {
						BscKnowledgeComment kcomment = new BscKnowledgeComment(kid,comment);
						comments.add(kcomment);
					}
					knowledgeDao.addKcomment(comments,database);//批量添加评论
				}
				if(null!=praiseList){
					for (BscTopicPraise praise : praiseList) {
						BscKnowledgePraise kpraise = new BscKnowledgePraise(kid,praise.getMemberId());
						praises.add(kpraise);
					}
					knowledgeDao.addKpraise(praises,database);//批量添加赞
				}
			}
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询知识点
	  *@param groupId
	  *@param sortId
	  *@param database
	  *@return
	  *@创建：作者:YYP		创建时间：2015-3-3
	 */
	public Page queryKnowledge(Integer sortId,String searchContent,Integer groupId,String database,Integer pageNo,Integer pageSize) {
		try{
			Page p = knowledgeDao.querykpage(sortId,searchContent,groupId,database,pageNo,pageSize);
			return p;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 添加知识点分类
	  *@param sort
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-3-3
	 */
	public void addSort(BscSort sort, String database) {
		try{
			knowledgeDao.addSort(sort,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 删除分类
	  *@param sortId
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-3-4
	 */
	public void deleteSort(Integer sortId, String database) {
		try{
			knowledgeDao.deleteSort(sortId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 修改分类
	  *@param sortId
	  *@param sortNm
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-3-4
	 */
	public void updateSort(Integer sortId, String sortNm, String database) {
		try{
			knowledgeDao.updateSort(sortId,sortNm,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	public Integer addOutKnowledge(BscKnowledge knowledge, String database) {
		try{
			return knowledgeDao.addOutKnowledge(knowledge,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 判断分类名是否已存在
	  *@param sortNm
	  *@param groupId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-21
	 */
	public Integer querySortNmAppear(String sortNm,Integer sortId, Integer groupId,
			String datasource) {
		try{
			if(null==groupId){
				BscSort sort =  knowledgeDao.querySortById(sortId,datasource);
				groupId = sort.getGroupId();
			}
			return knowledgeDao.querySortNmAppear(sortNm,groupId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 删除知识点
	  *@param knowledgeId
	  *@param database
	  *@创建：作者:YYP		创建时间：2015-5-21
	 */
	public void deleteKnowledge(Integer knowledgeId, String database) {
		try{
			knowledgeDao.deleteKnowledge(knowledgeId,database);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
		
	}

	/**
	  *@see  判断该主题是否已存在于该分类中
	  *@param topicId
	  *@param sortId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-21
	 */
	public Integer queryIsExit(Integer topicId, Integer sortId,
			String datasource) {
		try{
			return knowledgeDao.queryIsExit(topicId,sortId,datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询知识库(帖子)详情
	  *@param knowledgeId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：2015-5-22
	 */
	public BscKnowledgeFactoryDTO queryKnowledgeDetail(Integer knowledgeId,
			String datasource) {
		try{
			BscKnowledgeFactoryDTO knowledge = knowledgeDao.queryKnowledgeDetail(knowledgeId,datasource);
			if("1".equals(knowledge.getTp())){
				List<BscKnowledgePic> kPic = knowledgeDao.querykPic(knowledgeId,datasource);
				knowledge.setPicList(kPic);
			}else if("3".equals(knowledge.getTp())){
				List<SysTaskAttachment> fileList = taskAttachmentDao.queryByKnowledgeId(knowledgeId, datasource);
				knowledge.setFileList(fileList);
			}
			/*List<BscKnowledgeComment> commentList = knowledgeDao.queryCommentList(knowledgeId,datasource);//获取评论
			knowledge.setCommentList(commentList);
			if(null!=commentList){
				for (BscKnowledgeComment comment : commentList) {
					comment.setRcList(knowledgeDao.queryRcList(comment.getCommentId(),datasource));//获取回复
				}
			}
			knowledge.setPraiseList(knowledgeDao.queryPraiseList(knowledgeId,datasource));*/
			return knowledge;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	  *@see 查询知识点文件
	  *@param knowledgeId
	  *@param datasource
	  *@return
	  *@创建：作者:YYP		创建时间：Aug 28, 2015
	 */
	public List<SysTaskAttachment> queryKnowledgeFile(Integer knowledgeId,
			String datasource) {
		try{
			return taskAttachmentDao.queryByKnowledgeId(knowledgeId, datasource);
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}

}
