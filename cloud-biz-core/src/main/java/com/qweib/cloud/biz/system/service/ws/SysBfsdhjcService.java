package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.SysBfsdhjc;
import com.qweib.cloud.core.domain.SysBfxgPic;

import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfsdhjcDao;
import com.qweib.cloud.repository.SysBfxgPicWebDao;
import com.qweib.cloud.utils.FileUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBfsdhjcService {
	@Resource
	private SysBfsdhjcDao bfsdhjcDao;
	@Resource
	private SysBfxgPicWebDao bfxgPicWebDao;
	
	/**
	 *说明：添加生动化检查
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public int addBfsdhjc(SysBfsdhjc bfsdhjc,List<SysBfxgPic> bfxgPicLs1,List<SysBfxgPic> bfxgPicLs2,String database) {
		try {
			this.bfsdhjcDao.addBfsdhjc(bfsdhjc, database);
			int id=this.bfsdhjcDao.getAutoId();
			//生动化
			if(bfxgPicLs1.size()>0){
				for (int i = 0; i < bfxgPicLs1.size(); i++) {
					bfxgPicLs1.get(i).setSsId(id);
					bfxgPicLs1.get(i).setType(2);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs1.get(i), database);
				}
			}
			//堆头
			if(bfxgPicLs2.size()>0){
				for (int i = 0; i < bfxgPicLs2.size(); i++) {
					bfxgPicLs2.get(i).setSsId(id);
					bfxgPicLs2.get(i).setType(3);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs2.get(i), database);
				}
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改生动化检查
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public void updateBfsdhjc(SysBfsdhjc bfsdhjc,List<SysBfxgPic> bfxgPicLs1,List<SysBfxgPic> bfxgPicLs2,String database) {
		try {
			this.bfsdhjcDao.updateBfsdhjc(bfsdhjc, database);
            //-----------生动化-----------------
			List<SysBfxgPic> list1=this.bfxgPicWebDao.queryBfxgPicls(database, bfsdhjc.getId(), 2,null);
			if(list1.size()>0){
				FileUtil fileUtil = new FileUtil();
				String path = CnlifeConstants.url()+"upload/";
				for (int i = 0; i < list1.size(); i++) {
					String paths = path+ list1.get(i).getPicMini();
					String picPath =path+ list1.get(i).getPic();
					//删除图片
					if(fileUtil.ifExist(paths)){
						fileUtil.deleteFile(paths);
						fileUtil.deleteFile(picPath);
					}
				}
			}
			this.bfxgPicWebDao.deleteBfxgPic(database, bfsdhjc.getId(), 2);
			if(bfxgPicLs1.size()>0){
				for (int i = 0; i < bfxgPicLs1.size(); i++) {
					bfxgPicLs1.get(i).setSsId(bfsdhjc.getId());
					bfxgPicLs1.get(i).setType(2);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs1.get(i), database);
				}
			}
			//----------------堆头----------------
			List<SysBfxgPic> list2=this.bfxgPicWebDao.queryBfxgPicls(database, bfsdhjc.getId(), 3,null);
			if(list2.size()>0){
				FileUtil fileUtil = new FileUtil();
				String path = CnlifeConstants.url()+"upload/";
				for (int i = 0; i < list2.size(); i++) {
					String paths = path+ list2.get(i).getPicMini();
					String picPath =path+ list2.get(i).getPic();
					//删除图片
					if(fileUtil.ifExist(paths)){
						fileUtil.deleteFile(paths);
						fileUtil.deleteFile(picPath);
					}
				}
			}
			this.bfxgPicWebDao.deleteBfxgPic(database, bfsdhjc.getId(), 3);
			if(bfxgPicLs2.size()>0){
				for (int i = 0; i < bfxgPicLs2.size(); i++) {
					bfxgPicLs2.get(i).setSsId(bfsdhjc.getId());
					bfxgPicLs2.get(i).setType(3);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs2.get(i), database);
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取生动化检查信息
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public SysBfsdhjc queryBfsdhjcOne(String database,Integer mid,Integer cid,String sddate){
		try {
			return this.bfsdhjcDao.queryBfsdhjcOne(database, mid, cid,sddate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
