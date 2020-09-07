package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.repository.SysBforderXlsDao;
import com.qweib.cloud.core.domain.SysBforderXls;
import com.qweib.cloud.core.exception.ServiceException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysBforderXlsService {
	@Resource
	private SysBforderXlsDao bforderXlsDao;
	
	/**
	 *说明：查询订单1
	 *@创建：作者:llp		创建时间：2016-5-26
	 *@修改历史：
	 *		[序号](llp	2016-5-26)<修改说明>
	 */
	public List<SysBforderXls> queryBforderXls1(String orderNo, String khNm,
			String memberNm, String sdate,String edate,String orderZt,String pszd,String datasource) {
		try {
			return this.bforderXlsDao.queryBforderXls1(orderNo, khNm, memberNm, sdate, edate,orderZt,pszd, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	/**
	 *说明：查询订单2
	 *@创建：作者:llp		创建时间：2016-5-26
	 *@修改历史：
	 *		[序号](llp	2016-5-26)<修改说明>
	 */
	public List<SysBforderXls> queryBforderXls2(Integer orderId,Integer count,String datasource) {
		try {
			return this.bforderXlsDao.queryBforderXls2(orderId, count, datasource);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
