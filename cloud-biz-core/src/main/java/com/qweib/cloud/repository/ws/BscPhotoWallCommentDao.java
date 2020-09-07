package com.qweib.cloud.repository.ws;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPhotoWallComment;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class BscPhotoWallCommentDao {
	@Resource(name = "daoTemplate")
	private JdbcDaoTemplate daoTemplate;

	/**
	 * @说明：根据照片墙id查照片墙评论
	 * @创建者： 作者：llp  创建时间：2014-5-6
	 * @return
	 */
	public List<BscPhotoWallComment> queryPhotoWallPicList(Integer wallId, String datasource){
		StringBuffer sql = new StringBuffer("select * from "+datasource+".bsc_photo_wall_comment where 1=1 ");
		if(!StrUtil.isNull(wallId)){
			sql.append(" and wall_id="+wallId+" ");
		}
		sql.append(" order by addtime ");
		try {
			return  this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallComment.class);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * @说明：添加评论
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public int addPhotoComment(BscPhotoWallComment sbscPhotoWallComment, String datasource){
		try {
			return this.daoTemplate.addByObject(""+datasource+".bsc_photo_wall_comment", sbscPhotoWallComment);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	 * @说明：根据用户ID查询评论
	 * @创建者： 作者：llp  创建时间：2014-5-8
	 * @return
	 */
	public List<BscPhotoWallComment> findPhotoComment(Integer memberId, String datasource){
		try {
			StringBuffer sql = new StringBuffer("select * from "+datasource+".bsc_photo_wall_comment where member_id = ?");
			return this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallComment.class,memberId);
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}

	/**
	 * @说明：删除照片墙评论
	 * @param wallId 照片墙ID
	 * @param commentId 评论ID
	 * @return
	 */
	public int deletePhotoComment(Integer wallId,Integer commentId,String datasource){
		try {
			StringBuffer sql = new StringBuffer("delete from "+datasource+".bsc_photo_wall_comment where 1 = 1 ");
			if(wallId!=null){
				sql.append(" and  wall_id = ").append(wallId);
			}
			if(commentId!=null){
				sql.append(" and comment_id  = ").append(commentId);
			}
			if(commentId == null&&wallId == null){
				sql.append(" 1 <> 1");
			}
			return this.daoTemplate.update(sql.toString());
		} catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
