package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysMemBfStat;
import com.qweib.cloud.core.domain.SysMemBfXsxjStat;
import com.qweib.cloud.repository.SysBfxsxjDao;
import com.qweib.cloud.core.domain.SysBfxsxj;
import com.qweib.cloud.core.exception.ServiceException;
import com.qweib.cloud.utils.Page;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class SysBfxsxjService {
	@Resource
	private SysBfxsxjDao bfxsxjDao;
	
	/**
	 *说明：分页查询销售小结（根据业务员和客户）
	 *@创建：作者:llp		创建时间：2016-4-28
	 *@修改历史：
	 *		[序号](llp	2016-4-28)<修改说明>
	 */
	public Page queryBfxsxjPage(String database,Integer mid,Integer cid,String xjdate,Integer page,Integer limit){
		try {
			return this.bfxsxjDao.queryBfxsxjPage(database, mid, cid, xjdate, page, limit);
		} catch (Exception e) {
			throw new ServiceException(e);
		}
	}
	
	public Page sumBfxsxjPage(SysBfxsxj xj,Integer page,Integer limit)
	{
		Page p= this.bfxsxjDao.sumBfxsxjPage(xj, page, limit);
		List<SysBfxsxj> list = p.getRows();
		for(SysBfxsxj vo: list)
		{
			SysBfxsxj vo1 = this.bfxsxjDao.getLastKcNum(vo.getCid(), vo.getWid(), xj.getSdate(), xj.getEdate(), xj.getDatabase());
			if(vo1 != null)
			{
				vo.setKcNum(vo1.getKcNum());
				vo.setXjdate(vo1.getXjdate());
			}
			
		}
		SysBfxsxj sumVo = this.bfxsxjDao.sumBfxsxjPage_total(xj);
		if(sumVo != null)
		{
			sumVo.setKhNm("合计：");
			Integer kcNum = this.bfxsxjDao.getLastKcNum_total(xj.getCid(),xj.getSdate(),xj.getEdate(), xj.getDatabase());
			sumVo.setKcNum(kcNum);
			list.add(sumVo);
		}
		return p;
	}

	public Page sumBfxsxjStatPage(final  SysBfxsxj xj,Integer page,Integer limit)
	{


		Page p= this.bfxsxjDao.sumBfxsxjPage2(xj, 1, 999999);
		List<SysBfxsxj> list = p.getRows();
        List<SysBfxsxj> kcList = this.bfxsxjDao.getSumLastKcNum_total(xj);
		for(SysBfxsxj vo: list)
		{

			for(SysBfxsxj vo1: kcList) {
			    if(vo1.getWid().intValue() == vo.getWid().intValue())
                vo.setKcNum(vo1.getKcNum());
            }
			if(vo.getKcNum() == null)vo.setKcNum(0);
		}
		Integer sumKcNum = 0;
        for(SysBfxsxj vo1: kcList) {
            if(vo1.getKcNum()!= null)sumKcNum+= vo1.getKcNum().intValue();
        }
		Integer cstQty = this.bfxsxjDao.getSumCstQty_total(xj);

		List<SysMemBfXsxjStat> retList = new ArrayList<SysMemBfXsxjStat>();
		for(SysBfxsxj vo: list)
		{
			SysMemBfXsxjStat stat = new SysMemBfXsxjStat();
			stat.setWareId(vo.getWid());
			stat.setWareNm(vo.getWareNm());
			stat.setCstQty(vo.getDhNum());//在售商家
			stat.setSaleRate(new BigDecimal(0));
			stat.setWareRate(new BigDecimal(0));

			stat.setKcNum(vo.getKcNum());
			if(sumKcNum.intValue() > 0)
			{
				double f = stat.getKcNum();
				f = f/sumKcNum.intValue();
				f = f *100;
				BigDecimal rate = new BigDecimal(f);
				rate = rate.setScale(2,BigDecimal.ROUND_HALF_UP);
				stat.setWareRate(rate);

			}

			if(cstQty.intValue() > 0)
			{
				double f = stat.getCstQty();
				f = f/cstQty.intValue();
				f = f *100;
				stat.setSaleRate(new BigDecimal((int)f));
			}
			if(stat.getCstQty() == null)stat.setCstQty(0);

			retList.add(stat);

		}
		//排序
		if(xj.getOrder()!= null&&xj.getSort() != null) {
			Collections.sort(retList, new Comparator<SysMemBfXsxjStat>() {
				@Override
				public int compare(SysMemBfXsxjStat o1, SysMemBfXsxjStat o2) {
					if (xj.getOrder().equals("asc")) {
						if (xj.getSort().equals("kcNum")) {
							if (o1.getKcNum().intValue() > o2.getKcNum().intValue()) return 1;
							if (o1.getKcNum().intValue() == o2.getKcNum().intValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("wareRate")) {
							if (o1.getWareRate().doubleValue() > o2.getWareRate().doubleValue()) return 1;
							if (o1.getWareRate().doubleValue() == o2.getWareRate().doubleValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("saleRate")) {
							if (o1.getSaleRate().doubleValue() > o2.getSaleRate().doubleValue()) return 1;
							if (o1.getSaleRate().doubleValue() == o2.getSaleRate().doubleValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("cstQty")) {
							if (o1.getCstQty().intValue() > o2.getCstQty().intValue()) return 1;
							if (o1.getCstQty().intValue() == o2.getCstQty().intValue()) return 0;
							return -1;
						}
					} else//降序
					{
						if (xj.getSort().equals("kcNum")) {
							if (o1.getKcNum().intValue() < o2.getKcNum().intValue()) return 1;
							if (o1.getKcNum().intValue() == o2.getKcNum().intValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("wareRate")) {
							if (o1.getWareRate().doubleValue() < o2.getWareRate().doubleValue()) return 1;
							if (o1.getWareRate().doubleValue() == o2.getWareRate().doubleValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("saleRate")) {
							if (o1.getSaleRate().doubleValue() < o2.getSaleRate().doubleValue()) return 1;
							if (o1.getSaleRate().doubleValue() == o2.getSaleRate().doubleValue()) return 0;
							return -1;
						}
						if (xj.getSort().equals("cstQty")) {
							if (o1.getCstQty().intValue() < o2.getCstQty().intValue()) return 1;
							if (o1.getCstQty().intValue() == o2.getCstQty().intValue()) return 0;
							return -1;
						}
					}

					return 0;
				}
			});
		}

		//处理分页
		List<SysMemBfXsxjStat> retList1 = new ArrayList<SysMemBfXsxjStat>();
		Integer start = (page.intValue() - 1)*limit.intValue();
		for(int i = start;i<start + limit;i++)
		{
			if(i >= retList.size())break;
			retList1.add(retList.get(i));
		}
		SysMemBfXsxjStat sumVo = new SysMemBfXsxjStat();
		sumVo.setWareNm("合计：");
		//sumVo.setCstQty(cstQty);
		sumVo.setKcNum(sumKcNum);
		sumVo.setWareRate(new BigDecimal(100));
		retList1.add(sumVo);
        SysMemBfXsxjStat sumVo1 = new SysMemBfXsxjStat();
        sumVo1.setWareNm("总网点数");
        sumVo1.setCstQty(cstQty);
        retList1.add(sumVo1);
        p.setRows(retList1);
		return p;
	}


	
	public Page sumBfxsxjPage1(SysBfxsxj xj,Integer page,Integer limit)
	{
		Page p= this.bfxsxjDao.sumBfxsxjPage1(xj, page, limit);
		List<SysBfxsxj> list = p.getRows();
		List<SysBfxsxj> kcList = this.bfxsxjDao.getLastKcNumByCustomer(xj,xj.getDatabase());
		for(SysBfxsxj vo: list)
		{
			vo.setKcNum(0);
			vo.setKcNum1(0);
			for(SysBfxsxj vo1: kcList)
			{
				if(vo.getCid().intValue() == vo1.getCid().intValue())
				{
					if(vo1.getNoCompany().intValue()== 1)vo.setKcNum1(vo1.getKcNum());
					else vo.setKcNum(vo1.getKcNum());
				}
			}
			//Integer kcNum = this.bfxsxjDao.getLastKcNum_total(vo.getCid(), xj.getSdate(), xj.getEdate(), xj.getDatabase());
			//vo.setKcNum(kcNum);
		}
		Integer kcNum = 0;
		Integer kcNum1 = 0;
		for(SysBfxsxj vo1: kcList)
		{
			if(vo1.getNoCompany().intValue() == 1)kcNum1+= vo1.getKcNum();
			else kcNum+= vo1.getKcNum();
		}
		SysBfxsxj sumVo = new SysBfxsxj();// this.bfxsxjDao.sumBfxsxjPage1_total(xj);
		sumVo.setKhNm("合计：");
		sumVo.setKcNum(kcNum);
		sumVo.setKcNum1(kcNum1);
		list.add(sumVo);

		return p;
	}
	
	public List<SysBfxsxj> queryxjDetail(SysBfxsxj xj)
	{
		return this.bfxsxjDao.queryxjDetail(xj);
	}
}
