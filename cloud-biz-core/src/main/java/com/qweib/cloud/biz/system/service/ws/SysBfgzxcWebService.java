package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.SysBfgzxc;
import com.qweib.cloud.core.domain.SysBfqdpz;
import com.qweib.cloud.core.domain.SysBfxgPic;

import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfgzxcWebDao;
import com.qweib.cloud.repository.SysBfxgPicWebDao;
import com.qweib.cloud.utils.FileUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBfgzxcWebService {
	@Resource
	private SysBfgzxcWebDao bfgzxcWebDao;
	@Resource
	private SysBfxgPicWebDao bfxgPicWebDao;
	
	/**
	 *说明：添加道谢并告知下次拜访
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public int addBfgzxc(SysBfgzxc bfgzxc,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			this.bfgzxcWebDao.addBfgzxc(bfgzxc, database);
			int id=this.bfgzxcWebDao.getAutoId();
			if(bfxgPicLs.size()>0){
				for (int i = 0; i < bfxgPicLs.size(); i++) {
					bfxgPicLs.get(i).setSsId(id);
					bfxgPicLs.get(i).setType(5);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(i), database);
				}
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改道谢并告知下次拜访
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public void updateBfgzxc(SysBfgzxc bfgzxc,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			this.bfgzxcWebDao.updateBfgzxc(bfgzxc, database);
			List<SysBfxgPic> list=this.bfxgPicWebDao.queryBfxgPicls(database, bfgzxc.getId(), 5,null);
			if(list.size()>0){
				FileUtil fileUtil = new FileUtil();
				String path = CnlifeConstants.url()+"upload/";
				for (int i = 0; i < list.size(); i++) {
					String paths = path+ list.get(i).getPicMini();
					String picPath =path+ list.get(i).getPic();
					//删除图片
					if(fileUtil.ifExist(paths)){
						fileUtil.deleteFile(paths);
						fileUtil.deleteFile(picPath);
					}
				}
			}
			this.bfxgPicWebDao.deleteBfxgPic(database, bfgzxc.getId(), 5);
			if(bfxgPicLs.size()>0){
				for (int i = 0; i < bfxgPicLs.size(); i++) {
					bfxgPicLs.get(i).setSsId(bfgzxc.getId());
					bfxgPicLs.get(i).setType(5);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(i), database);
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取道谢并告知下次拜访信息
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcOne(String database,Integer mid,Integer cid,String dqdate){
		try {
			return this.bfgzxcWebDao.queryBfgzxcOne(database, mid, cid,dqdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取道谢并告知下次拜访上次信息
	 *@创建：作者:llp		创建时间：2016-3-30
	 *@修改历史：
	 *		[序号](llp	2016-3-30)<修改说明>
	 */
	public SysBfgzxc queryBfgzxcOneSc(String database,Integer mid,Integer cid){
		try {
			return this.bfgzxcWebDao.queryBfgzxcOneSc(database, mid, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}

	/**
	 *说明：根据拜访id获取拜访签退拍照信息
	 */
	public SysBfgzxc queryBfgzxcById(String database, Integer id){
		try {
			return this.bfgzxcWebDao.queryBfgzxcById(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
