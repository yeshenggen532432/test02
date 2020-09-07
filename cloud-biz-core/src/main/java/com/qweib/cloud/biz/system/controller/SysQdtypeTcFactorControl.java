package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysAutoPriceService;
import com.qweib.cloud.biz.system.service.SysQdTypeTcFactorService;
import com.qweib.cloud.biz.system.service.SysQdtypeService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.core.domain.*;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import net.sf.json.JSONArray;
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
public class SysQdtypeTcFactorControl extends GeneralControl{
	@Resource
	private SysQdTypeTcFactorService qdTypeTcFactorService;
	@Resource
	private SysAutoPriceService autoPriceService;
	@Resource
	private SysWaresService sysWaresService;

	@RequestMapping("/qdTypeTcFactorwaretype")
	public String qdTypeTcFactorwaretype(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);
		return "/uglcw/tcfactor/qdTypeTcFactorwaretype";
	}

	/**
	 * 客户类别提成设置列表
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("customerTypeTcFactorList")
	public String customerTypeTcFactorList(Model model, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
		} catch (Exception e) {
			log.error("",e);
		}
		return "/uglcw/tcfactor/customer_type_list";
	}


	/**
	 * 进入客户类别-对应商品提成系数设置页
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/toCustomerTypeTcFactorSetWareTree")
	public String toCustomerTypeTcFactorSetWareTree(HttpServletRequest request, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		String relaId = request.getParameter("relaId");
		model.addAttribute("relaId",relaId);
		String type = request.getParameter("type");
		model.addAttribute("type",type);
		return "/uglcw/tcfactor/customer_type_set_tc_factor_ware_tree";
	}

	/**
	 * 加载已经设置的客户类别--对应商品提成系数数据
	 * @param wtype
	 * @param page
	 * @param rows
	 * @param ware
	 * @param response
	 * @param request
	 */
	@RequestMapping("/customerTypeTcFactorSetWarePage")
	public void customerTypeTcFactorSetWarePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request){
		SysLoginInfo info = this.getLoginInfo(request);
		ware.setWaretype(wtype);
		String relaId = request.getParameter("relaId");
		SysQdTypeTcFactor qdTypeTcFactor = new SysQdTypeTcFactor();
		qdTypeTcFactor.setRelaId(Integer.valueOf(relaId));
		List<SysQdTypeTcFactor> qdTypeTcFactorList = 	qdTypeTcFactorService.queryList(qdTypeTcFactor, info.getDatasource());
		try {
			ware.setWaretype(wtype);
			Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());
			if(p.getRows()!=null&&p.getRows().size()>0){

				autoPriceService.dealAutoFiledWarePrice(p.getRows(),info.getDatasource());

				for(int i=0;i<p.getRows().size();i++){
					SysWare sysWare = (SysWare)p.getRows().get(i);
					if(!StrUtil.isNumberNullOrZero(sysWare.getTcAmt())){
						sysWare.setTempTcAmt(sysWare.getTcAmt());
					}
					if(!StrUtil.isNumberNullOrZero(sysWare.getSaleGroTc())){
						sysWare.setTempSaleGroTc(sysWare.getSaleGroTc());
					}
					if(!StrUtil.isNumberNullOrZero(sysWare.getSaleProTc())){
						sysWare.setTempSaleProTc(sysWare.getSaleProTc());
					}
					sysWare.setTcAmt(null);
					sysWare.setSaleGroTc(null);
					sysWare.setSaleProTc(null);
					if(qdTypeTcFactorList!=null&&qdTypeTcFactorList.size()>0){
						for(int j=0;j<qdTypeTcFactorList.size();j++){
							SysQdTypeTcFactor sclp = qdTypeTcFactorList.get(j);
							if(sysWare.getWareId().equals(sclp.getWareId())){
								if(!StrUtil.isNull(sclp.getSaleQtyTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleQtyTc())){
									sysWare.setTcAmt(sclp.getSaleQtyTc());
								}
								if(!StrUtil.isNull(sclp.getSaleGroTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleGroTc())){
									sysWare.setSaleGroTc(sclp.getSaleGroTc());
								}
								if(!StrUtil.isNull(sclp.getSaleProTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleProTc())){
									sysWare.setSaleGroTc(sclp.getSaleProTc());
								}
								if(!StrUtil.isNull(sclp.getSaleQtyTcRate())&& !StrUtil.isNumberNullOrZero(sclp.getSaleQtyTcRate())){
									sysWare.setSaleQtyTcRate(sclp.getSaleQtyTcRate());
								}
								if(!StrUtil.isNull(sclp.getSaleGroTcRate())&& !StrUtil.isNumberNullOrZero(sclp.getSaleGroTcRate())){
									sysWare.setSaleGroTcRate(sclp.getSaleGroTcRate());
								}
								if(!StrUtil.isNull(sclp.getSaleProTcRate())&& !StrUtil.isNumberNullOrZero(sclp.getSaleProTcRate())){
									sysWare.setSaleProTcRate(sclp.getSaleProTcRate());
								}
							}
						}
					}
				}
			}

			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("",e);
		}
	}


	/**
	 * 添加更新客户类别提成系数
	 * @param response
	 * @param request
	 * @param wareId
	 * @param price
	 * @param field
	 */
	@RequestMapping("/updateCustomerTypeWareTcFactor")
	public void updateCustomerTypeWareTcFactor(HttpServletResponse response, HttpServletRequest request, Integer wareId, Double price,String field) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysQdTypeTcFactor  qdTypeTcFactor =  qdTypeTcFactorService.queryQdTypeTcFactorByWareIdAndRelaId(Integer.valueOf(relaId),wareId,info.getDatasource());
			if(qdTypeTcFactor==null){
				qdTypeTcFactor = new SysQdTypeTcFactor();
				qdTypeTcFactor.setWareId(wareId);
				qdTypeTcFactor.setRelaId(Integer.valueOf(relaId));
			}
			if("saleQtyTc".equals(field)){
				qdTypeTcFactor.setSaleQtyTc(new BigDecimal(price));
			}else if("saleProTc".equals(field)){
				qdTypeTcFactor.setSaleProTc(new BigDecimal(price));
			}else if("saleGroTc".equals(field)){
				qdTypeTcFactor.setSaleGroTc(new BigDecimal(price));
			}else if("saleQtyTcRate".equals(field)){
				qdTypeTcFactor.setSaleQtyTcRate(new BigDecimal(price));
			}else if("saleProTcRate".equals(field)){
				qdTypeTcFactor.setSaleProTcRate(new BigDecimal(price));
			}else if("saleGroTcRate".equals(field)){
				qdTypeTcFactor.setSaleGroTcRate(new BigDecimal(price));
			}
			int i = 0;
			if(StrUtil.isNull(qdTypeTcFactor.getId())){
				i=this.qdTypeTcFactorService.addQdTypeTcFactor(qdTypeTcFactor,info.getDatasource());
			}else{
				i=this.qdTypeTcFactorService.updateQdTypeTcFactor(qdTypeTcFactor,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}

}
