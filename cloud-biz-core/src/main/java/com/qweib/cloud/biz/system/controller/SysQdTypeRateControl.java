package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysQdTypeRateService;
import com.qweib.cloud.biz.system.service.SysQdtypeService;
import com.qweib.cloud.core.domain.SysQdTypeRate;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdtype;
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
public class SysQdTypeRateControl extends GeneralControl{
	@Resource
	private SysQdTypeRateService qdTypeRateService;
	@Resource
	private SysQdtypeService sysQdtypeService;

	@RequestMapping("/qdTypePage")
	public void qdTypePage(HttpServletRequest request, HttpServletResponse response, SysQdTypeRate levelRate, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.qdTypeRateService.queryQdTypeRate(levelRate, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户类型价格出错", e);
		}
	}

	@RequestMapping("/qdTypeRateList")
	public void qdTypeRateList(HttpServletRequest request, HttpServletResponse response, SysQdTypeRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);

			SysQdtype sysQdtype = sysQdtypeService.queryQdtypeById(rate.getRelaId(),info.getDatasource());
			List<SysQdTypeRate> rateList = this.qdTypeRateService.queryList(rate,info.getDatasource());
//			if(rateList!=null&&rateList.size()>0){
//				for(int i=0;i<rateList.size();i++){
//					SysQdTypeRate qdTypeRate = rateList.get(i);
//					if(StrUtil.isNumberNullOrZero(qdTypeRate.getRate())&&!StrUtil.isNumberNullOrZero(sysQdtype.getRate())){
//						qdTypeRate.setRate(sysQdtype.getRate());
//					}
//				}
//			}

			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询客户类型商品分类价格折扣率出错", e);
		}
	}

	/**
	 * 获取有设置二级商品类别折扣率的商品类别
	 * @param request
	 * @param response
	 * @param rate
	 */
	@RequestMapping("/querySubTypeRateList")
	public void querySubTypeRateList(HttpServletRequest request, HttpServletResponse response, SysQdTypeRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysQdTypeRate> rateList = this.qdTypeRateService.querySubTypeRateList(rate,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询客户类型商品分类价格折扣率出错", e);
		}
	}

	@RequestMapping("/customertyperatewaretype")
	public String customertyperatewaretype(HttpServletRequest request,Model model,Integer relaId){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("relaId",relaId);
		SysQdTypeRate typeRate = new SysQdTypeRate();
		SysQdtype sysQdtype = sysQdtypeService.queryQdtypeById(Integer.valueOf(relaId),info.getDatasource());
		List<SysQdTypeRate> rateList = qdTypeRateService.queryList(typeRate,info.getDatasource());
		model.addAttribute("rateList",rateList);
		model.addAttribute("sysQdtype",sysQdtype);
		return "/uglcw/khgxsx/customer_type_rate_waretype";
	}

	@RequestMapping("/updateCustomerTypeWareTypeRate")
	public void updateCustomerTypeWareTypeRate(HttpServletResponse response, HttpServletRequest request, Integer typeId, BigDecimal rate) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysQdTypeRate  qdTypeRate =  qdTypeRateService.queryQdTypeRateByTypeIdAndRelaId(Integer.valueOf(relaId),typeId,info.getDatasource());
			if(qdTypeRate==null){
				qdTypeRate = new SysQdTypeRate();
				qdTypeRate.setWaretypeId(typeId);
				qdTypeRate.setRelaId(Integer.valueOf(relaId));
			}
			if(StrUtil.isNull(rate)){
				rate = new BigDecimal(0);
			}
			qdTypeRate.setRate(rate);
			int i = 0;
			if(StrUtil.isNull(qdTypeRate.getId())){
				i=this.qdTypeRateService.addQdTypeRate(qdTypeRate,info.getDatasource());
			}else{
				i=this.qdTypeRateService.updateQdTypeRate(qdTypeRate,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}

}
	



