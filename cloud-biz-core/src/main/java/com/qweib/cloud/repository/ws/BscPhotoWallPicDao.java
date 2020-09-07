package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscPhotoWallPicDao {
	@Resource(name = "daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 * @说明：根据照片墙id查照片墙图片
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public List<BscPhotoWallPic> queryPhotoWallPicList(Integer wallId, String datasource){
		StringBuffer sql = new StringBuffer("select * from "+datasource+".bsc_photo_wall_pic where 1=1 ");
		if(!StrUtil.isNull(wallId)){
			sql.append(" and wall_id="+wallId+" ");
		}
		try {
			return  this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallPic.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * @说明：根据照片墙id删除该照片墙的ID
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public int deletePhotoWallPic(Integer wallId,String datasource){
		StringBuffer sql = new StringBuffer("delete from "+datasource+".bsc_photo_wall_pic where wall_id = ").append(wallId);
		try {
			return  this.daoTemplate.update(sql.toString());
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
