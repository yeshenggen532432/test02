package com.qweib.cloud.repository.company;

import com.qweib.cloud.core.dao.JdbcDaoTemplate;
import com.qweib.cloud.core.domain.BscPhotoWall;
import com.qweib.cloud.core.domain.BscPhotoWallPic;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.exception.DaoException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Repository
public class BscPhWallDao {

	@Resource(name="daoTemplate")
	private JdbcDaoTemplate daoTemplate;
	/**
	  *摘要：
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param phWall
	  *@param @param page
	  *@param @param rows
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	public Page queryPhWall(BscPhotoWall phWall, int page, int rows, SysLoginInfo info){
		String database = info.getDatasource();
		StringBuffer sql = new StringBuffer(" select a.wall_id,a.member_id,a.publish_time,a.publish_content,a.praise_num,m.member_nm as member_nm from "+database+".bsc_photo_wall a left join "+database+".sys_mem m on a.member_id=m.member_id where 1=1 ");
		try{
			/*if(null!=phWall){
				if(!StrUtil.isNull(phWall.getMemberNm())){
					sql.append(" and m.member_nm like '%").append(phWall.getMemberNm()).append("%' ");
				}
				if(!StrUtil.isNull(phWall.getStime())){
					sql.append(" and substr(a.publish_time,1,10) >='").append(phWall.getStime()).append("' ");
				}
				if(!StrUtil.isNull(phWall.getEtime())){
					sql.append(" and substr(a.publish_time,1,10) <='").append(phWall.getEtime()).append("' ");
				}
			}*/
			sql.append(" order by is_top desc,top_time desc ");
			return this.daoTemplate.queryForPageByMySql(sql.toString(), page, rows, BscPhotoWall.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *摘要：根据id查找照片墙照片
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param wallId
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	public List<BscPhotoWallPic> queryphWallPic(long wallId, String database){
		StringBuffer sql = new StringBuffer(" select * from "+database+".bsc_photo_wall_pic where wall_id=").append(wallId );
		try{
			return this.daoTemplate.queryForLists(sql.toString(), BscPhotoWallPic.class);
		}catch (Exception e) {
			throw new DaoException(e);
		}
		
	}
	/**
	  *摘要：删除照片墙照片
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-4-23
	  *@param @param picId
	  *@param @return 
	  *@修改历史：
	  *		[序号](YYP	2014-4-23)<修改说明>
	 */
	public long deletePic(long picId,String database){
		StringBuffer sql = new StringBuffer(" delete from "+database+".bsc_photo_wall_pic where pic_id=? ");
		try{
			return this.daoTemplate.update(sql.toString(),picId);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
	/**
	  *摘要：照片墙置顶
	  *@说明：
	  *@创建：作者:YYP		创建时间：2014-6-10
	  *@param @param wallId 
	  *@修改历史：
	  *		[序号](YYP	2014-6-10)<修改说明>
	 */
	public void updatePhotoWallToTop(Integer wallId,String database) {
		String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
		StringBuffer sql = new StringBuffer(" update "+database+".bsc_photo_wall set is_top=1,top_time=? where wall_id=").append(wallId);
		try{
			this.daoTemplate.update(sql.toString(),now);
		}catch (Exception e) {
			throw new DaoException(e);
		}
	}
}
