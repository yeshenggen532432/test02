package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.repository.ws.BscPhotoWallPicDao;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;


@Service
public class BscPhotoWallPicService {
	@Resource
	private BscPhotoWallPicDao bscPhotoWallPicDao;
	
	/**
	 * @说明：根据照片墙id查照片墙图片
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public List<BscPhotoWallPic> queryPhotoWallPicList(Integer wallId,String datasource){
		return this.bscPhotoWallPicDao.queryPhotoWallPicList(wallId,datasource);
	}
}
