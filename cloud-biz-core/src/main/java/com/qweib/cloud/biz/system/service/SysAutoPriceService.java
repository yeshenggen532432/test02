package com.qweib.cloud.biz.system.service;

import com.qweib.cloud.core.domain.SysAutoField;
import com.qweib.cloud.core.domain.SysWare;
import com.qweib.cloud.repository.SysAutoPriceDao;
import com.qweib.cloud.core.domain.SysAutoPrice;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SysAutoPriceService {
	@Resource
	private SysAutoPriceDao autoPriceDao;
	
	
	public Page queryAutoPrice(SysAutoPrice autoPrice,int page,int rows,String database){
		return autoPriceDao.queryAutoPrice(autoPrice, page, rows, database);
	}
	
    public List<SysAutoPrice> queryList(SysAutoPrice autoPrice, String database){
    	return autoPriceDao.queryList(autoPrice, database,"");
    }

	public int addAutoPrice(SysAutoPrice autoPrice,String database){
		return autoPriceDao.addAutoPrice(autoPrice, database);
	}
	
	public SysAutoPrice queryAutoPriceById(Integer autoPriceId,String database){
		
		return autoPriceDao.queryAutoPriceById(autoPriceId, database);
	}

	public int updateAutoPrice(SysAutoPrice autoPrice,String database){
		return autoPriceDao.updateAutoPrice(autoPrice, database);
	}
	
	public int deleteAutoPrice(Integer id,String database){
		return autoPriceDao.deleteAutoPrice(id, database);
	}
	
	public void deleteCustomerLevelAll(String database){
		autoPriceDao.deleteAutoPriceAll(database);
		
	}

	public void dealAutoFiledWarePrice(List<SysWare> wareList, String database){
		String wareIds = "";
		Map<Integer,SysWare> mapList = new HashMap<Integer,SysWare>();
		if(wareList!=null&&wareList.size()>0){
			for(int i=0;i<wareList.size();i++){
				SysWare sysWare = wareList.get(i);
				sysWare.setTcAmt(new BigDecimal(0));
				sysWare.setSaleProTc(new BigDecimal(0));
				sysWare.setSaleGroTc(new BigDecimal(0));
				if(wareIds!=""){
					wareIds+=",";
				}
				wareIds+=sysWare.getWareId();
				mapList.put(sysWare.getWareId(),sysWare);
			}
		}
		List<SysAutoPrice> autoPriceList =	autoPriceDao.queryList(null, database,wareIds);
		if(autoPriceList!=null&&autoPriceList.size()>0){
			for(int i=0;i<autoPriceList.size();i++){
				SysAutoPrice autoPrice = autoPriceList.get(i);
				Integer wareId = autoPrice.getWareId();
				String price =	autoPrice.getPrice();
				if(mapList.containsKey(wareId)){
					if("YWTC00".equals(autoPrice.getAutoCode())){
						SysWare sysWare = mapList.get(wareId);
						if(!StrUtil.isNull(price)&&price!="null"&&StrUtil.isNumeric(price)){
							sysWare.setTcAmt(new BigDecimal(price));
						}
					}else if("YWTC01".equals(autoPrice.getAutoCode())){
						SysWare sysWare = mapList.get(wareId);
						if(!StrUtil.isNull(price)&&price!="null"&&StrUtil.isNumeric(price)){
							sysWare.setSaleProTc(new BigDecimal(price));
						}
					} else if("YWTC02".equals(autoPrice.getAutoCode())){
						SysWare sysWare = mapList.get(wareId);
						if(!StrUtil.isNull(price)&&price!="null"&&StrUtil.isNumeric(price)){
							sysWare.setSaleGroTc(new BigDecimal(price));
						}
					}
				}

			}
		}



	}

}
