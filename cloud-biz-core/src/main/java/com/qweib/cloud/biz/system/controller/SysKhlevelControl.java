package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.biz.system.service.*;
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
public class SysKhlevelControl extends GeneralControl{
	@Resource
	private SysKhlevelService khlevelService;
	@Resource
	private SysQdtypeService qdtypeService;
	
	@Resource
	private SysCustomerLevelPriceService customerLevelPriceService;
	@Resource
	private SysWaresService sysWaresService;
	@Resource
	private SysCustomerService customerService;
	
	/**
	 * 
	 *摘要：
	 *@说明：客户等级页面
	 *@创建：作者:llp		创建时间：2016-7-25
	 *@修改历史：
	 *		[序号](llp	2016-7-25)<修改说明>
	 */
	@RequestMapping("queryKhlevel")
	public String queryKhlevel(Model model, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysQdtype> list = this.qdtypeService.queryQdtypels(info.getDatasource());
			model.addAttribute("list", list);
		} catch (Exception e) {
			log.error("获取渠道类型出错");
		}
		return "/uglcw/khgxsx/khlevel";
	}
	/**
	 * 
	 *摘要：
	 *@说明：分页查询客户等级
	 *@创建：作者:llp		创建时间：2016-7-25
	 *@修改历史：
	 *		[序号](llp	2016-7-25)<修改说明>
	 */
	@RequestMapping("toKhlevelPage")
	public void toKhlevelPage(SysKhlevel khlevel, int page, int rows, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			Page p = this.khlevelService.queryKhlevelPage(khlevel, info.getDatasource(), page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("分页查询客户等级出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：操作客户等级
	 *@创建：作者:llp		创建时间：2016-7-25
	 *@修改历史：
	 *		[序号](llp	2016-7-25)<修改说明>
	 */
	@RequestMapping("operKhlevel")
	public void operKhlevel(SysKhlevel khlevel, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			if(!StrUtil.isNull(khlevel)){
				if(null!=khlevel.getId()&&khlevel.getId()>0){
					this.khlevelService.updatekhlevel(khlevel, info.getDatasource());
					this.sendHtmlResponse(response, "2");
				}else{
					this.khlevelService.addkhlevel(khlevel, info.getDatasource());
					this.sendHtmlResponse(response, "1");
				}
			  }
		} catch (Exception e) {
			log.error("操作客户等级出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：获取客户等级
	 *@创建：作者:llp		创建时间：2016-7-25
	 *@修改历史：
	 *		[序号](llp	2016-7-25)<修改说明>
	 */
	@RequestMapping("getKhlevel")
	public void getKhlevel(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			SysKhlevel khlevel=this.khlevelService.querykhlevelById(id, info.getDatasource());
			JSONObject json = new JSONObject(khlevel);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取客户等级出错：", e);
		}
	}
	/**
	 * 
	 *摘要：
	 *@说明：删除客户等级
	 *@创建：作者:llp		创建时间：2016-7-25
	 *@修改历史：
	 *		[序号](llp	2016-7-25)<修改说明>
	 */
	@RequestMapping("deletekhlevelById")
	public void deletekhlevelById(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			int count =this.customerService.queryKhleveId(id,info.getDatasource());
			if(count>0){
				this.sendHtmlResponse(response, "2");
				return;
			}
			this.khlevelService.deletekhlevelById(id, info.getDatasource());
			this.sendHtmlResponse(response, "1");
		} catch (Exception e) {
			log.error("操作客户等级出错：", e);
			this.sendHtmlResponse(response, "-1");
		}
	}
	
	@RequestMapping("/levelpricewaretype")
	public String customerwaretype(HttpServletRequest request, Model model, String dataTp){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("datasource", info.getDatasource());
		model.addAttribute("dataTp", dataTp);

		//新ui：tree和page放同一页面
		List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
		JSONArray levelListJson = JSONArray.fromObject(levelList);
		model.addAttribute("levelTitleJson", levelListJson.toString());
		List<SysCustomerLevelPrice> levelPriceList = 	customerLevelPriceService.queryList(null, info.getDatasource());
		JSONArray levelPriceJson = JSONArray.fromObject(levelPriceList);
		model.addAttribute("levelPriceJson", levelPriceJson.toString());
		return "/uglcw/khgxsx/levelpricewaretype";
	}
	@RequestMapping("/levelpricewarepage")
	public String customerwarepage(HttpServletRequest request, Model model, Integer wtype, String dataTp, Integer levelId){
		SysLoginInfo info = this.getLoginInfo(request);
		model.addAttribute("wtype", wtype);
		model.addAttribute("tpNm", info.getTpNm());
		List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
		JSONArray levelListJson = JSONArray.fromObject(levelList);
		model.addAttribute("levelTitleJson", levelListJson.toString());
		
		List<SysCustomerLevelPrice> levelPriceList = 	customerLevelPriceService.queryList(null, info.getDatasource());
		JSONArray levelPriceJson = JSONArray.fromObject(levelPriceList);
		
		model.addAttribute("levelPriceJson", levelPriceJson.toString());
		
		return "/uglcw/khgxsx/levelpricewarepage";
	}

	@RequestMapping("/levelpriceoneware")
	public String levelpriceoneware(HttpServletRequest request, Model model, Integer wareId){
		SysLoginInfo info = this.getLoginInfo(request);
		List<SysKhlevel> levelList = khlevelService.queryList(null, info.getDatasource());
		model.addAttribute("levelList", levelList);
		SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
		if(!StrUtil.isNull(wareId)){
			levelPrice.setWareId(wareId);
		}else{
			return null;
		}
		List<SysCustomerLevelPrice> levelPriceList = 	customerLevelPriceService.queryList(levelPrice, info.getDatasource());
		model.addAttribute("wareId",wareId);
		model.addAttribute("levelPriceList", levelPriceList);
		return "/uglcw/khgxsx/levelpriceoneware";
	}
	
	@RequestMapping("/updateLevelPrice")
	public void updateLevelPrice(HttpServletResponse response, HttpServletRequest request, SysCustomerLevelPrice model){
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			int i = 0;
			if(model!=null){
				if(StrUtil.isNull(model.getId())){
				i=this.customerLevelPriceService.addCustomerLevelPrice(model, info.getDatasource());
				}else{
				i=this.customerLevelPriceService.updateCustomerLevelPrice(model, info.getDatasource());
				}
			}
			 this.sendJsonResponse(response, ""+i); 
		} catch (Exception e) {
		}
	}


	@RequestMapping("customerLevelList")
	public String customerLevelList(Model model, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			List<SysQdtype> list = this.qdtypeService.queryQdtypels(info.getDatasource());
			model.addAttribute("list", list);
		} catch (Exception e) {
			log.error("",e);
		}
		return "/uglcw/khgxsx/customer_level_list";
	}


	@RequestMapping("/getCustomerLevelDatas")
	public void getCustomerLevelDatas(HttpServletResponse response, HttpServletRequest request) {
		try {
			SysLoginInfo info = getInfo(request);
			SysQdKhLs qdKhLs = new SysQdKhLs();
			List<SysKhlevel> list = this.khlevelService.queryList(null,info.getDatasource());
			if(list!=null&&list.size()>0){
				for(int i=0;i<list.size();i++){
					SysKhlevel level = list.get(i);
					level.setKhdjNm(level.getQdtpNm()+"_"+level.getKhdjNm());
				}
			}
			qdKhLs.setList2(list);
			JSONObject json = new JSONObject(qdKhLs);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取客户等级", e);
		}

	}

	@RequestMapping("/toCustomerLevelSetWareTree")
	public String toCustomerLevelSetWareTree(HttpServletRequest request, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		String levelId = request.getParameter("levelId");
		model.addAttribute("levelId",levelId);

		return "/uglcw/khgxsx/customer_level_set_ware_tree";
	}

	@RequestMapping("/toCustomerLevelSetWarePage")
	public String toCustomerLevelSetWarePage(HttpServletRequest request, Integer wtype, Model model){
		SysLoginInfo info = this.getLoginInfo(request);
		String levelId = request.getParameter("levelId");
		model.addAttribute("levelId",levelId);
		model.addAttribute("wtype",wtype);
		String isType = request.getParameter("isType");
		if(StrUtil.isNull(isType)){
			model.addAttribute("isType", "");
		}else{
			model.addAttribute("isType", isType);
		}
		return "/uglcw/khgxsx/customer_level_set_ware_page";
	}

	@RequestMapping("/customerLevelSetWarePage")
	public void customerLevelSetWarePage(Integer wtype, int page, int rows, SysWare ware, HttpServletResponse response, HttpServletRequest request){
		SysLoginInfo info = this.getLoginInfo(request);
		ware.setWaretype(wtype);
		String levelId = request.getParameter("levelId");
		SysCustomerLevelPrice levelPrice = new SysCustomerLevelPrice();
		levelPrice.setLevelId(Integer.valueOf(levelId));
		List<SysCustomerLevelPrice> levelPriceList = 	customerLevelPriceService.queryList(levelPrice, info.getDatasource());
		try {
			ware.setWaretype(wtype);
			Page p = this.sysWaresService.queryCompanyStockWare(ware, page, rows, info.getDatasource());

			if(p.getRows()!=null&&p.getRows().size()>0){
				for(int i=0;i<p.getRows().size();i++){
					SysWare sysWare = (SysWare)p.getRows().get(i);
					sysWare.setWareDj(null);

					sysWare.setCxPrice(null);
					sysWare.setFxPrice(null);
					sysWare.setSunitPrice(null);
					sysWare.setMinCxPrice(null);
					sysWare.setMinFxPrice(null);

					sysWare.setRate(null);
					if(!StrUtil.isNumberNullOrZero(sysWare.getLsPrice())){
						sysWare.setTempWareDj(sysWare.getLsPrice());
					}
					if(!StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())){
						sysWare.setTempSunitPrice(new BigDecimal(sysWare.getMinLsPrice()));
					}

//					if(StrUtil.isNumberNullOrZero(sysWare.getTempWareDj())){
//						BigDecimal rate = new BigDecimal(1);
//						if(!StrUtil.isNumberNullOrZero(sysWare.getAddRate())){
//							rate = sysWare.getAddRate().divide(new BigDecimal(100));
//							if(StrUtil.isNumberNullOrZero(sysWare.getLsPrice())&&!StrUtil.isNumberNullOrZero(sysWare.getInPrice())){
//								sysWare.setTempWareDj(sysWare.getInPrice()*(rate.doubleValue()));
//							}
//							if(StrUtil.isNumberNullOrZero(sysWare.getMinLsPrice())&&!StrUtil.isNumberNullOrZero(sysWare.getMinInPrice())){
//								sysWare.setTempSunitPrice(new BigDecimal(sysWare.getMinInPrice()*(rate.doubleValue())));
//							}
//						}
//					}

					sysWare.setLsPrice(null);
					sysWare.setMinLsPrice(null);
					if(levelPriceList!=null&&levelPriceList.size()>0){
						for(int j=0;j<levelPriceList.size();j++){
							SysCustomerLevelPrice sclp = levelPriceList.get(j);
							if(sysWare.getWareId().equals(sclp.getWareId())){
								if(!StrUtil.isNumberNullOrZero(sclp.getPrice())){
									sysWare.setWareDj(Double.valueOf(sclp.getPrice()));
								}
								sysWare.setLsPrice(sclp.getLsPrice());
								sysWare.setCxPrice(sclp.getCxPrice());
								sysWare.setFxPrice(sclp.getFxPrice());
								if(!StrUtil.isNumberNullOrZero(sclp.getSunitPrice())){
									sysWare.setSunitPrice(new BigDecimal(sclp.getSunitPrice()));
								}
								sysWare.setMinCxPrice(sclp.getMinCxPrice());
								sysWare.setMinFxPrice(sclp.getMinFxPrice());
								sysWare.setMinLsPrice(sclp.getMinLsPrice());
								sysWare.setRate(sclp.getRate());
								break;
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


	@RequestMapping("/updateCustomerLevelWarePrice")
	public void updateCustomerLevelWarePrice(HttpServletResponse response, HttpServletRequest request, Integer wareId, Double price,String field) {
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			String  levelId = request.getParameter("levelId");
			if(StrUtil.isNull(price)){
				price = 0.0;
			}
			SysCustomerLevelPrice  levelPrice =  customerLevelPriceService.queryCustomerLevelByWareIdAndLevelId(Integer.valueOf(levelId),wareId,info.getDatasource());
			if(levelPrice==null){
				levelPrice = new SysCustomerLevelPrice();
				levelPrice.setLevelId(Integer.valueOf(levelId));
				levelPrice.setWareId(wareId);
			}
			if(StrUtil.isNull(levelPrice.getLevelId())||StrUtil.isNull(levelPrice.getWareId())){
                this.sendJsonResponse(response, "1");
                return;
            }
			if("wareDj".equals(field)){
				levelPrice.setPrice(price+"");
			}else if("lsPrice".equals(field)){
				levelPrice.setLsPrice(price);
			}else if("fxPrice".equals(field)){
				levelPrice.setFxPrice(price);
			}else if("cxPrice".equals(field)){
				levelPrice.setCxPrice(price);
			}else if("sunitPrice".equals(field)){
				levelPrice.setSunitPrice(price);
			}else if("minLsPrice".equals(field)){
				levelPrice.setMinLsPrice(price);
			}else if("minFxPrice".equals(field)){
				levelPrice.setMinFxPrice(price);
			}else if("minCxPrice".equals(field)){
				levelPrice.setMinCxPrice(price);
			}else if("rate".equals(field)){
				levelPrice.setRate(new BigDecimal(price));
			}
			int i = 0;
			if(StrUtil.isNull(levelPrice.getId())){
				i=this.customerLevelPriceService.addCustomerLevelPrice(levelPrice, info.getDatasource());
			}else{
				i=this.customerLevelPriceService.updateCustomerLevelPrice(levelPrice, info.getDatasource());
			}
			this.sendJsonResponse(response, "1");
		} catch (Exception e) {
		   log.error("",e);
		}
	}

	@RequestMapping("toCustomerLevelPage")
	public String toCustomerLevelPage(Model model, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			String khdjNm = request.getParameter("khdjNm");
			model.addAttribute("khdjNm",khdjNm);
		} catch (Exception e) {
			log.error("",e);
		}
		return "/uglcw/khgxsx/customer_level_page";
	}


}
