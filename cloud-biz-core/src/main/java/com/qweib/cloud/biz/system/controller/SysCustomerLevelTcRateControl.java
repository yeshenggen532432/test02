package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysAutoPriceService;
import com.qweib.cloud.biz.system.service.SysCustomerLevelTcRateService;
import com.qweib.cloud.core.domain.SysCustomerLevelTcRate;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class SysCustomerLevelTcRateControl extends GeneralControl{
	@Resource
	private SysCustomerLevelTcRateService customerLevelTcRateService;

	@RequestMapping("/customerLevelTcRatePage")
	public void customerLevelTcRatePage(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelTcRate LevelTcRate, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.customerLevelTcRateService.queryCustomerLevelTcRate(LevelTcRate, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户等级商品类别比例出错", e);
		}
	}

	@RequestMapping("/customerLevelTcRatewaretype")
	public String customerLevelTcRatewaretype(HttpServletRequest request, Model model,Integer relaId){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("relaId",relaId);
		SysCustomerLevelTcRate LevelTcRate = new SysCustomerLevelTcRate();
		LevelTcRate.setRelaId(relaId);
		String type = request.getParameter("type");
		model.addAttribute("type",type);
		return "/uglcw/tcfactor/customer_level_tc_rate_waretype";
	}

	@RequestMapping("/customerLevelTcRateList")
	public void customerLevelTcRateList(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelTcRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysCustomerLevelTcRate> rateList = this.customerLevelTcRateService.queryList(rate,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询客户等级商品分类价格折扣率出错", e);
		}
	}

	@RequestMapping("/updateCustomerLevelWareTypeTcRate")
	public void updateCustomerLevelWareTypeTcRate(HttpServletResponse response, HttpServletRequest request, Integer typeId, BigDecimal rate,String field) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysCustomerLevelTcRate  customerLevelTcRate =  customerLevelTcRateService.queryCustomerLevelByTypeIdAndLevelId(Integer.valueOf(relaId),typeId,info.getDatasource());
			if(customerLevelTcRate==null){
				customerLevelTcRate = new SysCustomerLevelTcRate();
				customerLevelTcRate.setWaretypeId(typeId);
				customerLevelTcRate.setRelaId(Integer.valueOf(relaId));
			}
			if(StrUtil.isNull(rate)){
				rate = new BigDecimal(0);
			}
			if("saleQtyTcRate".equals(field)){
				customerLevelTcRate.setSaleQtyTcRate(rate);
			}else if("saleProTcRate".equals(field)){
				customerLevelTcRate.setSaleProTcRate(rate);
			}else if("saleGroTcRate".equals(field)){
				customerLevelTcRate.setSaleGroTcRate(rate);
			}else if("saleQtyTc".equals(field)){
				customerLevelTcRate.setSaleQtyTc(rate);
			}else if("saleProTc".equals(field)){
				customerLevelTcRate.setSaleProTc(rate);
			}else if("saleGroTc".equals(field)){
				customerLevelTcRate.setSaleGroTc(rate);
			}
			int i = 0;
			if(StrUtil.isNull(customerLevelTcRate.getId())){
				i=this.customerLevelTcRateService.addCustomerLevelTcRate(customerLevelTcRate,info.getDatasource());
			}else{
				i=this.customerLevelTcRateService.updateCustomerLevelTcRate(customerLevelTcRate,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}

}
	



