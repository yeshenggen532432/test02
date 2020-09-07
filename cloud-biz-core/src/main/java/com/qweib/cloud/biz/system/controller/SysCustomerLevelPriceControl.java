package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.SysCustomerLevelPriceService;
import com.qweib.cloud.core.domain.SysCustomerLevelPrice;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.Page;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manager")
public class SysCustomerLevelPriceControl extends GeneralControl{
	@Resource
	private SysCustomerLevelPriceService customerLevelPriceService;
	

	@RequestMapping("/customerLevelPage")
	public void customerLevelPage(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelPrice levelPrice, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.customerLevelPriceService.queryCustomerLevelPrice(levelPrice, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询等级价格出错", e);
		}
	}
	
	


	
	@RequestMapping("/customerlevelpricewaretype")
	public String customerwaretype(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);
		return "/uglcw/customer/customerwaretype";
	}
//	
//	@RequestMapping("/updateSysCustomerLevelPrice")
//	public void updateSysCustomerLevelPriceSalePrice(HttpServletResponse response,HttpServletRequest request,SysCustomerLevelPriceSalePrice model){
//		SysLoginInfo info = this.getLoginInfo(request);
//		try {
//			 int i = this.customerService.updateSysCustomerLevelPriceSalePrice(info.getDatasource(), model);
//			 this.sendJsonResponse(response, ""+i); 
//		} catch (Exception e) {
//		}
//	}
//
//	
//	@RequestMapping("/updateSysCustomerLevelPrice")
//	public void updateSysCustomerLevelPricePrice(HttpServletResponse response,HttpServletRequest request,SysCustomerLevelPrice model){
//		SysLoginInfo info = this.getLoginInfo(request);
//		try {
//			 int i = this.customerLevelPriceService.updateSysCustomerLevelPrice(info.getDatasource(), model);
//			 this.sendJsonResponse(response, ""+i); 
//		} catch (Exception e) {
//		}
//	}
}
	



