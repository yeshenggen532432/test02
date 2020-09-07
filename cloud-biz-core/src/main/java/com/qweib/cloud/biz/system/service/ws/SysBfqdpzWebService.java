package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.common.CnlifeConstants;
import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysBfqdpzWebDao;
import com.qweib.cloud.repository.SysBfxgPicWebDao;
import com.qweib.cloud.utils.FileUtil;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class SysBfqdpzWebService {
	@Resource
	private SysBfqdpzWebDao bfqdpzWebDao;
	@Resource
	private SysBfxgPicWebDao bfxgPicWebDao;
	@Resource
	private SysDeptmempowerService deptmempowerService;
	/**
	 *说明：添加拜访签到拍照
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public int addBfqdpz(SysBfqdpz bfqdpz,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			this.bfqdpzWebDao.addBfqdpz(bfqdpz, database);
			int id=this.bfqdpzWebDao.getAutoId();
			if(bfxgPicLs.size()>0){
				for (int i = 0; i < bfxgPicLs.size(); i++) {
					bfxgPicLs.get(i).setSsId(id);
					bfxgPicLs.get(i).setType(1);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(i), database);
				}
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：修改拜访签到拍照
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public void updateBfqdpz(SysBfqdpz bfqdpz,List<SysBfxgPic> bfxgPicLs,String database) {
		try {
			this.bfqdpzWebDao.updateBfqdpz(bfqdpz, database);
			List<SysBfxgPic> list=this.bfxgPicWebDao.queryBfxgPicls(database, bfqdpz.getId(), 1,null);
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
			this.bfxgPicWebDao.deleteBfxgPic(database, bfqdpz.getId(), 1);
			if(bfxgPicLs.size()>0){
				for (int i = 0; i < bfxgPicLs.size(); i++) {
					bfxgPicLs.get(i).setSsId(bfqdpz.getId());
					bfxgPicLs.get(i).setType(1);
					this.bfxgPicWebDao.addBfxgPic(bfxgPicLs.get(i), database);
				}
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取拜访签到拍照信息
	 *@创建：作者:llp		创建时间：2016-3-24
	 *@修改历史：
	 *		[序号](llp	2016-3-24)<修改说明>
	 */
	public SysBfqdpz queryBfqdpzOne(String database,Integer mid,Integer cid,String qddate){
		try {
			return this.bfqdpzWebDao.queryBfqdpzOne(database, mid, cid,qddate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：获取拜访签到拍照上次信息
	 *@创建：作者:llp		创建时间：2016-3-30
	 *@修改历史：
	 *		[序号](llp	2016-3-30)<修改说明>
	 */
	public SysBfqdpz queryBfqdpzOneSc(String database,Integer mid,Integer cid){
		try {
			return this.bfqdpzWebDao.queryBfqdpzOneSc(database, mid, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询拜访客户信息
	 *@创建：作者:llp		创建时间：2016-3-31
	 *@修改历史：
	 *		[序号](llp	2016-3-31)<修改说明>
	 */
	public Page queryBfqdpzPage(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String qddate,String mids){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzPage(datasource,map, page, limit, khNm,qddate,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询拜访客户信息2
	 *@创建：作者:llp		创建时间：2017-8-3
	 *@修改历史：
	 *		[序号](llp	2017-8-3)<修改说明>
	 */
	public Page queryBfqdpzPage2(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String mids,String sdate,String edate,Integer cid,Integer id){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzPage2(datasource,map, page, limit, khNm,mids,sdate,edate,cid,id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public Page queryBfqdpzPage3(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String mids,String sdate,String edate,Integer cid,Integer id){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzPage3(datasource,map, page, limit, khNm,mids,sdate,edate,cid,id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
    public Page queryBfqdpzPageNew(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String mids,String sdate,String edate,Integer cid,Integer id){
        try {
            String datasource = user.getDatabase();
            Integer memberId = user.getMemId();
            Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
            return this.bfqdpzWebDao.queryBfqdpzPageNew(datasource,map, page, limit, khNm,mids,sdate,edate,cid,id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }

    /**
     * 打卡明细：图片和语音路径
     */
    public List<SysSignDetail> querySignInDetailList(String database, Integer id) {
	    try {
            return  this.bfqdpzWebDao.querySignInDetailList(database, id);
        } catch (Exception e) {
            throw new ServiceException(e);
        }
    }
	//统计商家数
	public int queryBfqdpzWebCount(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String mids,String sdate,String edate,Integer cid){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzWebCount(datasource,map, page, limit, khNm,mids,sdate,edate,cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public int queryBfqdpzWebCount2(OnlineUser user, String dataTp,Integer page,Integer limit,String khNm,String mids,String sdate,String edate,Integer cid){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzWebCount2(datasource,map, page, limit, khNm,mids,sdate,edate,cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public SysBfqdpzJl queryBfqdpzBy4cs(OnlineUser user, String dataTp,String mids){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzBy4cs(datasource, map, mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据拜访id获取拜访签到拍照信息
	 *@创建：作者:llp		创建时间：2016-4-12
	 *@修改历史：
	 *		[序号](llp	2016-4-12)<修改说明>
	 */
	public SysBfqdpz queryBfqdpzById(String database,Integer id){
		try {
			return this.bfqdpzWebDao.queryBfqdpzById(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	public SysBfqdpzJl queryBfqdpzById2(String database,Integer id){
		try {
			return this.bfqdpzWebDao.queryBfqdpzById2(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据客户，业务，时间获取拜访签到拍照信息
	 *@创建：作者:llp		创建时间：2016-8-11
	 *@修改历史：
	 *		[序号](llp	2016-8-11)<修改说明>
	 */
	public SysBfqdpz queryBfqdpzBycmd(String database,Integer mid,Integer cid,String date){
		try {
			return this.bfqdpzWebDao.queryBfqdpzBycmd(database, mid, cid, date);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询拜访客户信息
	 *@创建：作者:llp		创建时间：2016-4-12
	 *@修改历史：
	 *		[序号](llp	2016-4-12)<修改说明>
	 */
	public Page queryBfqdpzPageBymcid(OnlineUser user,Integer page,Integer limit,Integer cid, String dataTp){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.bfqdpzWebDao.queryBfqdpzPageBymcid(datasource, page, limit, map, cid);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 查询拜访评论
	  *@param topicId
	  *@param database
	  *@return
	  *@创建：作者:llp		创建时间：2017-8-9
	 */
	public List<SysBfcomment> queryBfCommentList(Integer bfId,String datasource) {
		try {
			return this.bfqdpzWebDao.queryBfCommentList(bfId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 查询拜访回复
	  *@param topicId
	  *@param database
	  *@return
	  *@创建：作者:llp		创建时间：2017-8-9
	 */
	public List<SysBfcomment> queryBfRcList(Integer commentId,String datasource) {
		try {
			return this.bfqdpzWebDao.queryBfRcList(commentId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	  *@see 查询拜访发布人信息
	  *@param bfId
	  *@param database
	  *@return
	  *@创建：作者:llp		创建时间：2017-8-9
	 */
	public SysMemDTO findMemberByQdpz(Integer bfId,String datasource) {
		try {
			return this.bfqdpzWebDao.findMemberByQdpz(bfId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据评论id查询
	 *@创建：作者:llp		创建时间：2017-8-9
	 *@修改历史：
	 *		[序号](llp	2017-8-9)<修改说明>
	 */
	public SysBfcomment queryBfCommentById(Integer commentId,String datasource) {
		try {
			return this.bfqdpzWebDao.queryBfCommentById(commentId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：添加评论/回复
	 *@创建：作者:llp		创建时间：2017-8-9
	 *@修改历史：
	 *		[序号](llp	2017-8-9)<修改说明>
	 */
	public int addBfcomment(SysBfcomment bfcomment,String database) {
		try {
			return this.bfqdpzWebDao.addBfcomment(bfcomment, database);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：删除评论,回复
	 *@创建：作者:llp		创建时间：2017-8-9
	 *@修改历史：
	 *		[序号](llp	2017-8-9)<修改说明>
	 */
	public void deleteBfComment(Integer commentId,String datasource) {
		try {
			this.bfqdpzWebDao.deleteBfComment(commentId, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
