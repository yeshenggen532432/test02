package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.core.domain.SysWarePic;
import com.qweib.cloud.core.domain.SysWaretype;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysWarePicWebDao;
import com.qweib.cloud.repository.SysWareWebDao;
import com.qweib.cloud.utils.FileUtil;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysWareWebService {
	@Resource
	private SysWareWebDao wareWebDao;
	@Resource
	private SysWarePicWebDao wareWebPicDao;
	
	/**
	 *说明：获取商品分类第一级
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public List<SysWaretype> queryWaretypeLs1(SysWaretype type,String database){
		try {
			return this.wareWebDao.queryWaretypeLs1(type,database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据分类pid获取商品分类
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public List<SysWaretype> queryWaretypeLs2(SysWaretype type,String database,Integer waretypeId){
		try {
			return this.wareWebDao.queryWaretypeLs2(type,database, waretypeId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据商品分类id获取商品信息
	 *@创建：作者:llp		创建时间：2016-3-28
	 *@修改历史：
	 *		[序号](llp	2016-3-28)<修改说明>
	 */
	public List<SysWare> queryWareLs(String database,Integer waretypeId){
		try {
			return this.wareWebDao.queryWareLs(database, waretypeId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	
	public void updateWare(SysWare sysWare,List<SysWarePic> warePicList,String delPicIds,String database) {
		try {
			SysWarePic warePic = new SysWarePic();
			warePic.setWareId(sysWare.getWareId());
			if(!StrUtil.isNull(delPicIds)){
				List<SysWarePic> list=this.wareWebPicDao.queryWarePic(database, warePic);
				if(list.size()>0){
					FileUtil fileUtil = new FileUtil();
					String path = CnlifeConstants.url()+"upload/ware/pic";
					delPicIds = ","+delPicIds+",";
					for (int i = 0; i < list.size(); i++) {
						String picId = ","+list.get(i).getId()+",";
						if(delPicIds.contains(picId)){
							String paths = path+ list.get(i).getPicMini();
							String picPath =path+ list.get(i).getPic();
							//删除图片
							if(fileUtil.ifExist(paths)){
								fileUtil.deleteFile(paths);
								fileUtil.deleteFile(picPath);
							}
							this.wareWebPicDao.deleteWarePic(database,list.get(i));
						}
					}
				}
			}
			
			if(warePicList.size()>0){
				for (int i = 0; i < warePicList.size(); i++) {
					warePicList.get(i).setWareId(sysWare.getWareId());
					this.wareWebPicDao.addWarePic(warePicList.get(i), database);
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
}
