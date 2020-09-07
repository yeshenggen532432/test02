package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.SysBfcljccj;
import com.qweib.cloud.core.domain.SysBfxgPic;

import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfcljccjWebDao;
import com.qweib.cloud.repository.SysBfxgPicWebDao;
import com.qweib.cloud.utils.FileUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBfcljccjWebService {
	@Resource
	private SysBfcljccjWebDao bfcljccjWebDao;
	@Resource
	private SysBfxgPicWebDao bfxgPicWebDao;
	
	/**
	 *说明：添加陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public void addBfcljccj(List<SysBfcljccj> bfcljccjLs,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			for(int i=0;i<bfcljccjLs.size();i++){
				this.bfcljccjWebDao.addBfcljccj(bfcljccjLs.get(i), database);
				int id=this.bfcljccjWebDao.getAutoId();
				if(bfxgPicLs.size()>0){
					for (int j = 0; j < bfxgPicLs.size(); j++) {
						if(bfxgPicLs.get(j).getXxId().equals(bfcljccjLs.get(i).getMdid())){
							bfxgPicLs.get(j).setSsId(id);
							bfxgPicLs.get(j).setType(4);
							bfxgPicLs.get(j).setXxId(bfcljccjLs.get(i).getMdid());
							this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(j), database);
						}
					}
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public void updateBfcljccj(List<SysBfcljccj> bfcljccjLs,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			for(int i=0;i<bfcljccjLs.size();i++){
				this.bfcljccjWebDao.updateBfcljccj(bfcljccjLs.get(i), database);
				List<SysBfxgPic> list1=this.bfxgPicWebDao.queryBfxgPicls(database, bfcljccjLs.get(i).getId(), 4,null);
				if(list1.size()>0){
					FileUtil fileUtil = new FileUtil();
					String path = CnlifeConstants.url()+"upload/";
					for (int a = 0; a < list1.size(); a++) {
						String paths = path+ list1.get(a).getPicMini();
						String picPath =path+ list1.get(a).getPic();
						//删除图片
						if(fileUtil.ifExist(paths)){
							fileUtil.deleteFile(paths);
							fileUtil.deleteFile(picPath);
						}
					}
				}
				this.bfxgPicWebDao.deleteBfxgPic(database, bfcljccjLs.get(i).getId(), 4);
				if(bfxgPicLs.size()>0){
					for (int j = 0; j < bfxgPicLs.size(); j++) {
						if(bfxgPicLs.get(j).getXxId().equals(bfcljccjLs.get(i).getMdid())){
							bfxgPicLs.get(j).setSsId(bfcljccjLs.get(i).getId());
							bfxgPicLs.get(j).setType(4);
							bfxgPicLs.get(j).setXxId(bfcljccjLs.get(i).getMdid());
							this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(j), database);
						}
					}
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取陈列检查采集
	 *@创建：作者:llp		创建时间：2016-3-25
	 *@修改历史：
	 *		[序号](llp	2016-3-25)<修改说明>
	 */
	public List<SysBfcljccj> queryBfcljccjOne(String database,Integer mid,Integer cid,String cjdate){
		try {
			return this.bfcljccjWebDao.queryBfcljccjOne(database, mid, cid,cjdate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
