package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscPhotoWallPraise;
import com.qweib.cloud.repository.ws.BscPhotoWallDao;
import com.qweib.cloud.repository.ws.BscPhotoWallPraiseDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;


@Service
public class BscPhotoWallPraiseService {
	@Resource
	private BscPhotoWallPraiseDao bscPhotoWallPraiseDao;
	@Resource
	private BscPhotoWallDao bscPhotoWallDao;
	/**
	 * @说明：根据照片墙id查照片墙赞
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public List<BscPhotoWallPraise> queryPhotoWallPicList(Integer wallId,String datasource){
		return this.bscPhotoWallPraiseDao.queryPhotoWallPicList(wallId,datasource);
	}
	/**
	 * @说明：根据用户id判断是否已赞
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public long queryPhotoPraiseCount(Integer memberId,Integer wallId,String datasource){
		return this.bscPhotoWallPraiseDao.queryPhotoPraiseCount(memberId,wallId,datasource);
	}
	/**
	 * @说明：添加赞
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public int addPhotoPraise(BscPhotoWallPraise sbscPhotoWallPraise,Integer isAdd,String datasource){
		this.bscPhotoWallPraiseDao.addPhotoPraise(sbscPhotoWallPraise,datasource);
		Integer num = queryPhotoWallPicList(sbscPhotoWallPraise.getWallId(),datasource).size();
		if(isAdd!=1){
			this.bscPhotoWallDao.updatePhotoWallScore(sbscPhotoWallPraise.getWallId(), 1,datasource);
		}
		return bscPhotoWallDao.updatePhtoNum(sbscPhotoWallPraise.getWallId(), num, 2,datasource);
	}
	/**
	 * @说明：取消赞
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public int deletePhotoPraise(Integer memberId,Integer wallId,Integer isDel,String datasource){
		this.bscPhotoWallPraiseDao.deletePhotoPraise(memberId,wallId,datasource);
		Integer num = queryPhotoWallPicList(wallId,datasource).size();
		if(isDel != 1){
			this.bscPhotoWallDao.updatePhotoWallScore(wallId, 0,datasource);
		}
		return bscPhotoWallDao.updatePhtoNum(wallId, num, 2,datasource);
	}

	/**
	 * @说明：查询点赞记录
	 * @创建者： 作者：yjp  创建时间：2014-5-30
	 * @return
	 */
	public List<BscPhotoWallPraise> findPhotoPraise(Integer memberId,String datasource){
		return this.bscPhotoWallPraiseDao.findPhotoPraise(memberId,datasource);
	}
	
	/**
	 * @说明：查询点赞分页
	 * @创建者： 作者：yjp  创建时间：2014-5-30
	 * @return
	 */
	public Page findPhotoPraisePage(Integer memberId,Integer pageNo,Integer row,String datasource){
		return this.bscPhotoWallPraiseDao.findPhotoPraisePage(memberId, pageNo, row,datasource);
	}
	/**
	 * @说明：分页查询点赞
	 * @创建者： 作者：yjp  创建时间：2014-6-23
	 */
	public Page findPhotoByPrasie(Integer memberId,Integer pageNo,Integer row,String datasource){
		return this.bscPhotoWallPraiseDao.findPhotoByPrasie(memberId, pageNo, row,datasource);
	}
}
