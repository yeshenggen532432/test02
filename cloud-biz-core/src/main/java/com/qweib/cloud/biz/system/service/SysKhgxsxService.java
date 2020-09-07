package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysKhgxsxDao;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysKhgxsxService {
	@Resource
	private SysKhgxsxDao khgxsxDao;

//	/**
//	 *说明：分页查询拜访频次
//	 *@创建：作者:llp		创建时间：2016-2-16
//	 *@修改历史：
//	 *		[序号](llp	2016-2-16)<修改说明>
//	 */
//	public Page querySysBfpc(SysBfpc bfpc,String datasource,Integer page,Integer limit){
//		try {
//			return this.khgxsxDao.querySysBfpc(bfpc, datasource, page, limit);
//		} catch (Exception e) {
//			throw new ServiceException(e);
//		}
//	}
	/**
	 *说明：列表查询拜访频次
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysBfpc> queryBfpcls(){
		try {
			return this.khgxsxDao.queryBfpcls();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
//	/**
//	 *说明：分页查询供货类型
//	 *@创建：作者:llp		创建时间：2016-2-16
//	 *@修改历史：
//	 *		[序号](llp	2016-2-16)<修改说明>
//	 */
//	public Page querySysGhtype(SysGhtype ghtype,String datasource,Integer page,Integer limit){
//		try {
//			return this.khgxsxDao.querySysGhtype(ghtype, datasource, page, limit);
//		} catch (Exception e) {
//			throw new ServiceException(e);
//		}
//	}
	/**
	 *说明：列表查询供货类型
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysGhtype> queryGhtypels(){
		try {
			return this.khgxsxDao.queryGhtypels();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询经销商分类
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysJxsfl(SysJxsfl jxsfl,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysJxsfl(jxsfl, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询经销商分类
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysJxsfl> queryJxsflls(String datasource){
		try {
			return this.khgxsxDao.queryJxsflls(datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询经销商级别
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysJxsjb(SysJxsjb jxsjb,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysJxsjb(jxsjb, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询经销商级别
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysJxsjb> queryJxsjbls(String datasource){
		try {
			return this.khgxsxDao.queryJxsjbls(datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询经销商状态
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysJxszt(SysJxszt jxszt,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysJxszt(jxszt, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询经销商状态
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysJxszt> queryJxsztls(String datasource){
		try {
			return this.khgxsxDao.queryJxsztls(datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询客户等级
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysKhlevel(SysKhlevel khlevel,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysKhlevel(khlevel, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询客户等级
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysKhlevel> queryKhlevells(Integer qdId,String datasource){
		try {
			return this.khgxsxDao.queryKhlevells(qdId,datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询渠道类型
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysQdtype(SysQdtype qdtype,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysQdtype(qdtype,page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询渠道类型
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysQdtype> queryQdtypls(String datasource){
		try {
			return this.khgxsxDao.queryQdtypls(datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：根据渠道名称获取信息
	 *@创建：作者:llp		创建时间：2016-4-13
	 *@修改历史：
	 *		[序号](llp	2016-4-13)<修改说明>
	 */
	public SysQdtype queryQdtypone(String qdtpNm,String datasource){
		try {
			return this.khgxsxDao.queryQdtypone(qdtpNm,datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询市场类型
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysSctype(SysSctype sctype,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysSctype(sctype, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询市场类型
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysSctype> querySctypels(){
		try {
			return this.khgxsxDao.querySctypels();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：分页查询销售阶段
	 *@创建：作者:llp		创建时间：2016-2-16
	 *@修改历史：
	 *		[序号](llp	2016-2-16)<修改说明>
	 */
	public Page querySysXsphase(SysXsphase xsphase,String datasource,Integer page,Integer limit){
		try {
			return this.khgxsxDao.querySysXsphase(xsphase, datasource, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询销售阶段
	 *@创建：作者:llp		创建时间：2016-2-17
	 *@修改历史：
	 *		[序号](llp	2016-2-17)<修改说明>
	 */
	public List<SysXsphase> queryXsphasels(){
		try {
			return this.khgxsxDao.queryXsphasels();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询合作方式
	 *@创建：作者:llp		创建时间：2016-4-13
	 *@修改历史：
	 *		[序号](llp	2016-4-13)<修改说明>
	 */
	public List<SysHzfs> queryHzfsls(){
		try {
			return this.khgxsxDao.queryHzfsls();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：列表查询销售类型
	 *@创建：作者:llp		创建时间：2016-4-13
	 *@修改历史：
	 *		[序号](llp	2016-4-13)<修改说明>
	 */
	public List<SysXstype> queryXstypels(){
		try {
			return this.khgxsxDao.queryXstypels();
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
