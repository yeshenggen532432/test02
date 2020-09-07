package com.qweib.cloud.biz.system.service.ws;


import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.repository.ws.BscPhotoWallCommentDao;
import com.qweib.cloud.repository.ws.BscPhotoWallDao;
import com.qweib.cloud.repository.ws.BscPhotoWallPicDao;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.FileUtil;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;


@Service
public class BscPhotoWallService {
	@Resource
	private BscPhotoWallDao bscPhotoWallDao;
	@Resource
	private BscPhotoWallPicDao bscPhotoWallPicDao;
	@Resource
	private BscPhotoWallCommentDao bscPhotoWallCommentDao;
	
	/**
	 * @说明：查最新照片墙
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public Page queryPhotoWallList(int pageNum,int rows,String datasource){
		return this.bscPhotoWallDao.queryPhotoWallList(pageNum,rows,datasource);
	}
	/**
	 *摘要：
	 *@说明：添加照片墙
	 *@创建：作者:llp	创建时间：2014-5-8
	 *@param bscPhotoWall,wallPicdetail
	 *@return 
	 *@修改历史：
	 *		[序号](llp	2014-5-8)<修改说明>
	 */
	public int addbscPhotoWall(BscPhotoWall bscPhotoWall,List<BscPhotoWallPic> wallPicdetail,String datasource){
		try{
			this.bscPhotoWallDao.addBscPhotoWall(bscPhotoWall,datasource);
			  int wallId=this.bscPhotoWallDao.queryAutoId();
			  for (BscPhotoWallPic detail : wallPicdetail) {
					detail.setWallId(wallId);
			  }
			  this.bscPhotoWallDao.addwallPicdetaildetail(wallPicdetail,datasource);
			  return wallId;
		}catch (Exception e) {
			throw new ServiceException(e);
		}  
	}
	/**
	 * @说明：查热门照片墙
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public Page queryHotPhotoWallList(Integer pageNo,Integer rows,String datasource){
		return this.bscPhotoWallDao.queryHotPhotoWallList(pageNo,rows,datasource);
	}
	
	/**
	 * @说明：查单个照片墙
	 * @创建者： 作者：yjp  创建时间：2014-5-30
	 * @return
	 */
	public BscPhotoWall queryBscPhotoWall(Integer wallId,String datasource){
		return this.bscPhotoWallDao.queryBscPhotoWall(wallId,datasource);
	}
	
	/**@说明： 查询用户发布的照片--分页--
	 * @param memberId 用户ID
	 * @return
	 */
	public Page findMemberPhoto(Integer memberId,String hotTopic,Integer pageNo,Integer row,String datasource){
		return this.bscPhotoWallDao.findMemberPhoto(memberId,hotTopic,pageNo,row,datasource);
	}
	/**@说明： 查询用户发布的照片
	 * @param memberId 用户ID
	 * @return
	 */
	public List<BscPhotoWall> findMemberPhoto(Integer memberId,Integer limitNum,String datasource){
		return this.bscPhotoWallDao.findMemberPhoto(memberId,limitNum,datasource);
	}

	/**@说明：删除照片墙
	 * @创建者： 作者:YJP 创建时间：2014-6-12
	 * @param wallId 照片墙ID
	 * @return
	 */
	public int deleteWall(Integer wallId,String datasource){
		//删除评论
		this.bscPhotoWallCommentDao.deletePhotoComment(wallId, null,datasource);
		List<BscPhotoWallPic> wallPicList = this.bscPhotoWallPicDao.queryPhotoWallPicList(wallId,datasource);
		//删除照片
		this.bscPhotoWallPicDao.deletePhotoWallPic(wallId,datasource);
		if(wallPicList.size()>0){
			FileUtil fileUtil = new FileUtil();
			String path = CnlifeConstants.url()+"upload/";
			for (int i = 0; i < wallPicList.size(); i++) {
				String paths = path+ wallPicList.get(i).getPicMini();
				String picPath =path+ wallPicList.get(i).getPic();
				//删除图片
				if(fileUtil.ifExist(paths)){
					fileUtil.deleteFile(paths);
					fileUtil.deleteFile(picPath);
				}
			}
		}
		//删除照片墙
		return this.bscPhotoWallDao.deleteWall(wallId,datasource);
	}
	
	
	/**
	  *摘要：根据评论id查询照片墙信息
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-8-13
	  *@param @param commentId
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-8-13)<修改说明>
	 */
	public BscPhotoWall queryPhotoWallByCommentId(Integer commentId,String datasource) {
		return this.bscPhotoWallDao.udpatePhotoComemnt(commentId,datasource);
	}
	
}
