package com.qweib.cloud.biz.system.controller;

import com.qweib.cloud.biz.system.service.BscOrderlsService;
import com.qweib.cloud.biz.system.service.SysBforderMsgService;
import com.qweib.cloud.biz.system.service.ws.BscOrderlsWebService;
import com.qweib.cloud.core.domain.*;

import com.qweib.cloud.biz.common.GeneralControl;
import com.qweib.cloud.utils.DateTimeUtil;
import com.qweib.cloud.utils.Page;
import com.qweib.cloud.utils.StrUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/manager")
public class BscOrderlsControl extends GeneralControl{
	@Resource
	private BscOrderlsService orderlsService;
	@Resource
	private BscOrderlsWebService orderlsWebService;
	@Resource
	private SysBforderMsgService orderMsgService;
	
	/**
	 *说明：到订单页面
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("/queryOrderlsPage1")
	public String queryOrderlsPage1(HttpServletRequest request, Model model){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			model.addAttribute("database", info.getDatasource());
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			model.addAttribute("sdate", format.format(calendar.getTime()));
			model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "/uglcw/orderls/orderls";
	}
	/**
	 *说明：分页查询订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("/orderlsPage1")
	public void orderlsPage1(HttpServletRequest request, HttpServletResponse response, BscOrderls order, Integer page, Integer rows){
		try{
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			if(StrUtil.isNull(order.getSdate())){
				order.setSdate(format.format(calendar.getTime()));
			}
			if(StrUtil.isNull(order.getEdate())){
				order.setEdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			Page p = this.orderlsService.queryOrderlsPage1(order, page, rows);
			List<BscOrderls> vlist=(List<BscOrderls>)p.getRows();
			for (BscOrderls orderls : vlist) {
				orderls.setList(this.orderlsWebService.queryOrderlsDetail(order.getDatabase(), orderls.getId()));
			}
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询订单出错", e);
		}
	}
	/**
	 *说明：到结算订单页面
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("/queryOrderlsBbPage1")
	public String queryOrderlsBbPage1(HttpServletRequest request, Model model){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			model.addAttribute("database", info.getDatasource());
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			model.addAttribute("sdate", format.format(calendar.getTime()));
			model.addAttribute("edate", DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "/uglcw/orderls/orderlsbb";
	}
	/**
	 *说明：分页查询结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("/orderlsBbPage1")
	public void orderlsBbPage1(HttpServletRequest request, HttpServletResponse response, BscOrderlsBb orderlsBb, Integer page, Integer rows){
		try{
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			if(StrUtil.isNull(orderlsBb.getSdate())){
				orderlsBb.setSdate(format.format(calendar.getTime()));
			}
			if(StrUtil.isNull(orderlsBb.getEdate())){
				orderlsBb.setEdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd"));
			}
			Page p = this.orderlsService.queryOrderlsBbPage1(orderlsBb, page, rows);
			JSONObject json = new JSONObject();
			json.put("total", p.getTotal());
			json.put("rows", p.getRows());
			List<ToolModel> toolModells = new ArrayList<ToolModel>();
			ToolModel toolModel = new ToolModel();
			toolModel.setOrderNo("合计");
			toolModel.setAllJg(p.getTolprice1());
			toolModel.setZhJg(p.getTolprice2());
			toolModells.add(toolModel);
			json.put("footer", toolModells);
			this.sendJsonResponse(response, json.toString());
			p = null;
		}catch (Exception e) {
			log.error("分页查询结算订单出错", e);
		}
	}
	/**
	 *@说明：修改订单审核
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	@RequestMapping("/updateOrderlsSh")
	public void updateOrderlsSh(HttpServletResponse response, HttpServletRequest request, Integer id, String sh){
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			 this.orderlsService.updateOrderlsSh(info.getDatasource(), id, sh);
			 BscOrderls order=this.orderlsWebService.queryOrderlsOne(info.getDatasource(), id);
			 this.orderMsgService.updateBforderMsgisRead2(info.getDatasource(), order.getOrderNo());
			 this.sendJsonResponse(response, "1"); 
		} catch (Exception e) {
		     log.error("修改订单审核出错：", e);
			 this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 *说明：获取结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("getOrderBb")
	public void getOrderBb(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			BscOrderlsBb orderlsBb=this.orderlsWebService.queryOrderlsBbById(id, info.getDatasource());
			JSONObject json = new JSONObject(orderlsBb);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取获取结算订单出错：", e);
		}
	}
	/**
	 *@说明：结算订单
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	@RequestMapping("/updateOrderBbJg")
	public void updateOrderBbJg(HttpServletResponse response, HttpServletRequest request, BscOrderlsBb orderlsBb){
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			BscOrderls orderls=this.orderlsWebService.queryOrderlsOne(info.getDatasource(), orderlsBb.getOrderId());
			SimpleDateFormat dateFormat= new SimpleDateFormat("yyMMdd_HHmmssSSS");
			String orderNo= "T" + dateFormat.format(new Date());
			orderlsBb.setOrderNo(orderNo);
			orderlsBb.setOdate(DateTimeUtil.getDateToStr(new Date(), "yyyy-MM-dd HH:mm:ss"));
			orderlsBb.setCid(orderls.getCid());
			orderlsBb.setMid(orderls.getMid());
			orderlsBb.setAllJg(orderlsBb.getAwJg()+orderlsBb.getBwJg()+orderlsBb.getCwJg()+orderlsBb.getDwJg()+orderlsBb.getEwJg()+orderlsBb.getFwJg());
			List<BscOrderlsDetail> list=this.orderlsWebService.queryOrderlsDetail(info.getDatasource(), orderlsBb.getOrderId());
			orderlsBb.setZhJg(orderlsBb.getAwJg()*list.get(0).getZh()+orderlsBb.getBwJg()*list.get(1).getZh()+orderlsBb.getCwJg()*list.get(2).getZh()+orderlsBb.getDwJg()*list.get(3).getZh()+orderlsBb.getEwJg()*list.get(4).getZh()+orderlsBb.getFwJg()*list.get(5).getZh());
			orderlsBb.setLsJg(orderlsBb.getAwJg()*list.get(0).getLs()+orderlsBb.getBwJg()*list.get(1).getLs()+orderlsBb.getCwJg()*list.get(2).getLs()+orderlsBb.getDwJg()*list.get(3).getLs()+orderlsBb.getEwJg()*list.get(4).getLs()+orderlsBb.getFwJg()*list.get(5).getLs());
			orderlsBb.setDyJg(orderlsBb.getAwJg()*list.get(0).getDy()+orderlsBb.getBwJg()*list.get(1).getDy()+orderlsBb.getCwJg()*list.get(2).getDy()+orderlsBb.getDwJg()*list.get(3).getDy()+orderlsBb.getEwJg()*list.get(4).getDy()+orderlsBb.getFwJg()*list.get(5).getDy());
			orderlsBb.setSjJg(orderlsBb.getAwJg()*list.get(0).getSj()+orderlsBb.getBwJg()*list.get(1).getSj()+orderlsBb.getCwJg()*list.get(2).getSj()+orderlsBb.getDwJg()*list.get(3).getSj()+orderlsBb.getEwJg()*list.get(4).getSj()+orderlsBb.getFwJg()*list.get(5).getSj());
			orderlsBb.setQpJg(orderlsBb.getAwJg()*list.get(0).getQp()+orderlsBb.getBwJg()*list.get(1).getQp()+orderlsBb.getCwJg()*list.get(2).getQp()+orderlsBb.getDwJg()*list.get(3).getQp()+orderlsBb.getEwJg()*list.get(4).getQp()+orderlsBb.getFwJg()*list.get(5).getQp());
			this.orderlsWebService.addOrderlsBb(orderlsBb, info.getDatasource());
			this.sendJsonResponse(response, "1"); 
		} catch (Exception e) {
		     log.error("结算订单出错：", e);
			 this.sendHtmlResponse(response, "-1");
		}
	}
	/**
	 *说明：获取结算订单
	 *@创建：作者:llp		创建时间：2016-8-31
	 *@修改历史：
	 *		[序号](llp	2016-8-31)<修改说明>
	 */
	@RequestMapping("getOrderBb2")
	public void getOrderBb2(Integer id, HttpServletResponse response, HttpServletRequest request){
		try {
			SysLoginInfo info = this.getLoginInfo(request);
			BscOrderlsBb orderlsBb=this.orderlsService.queryOrderlsBbOne(info.getDatasource(),id);
			JSONObject json = new JSONObject(orderlsBb);
			this.sendJsonResponse(response, json.toString());
		} catch (Exception e) {
			log.error("获取获取结算订单出错：", e);
		}
	}
	/**
	 *@说明：修改结算订单
	 *@创建：作者:llp		创建时间：2016-5-17
	 *@修改历史：
	 *		[序号](llp	2016-5-17)<修改说明>
	 */
	@RequestMapping("/updateOrderBb")
	public void updateOrderBb(HttpServletResponse response, HttpServletRequest request, BscOrderlsBb orderlsBb){
		SysLoginInfo info = this.getLoginInfo(request);
		try {
			orderlsBb.setIsJs(orderlsBb.getIsJs2());
			this.orderlsService.updateOrderBbJg(info.getDatasource(), orderlsBb);
			this.sendJsonResponse(response, "1"); 
		} catch (Exception e) {
		     log.error("修改结算订单出错：", e);
			 this.sendHtmlResponse(response, "-1");
		}
	}
}
