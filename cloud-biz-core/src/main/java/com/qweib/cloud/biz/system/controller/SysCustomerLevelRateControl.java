package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysCustomerLevelRateService;
import com.qweib.cloud.core.domain.SysCustomerLevelRate;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdTypeRate;
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
public class SysCustomerLevelRateControl extends GeneralControl{
	@Resource
	private SysCustomerLevelRateService customerLevelRateService;

	@RequestMapping("/customerLevelRatePage")
	public void customerLevelRatePage(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelRate levelRate, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.customerLevelRateService.queryCustomerLevelRate(levelRate, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户等级商品类别比例出错", e);
		}
	}

	@RequestMapping("/customerlevelratewaretype")
	public String customerlevelratewaretype(HttpServletRequest request, Model model,Integer relaId){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("relaId",relaId);
		SysCustomerLevelRate levelRate = new SysCustomerLevelRate();
		levelRate.setRelaId(relaId);
		List<SysCustomerLevelRate> rateList = customerLevelRateService.queryList(levelRate,info.getDatasource());
		model.addAttribute("rateList",rateList);
		return "/uglcw/khgxsx/customer_level_rate_waretype";
	}

	@RequestMapping("/customerLevelRateList")
	public void customerLevelRateList(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysCustomerLevelRate> rateList = this.customerLevelRateService.queryList(rate,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询客户等级商品分类价格折扣率出错", e);
		}
	}

	/**
	 * 获取有设置二级商品类别折扣率的商品类别
	 * @param request
	 * @param response
	 * @param rate
	 */
	@RequestMapping("/queryLevelSubTypeRateList")
	public void queryLevelSubTypeRateList(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysCustomerLevelRate> rateList = this.customerLevelRateService.querySubTypeRateList(rate,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("获取有设置二级商品类别折扣率的商品类别出错", e);
		}
	}

	@RequestMapping("/updateCustomerLevelWareTypeRate")
	public void updateCustomerLevelWareTypeRate(HttpServletResponse response, HttpServletRequest request, Integer typeId, BigDecimal rate) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysCustomerLevelRate  customerLevelRate =  customerLevelRateService.queryCustomerLevelByTypeIdAndLevelId(Integer.valueOf(relaId),typeId,info.getDatasource());
			if(customerLevelRate==null){
				customerLevelRate = new SysCustomerLevelRate();
				customerLevelRate.setWaretypeId(typeId);
				customerLevelRate.setRelaId(Integer.valueOf(relaId));
			}
			if(StrUtil.isNull(rate)){
				rate = new BigDecimal(0);
			}
			customerLevelRate.setRate(rate);
			int i = 0;
			if(StrUtil.isNull(customerLevelRate.getId())){
				i=this.customerLevelRateService.addCustomerLevelRate(customerLevelRate,info.getDatasource());
			}else{
				i=this.customerLevelRateService.updateCustomerLevelRate(customerLevelRate,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}

}
	



