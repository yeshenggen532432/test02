package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallComment;
import com.qweib.cloud.repository.ws.BscPhotoWallCommentDao;
import com.qweib.cloud.repository.ws.BscPhotoWallDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;


@Service
public class BscPhotoWallCommentService {
	@Resource
	private BscPhotoWallCommentDao bscPhotoWallCommentDao;
	@Resource
	private BscPhotoWallDao bscPhotoWallDao; 
	
	/**
	 * @说明：根据照片墙id查照片墙评论
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public List<BscPhotoWallComment> queryPhotoWallPicList(Integer wallId,String datasource){
		return this.bscPhotoWallCommentDao.queryPhotoWallPicList(wallId,datasource);
	}
	/**
	 * @说明：添加评论
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public int addPhotoComment(BscPhotoWallComment sbscPhotoWallComment,Integer isPoint,String datasource){
		this.bscPhotoWallCommentDao.addPhotoComment(sbscPhotoWallComment,datasource);
		Integer num = queryPhotoWallPicList(sbscPhotoWallComment.getWallId(),datasource).size();
		if(!isPoint.equals(1)){
			this.bscPhotoWallDao.updatePhotoWallScore(sbscPhotoWallComment.getWallId(), 2,datasource);
		}
		return bscPhotoWallDao.updatePhtoNum(sbscPhotoWallComment.getWallId(), num, 1,datasource);
	}
	
	/**
	 * @说明：根据用户ID查询评论
	 * @创建者： 作者：yjp  创建时间：2014-5-8
	 * @return
	 */
	public List<BscPhotoWallComment> findPhotoComment(Integer memberId,String datasource){
		return this.bscPhotoWallCommentDao.findPhotoComment(memberId,datasource);
	}
	
	/**
	 * @说明：删除照片墙评论
	 * @param wallId 照片墙ID
	 * @param commentId 评论ID
	 * @return
	 */
	public int deletePhotoComment(Integer commentId,Integer isPoint,String datasource){
		
		BscPhotoWall  bpwd=  bscPhotoWallDao.udpatePhotoComemnt(commentId,datasource);//根据评论id查询照片墙信息
		this.bscPhotoWallCommentDao.deletePhotoComment(null, commentId,datasource);//删除评论
		Integer num = queryPhotoWallPicList(bpwd.getWallId(),datasource).size();
		if(!isPoint.equals(1)){
			this.bscPhotoWallDao.updatePhotoWallScore(bpwd.getWallId(), -2,datasource);//扣分
		}
		return bscPhotoWallDao.updatePhtoNum(bpwd.getWallId(), num, 1,datasource);
	}
}
