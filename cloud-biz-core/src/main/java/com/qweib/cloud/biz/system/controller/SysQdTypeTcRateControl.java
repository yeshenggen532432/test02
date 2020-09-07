package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysQdTypeTcRateService;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysQdTypeTcRate;
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
public class SysQdTypeTcRateControl extends GeneralControl{
	@Resource
	private SysQdTypeTcRateService qdTypeTcRateService;

	@RequestMapping("/qdTypeTcRatePage")
	public void qdTypeTcRatePage(HttpServletRequest request, HttpServletResponse response, SysQdTypeTcRate levelRate, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.qdTypeTcRateService.queryQdTypeTcRate(levelRate, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询客户类型价格出错", e);
		}
	}

	/**
	 * 客户等级商品类别提成系数数据加载
	 * @param request
	 * @param response
	 * @param rate
	 */
	@RequestMapping("/qdTypeTcRateList")
	public void qdTypeTcRateList(HttpServletRequest request, HttpServletResponse response, SysQdTypeTcRate rate){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysQdTypeTcRate> rateList = this.qdTypeTcRateService.queryList(rate,info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("state", true);
			json.put("rows", rateList);
			this.sendJsonResponse(response, json.toString());
		}catch (Exception e) {
			log.error("查询客户类型商品分类价格折扣率出错", e);
		}
	}


	/**
	 * 进入客户类别商品类别--商品类别提成系数页
	 * @param request
	 * @param model
	 * @param relaId
	 * @return
	 */
	@RequestMapping("/customerTypeTcRatewaretype")
	public String customerTypeTcRatewaretype(HttpServletRequest request,Model model,Integer relaId){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("relaId",relaId);
		String type = request.getParameter("type");
		model.addAttribute("type",type);
		return "/uglcw/tcfactor/customer_type_tc_rate_waretype";
	}

	/**
	 * 新增或者更新客户类别对应商品类别提成系数
	 * @param response
	 * @param request
	 * @param typeId
	 * @param rate
	 */
	@RequestMapping("/updateCustomerTypeWareTypeTcRate")
	public void updateCustomerTypeWareTypeTcRate(HttpServletResponse response, HttpServletRequest request, Integer typeId, BigDecimal rate,String field) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysQdTypeTcRate  qdTypeTcRate =  qdTypeTcRateService.queryQdTypeTcRateByTypeIdAndRelaId(Integer.valueOf(relaId),typeId,info.getDatasource());
			if(qdTypeTcRate==null){
				qdTypeTcRate = new SysQdTypeTcRate();
				qdTypeTcRate.setWaretypeId(typeId);
				qdTypeTcRate.setRelaId(Integer.valueOf(relaId));
			}
			if(StrUtil.isNull(rate)){
				rate = new BigDecimal(0);
			}
			if("saleQtyTcRate".equals(field)){
				qdTypeTcRate.setSaleQtyTcRate(rate);
			}else if("saleProTcRate".equals(field)){
				qdTypeTcRate.setSaleProTcRate(rate);
			}else if("saleGroTcRate".equals(field)){
				qdTypeTcRate.setSaleGroTcRate(rate);
			}else if("saleQtyTc".equals(field)){
				qdTypeTcRate.setSaleQtyTc(rate);
			}else if("saleProTc".equals(field)){
				qdTypeTcRate.setSaleProTc(rate);
			}else if("saleGroTc".equals(field)){
				qdTypeTcRate.setSaleGroTc(rate);
			}
			int i = 0;
			if(StrUtil.isNull(qdTypeTcRate.getId())){
				i=this.qdTypeTcRateService.addQdTypeTcRate(qdTypeTcRate,info.getDatasource());
			}else{
				i=this.qdTypeTcRateService.updateQdTypeTcRate(qdTypeTcRate,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}

}
	



