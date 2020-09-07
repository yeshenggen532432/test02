package com.qweib.cloud.biz.system.service.ws;

import com.qweib.cloud.biz.system.service.plat.SysDeptmempowerService;
import com.qweib.cloud.core.domain.OnlineUser;
import com.qweib.cloud.core.domain.SysThorder;
import com.qweib.cloud.core.domain.SysThorderDetail;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.repository.SysThorderWebDao;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SysThorderWebService {
	@Resource
	private SysThorderWebDao thorderWebDao;
	@Resource
	private SysDeptmempowerService deptmempowerService;
	
	
	public int addThorder(SysThorder thorder,List<SysThorderDetail> detail,String database) {
		try {
			this.thorderWebDao.addThorder(thorder, database);
			int id=this.thorderWebDao.getAutoId();
			for(SysThorderDetail orderDetail:detail){
			    orderDetail.setOrderId(id);
				this.thorderWebDao.addThorderDetail(orderDetail, database);
			}
			return id;
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public void updateThorder(SysThorder thorder,List<SysThorderDetail> detail,String database) {
		try {
			this.thorderWebDao.updateThorder(thorder, database);
			this.thorderWebDao.deleteThorderDetail(database, thorder.getId());
			for(SysThorderDetail orderDetail:detail){
			    orderDetail.setOrderId(thorder.getId());
				this.thorderWebDao.addThorderDetail(orderDetail, database);
			}
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public SysThorder queryThorderOne(String database,Integer mid,Integer cid,String oddate){
		try {
			return this.thorderWebDao.queryThorderOne(database, mid, cid,oddate);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public SysThorder queryThorderOne2(String database,Integer id){
		try {
			return this.thorderWebDao.queryThorderOne2(database, id);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public List<SysThorderDetail> queryThorderDetail(String database,Integer orderId){
		try {
			return this.thorderWebDao.queryThorderDetail(database, orderId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
//	----------------------------订货下单------------------------------
	
	public Page queryDhorder(OnlineUser user, String dataTp,Integer page,Integer limit,String kmNm,String sdate,String edate,String mids){
		try {
			String datasource = user.getDatabase();
			Integer memberId = user.getMemId();
			Map<String, Object> map = deptmempowerService.getPowerDept(dataTp, memberId, datasource);
			return this.thorderWebDao.queryDhorder(datasource, map, page, limit,kmNm,sdate,edate,mids);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public int queryOrderDetailCount(String database,Integer orderId){
		try {
			return this.thorderWebDao.queryOrderDetailCount(database, orderId);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
}
