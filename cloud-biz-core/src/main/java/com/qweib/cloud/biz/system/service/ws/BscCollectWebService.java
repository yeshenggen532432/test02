package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.repository.ws.BscCollectWebDao;
import com.qweib.cloud.repository.ws.BscTopicWebDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class BscCollectWebService {
    @Resource
	private BscCollectWebDao bscCollectWebDao;
	@Resource
	private BscTopicWebDao bscTopicWebDao;
   /**
	 * @说明：获取收藏列表
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 */
	/*public Page queryBscCollectPage(String database, Integer pageNo,Integer pageSize,Integer mbId) {
		try{
			Page topicPage = this.bscCollectWebDao.queryBscCollectPage(database, pageNo, pageSize, mbId);
			List<BscTopicFactoryDTO> topicList = topicPage.getRows();
			if(null!=topicList){
				for (BscTopicFactoryDTO bscTopicDTO : topicList) {
					bscTopicDTO.setPicList(bscTopicWebDao.queryTopicPic(bscTopicDTO.getTopicId(),database));
				}
			}
			return topicPage;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	 *//**
	 * @说明：获取收藏详情
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	public BscTopicFactoryDTO queryBscCollect(String database,Integer topicId) {
		try{
			BscTopicFactoryDTO bscTopicDTO=this.bscCollectWebDao.queryBscCollect(topicId, database);
			bscTopicDTO.setPicList(bscTopicWebDao.queryTopicPic(topicId,database));
			List<BscTopicComment> commentList = bscTopicWebDao.queryCommentList(topicId,database);//获取评论
			bscTopicDTO.setCommentList(commentList);
			if(null!=commentList){
				for (BscTopicComment comment : commentList) {
					comment.setRcList(bscTopicWebDao.queryRcList(comment.getCommentId(),database));//获取回复
				}
			}
			bscTopicDTO.setPraiseList(bscTopicWebDao.queryPraiseList(topicId,database));
			return bscTopicDTO;
		}catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	*//**
	 * @说明：添加收藏
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	public int addBscCollect(BscCollect bscCollect,String datasource){
		return this.bscCollectWebDao.addBscCollect(bscCollect, datasource);
	}
	*//**
	 * @说明：删除收藏
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	public void deleteBscCollect(Integer mbId, Integer topicId, String database) {
		this.bscCollectWebDao.deleteBscCollect(mbId, topicId, database);
	}
	*//**
	 * @说明：判断是否收藏过
	 * @创建者： 作者：llp  创建时间：2015-2-27
	 * @return
	 *//*
	public int queryBscCollectByTpid(Integer mbId, Integer topicId, String database){
		return this.bscCollectWebDao.queryBscCollectByTpid(mbId, topicId, database);
	}*/
}
