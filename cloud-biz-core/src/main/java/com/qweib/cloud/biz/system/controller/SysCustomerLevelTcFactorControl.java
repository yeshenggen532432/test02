package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.SysAutoPriceService;
import com.qweib.cloud.biz.system.service.SysCustomerLevelTcFactorService;
import com.qweib.cloud.biz.system.service.SysWaresService;
import com.qweib.cloud.core.domain.SysCustomerLevelTcFactor;
import com.qweib.cloud.core.domain.SysLoginInfo;
import com.qweib.cloud.core.domain.SysWare;
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

/**
 * 客户等级-对应商品系数提成设置
 */
@Controller
@RequestMapping("/manager")
public class SysCustomerLevelTcFactorControl extends GeneralControl{
	@Resource
	private SysCustomerLevelTcFactorService customerLevelTcFactorService;
	@Resource
	private SysWaresService sysWaresService;
	@Resource
	private SysAutoPriceService autoPriceService;

	@RequestMapping("/customerLevelTcFactorPage")
	public void customerLevelTcFactorPage(HttpServletRequest request, HttpServletResponse response, SysCustomerLevelTcFactor LevelTcFactor, String dataTp,
								  Integer page, Integer rows){
		try{
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.customerLevelTcFactorService.queryCustomerLevelTcFactor(LevelTcFactor, page, rows, info.getDatasource());
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询等级价格出错", e);
		}
	}

	@RequestMapping("/saleTcFactorSetIndex")
	public String saleTcFactorSetIndex(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);
		return "/uglcw/tcfactor/sale_tc_factor_set_index";
	}

	@RequestMapping("/customerLevelTcFactorwaretype")
	public String customerLevelTcFactorwaretype(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);
		return "/uglcw/tcfactor/customer_level_list";
	}

	/**
	 * 进入客户等级-对应商品提成系数设置页
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/toCustomerLevelTcFactorSetWareTree")
	public String toCustomerLevelTcFactorSetWareTree(HttpServletRequest request, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		String relaId = request.getParameter("relaId");
		model.addAttribute("relaId",relaId);
		String type = request.getParameter("type");
		model.addAttribute("type",type);
		return "/uglcw/tcfactor/customer_level_set_tc_factor_ware_tree";
	}

	/**
	 * 加载已经设置的客户等级--对应商品提成系数数据
	 * @param wtype
	 * @param page
	 * @param rows
	 * @param ware
	 * @param response
	 * @param request
	 */
	@RequestMapping("/customerLevelTcFactorSetWarePage")
	public void customerLevelTcFactorSetWarePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request){
		SysLoginInfo info = this.getLoginInfo(request);
		ware.setWaretype(wtype);
		String relaId = request.getParameter("relaId");
		SysCustomerLevelTcFactor customerLevelTcFactor = new SysCustomerLevelTcFactor();
		List<SysCustomerLevelTcFactor> customerLevelTcFactorList = 	customerLevelTcFactorService.queryList(customerLevelTcFactor, info.getDatasource());
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
					if(customerLevelTcFactorList!=null&&customerLevelTcFactorList.size()>0){
						for(int j=0;j<customerLevelTcFactorList.size();j++){
							SysCustomerLevelTcFactor sclp = customerLevelTcFactorList.get(j);
							if(sysWare.getWareId().equals(sclp.getWareId())){
								if(!StrUtil.isNull(sclp.getSaleQtyTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleQtyTc())){
									sysWare.setTcAmt(sclp.getSaleQtyTc());
								}
								if(!StrUtil.isNull(sclp.getSaleGroTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleGroTc())){
									sysWare.setSaleGroTc(sclp.getSaleGroTc());
								}
								if(!StrUtil.isNull(sclp.getSaleProTc())&& !StrUtil.isNumberNullOrZero(sclp.getSaleProTc())){
									sysWare.setSaleProTc(sclp.getSaleProTc());
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
	 * 添加更新客户等级提成系数
	 * @param response
	 * @param request
	 * @param wareId
	 * @param price
	 * @param field
	 */
	@RequestMapping("/updateCustomerLevelWareTcFactor")
	public void updateCustomerLevelWareTcFactor(HttpServletResponse response, HttpServletRequest request, Integer wareId, Double price,String field) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  relaId = request.getParameter("relaId");
			SysCustomerLevelTcFactor  customerLevelTcFactor =  customerLevelTcFactorService.queryCustomerLevelTcFactorByWareIdAndLevelId(Integer.valueOf(relaId),wareId,info.getDatasource());
			if(customerLevelTcFactor==null){
				customerLevelTcFactor = new SysCustomerLevelTcFactor();
				customerLevelTcFactor.setWareId(wareId);
				customerLevelTcFactor.setLevelId(Integer.valueOf(relaId));
			}
			if("saleQtyTc".equals(field)){
				customerLevelTcFactor.setSaleQtyTc(new BigDecimal(price));
			}else if("saleProTc".equals(field)){
				customerLevelTcFactor.setSaleProTc(new BigDecimal(price));
			}else if("saleGroTc".equals(field)){
				customerLevelTcFactor.setSaleGroTc(new BigDecimal(price));
			}else if("saleQtyTcRate".equals(field)){
				customerLevelTcFactor.setSaleQtyTcRate(new BigDecimal(price));
			}else if("saleProTcRate".equals(field)){
				customerLevelTcFactor.setSaleProTcRate(new BigDecimal(price));
			}else if("saleGroTcRate".equals(field)){
				customerLevelTcFactor.setSaleGroTcRate(new BigDecimal(price));
			}
			int i = 0;
			if(StrUtil.isNull(customerLevelTcFactor.getId())){
				i=this.customerLevelTcFactorService.addCustomerLevelTcFactor(customerLevelTcFactor,info.getDatasource());
			}else{
				i=this.customerLevelTcFactorService.updateCustomerLevelTcFactor(customerLevelTcFactor,info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
			log.error("",e);
		}
	}
}