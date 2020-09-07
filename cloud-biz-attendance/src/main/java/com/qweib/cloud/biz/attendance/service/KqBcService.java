package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqBcDao;
import com.qweib.cloud.biz.attendance.model.KqAddress;
import com.qweib.cloud.biz.attendance.model.KqBc;
import com.qweib.cloud.biz.attendance.model.KqBcTimes;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service
public class KqBcService {
	
	@Resource
	private KqBcDao bcDao;
	
	/**
	 * 新增班次
	 */
	public int addKqBc(KqBc bcRec,String database)
	{
		bcRec.setStatus(1);
//		bcRec.setAreaLong(0);
//		bcRec.setOutOf(0);
		if(StrUtil.isNull(bcRec.getLongitude())){
			bcRec.setLatitude("0");
			bcRec.setLongitude("0");
		}

		if(bcRec.getAddress()!= null)
		{
			KqBc bc1 = this.bcDao.getBcByAddress(bcRec.getAddress(), database);
			if(bc1 != null)
			{
				bcRec.setLatitude(bc1.getLatitude());
				bcRec.setLongitude(bc1.getLongitude());
			}
		}
		List<KqBcTimes> subList = bcRec.getSubList();
		int ret = this.bcDao.addBc(bcRec, database);
		if(ret == 0)
		{
			return 0;
		}
		for(KqBcTimes times: subList)
		{
			times.setBcId(ret);
			if (this.bcDao.addBcTimes(times, database) == 0)
			{
				throw new ServiceException("保存失败");
			}
		}
		return ret;
	}
	
	
	public int updateKqBc(KqBc bcRec,String database)
	{
		KqBc bc1 = this.bcDao.getKqBcById(bcRec.getId(), database);
		if(bc1 != null)
		{
			if(!bc1.getAddress().equals(bcRec.getAddress())||bc1.getLatitude().length() < 3)//地址不一样
			{
				bc1 = this.bcDao.getBcByAddress(bcRec.getAddress(), database);
				if(bc1 != null)
				{
					bcRec.setLongitude(bc1.getLongitude());
					bcRec.setLatitude(bc1.getLatitude());
				}
			}
		}
		List<KqBcTimes> subList = bcRec.getSubList();
		int ret = this.bcDao.updateBc(bcRec, database);
		if(ret == 0)return ret;
		this.bcDao.deleteBcTimes(bcRec.getId(), database);
		for(KqBcTimes times: subList)
		{
			times.setBcId(bcRec.getId());
			times.setId(null);
			if (this.bcDao.addBcTimes(times, database) == 0)
			{
				throw new ServiceException("保存失败");
			}
		}
		return ret;
	}
	
	public Page queryKqBc(KqBc bc, String database, Integer page, Integer limit)
	{
		Page p = this.bcDao.queryKqBc(bc, database, page, limit);
		List<KqBc> list = p.getRows();
		if(list.size() == 0)return p;
		String bcIds = "";
		for(KqBc vo: list)
		{
			if(bcIds.length() == 0)bcIds = vo.getId().toString();
			else bcIds = bcIds + "," + vo.getId().toString();
		}
		List<KqBcTimes> subList = this.bcDao.queryBcTimes(bcIds, database);
		for(KqBc vo: list)
		{
			List<KqBcTimes> subList1 = new ArrayList<KqBcTimes>();
			for(KqBcTimes time: subList)
			{
				if(time.getBcId().intValue() == vo.getId().intValue())
				{
					subList1.add(time);
				}
			}
			vo.setSubList(subList1);
		}
		return p;
	}
	
	public int updateBcStatus(Integer id,Integer status,String database)
	{
		return this.bcDao.updateBcStatus(id, status, database);
	}
	
	public int deleteBc(Integer id,String database)
	{
		this.bcDao.deleteBcTimes(id, database);
		return this.bcDao.deleteBc(id, database);
	}
	
	public KqBc getKqBcById(Integer id,String database)
	{
		KqBc bcRec = this.bcDao.getKqBcById(id, database);
		if(bcRec == null)return null;
		List<KqBcTimes> subList = this.bcDao.queryBcTimes(id.toString(), database);
		bcRec.setSubList(subList);
		return bcRec;
	}
	
	public List<KqAddress> queryBcAddress(String database)
	{
		return this.bcDao.queryAddress(database);
	}
	
	public int updateKqAddress(KqAddress bo,String database)
	{
		return this.bcDao.updateAddress(bo, database);
	}

}
