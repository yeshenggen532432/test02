package com.qweib.cloud.biz.attendance.service;

import com.qweib.cloud.biz.attendance.dao.KqPbDao;
import com.qweib.cloud.biz.attendance.model.KqPb;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class KqPbService {
	
	@Resource
	private KqPbDao pbDao;
	
	/**
	 * 批量保存排班记录
	 * @param dates
	 * @param empIds
	 * @param bcId
	 * @param database
	 * @return
	 */
	public int addBatKqPb(String dateStr,String empIdStr,Integer bcId,String database)
	{
		String []dates = dateStr.split(",");
		if(dates.length == 0)return 0;
		String []empIds = empIdStr.split(",");
		if(empIds.length == 0)return 0;
		for(int i = 0;i<empIds.length;i++)
		{
			Integer empId = Integer.parseInt(empIds[i]);
			if(empId == 0)continue;
			for(int j = 0;j<dates.length;j++)
			{
				KqPb bo = new KqPb();
				bo.setBcDate(dates[j]);
				bo.setBcId(bcId);
				bo.setMemberId(empId);
				this.pbDao.deleteKqPb(bo, database);
				int ret = this.pbDao.addKqPb(bo, database);
				if(ret == 0)
				{
					throw new ServiceException("保存失败");
				}
			}
		}
		return 1;
	}
	
	public int deleteKqPb1(String ids,String sdate,String edate,String database)
	{
		return this.pbDao.deleteKqPb1(ids, sdate, edate, database);
	}
	
	public Page queryKqPbPage(KqPb bo, String database, Integer page, Integer limit)
	{
		Page p = this.pbDao.queryKqPbPage(bo, database, page, limit);
		List<KqPb> list = p.getRows();
		for(KqPb vo: list)
		{
			if(vo.getBcId().intValue() == 0)vo.setBcName("休");
			if(vo.getBcId().intValue() == -1)vo.setBcName("未排班");
		}
		return p;
	}
	
	//public KqBc getBcByEmpIdAndDate(Integer empId,String )

}
